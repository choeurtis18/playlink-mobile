import { createClerkClient, verifyToken } from "@clerk/backend";
import { prisma } from "./prisma";

/**
 * Vérification des joueurs (app mobile) — distincte de `requireEditor`
 * (auth.ts), qui couvre les éditeurs back-office via `@clerk/nextjs`. Deux
 * instances Clerk séparées, jamais mélangées (CLAUDE.md) : celle-ci lit
 * `CLERK_SECRET_KEY_PLAYERS`, jamais `CLERK_SECRET_KEY` (éditeurs).
 */
const playersSecretKey = process.env.CLERK_SECRET_KEY_PLAYERS;

const playersClerkClient = playersSecretKey
  ? createClerkClient({ secretKey: playersSecretKey })
  : null;

export class UnauthorizedError extends Error {}

/** Extrait et vérifie le token du header `Authorization: Bearer <jwt>`. */
export async function verifyPlayerToken(request: Request): Promise<{ clerkId: string }> {
  if (!playersSecretKey) throw new Error("CLERK_SECRET_KEY_PLAYERS manquant côté serveur");

  const header = request.headers.get("authorization");
  const token = header?.startsWith("Bearer ") ? header.slice("Bearer ".length) : null;
  if (!token) throw new UnauthorizedError("Token manquant");

  try {
    const payload = await verifyToken(token, { secretKey: playersSecretKey });
    return { clerkId: payload.sub };
  } catch {
    throw new UnauthorizedError("Token invalide ou expiré");
  }
}

/**
 * Compte joueur courant, créé à la volée à sa première synchro. Le token
 * ne porte que le `userId` (sub) — l'email n'est récupéré via l'API Clerk
 * qu'à la création, jamais reconfirmé aux appels suivants (évite un aller-
 * retour réseau supplémentaire à chaque requête).
 */
export async function requirePlayerAccount(request: Request) {
  const { clerkId } = await verifyPlayerToken(request);

  const existing = await prisma.account.findUnique({ where: { clerkId } });
  if (existing) return existing;

  if (!playersClerkClient) throw new Error("CLERK_SECRET_KEY_PLAYERS manquant côté serveur");
  const user = await playersClerkClient.users.getUser(clerkId);
  const email = user.primaryEmailAddress?.emailAddress;
  if (!email) throw new Error("Compte Clerk joueur sans email primaire");

  return prisma.account.create({ data: { clerkId, email } });
}
