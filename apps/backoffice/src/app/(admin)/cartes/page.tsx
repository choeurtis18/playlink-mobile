import Link from "next/link";
import { CheckCircleIcon, DownloadSimpleIcon, MinusCircleIcon, UploadSimpleIcon } from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { ButtonLink, ImportButton, PageHeader } from "@/components/ui";
import { importCards } from "@/lib/actions";
import { ActiveSwitch, CardFilters, DeleteCardButton, EditCardButton, IntensityPips, NewCardButton } from "./CardEditor";

export const dynamic = "force-dynamic";

const PER_PAGE = 50;
const nf = new Intl.NumberFormat("fr-FR");

export default async function Cartes({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; jeu?: string; categorie?: string; intensite?: string; q?: string; sansEn?: string }>;
}) {
  const sp = await searchParams;
  const page = Math.max(1, parseInt(sp.page ?? "1", 10) || 1);
  const intensity = parseInt(sp.intensite ?? "", 10);
  const where = {
    ...(sp.categorie
      ? { category: { slug: sp.categorie, ...(sp.jeu ? { game: { slug: sp.jeu } } : {}) } }
      : sp.jeu ? { category: { game: { slug: sp.jeu } } } : {}),
    ...(intensity >= 1 && intensity <= 5 ? { intensity } : {}),
    ...(sp.q ? { text: { contains: sp.q, mode: "insensitive" as const } } : {}),
    ...(sp.sansEn ? { translations: { none: { locale: "en" } } } : {}),
  };

  const [games, categories, total, all, cards] = await Promise.all([
    prisma.game.findMany({ orderBy: { order: "asc" }, select: { id: true, slug: true, name: true, colorMain: true, colorSecondary: true } }),
    prisma.category.findMany({
      orderBy: [{ game: { order: "asc" } }, { order: "asc" }],
      select: { id: true, name: true, slug: true, gameId: true, game: { select: { name: true, slug: true } } },
    }),
    prisma.card.count({ where }),
    prisma.card.count(),
    prisma.card.findMany({
      where,
      // `id` en dernier : sans lui, des cartes de même ordre changent de place
      // après chaque modification (ordre arbitraire de PostgreSQL).
      orderBy: [{ category: { game: { order: "asc" } } }, { category: { order: "asc" } }, { order: "asc" }, { id: "asc" }],
      skip: (page - 1) * PER_PAGE,
      take: PER_PAGE,
      include: {
        category: { select: { id: true, name: true, game: { select: { name: true, icon: true, colorMain: true, colorSecondary: true } } } },
        _count: { select: { translations: { where: { locale: "en" } } } },
      },
    }),
  ]);

  const pages = Math.max(1, Math.ceil(total / PER_PAGE));
  const qs = (over: Record<string, string | undefined>) => {
    const p = new URLSearchParams();
    for (const [k, v] of Object.entries({ ...sp, ...over })) if (v) p.set(k, v);
    return `?${p}`;
  };
  const filtered = total !== all;

  return (
    <>
      <PageHeader
        title={<>Cartes <span className="font-sans text-lg font-medium tracking-normal text-neutral-faint">{nf.format(all)}</span></>}
        actions={
          <>
            <ButtonLink href={`/api/export/cards${sp.jeu ? `?jeu=${sp.jeu}` : ""}`} icon={<DownloadSimpleIcon aria-hidden />}>Export CSV</ButtonLink>
            <ImportButton
              icon={<UploadSimpleIcon aria-hidden />}
              templateHref="/api/templates/cards"
              columns="id, jeu, categorie, texte, intensite, tags, actif, ordre, texte_en"
              notes="Une ligne avec id met à jour, sans id crée. jeu/categorie doivent correspondre au nom exact existant. Tout ou rien : une erreur annule l'import entier."
              action={importCards}
            />
            <NewCardButton games={games} categories={categories} />
          </>
        }
      />

      <CardFilters games={games} categories={categories} sp={sp} />

      {/* `relative` : les textes masqués (sr-only, en absolu) restent dans la zone de défilement au lieu d’élargir la page. */}
      <div className="relative overflow-x-auto rounded-[14px] border border-hairline bg-surface">
        <table className="w-full border-collapse text-[13.5px] leading-[1.45]">
          <caption className="sr-only">Cartes{filtered ? " filtrées" : ""}, page {page} sur {pages}</caption>
          <thead className="text-left font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint">
            <tr>
              <th className="px-3.5 py-3 font-medium">Carte</th>
              <th className="px-3.5 py-3 font-medium">Catégorie</th>
              <th className="px-3.5 py-3 font-medium">Intensité</th>
              <th className="px-3.5 py-3 font-medium">EN</th>
              <th className="px-3.5 py-3 font-medium">Active</th>
              <th className="relative px-3.5 py-3"><span className="sr-only">Actions</span></th>
            </tr>
          </thead>
          <tbody>
            {cards.map((c) => {
              const g = c.category.game;
              const hasEn = c._count.translations > 0;
              return (
                <tr key={c.id} className="border-t border-hairline transition-colors hover:bg-raised">
                  <td className={`max-w-[420px] px-3.5 py-[11px] ${c.active ? "" : "text-neutral-faint"}`}>
                    <div className="flex items-start gap-2.5">
                      <span aria-hidden className="mt-1.5 h-2 w-2 flex-none rounded-full" style={{ background: `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})` }} />
                      <span>{c.text}</span>
                    </div>
                  </td>
                  <td className={`whitespace-nowrap px-3.5 py-[11px] ${c.active ? "" : "text-neutral-faint"}`}>
                    <div className="flex flex-col">
                      <span>{c.category.name}</span>
                      <span className="text-xs text-neutral-faint">{g.icon} {g.name}</span>
                    </div>
                  </td>
                  <td className="whitespace-nowrap px-3.5 py-[11px]"><IntensityPips value={c.intensity} /></td>
                  <td className="px-3.5 py-[11px]">
                    {hasEn
                      ? <CheckCircleIcon weight="fill" className="text-base text-success" aria-label="Traduite en anglais" />
                      : <MinusCircleIcon className="text-base text-neutral-faint" aria-label="Pas de traduction anglaise" />}
                  </td>
                  <td className="px-3.5 py-[11px]"><ActiveSwitch id={c.id} active={c.active} label={c.text.slice(0, 40)} /></td>
                  <td className="whitespace-nowrap px-3.5 py-[11px] text-right">
                    <div className="inline-flex items-center gap-1">
                      <EditCardButton
                        card={{ id: c.id, text: c.text, intensity: c.intensity, tags: c.tags, active: c.active, order: c.order, categoryId: c.category.id }}
                        games={games} categories={categories} />
                      <DeleteCardButton id={c.id} />
                    </div>
                  </td>
                </tr>
              );
            })}
            {!cards.length && (
              <tr><td colSpan={6} className="px-8 py-8 text-center text-neutral-faint">Aucune carte ne correspond aux filtres.</td></tr>
            )}
          </tbody>
        </table>
      </div>

      <div className="mt-3 flex flex-wrap items-center justify-between gap-3 text-xs text-neutral-faint">
        <p className="m-0">
          {filtered ? `${nf.format(total)} carte${total > 1 ? "s" : ""} sur ${nf.format(all)}` : `${nf.format(total)} carte${total > 1 ? "s" : ""}`}
          {pages > 1 && ` · page ${page} / ${pages}`}
        </p>
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
