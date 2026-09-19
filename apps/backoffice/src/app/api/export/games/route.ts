import { auth } from "@clerk/nextjs/server";
import { prisma } from "@/lib/prisma";
import { toCsv } from "@/lib/csv";

const COLUMNS = [
  "jeu_slug", "jeu_nom", "jeu_description", "jeu_icone", "jeu_couleur1", "jeu_couleur2", "jeu_actif", "jeu_ordre",
  "categorie_slug", "categorie_nom", "categorie_description", "categorie_icone", "categorie_ordre",
];

// Mêmes colonnes que le modèle d'import (`/api/templates/games`) — cet
// export peut être réimporté tel quel après modification.
export async function GET() {
  const { userId } = await auth();
  if (!userId) return new Response("Non authentifié", { status: 401 });

  const games = await prisma.game.findMany({
    orderBy: { order: "asc" },
    include: { categories: { orderBy: { order: "asc" } } },
  });

  const rows: Record<string, unknown>[] = [];
  for (const g of games) {
    rows.push({
      jeu_slug: g.slug, jeu_nom: g.name, jeu_description: g.description ?? "",
      jeu_icone: g.icon ?? "", jeu_couleur1: g.colorMain, jeu_couleur2: g.colorSecondary,
      jeu_actif: g.active ? "1" : "0", jeu_ordre: g.order,
      categorie_slug: "", categorie_nom: "", categorie_description: "", categorie_icone: "", categorie_ordre: "",
    });
    for (const c of g.categories) {
      rows.push({
        jeu_slug: g.slug, jeu_nom: "", jeu_description: "", jeu_icone: "", jeu_couleur1: "", jeu_couleur2: "", jeu_actif: "", jeu_ordre: "",
        categorie_slug: c.slug, categorie_nom: c.name, categorie_description: c.description ?? "",
        categorie_icone: c.icon ?? "", categorie_ordre: c.order,
      });
    }
  }

  const csv = toCsv(rows, COLUMNS);

  return new Response("﻿" + csv, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="playlink-jeux.csv"`,
    },
  });
}
