import { auth } from "@clerk/nextjs/server";
import { toCsv } from "@/lib/csv";

const COLUMNS = ["id", "jeu", "categorie", "texte", "intensite", "tags", "actif", "ordre", "texte_en"];

// Modèle vierge (2 lignes d'exemple) pour l'import cartes — mêmes colonnes
// que l'export, "jeu"/"categorie" doivent correspondre EXACTEMENT au nom
// existant (pas le slug) pour être reconnus.
export async function GET() {
  const { userId } = await auth();
  if (!userId) return new Response("Non authentifié", { status: 401 });

  const rows = [
    { id: "", jeu: "Action ou Vérité", categorie: "Vérités légères", texte: "Quel est ton plus grand regret ?", intensite: 2, tags: "vérité|léger", actif: "1", ordre: 0, texte_en: "What's your biggest regret?" },
    { id: "", jeu: "Action ou Vérité", categorie: "Actions Rigolote", texte: "Imite ton animal préféré pendant 30 secondes", intensite: 1, tags: "action|humour", actif: "1", ordre: 1, texte_en: "" },
  ];
  const csv = toCsv(rows, COLUMNS);

  return new Response("﻿" + csv, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="playlink-modele-cartes.csv"`,
    },
  });
}
