// Prévient la landing (apps/web) qu'un contenu a changé, pour qu'elle se
// mette à jour tout de suite au lieu d'attendre l'expiration de son cache.
// Jamais bloquant : si le site ne répond pas, l'enregistrement a quand
// même réussi, et le site se rafraîchira de lui-même sous 5 minutes.
//
// Le résultat remonte jusqu'à l'éditeur (notification après « Publier ») :
// un échec silencieux laissait la landing en retard sans que personne ne
// sache pourquoi.

const TIMEOUT_MS = 3000;

export type NotifyResult = { ok: true } | { ok: false; reason: string };

export async function notifySite(tags: string[]): Promise<NotifyResult> {
  const url = process.env.WEB_URL;
  const secret = process.env.LANDING_API_SECRET;
  if (!url || !secret) {
    const missing = [!url && "WEB_URL", !secret && "LANDING_API_SECRET"].filter(Boolean).join(" et ");
    console.warn(`[notify-site] ${missing} absent : la landing n'est pas prévenue`);
    return { ok: false, reason: `${missing} absent de la configuration du back-office` };
  }
  const endpoint = `${url.replace(/\/$/, "")}/api/revalidate`;
  try {
    const res = await fetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${secret}` },
      body: JSON.stringify({ tags }),
      signal: AbortSignal.timeout(TIMEOUT_MS),
      cache: "no-store",
    });
    if (res.ok) return { ok: true };
    console.error(`[notify-site] ${endpoint} → HTTP ${res.status}`);
    return {
      ok: false,
      reason: res.status === 401
        ? "secret refusé par le site (LANDING_API_SECRET différent entre les deux projets)"
        : res.status === 503
          ? "LANDING_API_SECRET absent de la configuration du site"
          : `le site a répondu HTTP ${res.status} (${endpoint})`,
    };
  } catch (e) {
    console.error(`[notify-site] ${endpoint} injoignable`, e);
    const timeout = e instanceof Error && e.name === "TimeoutError";
    return { ok: false, reason: timeout ? `le site n'a pas répondu en ${TIMEOUT_MS / 1000} s (${endpoint})` : `site injoignable (${endpoint})` };
  }
}
