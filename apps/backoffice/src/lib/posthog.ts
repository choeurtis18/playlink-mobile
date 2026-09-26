// Lecture des événements de la landing via l'API Query de PostHog (HogQL).
// Clé personnelle limitée à « Query : Read » sur le seul projet de la
// landing : ce module ne fait que lire.

const TIMEOUT_MS = 20_000;

export function posthogConfig() {
  const key = process.env.POSTHOG_PERSONAL_API_KEY;
  const project = process.env.POSTHOG_PROJECT_ID;
  const host = (process.env.POSTHOG_API_HOST ?? "https://eu.posthog.com").replace(/\/$/, "");
  if (!key || !project) return null;
  return { key, project, host };
}

/** Exécute une requête HogQL et renvoie ses lignes. */
export async function hogql(query: string): Promise<unknown[][]> {
  const cfg = posthogConfig();
  if (!cfg) throw new Error("POSTHOG_PERSONAL_API_KEY ou POSTHOG_PROJECT_ID absent de la configuration du back-office");
  const res = await fetch(`${cfg.host}/api/projects/${encodeURIComponent(cfg.project)}/query/`, {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${cfg.key}` },
    body: JSON.stringify({ query: { kind: "HogQLQuery", query } }),
    signal: AbortSignal.timeout(TIMEOUT_MS),
    cache: "no-store",
  });
  if (!res.ok) {
    const detail = await res.text().catch(() => "");
    const hint = res.status === 401 || res.status === 403
      ? " — clé refusée : vérifie la clé et son accès « Query : Read » au projet"
      : res.status === 404 ? " — projet introuvable : vérifie POSTHOG_PROJECT_ID et POSTHOG_API_HOST" : "";
    throw new Error(`PostHog HTTP ${res.status}${hint}${detail ? ` (${detail.slice(0, 200)})` : ""}`);
  }
  const json = (await res.json()) as { results?: unknown[][] };
  return json.results ?? [];
}
