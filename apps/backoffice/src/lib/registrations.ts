import type { Prisma } from "@prisma/client";

// Filtres de la liste des pré-inscriptions, partagés entre l'écran et
// l'export CSV (l'export reprend exactement ce qui est affiché).

export type RegistrationFilters = { q?: string; langue?: string; statut?: string };

export const REGISTRATION_STATUS = { confirmee: "Confirmée", attente: "En attente" } as const;

export function registrationWhere(f: RegistrationFilters): Prisma.LandingPreRegistrationWhereInput {
  const q = f.q?.trim().toLowerCase();
  return {
    ...(q ? { email: { contains: q } } : {}),
    ...(f.langue === "fr" || f.langue === "en" ? { locale: f.langue } : {}),
    ...(f.statut === "confirmee" ? { confirmedAt: { not: null } } : f.statut === "attente" ? { confirmedAt: null } : {}),
  };
}
