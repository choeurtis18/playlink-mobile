import { randomBytes } from "node:crypto";
import { after, NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { checkLandingSecret } from "@/lib/landing-api";
import { confirmationEmail, sendEmail } from "@/lib/email";
import { announceRegistration } from "@/lib/registration-emails";

const SITE_URL = process.env.SITE_URL ?? "https://playlink-game.fr";
const UNCONFIRMED_TTL_MS = 30 * 24 * 60 * 60 * 1000;

const Input = z.object({
  email: z.string().trim().toLowerCase().email().max(254),
  locale: z.enum(["fr", "en"]),
  // Sans consentement, rien n'est enregistré : c'est la seule raison
  // d'être de cette adresse (RGPD, base légale = consentement).
  consent: z.literal(true),
});

/** Pré-inscription depuis la landing (appel serveur de apps/web).
 *
 * Réponse identique que l'adresse soit nouvelle ou déjà inscrite : sinon
 * le formulaire permettrait de tester si quelqu'un est inscrit. */
export async function POST(req: Request) {
  const denied = checkLandingSecret(req);
  if (denied) return denied;

  const parsed = Input.safeParse(await req.json().catch(() => null));
  if (!parsed.success) return NextResponse.json({ error: "invalid" }, { status: 400 });
  const { email, locale } = parsed.data;

  // Promesse de l'e-mail de confirmation et de la politique de
  // confidentialité : une inscription jamais confirmée n'est pas gardée
  // plus de 30 jours. Fait ici, à chaque inscription : pas besoin d'une
  // tâche planifiée pour un volume aussi faible.
  await prisma.landingPreRegistration.deleteMany({
    where: { confirmedAt: null, createdAt: { lt: new Date(Date.now() - UNCONFIRMED_TTL_MS) } },
  });

  const site = await prisma.siteContent.findUnique({ where: { id: "default" }, select: { doubleOptIn: true } });
  const doubleOptIn = site?.doubleOptIn ?? false;
  const existing = await prisma.landingPreRegistration.findUnique({ where: { email } });

  if (!doubleOptIn) {
    await prisma.landingPreRegistration.upsert({
      where: { email },
      create: { email, locale, consentNewsletter: true, confirmedAt: new Date() },
      update: { locale, consentNewsletter: true, confirmToken: null, confirmedAt: existing?.confirmedAt ?? new Date() },
    });
    // Bienvenue + alerte admin une seule fois par adresse : une seconde
    // saisie de la même adresse ne renvoie rien. Après la réponse (`after`,
    // tenu en vie par Vercel) : le formulaire n'attend pas Resend.
    if (!existing?.confirmedAt) after(() => announceRegistration(email, locale, false));
    return NextResponse.json({ ok: true, pending: false });
  }

  // Double opt-in : déjà confirmée → rien à renvoyer. Sinon, nouveau jeton
  // (l'ancien lien devient caduc) et e-mail de confirmation.
  if (existing?.confirmedAt) {
    await prisma.landingPreRegistration.update({ where: { email }, data: { locale } });
  } else {
    const confirmToken = randomBytes(24).toString("base64url");
    await prisma.landingPreRegistration.upsert({
      where: { email },
      create: { email, locale, consentNewsletter: true, confirmToken },
      update: { locale, consentNewsletter: true, confirmToken },
    });
    const link = `${SITE_URL}/${locale}/confirmation?token=${confirmToken}`;
    await sendEmail(confirmationEmail(email, locale, link));
  }
  return NextResponse.json({ ok: true, pending: true });
}
