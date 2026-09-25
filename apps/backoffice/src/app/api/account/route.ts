import { NextResponse } from "next/server";
import { UnauthorizedError, requirePlayerAccount } from "@/lib/auth-players";

/**
 * Appelée par l'app mobile juste après une connexion Clerk réussie (§04) —
 * crée l'`Account` Prisma à la première synchro, ou le retrouve ensuite.
 * Idempotent : rejouable sans effet de bord (même `clerkId` → même compte).
 *
 * Ne synchronise encore aucune donnée de jeu (profils, parties, badges) —
 * seulement le lien compte ↔ joueur. La suite (merge local → cloud) est un
 * chantier séparé.
 */
export async function POST(request: Request) {
  try {
    const account = await requirePlayerAccount(request);
    return NextResponse.json({
      id: account.id,
      email: account.email,
      locale: account.locale,
      premiumUntil: account.premiumUntil,
    });
  } catch (error) {
    if (error instanceof UnauthorizedError) {
      return NextResponse.json({ error: error.message }, { status: 401 });
    }
    console.error("POST /api/account", error);
    return NextResponse.json({ error: "Erreur serveur" }, { status: 500 });
  }
}
