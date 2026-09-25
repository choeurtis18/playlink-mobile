"use client";

import { useState } from "react";

type Game = { id: string; slug: string; name: string; icon: string | null };
type Cat = { id: string; name: string; slug: string; gameId: string; game: { name: string; slug: string } };

/** Filtre jeu → catégorie + recherche texte (FR/EN) — GET classique vers
 * /traductions, en préservant "tout" (reste-à-faire vs. tout le contenu). */
export function TranslationFilters({
  games, categories, sp,
}: {
  games: Game[]; categories: Cat[];
  sp: { jeu?: string; categorie?: string; q?: string; tout?: string };
}) {
  const [jeu, setJeu] = useState(sp.jeu ?? "");
  const filtered = jeu ? categories.filter((c) => c.game.slug === jeu) : categories;
  const categorieDefault = jeu === (sp.jeu ?? "") ? (sp.categorie ?? "") : "";

  return (
    <form className="mb-4 flex flex-wrap items-center gap-2 text-sm">
      {sp.tout && <input type="hidden" name="tout" value={sp.tout} />}
      <input name="q" aria-label="Rechercher" defaultValue={sp.q} placeholder="Rechercher une carte…"
        className="rounded border border-hairline bg-surface px-3 py-1.5" />
      <select name="jeu" aria-label="Jeu" value={jeu} onChange={(e) => setJeu(e.target.value)}
        className="rounded border border-hairline bg-surface px-3 py-1.5">
        <option value="">Tous les jeux</option>
        {games.map((g) => <option key={g.slug} value={g.slug}>{g.icon} {g.name}</option>)}
      </select>
      <select name="categorie" aria-label="Catégorie" defaultValue={categorieDefault} key={jeu}
        className="rounded border border-hairline bg-surface px-3 py-1.5">
        <option value="">Toutes catégories</option>
        {filtered.map((c) => <option key={c.slug} value={c.slug}>{c.name}</option>)}
      </select>
      <button className="rounded bg-accent px-3 py-1.5 font-semibold text-ground-deep hover:bg-accent-deep">Filtrer</button>
      {(sp.q || sp.jeu || sp.categorie) && (
        <a href={sp.tout ? "/traductions?tout=1" : "/traductions"} className="text-neutral-faint hover:text-ink">
          réinitialiser
        </a>
      )}
    </form>
  );
}
