import { after, NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { checkLandingSecret } from "@/lib/landing-api";
import { announceRegistration } from "@/lib/registration-emails";

const Input = z.object({ token: z.string().min(16).max(128) });

/** Clic sur le lien de l'e-mail de confirmation (via apps/web). Le jeton
 * est effacé à l'usage : un lien ne sert qu'une fois. */
export async function POST(req: Request) {
  const denied = checkLandingSecret(req);
  if (denied) return denied;

  const parsed = Input.safeParse(await req.json().catch(() => null));
  if (!parsed.success) return NextResponse.json({ ok: false }, { status: 400 });

  const token = parsed.data.token;
  const reg = await prisma.landingPreRegistration.findUnique({ where: { confirmToken: token }, select: { email: true, locale: true } });
  if (!reg) return NextResponse.json({ ok: false });
  // `updateMany` sur le jeton : deux clics simultanés ne confirment (et
  // n'annoncent) qu'une fois.
  const { count } = await prisma.landingPreRegistration.updateMany({
    where: { confirmToken: token },
    data: { confirmToken: null, confirmedAt: new Date() },
  });
  if (count > 0) after(() => announceRegistration(reg.email, reg.locale, true));
  return NextResponse.json({ ok: count > 0 });
}
