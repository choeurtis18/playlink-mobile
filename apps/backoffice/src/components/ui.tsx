"use client";

import { useState, useTransition } from "react";
import type { ActionResult } from "@/lib/actions";

export function Button({ children, variant = "primary", ...props }: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: "primary" | "ghost" | "danger" }) {
  const styles = {
    primary: "bg-accent text-white hover:opacity-90",
    ghost: "border border-hairline text-ink-soft hover:bg-surface",
    danger: "border border-hairline text-red-400 hover:bg-red-950/30",
  }[variant];
  return (
    <button {...props} className={`rounded px-3 py-1.5 text-sm font-medium transition disabled:opacity-50 ${styles} ${props.className ?? ""}`}>
      {children}
    </button>
  );
}

export function Field({ label, hint, children }: { label: string; hint?: string; children: React.ReactNode }) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs text-neutral-faint">{label}</span>
      {children}
      {hint && <span className="mt-1 block text-xs text-neutral-faint">{hint}</span>}
    </label>
  );
}

const inputCls = "w-full rounded border border-hairline bg-ground px-3 py-2 text-sm text-ink focus:border-accent focus:outline-none";

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  return <input {...props} className={`${inputCls} ${props.className ?? ""}`} />;
}
export function Textarea(props: React.TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return <textarea {...props} className={`${inputCls} ${props.className ?? ""}`} />;
}
export function Select(props: React.SelectHTMLAttributes<HTMLSelectElement>) {
  return <select {...props} className={`${inputCls} ${props.className ?? ""}`} />;
}

/** Modale de formulaire : soumet une Server Action et affiche son erreur.
 * `wide` : plus large que le formulaire standard — pour les cas avec
 * aperçu visuel affiché en regard des champs (jeu, carte, règle). */
export function Modal({ title, open, onClose, action, children, wide = false }: {
  title: string; open: boolean; onClose: () => void;
  action: (form: FormData) => Promise<ActionResult>;
  children: React.ReactNode;
  wide?: boolean;
}) {
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-black/70 p-6"
      onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className={`w-full rounded-lg border border-hairline bg-surface p-5 ${wide ? "max-w-3xl" : "max-w-lg"}`}>
        <h2 className="mb-4 text-lg font-semibold">{title}</h2>
        <form
          action={(fd) => start(async () => {
            const r = await action(fd);
            if (r.ok) { setError(null); onClose(); } else setError(r.error);
          })}
          className="flex flex-col gap-3"
        >
          {children}
          {error && <p className="rounded border border-red-900 bg-red-950/40 px-3 py-2 text-sm text-red-300">{error}</p>}
          <div className="mt-2 flex justify-end gap-2">
            <Button type="button" variant="ghost" onClick={onClose}>Annuler</Button>
            <Button type="submit" disabled={pending}>{pending ? "Enregistrement…" : "Enregistrer"}</Button>
          </div>
        </form>
      </div>
    </div>
  );
}

// Émojis prédéfinis pour jeux/catégories — thématique "jeux de soirée,
// discussion, confession" plutôt qu'une liste emoji générique. Les icônes
// déjà présentes dans le contenu réel (content_v3.json) y figurent toutes,
// pour que resélectionner l'existant reste possible depuis la grille.
export const ICON_CHOICES = [
  "🎲", "🎯", "🎭", "🎪", "🎬", "🎤", "🎉", "🎊",
  "❤️", "💕", "💘", "💔", "😘", "😏", "😄", "😱",
  "🤡", "🤫", "🤪", "🤝", "🧠", "👀", "🔍", "🕵️",
  "💬", "💭", "💼", "🏠", "🌍", "🌶️", "🔥", "🧊",
  "⚖️", "✨", "🔴", "🟡", "🟢", "📦", "🍕", "🍺",
  "🃏", "🎮", "⏱️", "🏆", "💡", "🎁", "😈", "👑",
] as const;

/** Émojis prédéfinis pour les badges — récompenses/progression, distincts
 * de la thématique "jeu de soirée" de `ICON_CHOICES`. */
export const BADGE_ICON_CHOICES = [
  "🏆", "🥇", "🥈", "🥉", "🎖️", "🏅", "👑", "⭐",
  "🌟", "💫", "🔥", "⚡", "🚀", "💎", "🎯", "🧩",
  "🦋", "🦉", "🦄", "🐉", "🌙", "☀️", "🎓", "📈",
] as const;

