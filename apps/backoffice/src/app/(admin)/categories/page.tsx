import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { DeleteCategoryButton, EditCategoryButton, NewCategoryButton } from "./CategoryTable";

export const dynamic = "force-dynamic";

export default async function Categories({
  searchParams,
}: {
  searchParams: Promise<{ jeu?: string }>;
}) {
  const sp = await searchParams;

  const [games, categories] = await Promise.all([
    prisma.game.findMany({ orderBy: { order: "asc" }, select: { id: true, slug: true, name: true, icon: true } }),
    prisma.category.findMany({
      where: sp.jeu ? { game: { slug: sp.jeu } } : {},
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      include: {
        game: { select: { name: true, icon: true, slug: true } },
        _count: { select: { cards: true } },
      },
    }),
  ]);

  // Répartition par intensité : montre d'un coup d'œil si une catégorie est
  // déséquilibrée, ce que le tirage pondéré rendrait sensible en jeu.
  const spread = await prisma.card.groupBy({
    by: ["categoryId", "intensity"],
    _count: true,
    where: { active: true },
  });
  const byCat = new Map<string, number[]>();
  for (const r of spread) {
    const arr = byCat.get(r.categoryId) ?? [0, 0, 0, 0, 0];
    arr[r.intensity - 1] = r._count;
    byCat.set(r.categoryId, arr);
  }

  const totalCards = categories.reduce((s, c) => s + c._count.cards, 0);

  return (
    <>
      <div className="mb-4 flex items-center justify-between">
        <h1 className="font-display text-[32px] font-semibold tracking-[-0.025em]">
          Catégories <span className="text-neutral-faint">{categories.length}</span>
        </h1>
        <NewCategoryButton games={games} />
      </div>

      <div className="mb-4 flex flex-wrap items-center gap-2 text-sm">
        <Link href="/categories"
          className={`rounded border px-3 py-1.5 ${!sp.jeu ? "border-accent bg-accent/10" : "border-hairline hover:bg-surface"}`}>
          Tous les jeux
        </Link>
        {games.map((g) => (
          <Link key={g.id} href={`/categories?jeu=${g.slug}`}
            className={`rounded border px-3 py-1.5 ${sp.jeu === g.slug ? "border-accent bg-accent/10" : "border-hairline hover:bg-surface"}`}>
            {g.icon} {g.name}
          </Link>
        ))}
      </div>

      <p className="mb-4 text-sm text-neutral-faint">
        {totalCards} cartes actives réparties sur ces catégories.
      </p>

      <div className="overflow-x-auto rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr>
              <th className="p-3">Catégorie</th>
              <th className="p-3">Jeu</th>
              <th className="p-3">Slug</th>
              <th className="p-3">Cartes</th>
              <th className="p-3">Répartition 1→5</th>
              <th className="p-3">Ordre</th>
              <th className="relative p-3"><span className="sr-only">Actions</span></th>
            </tr>
          </thead>
          <tbody>
            {categories.map((c) => {
              const dist = byCat.get(c.id) ?? [0, 0, 0, 0, 0];
              const max = Math.max(...dist, 1);
              return (
                <tr key={c.id} className="border-t border-hairline">
                  <td className="p-3">
                    <div className="font-medium">{c.icon} {c.name}</div>
                    {c.description && <div className="text-xs text-neutral-faint">{c.description}</div>}
                  </td>
                  <td className="whitespace-nowrap p-3 text-ink-soft">{c.game.icon} {c.game.name}</td>
                  <td className="p-3"><code className="text-xs text-neutral-faint">{c.slug}</code></td>
                  <td className="p-3">
                    <Link href={`/cartes?jeu=${c.game.slug}`} className="hover:text-accent">
                      {c._count.cards}
                    </Link>
                  </td>
                  <td className="p-3">
                    <div className="flex items-end gap-0.5" title={dist.map((n, i) => `${i + 1}: ${n}`).join(" · ")}>
                      {dist.map((n, i) => (
                        <div key={i} className="w-3 rounded-sm bg-accent"
                          style={{ height: `${Math.max(2, (n / max) * 22)}px`, opacity: n ? 0.4 + (n / max) * 0.6 : 0.15 }} />
                      ))}
                    </div>
                  </td>
                  <td className="p-3 text-neutral-faint">{c.order}</td>
                  <td className="whitespace-nowrap p-3">
                    <div className="flex gap-1">
                      <EditCategoryButton
                        cat={{ id: c.id, name: c.name, slug: c.slug, description: c.description, icon: c.icon, order: c.order, gameId: c.gameId }}
                        games={games} />
                      <DeleteCategoryButton id={c.id} name={c.name} cards={c._count.cards} />
                    </div>
                  </td>
                </tr>
              );
            })}
            {!categories.length && (
              <tr><td colSpan={7} className="p-4 text-neutral-faint">Aucune catégorie</td></tr>
            )}
          </tbody>
        </table>
      </div>
    </>
  );
}
