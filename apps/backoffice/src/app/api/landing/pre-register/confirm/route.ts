import { NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { checkLandingSecret } from "@/lib/landing-api";

const Input = z.object({ token: z.string().min(16).max(128) });

/** Clic sur le lien de l'e-mail de confirmation (via apps/web). Le jeton
 * est effacé à l'usage : un lien ne sert qu'une fois. */
export async function POST(req: Request) {
  const denied = checkLandingSecret(req);
  if (denied) return denied;

  const parsed = Input.safeParse(await req.json().catch(() => null));
  if (!parsed.success) return NextResponse.json({ ok: false }, { status: 400 });

  const { count } = await prisma.landingPreRegistration.updateMany({
    where: { confirmToken: parsed.data.token },
    data: { confirmToken: null, confirmedAt: new Date() },
  });
  return NextResponse.json({ ok: count > 0 });
}
