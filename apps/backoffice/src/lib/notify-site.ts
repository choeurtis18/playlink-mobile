// Prévient la landing (apps/web) qu'un contenu a changé, pour qu'elle se
// mette à jour tout de suite au lieu d'attendre l'expiration de son cache.
// Jamais bloquant : si le site ne répond pas, l'enregistrement a quand
// même réussi, et le site se rafraîchira de lui-même sous 5 minutes.

const TIMEOUT_MS = 3000;

export async function notifySite(tags: string[]) {
  const url = process.env.WEB_URL;
  const secret = process.env.LANDING_API_SECRET;
  if (!url || !secret) return;
  try {
    const res = await fetch(`${url.replace(/\/$/, "")}/api/revalidate`, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${secret}` },
      body: JSON.stringify({ tags }),
      signal: AbortSignal.timeout(TIMEOUT_MS),
      cache: "no-store",
    });
    if (!res.ok) console.error(`[notify-site] ${url} → HTTP ${res.status}`);
  } catch (e) {
    console.error(`[notify-site] ${url} injoignable`, e);
  }
}
