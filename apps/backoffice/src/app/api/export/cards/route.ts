import { auth } from "@clerk/nextjs/server";
import { prisma } from "@/lib/prisma";
import { toCsv } from "@/lib/csv";

const COLUMNS = ["id", "jeu", "categorie", "texte", "intensite", "tags", "actif", "ordre", "texte_en"];

export async function GET(req: Request) {
  const { userId } = await auth();
  if (!userId) return new Response("Non authentifié", { status: 401 });

  const jeu = new URL(req.url).searchParams.get("jeu");
  const cards = await prisma.card.findMany({
    where: jeu ? { category: { game: { slug: jeu } } } : {},
    orderBy: [{ category: { game: { order: "asc" } } }, { order: "asc" }],
    include: {
      category: { select: { name: true, game: { select: { name: true } } } },
      translations: { where: { locale: "en" }, select: { text: true } },
    },
  });

  const csv = toCsv(
    cards.map((c) => ({
      id: c.id, jeu: c.category.game.name, categorie: c.category.name,
      texte: c.text, intensite: c.intensity, tags: c.tags.join("|"),
      actif: c.active ? "1" : "0", ordre: c.order,
      texte_en: c.translations[0]?.text ?? "",
    })),
    COLUMNS,
  );

  return new Response("﻿" + csv, {  // BOM : Excel lit l'UTF-8 correctement
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="playlink-cartes${jeu ? `-${jeu}` : ""}.csv"`,
    },
  });
}
