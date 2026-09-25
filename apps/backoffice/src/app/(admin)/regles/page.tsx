import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { NewSlideButton } from "./SlideEditor";
import { SlideList } from "./SlideList";

export const dynamic = "force-dynamic";

export default async function Regles({ searchParams }: { searchParams: Promise<{ jeu?: string }> }) {
  const sp = await searchParams;
  const games = await prisma.game.findMany({
    orderBy: { order: "asc" },
    select: {
      id: true, slug: true, name: true, icon: true, colorMain: true, colorSecondary: true,
      _count: { select: { ruleSlides: true } },
    },
  });
  const current = games.find((g) => g.slug === sp.jeu) ?? games[0];

  const slides = current
    ? await prisma.gameRuleSlide.findMany({ where: { gameId: current.id }, orderBy: { order: "asc" } })
    : [];

  return (
    <>
      <h1 className="mb-2 font-display text-[32px] font-semibold tracking-[-0.025em]">Règles du jeu</h1>
      <p className="mb-6 max-w-prose text-sm text-neutral-faint">
        Les règles sont présentées à l&apos;écran sous forme de slides illustrées.
        Les images sont des références locales (<code>asset://</code>) résolues
        par l&apos;app hors-ligne — leur remplacement passe par le script
        <code> fetch-assets</code>.
      </p>

      <div className="mb-6 flex flex-wrap gap-2">
        {games.map((g) => (
          <Link key={g.id} href={`/regles?jeu=${g.slug}`}
            className={`rounded border px-3 py-1.5 text-sm ${g.id === current?.id ? "border-accent bg-accent/10" : "border-hairline hover:bg-surface"}`}>
            {g.icon} {g.name} <span className="text-neutral-faint">{g._count.ruleSlides}</span>
          </Link>
        ))}
      </div>

      {current && (
        <>
          <div className="mb-3 flex items-center justify-between">
            <h2 className="font-medium">{current.icon} {current.name} — {slides.length} slides</h2>
            <NewSlideButton gameId={current.id} gameName={current.name}
              gameColors={{ colorMain: current.colorMain, colorSecondary: current.colorSecondary }}
              nextOrder={slides.length ? Math.max(...slides.map((s) => s.order)) + 1 : 0} />
          </div>

          {slides.length ? (
            <SlideList slides={slides} gameColors={{ colorMain: current.colorMain, colorSecondary: current.colorSecondary }} />
          ) : (
            <p className="rounded-lg border border-hairline bg-surface p-4 text-sm text-neutral-faint">
              Aucune slide pour ce jeu.
            </p>
          )}
        </>
      )}
    </>
  );
}
