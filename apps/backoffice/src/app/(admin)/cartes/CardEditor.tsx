"use client";

import { useEffect, useRef, useState, useTransition } from "react";
import { usePathname, useRouter } from "next/navigation";
import { MagnifyingGlassIcon, PencilSimpleIcon, PlusIcon, TranslateIcon, TrashIcon, XIcon } from "@phosphor-icons/react/dist/ssr";
import { Button, ConfirmButton, Field, Input, Modal, Segmented, Select, Switch, Textarea, useToast } from "@/components/ui";
import { CardPreview } from "@/components/CardPreview";
import { deleteCard, saveCard, toggleCardActive } from "@/lib/actions";

// Doit rester identique à `intensityLabels` (apps/mobile/lib/core/deck.dart).
export const INTENSITY_LABELS: Record<number, string> = {
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
      <Button icon={<PlusIcon aria-hidden />} onClick={() => setOpen(true)}>Nouvelle carte</Button>
      <Modal title="Nouvelle carte" open={open} onClose={() => setOpen(false)} wide successMessage="Carte créée"
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
      <button type="button" onClick={() => setOpen(true)} aria-label={`Éditer la carte « ${card.text.slice(0, 40)} »`}
        className="flex h-[30px] w-[30px] items-center justify-center rounded-[7px] border border-hairline text-ink-soft transition-colors hover:bg-ground hover:text-ink">
        <PencilSimpleIcon aria-hidden />
      </button>
      <Modal title="Modifier la carte" open={open} onClose={() => setOpen(false)} wide successMessage="Carte mise à jour"
        action={(fd) => saveCard(card.id, fd)}>
        <CardFields card={card} games={games} categories={categories} />
      </Modal>
    </>
  );
}

export function DeleteCardButton({ id }: { id: string }) {
  return (
    <ConfirmButton size="xs" label="Supprimer la carte" confirm="Supprimer définitivement cette carte ?"
      action={() => deleteCard(id)} doneMessage="Carte supprimée">
      <TrashIcon aria-hidden className="text-sm" />
    </ConfirmButton>
  );
}

/** Interrupteur « carte active », dans la ligne. Bascule tout de suite à
 * l'écran ; revient en arrière si le serveur refuse. */
export function ActiveSwitch({ id, active, label }: { id: string; active: boolean; label: string }) {
  const toast = useToast();
  const [on, setOn] = useState(active);
  const [pending, start] = useTransition();
  useEffect(() => setOn(active), [active]);
  return (
    <Switch
      size="sm"
      label={`Carte active : ${label}`}
      checked={on}
      disabled={pending}
      onChange={(next) => {
        setOn(next);
        start(async () => {
          const r = await toggleCardActive(id, next);
          if (!r.ok) { setOn(!next); toast(r.error, "error"); }
          else toast(next ? "Carte activée" : "Carte désactivée");
        });
      }}
    />
  );
}

