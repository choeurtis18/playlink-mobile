import { prisma } from "@/lib/prisma";
import { ImportButton } from "@/components/ui";
import { importGames } from "@/lib/actions";
import { NewGameButton } from "./GameEditor";
import { GameList } from "./GameList";

export const dynamic = "force-dynamic";

export default async function Jeux() {
  const games = await prisma.game.findMany({
    orderBy: { order: "asc" },
    include: {
      _count: { select: { ruleSlides: true } },
      categories: { orderBy: { order: "asc" }, include: { _count: { select: { cards: true } } } },
    },
  });

  return (
    <>
      <div className="mb-6 flex items-center justify-between">
        <h1 className="font-display text-[32px] font-semibold tracking-[-0.025em]">Jeux</h1>
        <div className="flex gap-2">
          <a href="/api/export/games" className="rounded border border-hairline px-3 py-1.5 text-sm text-ink-soft hover:bg-surface">
            Export CSV
          </a>
          <ImportButton
            templateHref="/api/templates/games"
            columns="jeu_slug, jeu_nom, jeu_description, jeu_icone, jeu_couleur1, jeu_couleur2, jeu_actif, jeu_ordre, categorie_slug, categorie_nom, categorie_description, categorie_icone, categorie_ordre"
            notes="Une ligne avec categorie_slug vide crée/met à jour le JEU ; une ligne avec categorie_slug rempli crée/met à jour une catégorie de ce jeu (jeu_slug seul suffit sur ces lignes). Upsert par slug — un slug existant est mis à jour, pas dupliqué."
            action={importGames}
          />
          <NewGameButton />
        </div>
      </div>

      <GameList games={games} />
    </>
  );
}
