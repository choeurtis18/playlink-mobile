import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { BookOpenIcon } from "@phosphor-icons/react/dist/ssr";
import { EmptyState, PageHeader } from "@/components/ui";
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
    ? await prisma.gameRuleSlide.findMany({ where: { gameId: current.id }, orderBy: [{ order: "asc" }, { id: "asc" }] })
    : [];

  const pill = (on: boolean) =>
    `inline-flex items-center gap-1.5 rounded-full border px-3 py-1 text-[13px] transition-colors ${on ? "border-accent bg-accent/12 text-ink" : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink"}`;

  return (
    <>
      <PageHeader
        title="Règles du jeu"
        description={<>Présentées dans l’app sous forme de slides. Les images sont des références locales (<code className="font-mono text-ink-soft">asset://</code>) résolues hors ligne par le script <code className="font-mono text-ink-soft">fetch-assets</code>.</>}
      />

      <nav aria-label="Choisir un jeu" className="mb-4 flex flex-wrap gap-1.5">
        {games.map((g) => (
          <Link key={g.id} href={`/regles?jeu=${g.slug}`} aria-current={g.id === current?.id ? "page" : undefined} className={pill(g.id === current?.id)}>
            <span aria-hidden>{g.icon}</span> {g.name} <span className="font-mono text-[11px] text-neutral-faint">{g._count.ruleSlides}</span>
          </Link>
        ))}
      </nav>

      {current && (
        <>
          <div className="mb-3 flex flex-wrap items-center justify-between gap-3">
            <h2 className="m-0 text-base font-semibold">
              {current.icon} {current.name} <span className="font-medium text-neutral-faint">— {slides.length} slide{slides.length > 1 ? "s" : ""}</span>
            </h2>
            <NewSlideButton gameId={current.id} gameName={current.name}
              gameColors={{ colorMain: current.colorMain, colorSecondary: current.colorSecondary }}
              nextOrder={slides.length ? Math.max(...slides.map((s) => s.order)) + 1 : 0} />
          </div>

          {slides.length ? (
            <SlideList key={current.id} slides={slides} gameColors={{ colorMain: current.colorMain, colorSecondary: current.colorSecondary }} />
          ) : (
            <EmptyState icon={<BookOpenIcon />} title="Aucune slide pour ce jeu">
              Ajoute la première avec « Nouvelle slide » : elle apparaîtra dans l’app après la prochaine publication.
            </EmptyState>
          )}
        </>
      )}
    </>
  );
}
