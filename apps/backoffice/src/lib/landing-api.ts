import { timingSafeEqual } from "node:crypto";
import { NextResponse } from "next/server";

// Routes d'écriture appelées par apps/web (serveur à serveur uniquement,
// jamais par le navigateur) : le site n'a pas accès à la base, il passe
// par ici. Le secret partagé empêche quiconque d'autre de les appeler.

/** Renvoie une réponse d'erreur si l'appel n'est pas authentifié, `null`
 * sinon. Comparaison à temps constant : pas d'indice sur le secret. */
export function checkLandingSecret(req: Request): NextResponse | null {
  const expected = process.env.LANDING_API_SECRET;
  if (!expected) {
    console.error("[landing-api] LANDING_API_SECRET absent : route désactivée");
    return NextResponse.json({ error: "unavailable" }, { status: 503 });
  }
  const given = req.headers.get("authorization")?.replace(/^Bearer /, "") ?? "";
  const a = Buffer.from(given);
  const b = Buffer.from(expected);
  if (a.length !== b.length || !timingSafeEqual(a, b)) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }
  return null;
}

/** En-tête des routes publiques lues par la landing. Pas de cache CDN :
 * celui de Vercel est régional et ne se vide pas à la publication — la
 * landing (servie depuis une autre région que l'éditeur) relisait une
 * copie périmée jusqu'à une heure, voire 24 h avec stale-while-revalidate.
 * Le cache utile est ailleurs : unstable_cache ici (vidé par
 * revalidateTag) et le cache de fetch de la landing (vidé par
 * /api/revalidate, 5 min au plus sinon). */
export const PUBLIC_API_HEADERS = { "Cache-Control": "no-store" } as const;
