import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { CategoryButtons, DeleteCategoryButton, EditGameButton, NewCategoryButton, NewGameButton } from "./GameEditor";

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
        <h1 className="text-2xl font-semibold">Jeux</h1>
        <NewGameButton />
      </div>

      <div className="flex flex-col gap-3">
        {games.map((g) => {
          const cards = g.categories.reduce((s, c) => s + c._count.cards, 0);
          return (
            <div key={g.id} className={`rounded-lg border border-hairline bg-surface p-4 ${g.active ? "" : "opacity-60"}`}>
              <div className="flex items-center gap-3">
                <span className="text-2xl">{g.icon}</span>
                <div className="min-w-0 flex-1">
                  <div className="font-medium">{g.name} {!g.active && <span className="text-xs text-neutral-faint">(inactif)</span>}</div>
                  <div className="text-xs text-neutral-faint">
                    {g.slug} · {g.categories.length} catégories · {cards} cartes ·{" "}
                    <Link href={`/regles?jeu=${g.slug}`} className="hover:text-ink">{g._count.ruleSlides} slides</Link>
                  </div>
                </div>
                <div className="flex gap-1">
                  <span className="h-6 w-6 rounded" style={{ background: g.colorMain }} />
                  <span className="h-6 w-6 rounded" style={{ background: g.colorSecondary }} />
                </div>
                <EditGameButton game={g} />
              </div>

              <div className="mt-3 flex flex-wrap items-center gap-2">
                {g.categories.map((c) => (
                  <span key={c.id} className="inline-flex items-center gap-1.5 rounded border border-hairline bg-raised px-2 py-1 text-xs">
                    <Link href={`/cartes?jeu=${g.slug}`} className="hover:text-accent">
                      {c.name} <span className="text-neutral-faint">{c._count.cards}</span>
                    </Link>
                    <CategoryButtons cat={c} />
                    {c._count.cards === 0 && <DeleteCategoryButton id={c.id} name={c.name} />}
                  </span>
                ))}
                <NewCategoryButton gameId={g.id} gameName={g.name} />
              </div>
            </div>
          );
        })}
      </div>
    </>
  );
}
