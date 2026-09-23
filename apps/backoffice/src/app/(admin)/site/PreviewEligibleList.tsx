"use client";

import { useState, useTransition } from "react";
import { toggleCategoryPreviewEligible } from "@/lib/actions";
import type { Category, Game } from "@prisma/client";

type GameWithCategories = Game & { categories: Category[] };

export function PreviewEligibleList({ games }: { games: GameWithCategories[] }) {
  const [pendingId, setPendingId] = useState<string | null>(null);
  const [, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  function toggle(id: string, next: boolean) {
    setError(null);
    setPendingId(id);
    startTransition(async () => {
      const r = await toggleCategoryPreviewEligible(id, next);
      if (!r.ok) setError(r.error);
      setPendingId(null);
    });
  }

  return (
    <div className="flex flex-col gap-4">
      {error && <p className="rounded border border-red-900 bg-red-950/40 px-3 py-2 text-sm text-red-300">{error}</p>}
      {games.map((game) => (
        <div key={game.id} className="rounded-lg border border-hairline bg-surface p-4">
          <h4 className="mb-2 text-sm font-semibold">{game.name}</h4>
          {game.categories.length === 0 ? (
            <p className="text-xs text-neutral-faint">Aucune catégorie.</p>
          ) : (
            <div className="flex flex-wrap gap-2">
              {game.categories.map((cat) => (
                <label key={cat.id}
                  className={`flex cursor-pointer items-center gap-2 rounded-full border px-3 py-1.5 text-sm transition ${
                    cat.previewEligible ? "border-accent bg-accent/10 text-ink" : "border-hairline text-ink-soft hover:bg-ground"
                  } ${pendingId === cat.id ? "opacity-50" : ""}`}>
                  <input type="checkbox" className="sr-only" checked={cat.previewEligible}
                    disabled={pendingId === cat.id}
                    onChange={(e) => toggle(cat.id, e.target.checked)} />
                  {cat.name}
                </label>
              ))}
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
