"use client";

import { useState } from "react";
import { MagnifyingGlassIcon, XIcon } from "@phosphor-icons/react/dist/ssr";
import { useUrlFilters } from "@/lib/use-url-filters";

type Game = { slug: string; name: string; icon: string | null };
type Cat = { id: string; name: string; slug: string; game: { name: string; slug: string } };

/** Recherche (FR ou EN), jeu, catégorie — appliqués en direct. Le mode
 * « tout voir » (`tout`) est conservé par la réinitialisation. */
export function TranslationFilters({ games, categories, sp }: {
  games: Game[]; categories: Cat[];
  sp: { jeu?: string; categorie?: string; q?: string; tout?: string; page?: string };
}) {
  const { apply, applyLater, reset, pending } = useUrlFilters(sp);
  const [q, setQ] = useState(sp.q ?? "");
  const categoriesOfGame = sp.jeu ? categories.filter((c) => c.game.slug === sp.jeu) : categories;
  const control = "rounded-lg border border-hairline bg-surface px-2.5 py-2 text-[13px] text-ink focus:border-accent focus:outline-none";

  return (
    <div role="search" aria-label="Filtrer les traductions" aria-busy={pending} className="flex flex-wrap items-center gap-2">
      <label className="flex min-w-[220px] items-center gap-2 rounded-lg border border-hairline bg-surface px-2.5 py-[7px] text-neutral-faint focus-within:border-accent">
        <MagnifyingGlassIcon aria-hidden />
        <input
          value={q}
          aria-label="Rechercher en français ou en anglais"
          placeholder="Rechercher (FR ou EN)…"
          onChange={(e) => { setQ(e.target.value); applyLater({ q: e.target.value.trim() || undefined }); }}
          className="min-w-0 flex-1 bg-transparent text-[13px] text-ink outline-none placeholder:text-neutral-faint focus-visible:outline-none"
        />
      </label>
      <select aria-label="Jeu" value={sp.jeu ?? ""} className={control}
        onChange={(e) => apply({ jeu: e.target.value || undefined, categorie: undefined })}>
        <option value="">Tous les jeux</option>
        {games.map((g) => <option key={g.slug} value={g.slug}>{g.icon} {g.name}</option>)}
      </select>
      <select aria-label="Catégorie" value={sp.categorie ?? ""} className={control}
        onChange={(e) => apply({ categorie: e.target.value || undefined })}>
        <option value="">Toutes catégories</option>
        {categoriesOfGame.map((c) => <option key={c.id} value={c.slug}>{sp.jeu ? c.name : `${c.game.name} · ${c.name}`}</option>)}
      </select>
      {(sp.q || sp.jeu || sp.categorie) && (
        <button type="button" onClick={() => { setQ(""); reset({ tout: sp.tout }); }}
          className="flex items-center gap-1 px-1 text-[13px] text-neutral-faint hover:text-ink">
          <XIcon aria-hidden /> Réinitialiser
        </button>
      )}
    </div>
  );
}
