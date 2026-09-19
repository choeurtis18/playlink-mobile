import { auth } from "@clerk/nextjs/server";
import { toCsv } from "@/lib/csv";

const COLUMNS = [
  "jeu_slug", "jeu_nom", "jeu_description", "jeu_icone", "jeu_couleur1", "jeu_couleur2", "jeu_actif", "jeu_ordre",
  "categorie_slug", "categorie_nom", "categorie_description", "categorie_icone", "categorie_ordre",
];

// Modèle vierge pour l'import jeux+catégories : une ligne "jeu" (colonnes
// jeu_*, categorie_slug vide) suivie de ses lignes "catégorie" (jeu_slug
// répété + colonnes categorie_*) — voir importGames dans lib/actions.ts.
export async function GET() {
  const { userId } = await auth();
  if (!userId) return new Response("Non authentifié", { status: 401 });

  const rows = [
    { jeu_slug: "mon-nouveau-jeu", jeu_nom: "Mon nouveau jeu", jeu_description: "Description courte du jeu", jeu_icone: "🎲", jeu_couleur1: "#7C3AED", jeu_couleur2: "#EC4899", jeu_actif: "1", jeu_ordre: 8, categorie_slug: "", categorie_nom: "", categorie_description: "", categorie_icone: "", categorie_ordre: "" },
    { jeu_slug: "mon-nouveau-jeu", jeu_nom: "", jeu_description: "", jeu_icone: "", jeu_couleur1: "", jeu_couleur2: "", jeu_actif: "", jeu_ordre: "", categorie_slug: "premiere-categorie", categorie_nom: "Première catégorie", categorie_description: "", categorie_icone: "😄", categorie_ordre: 0 },
    { jeu_slug: "mon-nouveau-jeu", jeu_nom: "", jeu_description: "", jeu_icone: "", jeu_couleur1: "", jeu_couleur2: "", jeu_actif: "", jeu_ordre: "", categorie_slug: "deuxieme-categorie", categorie_nom: "Deuxième catégorie", categorie_description: "", categorie_icone: "🔥", categorie_ordre: 1 },
  ];
  const csv = toCsv(rows, COLUMNS);

  return new Response("﻿" + csv, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="playlink-modele-jeux.csv"`,
    },
  });
}
