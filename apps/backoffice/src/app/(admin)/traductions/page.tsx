import { prisma } from "@/lib/prisma";

export const dynamic = "force-dynamic";

// Le tableau de bord de l'effort de traduction (§04). FR est la langue
// d'origine : une carte sans CardTranslation 'en' est servie en FR à l'app,
// ce n'est pas un bug mais un reste-à-faire.
export default async function Traductions() {
  const games = await prisma.game.findMany({
    orderBy: { order: "asc" },
    select: {
      id: true, name: true, icon: true,
      categories: {
        select: {
          id: true, name: true,
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

  return (
    <>
      <h1 className="mb-2 text-2xl font-semibold">Traductions</h1>
      <p className="mb-6 text-sm text-neutral-faint">
        {total - missing} / {total} cartes traduites en anglais
        {total > 0 && ` — ${Math.round(((total - missing) / total) * 100)} % de couverture`}.
        Les cartes non traduites sont servies en français.
      </p>

      <div className="overflow-hidden rounded-lg border border-hairline">
        <table className="w-full text-sm">
          <thead className="bg-raised text-left text-xs text-neutral-faint">
            <tr><th className="p-3">Jeu</th><th className="p-3">Traduites</th><th className="p-3">Restantes</th><th className="p-3">Couverture</th></tr>
          </thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.id} className="border-t border-hairline">
                <td className="p-3">{r.icon} {r.name}</td>
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

      <p className="mt-6 text-sm text-neutral-faint">
        L&apos;export CSV du reste-à-faire et l&apos;édition inline FR↔EN arrivent en phase 5.
      </p>
    </>
  );
}
