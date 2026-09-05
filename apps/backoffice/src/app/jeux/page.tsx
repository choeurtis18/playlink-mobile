import { prisma } from "@/lib/prisma";

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
      <h1 className="mb-6 text-2xl font-semibold">Jeux</h1>
      <div className="flex flex-col gap-3">
        {games.map((g) => {
          const cards = g.categories.reduce((s, c) => s + c._count.cards, 0);
          return (
            <div key={g.id} className="rounded-lg border border-hairline bg-surface p-4">
              <div className="flex items-center gap-3">
                <span className="text-2xl">{g.icon}</span>
                <div className="min-w-0 flex-1">
                  <div className="font-medium">{g.name}</div>
                  <div className="text-xs text-neutral-faint">
                    {g.slug} · {g.categories.length} catégories · {cards} cartes ·{" "}
                    {g._count.ruleSlides} slides
                  </div>
                </div>
                <div className="flex gap-1">
                  <span className="h-6 w-6 rounded" style={{ background: g.colorMain }} />
                  <span className="h-6 w-6 rounded" style={{ background: g.colorSecondary }} />
                </div>
              </div>
              <div className="mt-3 flex flex-wrap gap-2">
                {g.categories.map((c) => (
                  <span key={c.id} className="rounded border border-hairline bg-raised px-2 py-1 text-xs">
                    {c.name} <span className="text-neutral-faint">{c._count.cards}</span>
                  </span>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}
