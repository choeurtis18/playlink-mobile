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

export function GameList({ games }: { games: Game[] }) {
  return (
    <DragList
      items={games}
      reorder={reorderGames}
      className="flex flex-col gap-3"
      renderItem={(g, onDragStart) => {
        const cards = g.categories.reduce((s, c) => s + c._count.cards, 0);
        return (
          <div className={`rounded-lg border border-hairline bg-surface p-4 ${g.active ? "" : "opacity-60"}`}>
            <div className="flex items-center gap-3">
              <DragHandle onDragStart={onDragStart} className="text-lg" />
              <span className="text-2xl">{g.icon}</span>
              <div className="min-w-0 flex-1">
                <div className="font-medium">{g.name} {!g.active && <span className="text-xs text-neutral-faint">(inactif)</span>}</div>
                <div className="text-xs text-neutral-faint">
                  {g.slug} · {g.categories.length} catégories · {cards} cartes ·{" "}
                  <Link href={`/regles?jeu=${g.slug}`} className="hover:text-ink">{g._count.ruleSlides} slides</Link>
                </div>
              </div>
              <div className="flex gap-1">
                <span className="h-6 w-6 rounded" style={{ background: g.colorMain }} />
                <span className="h-6 w-6 rounded" style={{ background: g.colorSecondary }} />
              </div>
              <EditGameButton game={g} categoryCount={g.categories.length} />
            </div>

            <div className="mt-3 flex flex-wrap items-center gap-2">
              {g.categories.map((c) => (
                <span key={c.id} className="inline-flex items-center gap-1.5 rounded border border-hairline bg-raised px-2 py-1 text-xs">
                  <Link href={`/cartes?jeu=${g.slug}`} className="hover:text-accent">
                    {c.name} <span className="text-neutral-faint">{c._count.cards}</span>
                  </Link>
                  <CategoryButtons cat={c} />
                  {c._count.cards === 0 && <DeleteCategoryButton id={c.id} name={c.name} />}
                </span>
              ))}
              <NewCategoryButton gameId={g.id} gameName={g.name} />
            </div>
          </div>
        );
      }}
    />
  );
}