/** Sélecteur d'icône : grille d'émojis prédéfinis + champ libre en repli
 * (un emoji hors liste reste possible, saisi à la main). `onChange`
 * optionnel : pour un parent qui veut refléter le choix ailleurs (aperçu
 * en direct) sans devenir lui-même responsable de la valeur soumise. */
export function IconPicker({
  name, defaultValue, choices = ICON_CHOICES, onChange,
}: { name: string; defaultValue?: string | null; choices?: readonly string[]; onChange?: (v: string) => void }) {
  const [value, setValue] = useState(defaultValue ?? "");
  const update = (v: string) => { setValue(v); onChange?.(v); };
  return (
    <div>
      <input type="hidden" name={name} value={value} />
      <div className="mb-2 grid grid-cols-8 gap-1.5">
        {choices.map((icon) => (
          <button key={icon} type="button" onClick={() => update(icon)}
            aria-pressed={value === icon}
            className={`flex h-8 w-8 items-center justify-center rounded border text-base transition ${
              value === icon ? "border-accent bg-accent/20" : "border-hairline hover:bg-raised"
            }`}>
            {icon}
          </button>
        ))}
      </div>
      <input value={value} onChange={(e) => update(e.target.value)} maxLength={4}
        placeholder="ou un autre émoji…" className={inputCls} />
    </div>
  );
}

/** Bouton "Importer" + modale (upload CSV, lien modèle, doc du format) —
 * pas basé sur `Modal` : l'action reçoit le texte du fichier lu côté
 * client, pas un `FormData` de champs de formulaire. */
export function ImportButton({
  label = "Importer", templateHref, templateLabel = "Télécharger le modèle CSV",
  columns, notes, action,
}: {
  label?: string;
  templateHref: string;
  templateLabel?: string;
  columns: string;
  notes: string;
  action: (csvText: string) => Promise<ActionResult & { count?: number }>;
}) {
  const [open, setOpen] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<string | null>(null);
  const [pending, start] = useTransition();

  return (
    <>
      <Button variant="ghost" onClick={() => setOpen(true)}>{label}</Button>
      {open && (
        <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-black/70 p-6"
          onClick={(e) => e.target === e.currentTarget && setOpen(false)}>
          <div className="w-full max-w-lg rounded-lg border border-hairline bg-surface p-5">
            <div className="mb-4 flex items-center justify-between">
              <h2 className="text-lg font-semibold">{label}</h2>
              <a href={templateHref} className="text-sm text-accent hover:underline">{templateLabel}</a>
            </div>
            <input type="file" accept=".csv,text/csv"
              className="block w-full text-sm text-ink-soft file:mr-3 file:rounded file:border-0 file:bg-raised file:px-3 file:py-1.5 file:text-sm file:text-ink"
              onChange={(e) => {
                const file = e.target.files?.[0];
                if (!file) return;
                start(async () => {
                  setError(null); setResult(null);
                  const text = await file.text();
                  const r = await action(text);
                  if (r.ok) setResult(`${r.count} ligne(s) importée(s)`);
                  else setError(r.error);
                  e.target.value = "";
                });
              }} />
            <p className="mt-2 text-xs text-neutral-faint">
              Colonnes attendues : <code>{columns}</code>. {notes}
            </p>
            {pending && <p className="mt-2 text-sm text-neutral-faint">Import en cours…</p>}
            {result && <p className="mt-2 text-sm text-green-400">{result}</p>}
            {error && <p className="mt-2 text-sm text-red-400">{error}</p>}
            <div className="mt-4 flex justify-end">
              <Button variant="ghost" onClick={() => setOpen(false)}>Fermer</Button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

/** Bouton d'action destructrice : demande confirmation avant d'agir. */
export function ConfirmButton({ label, confirm, action, children }: {
  label: string; confirm: string;
  action: () => Promise<ActionResult>;
  children?: React.ReactNode;
}) {
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();
  return (
    <>
      <Button variant="danger" disabled={pending} title={error ?? undefined}
        onClick={() => {
          if (!window.confirm(confirm)) return;
          start(async () => {
            const r = await action();
            if (!r.ok) setError(r.error);
          });
        }}>
        {children ?? label}
      </Button>
      {error && <span className="ml-2 text-xs text-red-400">{error}</span>}
    </>
  );
}
