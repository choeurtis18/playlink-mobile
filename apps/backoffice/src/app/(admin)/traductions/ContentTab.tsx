import Link from "next/link";
import type { ContentKind } from "@/lib/validation";
import { isMissing, loadContent } from "@/lib/content-translations";
import { ContentTranslationRow } from "./ContentTranslationRow";

const nf = new Intl.NumberFormat("fr-FR");

export async function ContentTab({ kind, sp }: { kind: ContentKind; sp: { type?: string; jeu?: string; tout?: string } }) {
  const items = await loadContent(kind);
  const missing = items.filter(isMissing);
  const withGame = kind === "category" || kind === "slide";
  const games = withGame ? [...new Map(items.map((i) => [i.gameSlug!, i.context!])).entries()] : [];
  const shown = items
    .filter((i) => sp.tout || isMissing(i))
    .filter((i) => !withGame || !sp.jeu || i.gameSlug === sp.jeu);
  const pct = items.length ? Math.round(((items.length - missing.length) / items.length) * 100) : 100;
  const qs = (o: Record<string, string | undefined>) => {
    const p = new URLSearchParams();
    for (const [k, v] of Object.entries({ ...sp, ...o })) if (v) p.set(k, v);
    return `?${p}`;
  };
  const pill = (on: boolean) =>
    `inline-flex items-center gap-1.5 rounded-full border px-3 py-1 text-[13px] transition-colors ${on ? "border-accent bg-accent/12 text-ink" : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink"}`;

  return (
    <>
      <section aria-label="Couverture anglaise" className="mb-5 flex flex-wrap items-center gap-x-6 gap-y-3 rounded-[14px] border border-hairline bg-surface p-5">
        <span className="font-display text-[44px] font-semibold leading-none tracking-[-0.03em]">{pct} %</span>
        <span className="flex min-w-[200px] flex-1 flex-col gap-2">
          <span className="text-sm text-ink-soft">{nf.format(items.length - missing.length)} / {nf.format(items.length)} traduits en anglais</span>
          <span role="progressbar" aria-label="Couverture anglaise" aria-valuenow={pct} aria-valuemin={0} aria-valuemax={100} className="h-2 overflow-hidden rounded bg-raised">
            <span className="block h-full rounded bg-accent" style={{ width: `${pct}%` }} />
          </span>
        </span>
      </section>

      <div className="mb-3 flex flex-wrap items-center gap-3">
        <h2 className="m-0 text-base font-semibold">
          {sp.tout ? "Tout" : "À traduire"} <span className="font-medium text-neutral-faint">{nf.format(shown.length)}</span>
        </h2>
        <Link href={qs({ tout: sp.tout ? undefined : "1" })} className="text-[13px] text-accent-deep hover:text-ink">
          {sp.tout ? "Voir seulement le reste à faire" : "Tout voir"}
        </Link>
      </div>
      {withGame && games.length > 1 && (
        <nav aria-label="Filtrer par jeu" className="mb-3 flex flex-wrap gap-1.5">
          <Link href={qs({ jeu: undefined })} aria-current={!sp.jeu ? "page" : undefined} className={pill(!sp.jeu)}>Tous les jeux</Link>
          {games.map(([slug, name]) => (
            <Link key={slug} href={qs({ jeu: slug })} aria-current={sp.jeu === slug ? "page" : undefined} className={pill(sp.jeu === slug)}>{name}</Link>
          ))}
        </nav>
      )}

      <div className="overflow-hidden rounded-[14px] border border-hairline bg-surface">
        <div aria-hidden className="hidden grid-cols-2 gap-5 border-b border-hairline px-[18px] py-3 font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint md:grid">
          <span>Français (original)</span><span>Anglais</span>
        </div>
        {shown.length ? (
          <ul className="m-0 list-none p-0">
            {shown.map((i) => (
              <ContentTranslationRow key={i.id} kind={kind} id={i.id} title={i.title} context={i.context} icon={i.icon} fields={i.fields} />
            ))}
          </ul>
        ) : (
          <p className="m-0 px-8 py-8 text-center text-sm text-neutral-faint">Rien à traduire ici — beau travail.</p>
        )}
      </div>
      <p className="mt-3 text-xs text-neutral-faint">
        Enregistrement automatique en quittant l’élément. Vider tous les champs anglais supprime la traduction : l’app affiche alors le français.
        Visible dans l’app après la prochaine publication.
      </p>
    </>
  );
}
