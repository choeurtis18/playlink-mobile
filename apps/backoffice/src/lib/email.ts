// Envoi d'e-mails transactionnels via Resend (API HTTP, sans SDK : un seul
// appel, une dépendance de moins). Domaine d'envoi playlink-game.fr,
// vérifié dans Resend (enregistrements DNS chez Gandi). Les réponses
// arrivent sur l'adresse de contact : aucune boîte n'existe sur le domaine.
// Sans import : les gabarits sont testés par `node --test` (email.test.ts).

const FROM = process.env.EMAIL_FROM ?? "Playlink <no-reply@playlink-game.fr>";
export const CONTACT_EMAIL = "gamesplaylink@gmail.com";
const SITE_URL = process.env.SITE_URL ?? "https://playlink-game.fr";

/** Destinataire des alertes « nouvelle pré-inscription ». `off` les coupe
 * (quota Resend gratuit : 100 e-mails par jour). */
export function adminNotifyEmail(): string | null {
  const v = (process.env.ADMIN_NOTIFY_EMAIL ?? CONTACT_EMAIL).trim();
  return !v || v === "off" ? null : v;
}

/** Adresse publique du back-office (lien des alertes). Vercel fournit
 * `VERCEL_PROJECT_PRODUCTION_URL` (sans protocole) si elle n'est pas fixée. */
export function backofficeUrl(): string {
  if (process.env.BACKOFFICE_URL) return process.env.BACKOFFICE_URL.replace(/\/$/, "");
  const vercel = process.env.VERCEL_PROJECT_PRODUCTION_URL;
  return vercel ? `https://${vercel}` : "http://localhost:3000";
}

export type Email = { to: string; subject: string; html: string; text: string; replyTo?: string };

/** `true` si l'e-mail est parti. Ne lève jamais : un e-mail raté ne doit
 * pas faire échouer l'inscription, il est journalisé pour être relancé. */
