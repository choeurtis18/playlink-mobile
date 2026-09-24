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
