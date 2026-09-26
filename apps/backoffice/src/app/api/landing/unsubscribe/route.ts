import { NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { checkLandingSecret } from "@/lib/landing-api";
import { checkUnsubscribeToken } from "@/lib/unsubscribe-token";

const Input = z.object({ id: z.string().min(1).max(64), token: z.string().min(16).max(64) });

/** Désinscription depuis le lien de l'e-mail (via apps/web : page du site
 * ou bouton « Se désabonner » de la messagerie). L'inscription est
 * effacée, pas seulement marquée : on ne garde rien d'une adresse qui ne
 * veut plus être contactée. Idempotent : un second clic répond `ok`. */
export async function POST(req: Request) {
  const denied = checkLandingSecret(req);
  if (denied) return denied;

  const parsed = Input.safeParse(await req.json().catch(() => null));
  if (!parsed.success) return NextResponse.json({ ok: false }, { status: 400 });
  const { id, token } = parsed.data;
  if (!checkUnsubscribeToken(id, token)) return NextResponse.json({ ok: false });

  const reg = await prisma.landingPreRegistration.findUnique({ where: { id }, select: { locale: true } });
  if (reg) {
    await prisma.$transaction([
      prisma.landingPreRegistration.deleteMany({ where: { id } }),
      // Trace sans l'adresse (comme l'effacement depuis le back-office).
      prisma.auditLog.create({ data: { action: "unsubscribed_preregistration", entity: "preregistration", entityId: id, meta: { locale: reg.locale } } }),
    ]);
  }
  return NextResponse.json({ ok: true });
}
