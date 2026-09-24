// Envoi d'e-mails transactionnels via Resend (API HTTP, sans SDK : un seul
// appel, une dépendance de moins). Domaine d'envoi playlink-game.fr, à
// vérifier dans Resend (enregistrements DNS chez Gandi). Les réponses
// arrivent sur l'adresse de contact : aucune boîte n'existe sur le domaine.

const FROM = process.env.EMAIL_FROM ?? "Playlink <no-reply@playlink-game.fr>";
const REPLY_TO = "gamesplaylink@gmail.com";

export type Email = { to: string; subject: string; html: string; text: string };

/** `true` si l'e-mail est parti. Ne lève jamais : un e-mail raté ne doit
 * pas faire échouer l'inscription, il est journalisé pour être relancé. */
export async function sendEmail(email: Email): Promise<boolean> {
  const key = process.env.RESEND_API_KEY;
  if (!key) {
    console.error(`[email] RESEND_API_KEY absent : e-mail « ${email.subject} » non envoyé`);
    return false;
  }
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from: FROM, reply_to: REPLY_TO, ...email }),
    });
    if (!res.ok) {
      console.error(`[email] Resend → HTTP ${res.status} : ${await res.text()}`);
      return false;
    }
    return true;
  } catch (e) {
    console.error("[email] Resend injoignable", e);
    return false;
  }
}

const COPY = {
  fr: {
    subject: "Confirme ton inscription à Playlink",
    title: "Plus qu’un clic.",
    body: "Confirme ton adresse pour être prévenu·e le jour où Playlink arrive sur les stores. Un seul e-mail, pas de spam.",
    cta: "Confirmer mon inscription",
    ignore: "Tu n’as rien demandé ? Ignore simplement cet e-mail : sans confirmation, ton adresse n’est pas conservée.",
  },
  en: {
    subject: "Confirm your Playlink sign-up",
    title: "Just one click.",
    body: "Confirm your address to hear from us the day Playlink hits the stores. One email, no spam.",
    cta: "Confirm my sign-up",
    ignore: "Didn’t ask for this? Just ignore this email: without confirmation, your address is not kept.",
  },
} as const;

export function confirmationEmail(to: string, locale: string, link: string): Email {
  const c = COPY[locale === "en" ? "en" : "fr"];
  // Mise en page en tableau et styles en ligne : seuls supportés partout
  // (Gmail, Outlook). Couleurs de la landing.
  const html = `<!doctype html><html lang="${locale}"><body style="margin:0;background:#0b0a0f;padding:32px 16px;font-family:Helvetica,Arial,sans-serif;color:#f3f1ec">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0"><tr><td align="center">
<table role="presentation" width="100%" style="max-width:520px;background:#17151d;border:1px solid #2a2733;border-radius:20px" cellpadding="0" cellspacing="0"><tr><td style="padding:36px 32px">
<p style="margin:0 0 20px;font-size:20px;font-weight:700;color:#f3f1ec">Playlink</p>
<h1 style="margin:0 0 12px;font-size:28px;line-height:1.15;color:#f3f1ec">${c.title}</h1>
<p style="margin:0 0 28px;font-size:16px;line-height:1.55;color:#c7c2d1">${c.body}</p>
<a href="${link}" style="display:inline-block;padding:14px 24px;border-radius:999px;background:#f23a6b;color:#060509;font-size:16px;font-weight:700;text-decoration:none">${c.cta}</a>
<p style="margin:28px 0 0;font-size:13px;line-height:1.5;color:#918ca6">${c.ignore}</p>
</td></tr></table></td></tr></table></body></html>`;
  const text = `${c.title}\n\n${c.body}\n\n${c.cta} : ${link}\n\n${c.ignore}`;
  return { to, subject: c.subject, html, text };
}
