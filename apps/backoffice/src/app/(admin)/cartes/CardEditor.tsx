"use client";

import { useState } from "react";
import { Button, ConfirmButton, Field, Input, Modal, Select, Textarea } from "@/components/ui";
import { CardPreview } from "@/components/CardPreview";
import { deleteCard, saveCard, toggleCardActive } from "@/lib/actions";

// Doit rester identique à `intensityLabels` (apps/mobile/lib/core/deck.dart).
const INTENSITY_LABELS: Record<number, string> = {
  1: "Soft", 2: "Léger", 3: "Normal", 4: "Chaud", 5: "Trash",
};

type Game = { id: string; slug: string; name: string; colorMain: string; colorSecondary: string };
type Cat = { id: string; name: string; slug: string; gameId: string; game: { name: string; slug: string } };
export type EditableCard = {
  id: string; text: string; intensity: number; tags: string[];
  active: boolean; order: number; categoryId: string;
};

export function NewCardButton({ games, categories }: { games: Game[]; categories: Cat[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button onClick={() => setOpen(true)}>Nouvelle carte</Button>
      <Modal title="Nouvelle carte" open={open} onClose={() => setOpen(false)} wide
        action={(fd) => saveCard(null, fd)}>
        <CardFields games={games} categories={categories} />
      </Modal>
    </>
  );
}

export function EditCardButton({ card, games, categories }: { card: EditableCard; games: Game[]; categories: Cat[] }) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>Éditer</Button>
      <Modal title="Modifier la carte" open={open} onClose={() => setOpen(false)} wide
        action={(fd) => saveCard(card.id, fd)}>
        <CardFields card={card} games={games} categories={categories} />
      </Modal>
    </>
  );
}

export function DeleteCardButton({ id }: { id: string }) {
  return <ConfirmButton label="Supprimer" confirm="Supprimer définitivement cette carte ?" action={() => deleteCard(id)} />;
}

export function ToggleActive({ id, active }: { id: string; active: boolean }) {
  return (
    <Button variant="ghost" onClick={() => toggleCardActive(id, !active)}>
      {active ? "Désactiver" : "Activer"}
    </Button>
  );
}