export async function sendEmail({ replyTo = CONTACT_EMAIL, ...email }: Email): Promise<boolean> {
  const key = process.env.RESEND_API_KEY;
  if (!key) {
    console.error(`[email] RESEND_API_KEY absent : e-mail « ${email.subject} » non envoyé`);
    return false;
  }
  try {
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
      body: JSON.stringify({ from: FROM, reply_to: replyTo, ...email }),
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

// ── Gabarit commun ────────────────────────────────────────────────────
// Tableaux et styles en ligne : seuls supportés partout (Gmail, Outlook).
// Couleurs et typographies de la landing ; Fraunces n'est chargée que par
// les clients qui l'acceptent (Apple Mail), Georgia sinon.

const C = {
  ground: "#0b0a0f", surface: "#17151d", raised: "#1f1c27", hairline: "#2a2733",
  ink: "#f3f1ec", soft: "#c7c2d1", faint: "#918ca6", accent: "#f23a6b", accentDeep: "#ff6b93", deep: "#060509",
};
const DISPLAY = "Fraunces,Georgia,'Times New Roman',serif";
const SANS = "'Inter Tight',Helvetica,Arial,sans-serif";

export const esc = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");

/** Bouton « pilule » au dégradé de la landing (couleur unie en repli). */
function button(href: string, label: string) {
  return `<a href="${esc(href)}" style="display:inline-block;padding:14px 26px;border-radius:999px;background:${C.accent};background-image:linear-gradient(135deg,${C.accent},${C.accentDeep});color:${C.deep};font-family:${SANS};font-size:16px;font-weight:700;text-decoration:none">${esc(label)}</a>`;
}

function layout({ lang, preheader, kicker, title, body, footer }: {
  lang: string; preheader: string; kicker?: string; title: string; body: string; footer: string;
}) {
  return `<!doctype html><html lang="${lang}"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="color-scheme" content="dark"><meta name="supported-color-schemes" content="dark">
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&family=Inter+Tight:wght@400;600;700&display=swap" rel="stylesheet"><title>${esc(title)}</title></head>
<body style="margin:0;padding:0;background:${C.ground}">
<div style="display:none;max-height:0;overflow:hidden;opacity:0;color:${C.ground}">${esc(preheader)}</div>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:${C.ground}"><tr><td align="center" style="padding:32px 16px">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:540px">
<tr><td style="padding:0 4px 20px">
<a href="${SITE_URL}" style="text-decoration:none"><table role="presentation" cellpadding="0" cellspacing="0"><tr>
<td style="vertical-align:middle"><img src="${SITE_URL}/email/logo.png" width="36" height="36" alt="" style="display:block;border:0;border-radius:9px"></td>
<td style="vertical-align:middle;padding-left:10px;font-family:${DISPLAY};font-size:22px;font-weight:600;letter-spacing:-0.02em;color:${C.ink}">Playlink</td>
</tr></table></a></td></tr>
<tr><td style="background:${C.surface};border:1px solid ${C.hairline};border-radius:22px;padding:36px 32px;font-family:${SANS};color:${C.ink}">
${kicker ? `<p style="margin:0 0 12px;font-family:'JetBrains Mono',Menlo,Consolas,monospace;font-size:11px;letter-spacing:0.14em;text-transform:uppercase;color:${C.accentDeep}">${esc(kicker)}</p>` : ""}
<h1 style="margin:0 0 14px;font-family:${DISPLAY};font-size:30px;line-height:1.12;font-weight:600;letter-spacing:-0.02em;color:${C.ink}">${esc(title)}</h1>
${body}
</td></tr>
<tr><td style="padding:20px 8px 0;font-family:${SANS};font-size:12px;line-height:1.6;color:${C.faint}">${footer}</td></tr>
</table></td></tr></table></body></html>`;
}

const p = (html: string) => `<p style="margin:0 0 20px;font-size:16px;line-height:1.6;color:${C.soft}">${html}</p>`;
const link = (href: string, label: string) => `<a href="${esc(href)}" style="color:${C.soft};text-decoration:underline">${esc(label)}</a>`;

type Locale = "fr" | "en";
const loc = (l: string): Locale => (l === "en" ? "en" : "fr");

// ── Confirmation (double opt-in) ──────────────────────────────────────

const CONFIRM = {
  fr: {
    subject: "Confirme ton inscription à Playlink",
    preheader: "Un clic pour être prévenu·e de la sortie.",
    title: "Plus qu’un clic.",
    body: "Confirme ton adresse pour être prévenu·e le jour où Playlink arrive sur les stores. Un seul e-mail, pas de spam.",
    cta: "Confirmer mon inscription",
    ignore: "Tu n’as rien demandé ? Ignore simplement cet e-mail : sans confirmation, ton adresse n’est pas conservée.",
  },
  en: {
    subject: "Confirm your Playlink sign-up",
    preheader: "One click to hear about the launch.",
    title: "Just one click.",
    body: "Confirm your address to hear from us the day Playlink hits the stores. One email, no spam.",
    cta: "Confirm my sign-up",
    ignore: "Didn’t ask for this? Just ignore this email: without confirmation, your address is not kept.",
  },
} as const;

export function confirmationEmail(to: string, locale: string, confirmLink: string): Email {
  const l = loc(locale), c = CONFIRM[l];
  const html = layout({
    lang: l, preheader: c.preheader, title: c.title,
    body: `${p(esc(c.body))}<p style="margin:8px 0 0">${button(confirmLink, c.cta)}</p>`,
    footer: esc(c.ignore),
  });
  const text = `${c.title}\n\n${c.body}\n\n${c.cta} : ${confirmLink}\n\n${c.ignore}`;
  return { to, subject: c.subject, html, text };
}

// ── Bienvenue (inscription effective) ─────────────────────────────────

const WELCOME = {
  fr: {
    subject: "C’est noté : tu seras prévenu·e de la sortie de Playlink",
    preheader: "Ton inscription est enregistrée. On te prévient dès que l’app sort.",
    kicker: "Inscription enregistrée",
    title: "Bienvenue dans la partie.",
    lead: "Merci ! Ton adresse est bien enregistrée : on t’écrit ",
    strong: "le jour où Playlink arrive sur l’App Store et Google Play",
    tail: ". Pas de newsletter à rallonge, pas de spam.",
    wait: "En attendant, tu peux déjà tester quelques cartes dans la démo du site.",
    cta: "Essayer la démo",
    follow: "Suivre Playlink :",
    why: "Tu reçois cet e-mail parce que tu t’es pré-inscrit·e sur playlink-game.fr.",
    leave: "Te désinscrire",
    leaveHint: "ou réponds simplement à cet e-mail.",
  },
  en: {
    subject: "You’re on the list: we’ll tell you when Playlink launches",
    preheader: "Your sign-up is saved. We’ll let you know as soon as the app is out.",
    kicker: "Sign-up saved",
    title: "Welcome to the game.",
    lead: "Thanks! Your address is saved: we’ll email you ",
    strong: "the day Playlink lands on the App Store and Google Play",
    tail: ". No endless newsletter, no spam.",
    wait: "Meanwhile, you can already try a few cards in the demo on the website.",
    cta: "Try the demo",
    follow: "Follow Playlink:",
    why: "You’re receiving this email because you signed up on playlink-game.fr.",
    leave: "Unsubscribe",
    leaveHint: "or simply reply to this email.",
  },
} as const;

export type Socials = { instagramUrl?: string | null; tiktokUrl?: string | null };

export function welcomeEmail(to: string, locale: string, socials: Socials = {}): Email {
  const l = loc(locale), c = WELCOME[l];
  const demo = `${SITE_URL}/${l}#demo`;
  const leave = `${SITE_URL}/${l}/supprimer-mes-donnees`;
  const social = [
    socials.instagramUrl && { href: socials.instagramUrl, label: "Instagram" },
    socials.tiktokUrl && { href: socials.tiktokUrl, label: "TikTok" },
  ].filter((s): s is { href: string; label: string } => !!s);

  const html = layout({
    lang: l, preheader: c.preheader, kicker: c.kicker, title: c.title,
    body: [
      p(`${esc(c.lead)}<strong style="color:${C.ink}">${esc(c.strong)}</strong>${esc(c.tail)}`),
      p(esc(c.wait)),
      `<p style="margin:4px 0 0">${button(demo, c.cta)}</p>`,
      social.length
        ? `<p style="margin:28px 0 0;padding-top:20px;border-top:1px solid ${C.hairline};font-size:14px;color:${C.faint}">${esc(c.follow)} ${social.map((s) => link(s.href, s.label)).join(" · ")}</p>`
        : "",
    ].join(""),
    footer: `${esc(c.why)}<br>${link(leave, c.leave)} ${esc(c.leaveHint)}`,
  });
  const text = [
    c.title, "", `${c.lead}${c.strong}${c.tail}`, "", c.wait, `${c.cta} : ${demo}`,
    ...(social.length ? ["", `${c.follow} ${social.map((s) => `${s.label} ${s.href}`).join(" · ")}`] : []),
    "", "—", c.why, `${c.leave} : ${leave} (${c.leaveHint})`,
  ].join("\n");
  return { to, subject: c.subject, html, text };
}

// ── Alerte admin ──────────────────────────────────────────────────────

export type SignupAlert = {
  email: string; locale: string; total: number; last24h: number; doubleOptIn: boolean;
};

/** Alerte interne (en français) : une nouvelle adresse vient d'être
 * enregistrée. « Répondre » écrit directement à l'inscrit. */
export function adminSignupEmail(to: string, a: SignupAlert): Email {
  const nf = new Intl.NumberFormat("fr-FR");
  const list = `${backofficeUrl()}/inscriptions`;
  const rows: [string, string][] = [
    ["Adresse", a.email],
    ["Langue", a.locale === "en" ? "Anglais (EN)" : "Français (FR)"],
    ["Confirmation", a.doubleOptIn ? "Lien de confirmation cliqué" : "Directe (double opt-in désactivé)"],
    ["Dernières 24 h", nf.format(a.last24h)],
  ];
  const cell = (i: number) => (i ? `border-top:1px solid ${C.hairline};` : "");
  const table = `<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="margin:0 0 24px;background:${C.raised};border-radius:14px">${rows
    .map(([k, v], i) => `<tr><td style="padding:12px 16px;${cell(i)}font-size:13px;color:${C.faint};white-space:nowrap">${esc(k)}</td><td style="padding:12px 16px;${cell(i)}font-size:14px;color:${C.ink};word-break:break-all">${esc(v)}</td></tr>`)
    .join("")}</table>`;

  const html = layout({
    lang: "fr",
    preheader: `${a.email} — ${nf.format(a.total)} pré-inscriptions au total.`,
    kicker: "Back-office · Pré-inscriptions",
    title: `Nouvelle pré-inscription, ${nf.format(a.total)} au total.`,
    body: `${p("Quelqu’un vient de laisser son adresse sur la landing pour être prévenu de la sortie.")}${table}<p style="margin:0">${button(list, "Voir les pré-inscriptions")}</p>`,
    footer: "Alerte envoyée à chaque nouvelle inscription. Pour la couper : variable ADMIN_NOTIFY_EMAIL=off sur le projet Vercel du back-office. Répondre à cet e-mail écrit à l’inscrit.",
  });
  const text = [
    `Nouvelle pré-inscription, ${nf.format(a.total)} au total.`, "",
    ...rows.map(([k, v]) => `${k} : ${v}`), "", `Voir les pré-inscriptions : ${list}`,
  ].join("\n");
  return { to, subject: `Nouvelle pré-inscription · ${a.email}`, html, text, replyTo: a.email };
}
