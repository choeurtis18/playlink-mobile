import { DownloadSimpleIcon, PlusIcon, UploadSimpleIcon } from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { ButtonLink, ImportButton, PageHeader } from "@/components/ui";
import { importGames } from "@/lib/actions";
import { NewGameButton } from "./GameEditor";
import { GameList } from "./GameList";

export const dynamic = "force-dynamic";
export const metadata = { title: "Jeux" };

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
      <PageHeader
        title="Jeux"
        description="Glisse une ligne par sa poignée (ou flèches ↑ ↓ au clavier) pour changer l’ordre d’affichage dans l’app et sur la landing."
        actions={
          <>
            <ButtonLink href="/api/export/games" icon={<DownloadSimpleIcon aria-hidden />}>Export CSV</ButtonLink>
            <ImportButton
              icon={<UploadSimpleIcon aria-hidden />}
              templateHref="/api/templates/games"
              columns="jeu_slug, jeu_nom, jeu_description, jeu_icone, jeu_couleur1, jeu_couleur2, jeu_actif, jeu_ordre, categorie_slug, categorie_nom, categorie_description, categorie_icone, categorie_ordre"
              notes="Une ligne avec categorie_slug vide crée/met à jour le JEU ; une ligne avec categorie_slug rempli crée/met à jour une catégorie de ce jeu (jeu_slug seul suffit sur ces lignes). Upsert par slug — un slug existant est mis à jour, pas dupliqué."
              action={importGames}
            />
            <NewGameButton icon={<PlusIcon aria-hidden />} />
          </>
        }
      />
      <GameList games={games} />
    </>
  );
}
