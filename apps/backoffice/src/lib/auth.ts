import { auth, currentUser } from "@clerk/nextjs/server";
import { prisma } from "./prisma";

/**
 * Éditeur courant, créé à la volée à sa première action.
 *
 * `AdminUser` est délibérément distinct des comptes joueurs (`Account`) :
 * ce sont deux populations qui ne doivent jamais se croiser (CLAUDE.md).
 */
export async function requireEditor() {
  const { userId } = await auth();
  if (!userId) throw new Error("Non authentifié");

  const existing = await prisma.adminUser.findUnique({ where: { clerkId: userId } });
  if (existing) return existing;

  const user = await currentUser();
  return prisma.adminUser.create({
    data: {
      clerkId: userId,
      email: user?.primaryEmailAddress?.emailAddress ?? `${userId}@unknown`,
      role: "editor",
    },
  });
}

/** Trace toute mutation : qui a changé quoi, et quand. */
export async function logAction(
  adminId: string,
  action: string,
  entity: string,
  entityId: string,
  meta?: Record<string, unknown>,
) {
  await prisma.auditLog.create({
    data: { adminId, action, entity, entityId, meta: meta as never },
  });
}