function CardFields({ card, games, categories }: { card?: EditableCard; games: Game[]; categories: Cat[] }) {
  // Jeu initial déduit de la catégorie de la carte (édition) — la liste de
  // catégories se filtre sur ce jeu, plutôt qu'un unique <select> mêlant
  // les ~30 catégories des 8 jeux dans un seul menu déroulant.
  const initialGameId = card ? categories.find((c) => c.id === card.categoryId)?.gameId : undefined;
  const [gameId, setGameId] = useState(initialGameId ?? games[0]?.id ?? "");
  const filtered = categories.filter((c) => c.gameId === gameId);
  const [categoryId, setCategoryId] = useState(card?.categoryId ?? filtered[0]?.id ?? "");
  const [text, setText] = useState(card?.text ?? "");
  const [intensity, setIntensity] = useState(card?.intensity ?? 3);

  const game = games.find((g) => g.id === gameId);
  const category = categories.find((c) => c.id === categoryId);

  return (
    <div className="grid grid-cols-1 gap-5 md:grid-cols-2">
      <div className="flex flex-col gap-3">
        <Field label="Texte">
          <Textarea name="text" rows={3} value={text} onChange={(e) => setText(e.target.value)} required maxLength={500} />
        </Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Jeu">
            <Select value={gameId} onChange={(e) => { setGameId(e.target.value); setCategoryId(""); }}>
              {games.map((g) => (
                <option key={g.id} value={g.id}>{g.name}</option>
              ))}
            </Select>
          </Field>
          <Field label="Catégorie">
            <Select name="categoryId" value={categoryId} onChange={(e) => setCategoryId(e.target.value)} required key={gameId}>
              {filtered.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </Select>
          </Field>
        </div>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Intensité (1–5)">
            <Select name="intensity" value={intensity} onChange={(e) => setIntensity(Number(e.target.value))}>
              {[1, 2, 3, 4, 5].map((i) => <option key={i} value={i}>{i} — {INTENSITY_LABELS[i]}</option>)}
            </Select>
          </Field>
          <Field label="Ordre">
            <Input type="number" name="order" defaultValue={card?.order ?? 0} min={0} />
          </Field>
        </div>
        <Field label="Tags" hint="Séparés par des virgules. Les tags canoniques sont recalculés automatiquement.">
          <Input name="tags" defaultValue={card?.tags.join(", ")} placeholder="humour, vérité" />
        </Field>
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" name="active" defaultChecked={card?.active ?? true} />
          Carte active (entre dans le tirage)
        </label>
      </div>

      <div className="flex min-w-0 flex-col items-center gap-2">
        <span className="text-xs text-neutral-faint">Aperçu dans l&apos;app</span>
        {game && (
          <CardPreview
            text={text}
            categoryLabel={category?.name}
            colorMain={game.colorMain}
            colorSecondary={game.colorSecondary}
            intensityLabel={INTENSITY_LABELS[intensity]}
          />
        )}
      </div>
    </div>
  );
}

/** Barre de filtres (recherche, jeu, catégorie, intensité) — GET classique
 * vers /cartes, mais le select catégorie se filtre en React sur le jeu
 * choisi plutôt que de mélanger les ~30 catégories des 8 jeux. */
export function CardFilters({
  games, categories, sp,
}: {
  games: Game[]; categories: Cat[];
  sp: { jeu?: string; categorie?: string; intensite?: string; q?: string; sansEn?: string };
}) {
  const [jeu, setJeu] = useState(sp.jeu ?? "");
  const filtered = jeu ? categories.filter((c) => c.game.slug === jeu) : categories;
  // La catégorie choisie n'a de sens que pour ce jeu — un changement de
  // jeu réinitialise la sélection plutôt que de garder une valeur qui
  // n'apparaît plus dans le menu filtré.
  const categorieDefault = jeu === (sp.jeu ?? "") ? (sp.categorie ?? "") : "";

  return (
    <form className="mb-4 flex flex-wrap items-center gap-2 text-sm">
      <input name="q" defaultValue={sp.q} placeholder="Rechercher…"
        className="rounded border border-hairline bg-surface px-3 py-1.5" />
      <select name="jeu" value={jeu} onChange={(e) => setJeu(e.target.value)}
        className="rounded border border-hairline bg-surface px-3 py-1.5">
        <option value="">Tous les jeux</option>
        {games.map((g) => <option key={g.slug} value={g.slug}>{g.name}</option>)}
      </select>
      <select name="categorie" defaultValue={categorieDefault} key={jeu}
        className="rounded border border-hairline bg-surface px-3 py-1.5">
        <option value="">Toutes catégories</option>
        {filtered.map((c) => <option key={c.slug} value={c.slug}>{c.name}</option>)}
      </select>
      <select name="intensite" defaultValue={sp.intensite ?? ""} className="rounded border border-hairline bg-surface px-3 py-1.5">
        <option value="">Toutes intensités</option>
        {[1, 2, 3, 4, 5].map((i) => <option key={i} value={i}>Intensité {i}</option>)}
      </select>
      <label className="flex items-center gap-1.5 text-ink-soft">
        <input type="checkbox" name="sansEn" value="1" defaultChecked={!!sp.sansEn} />
        sans traduction EN
      </label>
      <button className="rounded bg-accent px-3 py-1.5 font-medium text-white">Filtrer</button>
      {(sp.q || sp.jeu || sp.categorie || sp.intensite || sp.sansEn) && (
        <a href="/cartes" className="text-neutral-faint hover:text-ink">réinitialiser</a>
      )}
    </form>
  );
}
