import { prisma } from "@/lib/prisma";
import Link from "next/link";
import { TranslationRow } from "./TranslationRow";

export const dynamic = "force-dynamic";

const PER_PAGE = 25;

export default async function Traductions({
  searchParams,
}: {
  searchParams: Promise<{ jeu?: string; page?: string; tout?: string }>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, parseInt(sp.page ?? "1", 10));

  const games = await prisma.game.findMany({
    orderBy: { order: "asc" },
    select: {
      id: true, slug: true, name: true, icon: true,
      categories: {
        select: {
          _count: { select: { cards: true } },
          cards: { where: { translations: { none: { locale: "en" } } }, select: { id: true } },
        },
      },
    },
  });

  const rows = games.map((g) => {
    const total = g.categories.reduce((s, c) => s + c._count.cards, 0);
    const missing = g.categories.reduce((s, c) => s + c.cards.length, 0);
    return { ...g, total, missing, done: total - missing };
  });
  const total = rows.reduce((s, r) => s + r.total, 0);
  const missing = rows.reduce((s, r) => s + r.missing, 0);

  // Par défaut on ne montre que le reste-à-faire : c'est le tableau de bord
  // de l'effort de traduction, pas un explorateur de contenu.
  const where = {
    ...(sp.jeu ? { category: { game: { slug: sp.jeu } } } : {}),
    ...(sp.tout ? {} : { translations: { none: { locale: "en" } } }),
  };
  const [count, cards] = await Promise.all([
    prisma.card.count({ where }),
    prisma.card.findMany({
      where,
      orderBy: [{ category: { game: { order: "asc" } } }, { order: "asc" }],
      skip: (page - 1) * PER_PAGE, take: PER_PAGE,
      include: { translations: { where: { locale: "en" }, select: { text: true } } },
    }),
  ]);
  const pages = Math.ceil(count / PER_PAGE);
  const qs = (o: Record<string, string | undefined>) => {
    const p = new URLSearchParams();
    for (const [k, v] of Object.entries({ ...sp, ...o })) if (v) p.set(k, v);
    return `?${p}`;
  };

  return (
    <>
      <div className="mb-2 flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Traductions</h1>
        <a href="/api/export/cards" className="rounded border border-hairline px-3 py-1.5 text-sm text-ink-soft hover:bg-surface">
          Export CSV
        </a>
      </div>
      <p className="mb-6 text-sm text-neutral-faint">
        {total - missing} / {total} cartes traduites
        {total > 0 && ` — ${Math.round(((total - missing) / total) * 100)} % de couverture`}.
        Une carte non traduite est servie en français.
      </p>

      <div className="mb-6 overflow-hidden rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr><th className="p-3">Jeu</th><th className="p-3">Traduites</th><th className="p-3">Restantes</th><th className="p-3">Couverture</th></tr>
          </thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id} className="border-t border-hairline">
                <td className="p-3">
                  <Link href={qs({ jeu: r.slug, page: undefined })} className="hover:text-accent">
                    {r.icon} {r.name}
                  </Link>
                </td>
                <td className="p-3">{r.done}</td>
                <td className="p-3">{r.missing > 0 ? <span className="text-accent">{r.missing}</span> : "—"}</td>
                <td className="p-3">
                  <div className="h-2 w-32 overflow-hidden rounded bg-raised">
                    <div className="h-full bg-accent" style={{ width: `${r.total ? (r.done / r.total) * 100 : 0}%` }} />
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="mb-3 flex items-center gap-3 text-sm">
        <h2 className="font-medium">
          {sp.tout ? "Toutes les cartes" : "À traduire"} <span className="text-neutral-faint">{count}</span>
        </h2>
        {sp.jeu && <Link href={qs({ jeu: undefined, page: undefined })} className="text-neutral-faint hover:text-ink">tous les jeux</Link>}
        <Link href={qs({ tout: sp.tout ? undefined : "1", page: undefined })} className="text-neutral-faint hover:text-ink">
          {sp.tout ? "voir seulement le reste-à-faire" : "voir tout"}
        </Link>
      </div>

      <div className="overflow-hidden rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr><th className="p-2">Français (original)</th><th className="p-2">Anglais</th></tr>
          </thead>
          <tbody>
            {cards.map((c) => (
              <TranslationRow key={c.id} id={c.id} fr={c.text} en={c.translations[0]?.text ?? null} />
            ))}
            {!cards.length && <tr><td colSpan={2} className="p-4 text-neutral-faint">Rien à traduire ici 🎉</td></tr>}
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
