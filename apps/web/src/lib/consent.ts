// Consentement cookies (RGPD / CNIL) : rien de non essentiel avant un choix
// explicite, choix aussi simple à refuser qu'à accepter, valable 12 mois,
// modifiable à tout moment (« Gérer les cookies » en pied de page).
//
// Stocké dans un cookie first-party plutôt qu'en localStorage : même durée
// de vie garantie, et lisible côté serveur si un jour il le faut.

export const CONSENT_COOKIE = "playlink-consent-v1";
const MAX_AGE_S = 60 * 60 * 24 * 365;
export const CONSENT_CHANGED_EVENT = "playlink:consent-changed";
export const OPEN_COOKIES_EVENT = "playlink:open-cookies";

export type Consent = { analytics: boolean; at: string };

export function readConsent(): Consent | null {
  if (typeof document === "undefined") return null;
  const raw = document.cookie.split("; ").find((c) => c.startsWith(`${CONSENT_COOKIE}=`));
  if (!raw) return null;
  try {
    const value = JSON.parse(decodeURIComponent(raw.slice(CONSENT_COOKIE.length + 1)));
    return typeof value?.analytics === "boolean" ? value : null;
  } catch {
    return null;
  }
}

export function writeConsent(analytics: boolean) {
  const consent: Consent = { analytics, at: new Date().toISOString() };
  const secure = location.protocol === "https:" ? "; Secure" : "";
  document.cookie = `${CONSENT_COOKIE}=${encodeURIComponent(JSON.stringify(consent))}; Max-Age=${MAX_AGE_S}; Path=/; SameSite=Lax${secure}`;
  window.dispatchEvent(new CustomEvent<Consent>(CONSENT_CHANGED_EVENT, { detail: consent }));
}

export function openCookieSettings() {
  window.dispatchEvent(new Event(OPEN_COOKIES_EVENT));
}
