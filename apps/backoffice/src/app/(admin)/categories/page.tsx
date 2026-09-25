import Link from "next/link";
import { prisma } from "@/lib/prisma";
import { PageHeader } from "@/components/ui";
import { DeleteCategoryButton, DistBars, EditCategoryButton, NewCategoryButton } from "./CategoryTable";

export const dynamic = "force-dynamic";

const nf = new Intl.NumberFormat("fr-FR");

export default async function Categories({ searchParams }: { searchParams: Promise<{ jeu?: string }> }) {
  const sp = await searchParams;

  const [games, categories, spread] = await Promise.all([
    prisma.game.findMany({
      orderBy: { order: "asc" },
      select: { id: true, slug: true, name: true, icon: true, colorMain: true, colorSecondary: true, _count: { select: { categories: true } } },
    }),
    prisma.category.findMany({
      where: sp.jeu ? { game: { slug: sp.jeu } } : {},
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      include: {
        game: { select: { name: true, icon: true, slug: true, colorMain: true, colorSecondary: true } },
        _count: { select: { cards: true } },
      },
    }),
    // Répartition par intensité : montre d'un coup d'œil si une catégorie
    // est déséquilibrée, ce que le tirage pondéré rendrait sensible en jeu.
    prisma.card.groupBy({ by: ["categoryId", "intensity"], _count: true, where: { active: true } }),
  ]);

  const byCat = new Map<string, number[]>();
  for (const r of spread) {
    const arr = byCat.get(r.categoryId) ?? [0, 0, 0, 0, 0];
    arr[r.intensity - 1] = r._count;
    byCat.set(r.categoryId, arr);
  }
  const activeCards = categories.reduce((s, c) => s + (byCat.get(c.id) ?? []).reduce((a, b) => a + b, 0), 0);
  const allCategories = games.reduce((s, g) => s + g._count.categories, 0);
  const pill = (on: boolean) =>
    `inline-flex items-center gap-1.5 rounded-full border px-3 py-1 text-[13px] transition-colors ${on ? "border-accent bg-accent/12 text-ink" : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink"}`;

  return (
    <>
      <PageHeader
        title={<>Catégories <span className="font-sans text-lg font-medium tracking-normal text-neutral-faint">{categories.length}</span></>}
        description={`${nf.format(activeCards)} cartes actives réparties sur ces catégories.`}
        actions={<NewCategoryButton games={games} />}
      />

      <nav aria-label="Filtrer par jeu" className="mb-4 flex flex-wrap gap-1.5">
        <Link href="/categories" aria-current={!sp.jeu ? "page" : undefined} className={pill(!sp.jeu)}>
          Tous les jeux <span className="font-mono text-[11px] text-neutral-faint">{allCategories}</span>
        </Link>
        {games.map((g) => (
          <Link key={g.id} href={`/categories?jeu=${g.slug}`} aria-current={sp.jeu === g.slug ? "page" : undefined} className={pill(sp.jeu === g.slug)}>
            <span aria-hidden>{g.icon}</span> {g.name} <span className="font-mono text-[11px] text-neutral-faint">{g._count.categories}</span>
          </Link>
        ))}
      </nav>

      {/* `relative` : les textes masqués (sr-only, en absolu) restent dans la zone de défilement au lieu d’élargir la page. */}
      <div className="relative overflow-x-auto rounded-[14px] border border-hairline bg-surface">
        <table className="w-full border-collapse text-[13.5px] leading-[1.45]">
          <thead className="text-left font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint">
            <tr>
              <th className="px-3.5 py-3 font-medium">Catégorie</th>
              <th className="px-3.5 py-3 font-medium">Jeu</th>
              <th className="px-3.5 py-3 font-medium">Slug</th>
              <th className="px-3.5 py-3 font-medium">Cartes</th>
              <th className="px-3.5 py-3 font-medium">Répartition 1→5</th>
              <th className="px-3.5 py-3 font-medium">Ordre</th>
              <th className="relative px-3.5 py-3"><span className="sr-only">Actions</span></th>
            </tr>
          </thead>
          <tbody>
            {categories.map((c) => (
              <tr key={c.id} className="border-t border-hairline transition-colors hover:bg-raised">
                <td className="px-3.5 py-[11px]">
                  <div className="flex items-start gap-2.5">
                    <span aria-hidden className="text-lg leading-tight">{c.icon}</span>
                    <span className="flex flex-col">
                      <span className="font-medium">{c.name}</span>
                      {c.description && <span className="text-xs text-neutral-faint">{c.description}</span>}
                    </span>
                  </div>
                </td>
                <td className="whitespace-nowrap px-3.5 py-[11px] text-ink-soft">
                  <span className="inline-flex items-center gap-2">
                    <span aria-hidden className="h-2 w-2 rounded-full" style={{ background: `linear-gradient(135deg, ${c.game.colorMain}, ${c.game.colorSecondary})` }} />
                    {c.game.name}
                  </span>
                </td>
                <td className="px-3.5 py-[11px]"><code className="font-mono text-[11.5px] text-neutral-faint">{c.slug}</code></td>
                <td className="px-3.5 py-[11px]">
                  <Link href={`/cartes?jeu=${c.game.slug}&categorie=${c.slug}`} className="font-semibold text-ink hover:text-accent-deep">
                    {nf.format(c._count.cards)} <span className="sr-only">cartes, voir la liste</span>
                  </Link>
                </td>
                <td className="px-3.5 py-[11px]"><DistBars dist={byCat.get(c.id) ?? [0, 0, 0, 0, 0]} /></td>
                <td className="px-3.5 py-[11px] font-mono text-xs text-neutral-faint">{c.order}</td>
                <td className="whitespace-nowrap px-3.5 py-[11px] text-right">
                  <div className="inline-flex items-center gap-1">
                    <EditCategoryButton
                      cat={{ id: c.id, name: c.name, slug: c.slug, description: c.description, icon: c.icon, order: c.order, gameId: c.gameId }}
                      games={games} />
                    <DeleteCategoryButton id={c.id} name={c.name} cards={c._count.cards} />
                  </div>
                </td>
              </tr>
            ))}
            {!categories.length && (
              <tr><td colSpan={7} className="px-8 py-8 text-center text-neutral-faint">Aucune catégorie pour ce jeu.</td></tr>
            )}
          </tbody>
        </table>
      </div>
      <p className="mt-3 text-xs text-neutral-faint">Une catégorie non vide n’est pas supprimable : vide-la d’abord depuis Cartes.</p>
    </>
  );
}