/** Jauge d'intensité : 5 barres, remplies jusqu'au niveau de la carte. */
export function IntensityPips({ value }: { value: number }) {
  return (
    <span className="flex items-center gap-[3px]" title={`${value} — ${INTENSITY_LABELS[value]}`}>
      {[1, 2, 3, 4, 5].map((n) => (
        <span key={n} aria-hidden className={`h-3.5 w-1.5 rounded-sm ${n <= value ? "bg-accent" : "bg-hairline"}`} />
      ))}
      <span className="sr-only">Intensité {value} sur 5, {INTENSITY_LABELS[value]}</span>
    </span>
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
    <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
      <div className="flex flex-col gap-3.5">
        <Field label="Texte">
          <Textarea name="text" rows={3} value={text} onChange={(e) => setText(e.target.value)} required maxLength={500} counter />
        </Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label="Jeu">
            <Select value={gameId} onChange={(e) => { setGameId(e.target.value); setCategoryId(categories.find((c) => c.gameId === e.target.value)?.id ?? ""); }}>
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
        <div className="flex flex-col gap-1.5">
          <span className="text-[13px] font-semibold">Intensité</span>
          <Segmented
            name="intensity"
            label="Intensité de la carte"
            value={intensity}
            onChange={setIntensity}
            options={[1, 2, 3, 4, 5].map((i) => ({ value: i, label: String(i), title: INTENSITY_LABELS[i] }))}
          />
          <span className="text-xs text-neutral-faint">{INTENSITY_LABELS[intensity]}</span>
        </div>
        <div className="grid grid-cols-[2fr_1fr] gap-3">
          <Field label="Tags" hint="Séparés par des virgules. Les tags canoniques sont recalculés automatiquement.">
            <Input name="tags" defaultValue={card?.tags.join(", ")} placeholder="humour, vérité" />
          </Field>
          <Field label="Ordre">
            <Input type="number" name="order" defaultValue={card?.order ?? 0} min={0} />
          </Field>
        </div>
        <div className="flex items-center gap-2.5 text-sm">
          <Switch name="active" label="Carte active" defaultChecked={card?.active ?? true} size="sm" />
          Carte active <span className="text-xs text-neutral-faint">(entre dans le tirage)</span>
        </div>
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

type Filters = { jeu?: string; categorie?: string; intensite?: string; q?: string; sansEn?: string; page?: string };

const SEARCH_DELAY_MS = 300;

/** Filtres appliqués en direct : chaque changement réécrit l'URL (lien
 * partageable, retour arrière du navigateur), la page serveur relit la
 * base. La recherche attend une courte pause dans la frappe. */
export function CardFilters({ games, categories, sp }: { games: Game[]; categories: Cat[]; sp: Filters }) {
  const router = useRouter();
  const pathname = usePathname();
  const [pending, start] = useTransition();
  const [q, setQ] = useState(sp.q ?? "");
  const timer = useRef<number | undefined>(undefined);

  const apply = (over: Filters) => {
    // Nouveau filtre = retour à la première page.
    const next: Record<string, string | undefined> = { ...sp, ...over, page: undefined };
    const params = new URLSearchParams();
    for (const [k, v] of Object.entries(next)) if (v) params.set(k, v);
    start(() => router.replace(`${pathname}${params.size ? `?${params}` : ""}`, { scroll: false }));
  };

  useEffect(() => () => window.clearTimeout(timer.current), []);

  const categoriesOfGame = sp.jeu ? categories.filter((c) => c.game.slug === sp.jeu) : categories;
  const active = !!(sp.q || sp.jeu || sp.categorie || sp.intensite || sp.sansEn);
  const control = "rounded-lg border border-hairline bg-surface px-2.5 py-2 text-[13px] text-ink focus:border-accent focus:outline-none";

  return (
    <div role="search" aria-label="Filtrer les cartes" aria-busy={pending} className="mb-3 flex flex-wrap items-center gap-2">
      <label className="flex min-w-[220px] items-center gap-2 rounded-lg border border-hairline bg-surface px-2.5 py-[7px] text-neutral-faint focus-within:border-accent">
        <MagnifyingGlassIcon aria-hidden />
        <input
          value={q}
          aria-label="Rechercher dans le texte des cartes"
          placeholder="Rechercher…"
          onChange={(e) => {
            const v = e.target.value;
            setQ(v);
            window.clearTimeout(timer.current);
            timer.current = window.setTimeout(() => apply({ q: v.trim() || undefined }), SEARCH_DELAY_MS);
          }}
          className="min-w-0 flex-1 bg-transparent text-[13px] text-ink outline-none placeholder:text-neutral-faint focus-visible:outline-none"
        />
      </label>
      <select aria-label="Jeu" value={sp.jeu ?? ""} className={control}
        onChange={(e) => apply({ jeu: e.target.value || undefined, categorie: undefined })}>
        <option value="">Tous les jeux</option>
        {games.map((g) => <option key={g.slug} value={g.slug}>{g.name}</option>)}
      </select>
      <select aria-label="Catégorie" value={sp.categorie ?? ""} className={control}
        onChange={(e) => apply({ categorie: e.target.value || undefined })}>
        <option value="">Toutes catégories</option>
        {categoriesOfGame.map((c) => <option key={c.id} value={c.slug}>{sp.jeu ? c.name : `${c.game.name} · ${c.name}`}</option>)}
      </select>
      <Segmented
        size="sm"
        label="Intensité"
        value={sp.intensite ?? ""}
        onChange={(v) => apply({ intensite: v || undefined })}
        options={[{ value: "", label: "Toutes" }, ...[1, 2, 3, 4, 5].map((i) => ({ value: String(i), label: String(i), title: INTENSITY_LABELS[i] }))]}
      />
      <button
        type="button"
        aria-pressed={!!sp.sansEn}
        onClick={() => apply({ sansEn: sp.sansEn ? undefined : "1" })}
        className={`flex items-center gap-1.5 rounded-lg border px-2.5 py-[7px] text-[13px] transition-colors ${sp.sansEn ? "border-accent bg-accent/12 text-ink" : "border-hairline bg-surface text-ink-soft hover:text-ink"}`}
      >
        <TranslateIcon aria-hidden /> Sans EN
      </button>
      {active && (
        <button type="button" onClick={() => { setQ(""); start(() => router.replace(pathname, { scroll: false })); }}
          className="flex items-center gap-1 px-1 text-[13px] text-neutral-faint hover:text-ink">
          <XIcon aria-hidden /> Réinitialiser
        </button>
      )}
    </div>
  );
}
