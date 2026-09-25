"use client";

import Link from "next/link";
import { DragHandle, DragList } from "@/components/DragList";
import { reorderGames } from "@/lib/actions";
import { CategoryButtons, DeleteCategoryButton, EditGameButton, NewCategoryButton } from "./GameEditor";

type Cat = {
  id: string; name: string; slug: string; description: string | null; icon: string | null; order: number; gameId: string;
  _count: { cards: number };
};
type Game = {
  id: string; name: string; slug: string; description: string | null; icon: string | null;
  colorMain: string; colorSecondary: string; active: boolean; order: number;
  _count: { ruleSlides: number };
  categories: Cat[];
};

const nf = new Intl.NumberFormat("fr-FR");

export function GameList({ games }: { games: Game[] }) {
  return (
    <DragList
      items={games}
      reorder={reorderGames}
      label={(g) => g.name}
      className="flex flex-col gap-2.5"
      renderItem={(g, onDragStart, onMove) => {
        const cards = g.categories.reduce((s, c) => s + c._count.cards, 0);
        const gradient = `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})`;
        return (
          <article
            aria-label={g.name}
            className="relative overflow-hidden rounded-[14px] border border-hairline bg-surface py-3.5 pl-5 pr-4 transition-colors hover:border-hairline-firm"
          >
            <span aria-hidden className={`absolute inset-y-0 left-0 w-1 ${g.active ? "" : "opacity-30"}`} style={{ background: gradient }} />
            <div className="flex flex-wrap items-center gap-3.5">
              <DragHandle id={g.id} label={g.name} onDragStart={onDragStart} onMove={onMove} className="h-8 w-6" />
              {/* Inactif : seules les couleurs s'éteignent ; le texte garde son contraste. */}
              <span aria-hidden className={`flex h-11 w-11 flex-none items-center justify-center rounded-xl text-[22px] ${g.active ? "" : "opacity-40 grayscale"}`} style={{ background: gradient }}>
                {g.icon}
              </span>
              <div className="flex min-w-[180px] flex-1 flex-col gap-0.5">
                <h2 className="m-0 text-[15px] font-semibold">
                  {g.name} {!g.active && <span className="ml-1 rounded-full bg-raised px-1.5 py-0.5 align-middle font-mono text-[10px] font-semibold uppercase tracking-wide text-neutral-faint">inactif</span>}
                </h2>
                <span className="font-mono text-[11px] text-neutral-faint">{g.slug}</span>
              </div>
              <div className="flex gap-[18px] text-xs text-neutral-faint">
                <Figure value={g.categories.length} label="catégories" />
                <Figure value={cards} label="cartes" href={`/cartes?jeu=${g.slug}`} />
                <Figure value={g._count.ruleSlides} label="slides" href={`/regles?jeu=${g.slug}`} />
              </div>
              <EditGameButton game={g} categoryCount={g.categories.length} />
            </div>

            <ul className="m-0 mt-3 flex list-none flex-wrap items-center gap-1.5 p-0" aria-label={`Catégories de ${g.name}`}>
              {g.categories.map((c) => (
                <li key={c.id} className="inline-flex items-center rounded-full border border-hairline bg-raised text-xs transition-colors hover:border-hairline-firm">
                  <Link href={`/cartes?jeu=${g.slug}&categorie=${c.slug}`} className="flex items-center gap-1.5 py-1 pl-2.5 pr-1 text-ink hover:text-ink">
                    {c.icon && <span aria-hidden>{c.icon}</span>}
                    {c.name}
                    <span className="font-mono text-neutral-faint">{c._count.cards}</span>
                  </Link>
                  <CategoryButtons cat={c} />
                  {c._count.cards === 0 && <DeleteCategoryButton id={c.id} name={c.name} />}
                </li>
              ))}
              <li><NewCategoryButton gameId={g.id} gameName={g.name} /></li>
            </ul>
          </article>
        );
      }}
    />
  );
}

function Figure({ value, label, href }: { value: number; label: string; href?: string }) {
  const body = (
    <>
      <strong className="text-[15px] font-semibold text-ink">{nf.format(value)}</strong>
      <span>{label}</span>
    </>
  );
  return href ? (
    <Link href={href} className="flex flex-col items-end text-neutral-faint hover:text-ink">{body}</Link>
  ) : (
    <span className="flex flex-col items-end">{body}</span>
  );
}
