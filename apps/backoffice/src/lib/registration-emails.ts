import { prisma } from "./prisma";
import { adminNotifyEmail, adminSignupEmail, sendEmail, welcomeEmail } from "./email";

const DAY = 24 * 60 * 60 * 1000;

/** Inscription devenue effective (directe, ou lien de confirmation
 * cliqué) : e-mail de bienvenue à l'inscrit et alerte à l'admin, en
 * parallèle. Appelé une seule fois par adresse. Ne lève jamais : un
 * e-mail raté est journalisé par `sendEmail`. */
export async function announceRegistration(email: string, locale: string, doubleOptIn: boolean) {
  try {
    const admin = adminNotifyEmail();
    const [site, total, last24h] = await Promise.all([
      prisma.siteContent.findUnique({ where: { id: "default" }, select: { instagramUrl: true, tiktokUrl: true } }),
      admin ? prisma.landingPreRegistration.count() : 0,
      admin ? prisma.landingPreRegistration.count({ where: { createdAt: { gte: new Date(Date.now() - DAY) } } }) : 0,
    ]);
    await Promise.all([
      sendEmail(welcomeEmail(email, locale, site ?? {})),
      admin && sendEmail(adminSignupEmail(admin, { email, locale, total, last24h, doubleOptIn })),
    ]);
  } catch (e) {
    console.error("[email] annonce d'inscription", e);
  }
}
