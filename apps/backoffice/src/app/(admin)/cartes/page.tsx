import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { DeleteCardButton, EditCardButton, NewCardButton, ToggleActive } from "./CardEditor";

export const dynamic = "force-dynamic";

const PER_PAGE = 50;

export default async function Cartes({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; jeu?: string; intensite?: string; q?: string; sansEn?: string }>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, parseInt(sp.page ?? "1", 10));
  const where = {
    ...(sp.jeu ? { category: { game: { slug: sp.jeu } } } : {}),
    ...(sp.intensite ? { intensity: parseInt(sp.intensite, 10) } : {}),
    ...(sp.q ? { text: { contains: sp.q, mode: "insensitive" as const } } : {}),
    ...(sp.sansEn ? { translations: { none: { locale: "en" } } } : {}),
  };

  const [games, categories, total, cards] = await Promise.all([
    prisma.game.findMany({ orderBy: { order: "asc" }, select: { slug: true, name: true } }),
    prisma.category.findMany({
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      select: { id: true, name: true, game: { select: { name: true } } },
    }),
    prisma.card.count({ where }),
    prisma.card.findMany({
      where,
      orderBy: [{ category: { game: { order: "asc" } } }, { order: "asc" }],
      skip: (page - 1) * PER_PAGE,
      take: PER_PAGE,
      include: {
        category: { select: { id: true, name: true, game: { select: { name: true, icon: true } } } },
        _count: { select: { translations: true } },
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
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Cartes <span className="text-neutral-faint">{total}</span></h1>
        <div className="flex gap-2">
          <a href={`/api/export/cards${sp.jeu ? `?jeu=${sp.jeu}` : ""}`}
            className="rounded border border-hairline px-3 py-1.5 text-sm text-ink-soft hover:bg-surface">
            Export CSV
          </a>
          <NewCardButton categories={categories} />
        </div>
      </div>

      <form className="mb-4 flex flex-wrap items-center gap-2 text-sm">
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
        <label className="flex items-center gap-1.5 text-ink-soft">
          <input type="checkbox" name="sansEn" value="1" defaultChecked={!!sp.sansEn} />
          sans traduction EN
        </label>
        <button className="rounded bg-accent px-3 py-1.5 font-medium text-white">Filtrer</button>
        {(sp.q || sp.jeu || sp.intensite || sp.sansEn) && (
          <Link href="/cartes" className="text-neutral-faint hover:text-ink">réinitialiser</Link>
        )}
      </form>

      <div className="overflow-x-auto rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr>
              <th className="p-2">Texte</th><th className="p-2">Jeu</th>
              <th className="p-2">Catégorie</th><th className="p-2">Int.</th>
              <th className="p-2">Tags</th><th className="p-2">EN</th>
              <th className="p-2">État</th><th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {cards.map((c) => (
              <tr key={c.id} className={`border-t border-hairline ${c.active ? "" : "opacity-50"}`}>
                <td className="max-w-sm p-2">{c.text}</td>
                <td className="whitespace-nowrap p-2">{c.category.game.icon} {c.category.game.name}</td>
                <td className="whitespace-nowrap p-2 text-ink-soft">{c.category.name}</td>
                <td className="p-2">{c.intensity}</td>
                <td className="p-2 text-xs text-neutral-faint">{c.canonicalTags.join(", ")}</td>
                <td className="p-2">{c._count.translations ? "✓" : "—"}</td>
                <td className="p-2 text-xs">{c.active ? "active" : "inactive"}</td>
                <td className="whitespace-nowrap p-2">
                  <div className="flex gap-1">
                    <EditCardButton
                      card={{ id: c.id, text: c.text, intensity: c.intensity, tags: c.tags, active: c.active, order: c.order, categoryId: c.category.id }}
                      categories={categories} />
                    <ToggleActive id={c.id} active={c.active} />
                    <DeleteCardButton id={c.id} />
                  </div>
                </td>
              </tr>
            ))}
            {!cards.length && <tr><td colSpan={8} className="p-4 text-neutral-faint">Aucune carte</td></tr>}
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
