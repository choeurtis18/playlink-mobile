import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { DeleteSlideButton, EditSlideButton, NewSlideButton } from "./SlideEditor";

export const dynamic = "force-dynamic";

export default async function Regles({ searchParams }: { searchParams: Promise<{ jeu?: string }> }) {
  const sp = await searchParams;
  const games = await prisma.game.findMany({
    orderBy: { order: "asc" },
    select: { id: true, slug: true, name: true, icon: true, _count: { select: { ruleSlides: true } } },
  });
  const current = games.find((g) => g.slug === sp.jeu) ?? games[0];

  const slides = current
    ? await prisma.gameRuleSlide.findMany({ where: { gameId: current.id }, orderBy: { order: "asc" } })
    : [];

  return (
    <>
      <h1 className="mb-2 text-2xl font-semibold">Règles du jeu</h1>
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
              nextOrder={slides.length ? Math.max(...slides.map((s) => s.order)) + 1 : 0} />
          </div>

          <div className="flex flex-col gap-3">
            {slides.map((s) => (
              <div key={s.id} className="rounded-lg border border-hairline bg-surface p-4">
                <div className="flex items-start gap-4">
                  <span className="mt-1 w-6 shrink-0 text-sm text-neutral-faint">{s.order}</span>
                  <div className="min-w-0 flex-1">
                    <div className="font-medium">{s.title}</div>
                    <p className="mt-1 whitespace-pre-wrap text-sm text-ink-soft">{s.content}</p>
                    {s.imageRef && <code className="mt-2 block text-xs text-neutral-faint">{s.imageRef}</code>}
                  </div>
                  <div className="flex shrink-0 gap-1">
                    <EditSlideButton slide={{ id: s.id, gameId: s.gameId, title: s.title, content: s.content, order: s.order }} />
                    <DeleteSlideButton id={s.id} />
                  </div>
                </div>
              </div>
            ))}
            {!slides.length && (
              <p className="rounded-lg border border-hairline bg-surface p-4 text-sm text-neutral-faint">
                Aucune slide pour ce jeu.
              </p>
            )}
          </div>
        </>
      )}
    </>
  );
}
