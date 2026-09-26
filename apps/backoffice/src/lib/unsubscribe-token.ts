import { createHmac, timingSafeEqual } from "node:crypto";

// Lien de désinscription signé : l'identifiant de l'inscription et une
// signature HMAC. Personne ne peut désinscrire une autre adresse sans
// l'e-mail reçu, et rien à stocker en base. Clé dérivée de
// LANDING_API_SECRET (étiquette dédiée) : en changer invalide les liens
// déjà envoyés, qui renvoient alors vers la demande par e-mail.

const LABEL = "playlink:unsubscribe:v1:";

export function unsubscribeToken(id: string, secret = process.env.LANDING_API_SECRET ?? ""): string {
  if (!secret) throw new Error("LANDING_API_SECRET absent : lien de désinscription impossible");
  return createHmac("sha256", secret).update(LABEL + id).digest("base64url").slice(0, 32);
}

export function checkUnsubscribeToken(id: string, token: string, secret = process.env.LANDING_API_SECRET ?? ""): boolean {
  if (!secret || !id || !token) return false;
  const expected = Buffer.from(unsubscribeToken(id, secret));
  const given = Buffer.from(token);
  return given.length === expected.length && timingSafeEqual(given, expected);
}
