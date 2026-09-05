import { prisma } from "@/lib/prisma";
import Link from "next/link";

export const dynamic = "force-dynamic";

const PER_PAGE = 50;

// Pagination et filtres côté serveur : 1521 cartes ne se chargent pas d'un bloc.
export default async function Cartes({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; jeu?: string; intensite?: string; q?: string }>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, parseInt(sp.page ?? "1", 10));
  const where = {
    ...(sp.jeu ? { category: { game: { slug: sp.jeu } } } : {}),
    ...(sp.intensite ? { intensity: parseInt(sp.intensite, 10) } : {}),
    ...(sp.q ? { text: { contains: sp.q, mode: "insensitive" as const } } : {}),
  };

  const [games, total, cards] = await Promise.all([
    prisma.game.findMany({ orderBy: { order: "asc" }, select: { slug: true, name: true } }),
    prisma.card.count({ where }),
    prisma.card.findMany({
      where,
      orderBy: [{ category: { game: { order: "asc" } } }, { order: "asc" }],
      skip: (page - 1) * PER_PAGE,
      take: PER_PAGE,
      include: {
        category: { select: { name: true, game: { select: { name: true, icon: true } } } },
        _count: { select: { translations: true, likes: true } },
      },
    }),
  ]);

  const pages = Math.ceil(total / PER_PAGE);
  const qs = (over: Record<string, string | undefined>) => {
    const p = new URLSearchParams();
    for (const [k, v] of Object.entries({ ...sp, ...over })) if (v) p.set(k, v);
    return `?${p}`;
  };

  return (
    <>
      <h1 className="mb-4 text-2xl font-semibold">Cartes <span className="text-neutral-faint">{total}</span></h1>

      <form className="mb-4 flex flex-wrap gap-2 text-sm">
        <input name="q" defaultValue={sp.q} placeholder="Rechercher…"
          className="rounded border border-hairline bg-surface px-3 py-1.5" />
        <select name="jeu" defaultValue={sp.jeu ?? ""} className="rounded border border-hairline bg-surface px-3 py-1.5">
          <option value="">Tous les jeux</option>
          {games.map((g) => <option key={g.slug} value={g.slug}>{g.name}</option>)}
        </select>
        <select name="intensite" defaultValue={sp.intensite ?? ""} className="rounded border border-hairline bg-surface px-3 py-1.5">
          <option value="">Toutes intensités</option>
          {[1, 2, 3, 4, 5].map((i) => <option key={i} value={i}>Intensité {i}</option>)}
        </select>
        <button className="rounded bg-accent px-3 py-1.5 font-medium text-white">Filtrer</button>
      </form>

      <div className="overflow-x-auto rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr>
              <th className="p-2">Texte</th><th className="p-2">Jeu</th>
              <th className="p-2">Catégorie</th><th className="p-2">Int.</th>
              <th className="p-2">Tags</th><th className="p-2">EN</th>
            </tr>
          </thead>
          <tbody>
            {cards.map((c) => (
              <tr key={c.id} className="border-t border-hairline">
                <td className="max-w-md p-2">{c.text}</td>
                <td className="whitespace-nowrap p-2">{c.category.game.icon} {c.category.game.name}</td>
                <td className="whitespace-nowrap p-2 text-ink-soft">{c.category.name}</td>
                <td className="p-2">{c.intensity}</td>
                <td className="p-2 text-xs text-neutral-faint">{c.canonicalTags.join(", ")}</td>
                <td className="p-2">{c._count.translations ? "✓" : "—"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {pages > 1 && (
        <div className="mt-4 flex items-center gap-2 text-sm">
          {page > 1 && <Link href={qs({ page: String(page - 1) })} className="rounded border border-hairline px-3 py-1">Précédent</Link>}
          <span className="text-neutral-faint">page {page} / {pages}</span>
          {page < pages && <Link href={qs({ page: String(page + 1) })} className="rounded border border-hairline px-3 py-1">Suivant</Link>}
        </div>
      )}
    </>
  );
}
