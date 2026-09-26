import Link from "next/link";
import { prisma } from "@/lib/prisma";
import { TranslationRow } from "./TranslationRow";
import { TranslationFilters } from "./TranslationFilters";

const PER_PAGE = 25;
const nf = new Intl.NumberFormat("fr-FR");

/** Onglet Cartes : couverture, avancement par jeu, liste à traduire. */
export async function CardsTab({ sp }: { sp: { jeu?: string; categorie?: string; q?: string; page?: string; tout?: string } }) {
  const page = Math.max(1, parseInt(sp.page ?? "1", 10) || 1);

  const [games, categories, perGame] = await Promise.all([
    prisma.game.findMany({
      orderBy: { order: "asc" },
      select: { id: true, slug: true, name: true, icon: true, colorMain: true, colorSecondary: true },
    }),
    prisma.category.findMany({
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      select: { id: true, name: true, slug: true, game: { select: { name: true, slug: true } } },
    }),
    // Couverture par jeu : deux comptages groupés, pas une requête par jeu.
    Promise.all([
      prisma.card.groupBy({ by: ["categoryId"], _count: true }),
      prisma.card.groupBy({ by: ["categoryId"], _count: true, where: { translations: { some: { locale: "en" } } } }),
      prisma.category.findMany({ select: { id: true, gameId: true } }),
    ]),
  ]);

  const [allByCat, doneByCat, catGame] = perGame;
  const gameOf = new Map(catGame.map((c) => [c.id, c.gameId]));
  const sum = (rows: { categoryId: string; _count: number }[], gameId: string) =>
    rows.filter((r) => gameOf.get(r.categoryId) === gameId).reduce((s, r) => s + r._count, 0);
  const rows = games.map((g) => {
    const total = sum(allByCat, g.id);
    const done = sum(doneByCat, g.id);
    return { ...g, total, done, missing: total - done };
  });
  const total = rows.reduce((s, r) => s + r.total, 0);
  const done = rows.reduce((s, r) => s + r.done, 0);
  const pct = total ? Math.round((done / total) * 100) : 100;

  // Par défaut on ne montre que le reste-à-faire : c'est le tableau de bord
  // de l'effort de traduction, pas un explorateur de contenu.
  const where = {
    ...(sp.categorie
      ? { category: { slug: sp.categorie, ...(sp.jeu ? { game: { slug: sp.jeu } } : {}) } }
      : sp.jeu ? { category: { game: { slug: sp.jeu } } } : {}),
    ...(sp.q
      ? { OR: [
          { text: { contains: sp.q, mode: "insensitive" as const } },
          { translations: { some: { locale: "en", text: { contains: sp.q, mode: "insensitive" as const } } } },
        ] }
      : {}),
    ...(sp.tout ? {} : { translations: { none: { locale: "en" } } }),
  };
  const [count, cards] = await Promise.all([
    prisma.card.count({ where }),
    prisma.card.findMany({
      where,
      orderBy: [{ category: { game: { order: "asc" } } }, { category: { order: "asc" } }, { order: "asc" }, { id: "asc" }],
      skip: (page - 1) * PER_PAGE, take: PER_PAGE,
      include: {
        translations: { where: { locale: "en" }, select: { text: true } },
        category: { select: { name: true, game: { select: { name: true, colorMain: true, colorSecondary: true } } } },
      },
    }),
  ]);
  const pages = Math.max(1, Math.ceil(count / PER_PAGE));
  const qs = (o: Record<string, string | undefined>) => {
    const p = new URLSearchParams();
    for (const [k, v] of Object.entries({ ...sp, ...o })) if (v) p.set(k, v);
    return `?${p}`;
  };
  const gradient = (g: { colorMain: string; colorSecondary: string }) => `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})`;

  return (
    <>

      <div className="mb-6 grid grid-cols-[repeat(auto-fit,minmax(min(100%,320px),1fr))] gap-4">
        <section aria-label="Couverture anglaise" className="flex flex-col justify-center gap-3 rounded-[14px] border border-hairline bg-surface p-5">
          <span className="text-[13px] text-neutral-faint">Couverture anglaise</span>
          <span className="flex items-baseline gap-2.5">
            <span className="font-display text-[64px] font-semibold leading-none tracking-[-0.04em]">{pct} %</span>
            <span className="text-sm text-ink-soft">{nf.format(done)} / {nf.format(total)} cartes traduites</span>
          </span>
          <div role="progressbar" aria-label="Couverture anglaise" aria-valuenow={pct} aria-valuemin={0} aria-valuemax={100} className="h-2 overflow-hidden rounded bg-raised">
            <div className="h-full rounded bg-accent" style={{ width: `${pct}%` }} />
          </div>
        </section>

        <nav aria-label="Avancement par jeu" className="rounded-[14px] border border-hairline bg-surface px-[18px] py-2">
          <ul className="m-0 list-none p-0">
            {rows.map((r) => {
              const on = sp.jeu === r.slug;
              return (
                <li key={r.id}>
                  <Link
                    href={on ? qs({ jeu: undefined, categorie: undefined, page: undefined }) : qs({ jeu: r.slug, categorie: undefined, page: undefined })}
                    aria-current={on ? "true" : undefined}
                    className="grid grid-cols-[20px_minmax(0,130px)_1fr_64px] items-center gap-2.5 rounded-md py-1.5 text-[13px] text-ink hover:text-ink"
                  >
                    <span aria-hidden>{r.icon}</span>
                    <span className={`truncate ${on ? "font-semibold" : ""}`}>{r.name}</span>
                    <span aria-hidden className="h-1.5 overflow-hidden rounded-sm bg-raised">
                      <span className="block h-full" style={{ width: `${r.total ? (r.done / r.total) * 100 : 100}%`, background: gradient(r) }} />
                    </span>
                    <span className={`text-right text-xs ${r.missing ? "text-warning" : "text-success"}`}>
                      {r.missing ? `${r.missing} à faire` : "complet"}
                    </span>
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>
      </div>

      <div className="mb-3 flex flex-wrap items-center gap-3">
        <h2 className="m-0 text-base font-semibold">
          {sp.tout ? "Toutes les cartes" : "À traduire"} <span className="font-medium text-neutral-faint">{nf.format(count)}</span>
        </h2>
        <Link href={qs({ tout: sp.tout ? undefined : "1", page: undefined })} className="text-[13px] text-accent-deep hover:text-ink">
          {sp.tout ? "Voir seulement le reste à faire" : "Tout voir"}
        </Link>
        <span className="flex-1" />
        <TranslationFilters games={games} categories={categories} sp={sp} />
      </div>

      <div className="overflow-hidden rounded-[14px] border border-hairline bg-surface">
        <div aria-hidden className="hidden grid-cols-2 gap-5 px-[18px] py-3 font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint md:grid">
          <span>Français (original)</span><span>Anglais</span>
        </div>
        <ul className="m-0 list-none p-0" aria-label="Cartes à traduire">
          {cards.map((c) => (
            <TranslationRow
              key={c.id}
              id={c.id}
              fr={c.text}
              en={c.translations[0]?.text ?? null}
              meta={`${c.category.game.name} · ${c.category.name}`}
              color={gradient(c.category.game)}
            />
          ))}
        </ul>
        {!cards.length && (
          <p className="m-0 border-t border-hairline px-8 py-8 text-center text-sm text-neutral-faint">
            {sp.tout || sp.q ? "Aucune carte ne correspond." : "Rien à traduire ici — beau travail."}
          </p>
        )}
      </div>

      <div className="mt-3 flex flex-wrap items-center justify-between gap-3 text-xs text-neutral-faint">
        <p className="m-0">Enregistrement automatique en quittant le champ.{pages > 1 && ` Page ${page} / ${pages}.`}</p>
        {pages > 1 && (
          <nav aria-label="Pagination" className="flex gap-2">
            {page > 1 && <Link href={qs({ page: String(page - 1) })} className="rounded-lg border border-hairline px-3 py-1.5 text-ink-soft hover:text-ink">← Précédent</Link>}
            {page < pages && <Link href={qs({ page: String(page + 1) })} className="rounded-lg border border-hairline px-3 py-1.5 text-ink-soft hover:text-ink">Suivant →</Link>}
          </nav>
        )}
      </div>
    </>
  );
}
