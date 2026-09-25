"use client";

import { createContext, useCallback, useContext, useEffect, useId, useRef, useState, useTransition } from "react";
import { CheckCircleIcon, WarningCircleIcon, XIcon } from "@phosphor-icons/react/dist/ssr";
import type { ActionResult } from "@/lib/actions";

// Primitives du back-office v2. Les signatures d'avant la refonte sont
// conservées (Button, Field, Input, Textarea, Select, Modal, ConfirmButton,
// IconPicker, ImportButton) : les écrans existants changent d'apparence
// sans changer de code.

const cx = (...c: (string | false | null | undefined)[]) => c.filter(Boolean).join(" ");

// ── Boutons ──────────────────────────────────────────────────────────

type ButtonVariant = "primary" | "secondary" | "ghost" | "danger";

const BUTTON: Record<ButtonVariant, string> = {
  // Texte sombre sur le rose : le blanc n'y atteint que 3,6:1 (AA exige
  // 4,5:1 à cette taille) ; le sombre dépasse 5:1. Comme sur la landing.
  primary: "border border-transparent bg-accent font-semibold text-ground-deep hover:bg-accent-deep",
  secondary: "border border-hairline bg-surface font-medium text-ink-soft hover:border-hairline-firm hover:text-ink",
  // « ghost » est la variante la plus utilisée des écrans existants
  // (Éditer, Annuler…) : même rendu que secondary, fond transparent.
  ghost: "border border-hairline bg-transparent font-medium text-ink-soft hover:border-hairline-firm hover:bg-surface hover:text-ink",
  danger: "border border-hairline bg-transparent font-medium text-danger hover:border-danger/50 hover:bg-danger/10",
};

export function Button({
  children, variant = "primary", size = "md", icon, className, type = "button", ...props
}: React.ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: ButtonVariant;
  size?: "sm" | "md";
  icon?: React.ReactNode;
}) {
  return (
    <button
      type={type}
      {...props}
      className={cx(
        "inline-flex items-center justify-center gap-1.5 rounded-lg transition-[background,border-color,color] duration-150 disabled:cursor-not-allowed disabled:opacity-50",
        size === "sm" ? "px-2.5 py-1 text-[12.5px]" : "px-3.5 py-2 text-[13px]",
        BUTTON[variant],
        className,
      )}
    >
      {icon}
      {children}
    </button>
  );
}

/** Lien habillé en bouton (navigation, export). */
export function ButtonLink({
  children, variant = "secondary", icon, className, ...props
}: React.AnchorHTMLAttributes<HTMLAnchorElement> & { variant?: ButtonVariant; icon?: React.ReactNode }) {
  return (
    <a
      {...props}
      className={cx(
        "inline-flex items-center justify-center gap-1.5 rounded-lg px-3.5 py-2 text-[13px] transition-[background,border-color,color] duration-150",
        BUTTON[variant],
        className,
      )}
    >
      {icon}
      {children}
    </a>
  );
}

// ── Champs ───────────────────────────────────────────────────────────

export function Field({ label, hint, error, children }: {
  label: string; hint?: React.ReactNode; error?: string | null; children: React.ReactNode;
}) {
  return (
    <label className="flex flex-col gap-1.5">
      <span className="text-[13px] font-semibold text-ink">{label}</span>
      {children}
      {error ? (
        <span className="text-[11.5px] text-danger">{error}</span>
      ) : hint ? (
        <span className="text-[11.5px] text-neutral-faint">{hint}</span>
      ) : null}
    </label>
  );
}

const inputCls =
  "w-full rounded-lg border border-hairline bg-ground px-[11px] py-[9px] text-[13.5px] text-ink placeholder:text-neutral-faint transition-colors focus:border-accent focus:outline-none disabled:opacity-60";

/** Compteur « n / max » : orange à 90 %, rouge à la limite. */
function Counter({ length, max }: { length: number; max: number }) {
  const tone = length >= max ? "text-danger" : length >= max * 0.9 ? "text-warning" : "text-neutral-faint";
  return (
    <span aria-hidden className={cx("self-end font-mono text-[11px] tabular-nums", tone)}>
      {length} / {max}
    </span>
  );
}

/** Longueur initiale pour le compteur, en contrôlé comme en non contrôlé. */
const initialLength = (value: unknown, defaultValue: unknown) => String(value ?? defaultValue ?? "").length;

export function Input({ counter = false, ...props }: React.InputHTMLAttributes<HTMLInputElement> & { counter?: boolean }) {
  const [length, setLength] = useState(() => initialLength(props.value, props.defaultValue));
  const input = (
    <input
      {...props}
      onChange={(e) => { setLength(e.target.value.length); props.onChange?.(e); }}
      className={cx(inputCls, props.className)}
    />
  );
  if (!counter || !props.maxLength) return input;
  return <span className="flex flex-col gap-1">{input}<Counter length={length} max={props.maxLength} /></span>;
}

export function Textarea({ counter = false, ...props }: React.TextareaHTMLAttributes<HTMLTextAreaElement> & { counter?: boolean }) {
  const [length, setLength] = useState(() => initialLength(props.value, props.defaultValue));
  const area = (
    <textarea
      {...props}
      onChange={(e) => { setLength(e.target.value.length); props.onChange?.(e); }}
      className={cx(inputCls, "resize-y leading-normal", props.className)}
    />
  );
  if (!counter || !props.maxLength) return area;
  return <span className="flex flex-col gap-1">{area}<Counter length={length} max={props.maxLength} /></span>;
}

export function Select(props: React.SelectHTMLAttributes<HTMLSelectElement>) {
  return <select {...props} className={cx(inputCls, "cursor-pointer", props.className)} />;
}

/** Choix exclusif compact (intensité, taille du deck, langue…). Flèches
 * gauche/droite pour changer d'option, comme un groupe radio natif. `name`
 * ajoute un champ caché pour les formulaires de Server Action. */
export function Segmented<T extends string | number>({
  options, value, onChange, label, name, size = "md",
}: {
  options: { value: T; label: React.ReactNode; title?: string }[];
  value: T;
  onChange: (v: T) => void;
  label: string;
  name?: string;
  size?: "sm" | "md";
}) {
  const refs = useRef<(HTMLButtonElement | null)[]>([]);
  const move = (from: number, dir: 1 | -1) => {
    const next = (from + dir + options.length) % options.length;
    onChange(options[next].value);
    refs.current[next]?.focus();
  };
  return (
    <div role="radiogroup" aria-label={label} className="inline-flex gap-0.5 rounded-lg border border-hairline bg-surface p-[3px]">
      {name && <input type="hidden" name={name} value={String(value)} />}
      {options.map((o, i) => {
        const on = o.value === value;
        return (
          <button
            key={String(o.value)}
            ref={(el) => { refs.current[i] = el; }}
            type="button"
            role="radio"
            aria-checked={on}
            tabIndex={on ? 0 : -1}
            title={o.title}
            onClick={() => onChange(o.value)}
            onKeyDown={(e) => {
              if (e.key === "ArrowRight" || e.key === "ArrowDown") { e.preventDefault(); move(i, 1); }
              if (e.key === "ArrowLeft" || e.key === "ArrowUp") { e.preventDefault(); move(i, -1); }
            }}
            className={cx(
              "rounded-[5px] font-medium transition-colors",
              size === "sm" ? "px-2.5 py-1 text-xs" : "px-3 py-[5px] text-[13px]",
              on ? "bg-hairline text-ink" : "text-neutral-faint hover:text-ink",
            )}
          >
            {o.label}
          </button>
        );
      })}
    </div>
  );
}

/** Interrupteur. Contrôlé (`checked` + `onChange`) ou non contrôlé
 * (`defaultChecked` + `name`, la valeur part avec le formulaire : "on"). */
export function Switch({
  checked, defaultChecked = false, onChange, label, name, disabled, size = "md",
}: {
  checked?: boolean;
  defaultChecked?: boolean;
  onChange?: (v: boolean) => void;
  label: string;
  name?: string;
  disabled?: boolean;
  size?: "sm" | "md";
}) {
  const [inner, setInner] = useState(defaultChecked);
  const on = checked ?? inner;
  const big = size === "md";
  return (
    <>
      {name && on && <input type="hidden" name={name} value="on" />}
      <button
        type="button"
        role="switch"
        aria-checked={on}
        aria-label={label}
        disabled={disabled}
        onClick={() => { setInner(!on); onChange?.(!on); }}
        className={cx(
          "relative shrink-0 rounded-full transition-colors duration-200 disabled:opacity-50",
          big ? "h-6 w-10" : "h-5 w-[34px]",
          on ? "bg-accent" : "bg-hairline-firm",
        )}
      >
        <span
          className={cx(
            "absolute rounded-full bg-ink transition-transform duration-200",
            big ? "left-[3px] top-[3px] h-[18px] w-[18px]" : "left-0.5 top-0.5 h-4 w-4",
            on && (big ? "translate-x-4" : "translate-x-3.5"),
          )}
        />
      </button>
    </>
  );
}

// ── Étiquettes et conteneurs ─────────────────────────────────────────

type Tone = "neutral" | "accent" | "success" | "warning" | "danger" | "blue";

const BADGE: Record<Tone, string> = {
  neutral: "bg-raised text-neutral-faint",
  accent: "bg-accent/15 text-accent-deep",
  success: "bg-success/12 text-success",
  warning: "bg-warning/12 text-warning",
  danger: "bg-danger/12 text-danger",
  blue: "bg-blue/12 text-blue",
};

/** Petite étiquette (compteur, statut). */
export function Badge({ tone = "neutral", children, className }: { tone?: Tone; children: React.ReactNode; className?: string }) {
  return (
    <span className={cx("inline-flex items-center gap-1 rounded-full px-1.5 py-0.5 font-mono text-[10px] font-semibold", BADGE[tone], className)}>
      {children}
    </span>
  );
}

/** Puce de filtre, sélectionnable. */
export function Pill({ on, onClick, count, children }: {
  on: boolean; onClick: () => void; count?: number | string; children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      aria-pressed={on}
      onClick={onClick}
      className={cx(
        "inline-flex items-center gap-1.5 rounded-full border px-3 py-1 text-[13px] transition-colors",
        on ? "border-accent bg-accent/12 text-ink" : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink",
      )}
    >
      {children}
      {count !== undefined && <span className="font-mono text-[11px] text-neutral-faint">{count}</span>}
    </button>
  );
}

export function Card({ children, className }: { children: React.ReactNode; className?: string }) {
  return <div className={cx("rounded-[14px] border border-hairline bg-surface p-[18px]", className)}>{children}</div>;
}

/** Compteur du tableau de bord ; cliquable s'il a un lien. */
export function Stat({ icon, value, label, href }: {
  icon?: React.ReactNode; value: React.ReactNode; label: string; href?: string;
}) {
  const body = (
    <>
      {icon && (
        <span aria-hidden className="flex h-8 w-8 items-center justify-center rounded-[9px] bg-raised text-[17px] text-accent-deep">{icon}</span>
      )}
      <span className="flex flex-col gap-0.5">
        <span className="text-[26px] font-semibold tracking-[-0.02em] text-ink">{value}</span>
        <span className="text-[13px] text-neutral-faint">{label}</span>
      </span>
    </>
  );
  const cls = "flex flex-col gap-3 rounded-[14px] border border-hairline bg-surface p-4";
  return href ? (
    <a href={href} className={cx(cls, "transition-[border-color,transform] duration-200 hover:-translate-y-0.5 hover:border-hairline-firm")}>{body}</a>
  ) : (
    <div className={cls}>{body}</div>
  );
}

/** En-tête d'écran : titre, sous-titre, actions à droite. */
export function PageHeader({ title, description, actions }: {
  title: React.ReactNode; description?: React.ReactNode; actions?: React.ReactNode;
}) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div className="flex min-w-0 flex-col gap-1.5">
        <h1 className="m-0 font-display text-[32px] font-semibold leading-tight tracking-[-0.025em]">{title}</h1>
        {description && <p className="m-0 max-w-prose text-sm text-neutral-faint">{description}</p>}
      </div>
      {actions && <div className="flex flex-wrap items-center gap-2">{actions}</div>}
    </div>
  );
}

export function EmptyState({ icon, title, children, action }: {
  icon?: React.ReactNode; title: string; children?: React.ReactNode; action?: React.ReactNode;
}) {
  return (
    <div className="flex flex-col items-center gap-3 rounded-[14px] border border-dashed border-hairline-firm px-6 py-10 text-center">
      {icon && <span aria-hidden className="flex h-11 w-11 items-center justify-center rounded-xl bg-raised text-[22px] text-neutral-faint">{icon}</span>}
      <p className="m-0 text-[15px] font-semibold text-ink">{title}</p>
      {children && <p className="m-0 max-w-sm text-[13px] leading-relaxed text-neutral-faint">{children}</p>}
      {action}
    </div>
  );
}

// ── Notifications ────────────────────────────────────────────────────

type ToastTone = "success" | "error";
const ToastContext = createContext<(message: string, tone?: ToastTone) => void>(() => {});

/** Notification en bas à droite, 2,6 s. La zone `status` reste montée en
 * permanence : un lecteur d'écran n'annonce que le texte qui change dans
 * une zone déjà présente. */
export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toast, setToast] = useState<{ message: string; tone: ToastTone } | null>(null);
  const [visible, setVisible] = useState(false);
  const timer = useRef<number | undefined>(undefined);

  const show = useCallback((message: string, tone: ToastTone = "success") => {
    window.clearTimeout(timer.current);
    setToast({ message, tone });
    setVisible(true);
    timer.current = window.setTimeout(() => setVisible(false), 2600);
  }, []);
  useEffect(() => () => window.clearTimeout(timer.current), []);

  return (
    <ToastContext.Provider value={show}>
      {children}
      <div
        role="status"
        aria-live="polite"
        className={cx(
          "pointer-events-none fixed bottom-5 right-5 z-[70] flex items-center gap-2.5 rounded-xl border border-hairline-firm bg-raised px-4 py-[11px] text-[13.5px] shadow-[0_20px_40px_rgb(0_0_0/0.45)] transition-[transform,opacity] duration-300 ease-[cubic-bezier(.2,.8,.2,1)]",
          visible ? "translate-y-0 opacity-100" : "translate-y-5 opacity-0",
        )}
      >
        {toast && (toast.tone === "success"
          ? <CheckCircleIcon weight="fill" aria-hidden className="text-lg text-success" />
          : <WarningCircleIcon weight="fill" aria-hidden className="text-lg text-danger" />)}
        {toast?.message}
      </div>
    </ToastContext.Provider>
  );
}

export const useToast = () => useContext(ToastContext);

// ── Fenêtres modales ─────────────────────────────────────────────────

const FOCUSABLE = 'a[href],button:not([disabled]),input:not([disabled]):not([type="hidden"]),select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex="-1"])';

/** Socle commun des fenêtres : fond flouté, fermeture par Échap ou clic
 * sur le fond, focus piégé à l'intérieur et rendu à l'élément d'origine à
 * la fermeture, défilement de la page bloqué. */
export function Dialog({ open, onClose, labelledBy, className, children, placement = "top" }: {
  open: boolean;
  onClose: () => void;
  labelledBy: string;
  className?: string;
  children: React.ReactNode;
  placement?: "top" | "palette";
}) {
  const panel = useRef<HTMLDivElement>(null);
  const onCloseRef = useRef(onClose);
  onCloseRef.current = onClose;

  useEffect(() => {
    if (!open) return;
    const previous = document.activeElement as HTMLElement | null;
    const overflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    // Premier champ si la fenêtre en a un, sinon le premier bouton.
    const el = panel.current;
    const first = el?.querySelector<HTMLElement>("input:not([type=hidden]),textarea,select") ?? el?.querySelector<HTMLElement>(FOCUSABLE);
    (first ?? el)?.focus();

    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") { e.stopPropagation(); onCloseRef.current(); return; }
      if (e.key !== "Tab" || !el) return;
      const items = [...el.querySelectorAll<HTMLElement>(FOCUSABLE)].filter((n) => n.offsetParent !== null);
      if (items.length === 0) { e.preventDefault(); return; }
      const [head, tail] = [items[0], items[items.length - 1]];
      if (e.shiftKey && document.activeElement === head) { e.preventDefault(); tail.focus(); }
      else if (!e.shiftKey && document.activeElement === tail) { e.preventDefault(); head.focus(); }
    };
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = overflow;
      previous?.focus?.();
    };
  }, [open]);

  if (!open) return null;
  return (
    <div
      onMouseDown={(e) => e.target === e.currentTarget && onClose()}
      className={cx(
        "fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-ground-deep/75 px-5 backdrop-blur-[6px] motion-safe:animate-[bo-fade_.2s_ease-out]",
        placement === "palette" ? "pt-[12vh]" : "py-10",
      )}
    >
      <div
        ref={panel}
        role="dialog"
        aria-modal="true"
        aria-labelledby={labelledBy}
        tabIndex={-1}
        className={cx(
          "w-full overflow-hidden rounded-[18px] border border-hairline-firm bg-surface shadow-[0_40px_80px_-20px_rgb(0_0_0/0.7)] outline-none motion-safe:animate-[bo-pop_.25s_cubic-bezier(.2,.8,.2,1)]",
          className,
        )}
      >
        {children}
      </div>
    </div>
  );
}

function DialogHeader({ id, title, onClose }: { id: string; title: string; onClose: () => void }) {
  return (
    <div className="flex items-center justify-between gap-4 border-b border-hairline px-5 py-4">
      <h2 id={id} className="m-0 font-display text-[22px] font-semibold tracking-[-0.02em]">{title}</h2>
      <button
        type="button"
        onClick={onClose}
        aria-label="Fermer"
        className="flex h-8 w-8 items-center justify-center rounded-lg text-neutral-faint transition-colors hover:bg-raised hover:text-ink"
      >
        <XIcon aria-hidden className="text-base" />
      </button>
    </div>
  );
}

const ERROR_BOX = "m-0 rounded-lg border border-danger/40 bg-danger/10 px-3 py-2 text-sm text-danger";

/** Modale de formulaire : soumet une Server Action et affiche son erreur.
 * `wide` : plus large — pour les cas avec aperçu visuel affiché en regard
 * des champs (jeu, carte, règle). `successMessage` : notification après
 * un enregistrement réussi (`null` pour ne rien afficher). */
export function Modal({ title, open, onClose, action, children, wide = false, successMessage = "Modifications enregistrées" }: {
  title: string; open: boolean; onClose: () => void;
  action: (form: FormData) => Promise<ActionResult>;
  children: React.ReactNode;
  wide?: boolean;
  successMessage?: string | null;
}) {
  const id = useId();
  const toast = useToast();
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();
  const close = () => { setError(null); onClose(); };

  return (
    <Dialog open={open} onClose={close} labelledBy={id} className={wide ? "max-w-[800px]" : "max-w-[560px]"}>
      <DialogHeader id={id} title={title} onClose={close} />
      <form
        action={(fd) => start(async () => {
          const r = await action(fd);
          if (r.ok) { close(); if (successMessage) toast(successMessage); } else setError(r.error);
        })}
        className="flex flex-col"
      >
        <div className="flex flex-col gap-3.5 p-5">
          {children}
          {error && <p role="alert" className={ERROR_BOX}>{error}</p>}
        </div>
        <div className="flex justify-end gap-2 border-t border-hairline bg-sunk px-5 py-3.5">
          <Button variant="ghost" onClick={close}>Annuler</Button>
          <Button type="submit" disabled={pending}>{pending ? "Enregistrement…" : "Enregistrer"}</Button>
        </div>
      </form>
    </Dialog>
  );
}

// ── Icônes ───────────────────────────────────────────────────────────

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
      <div className="mb-2 grid grid-cols-[repeat(auto-fill,34px)] gap-1.5">
        {choices.map((icon) => (
          <button key={icon} type="button" onClick={() => update(icon)}
            aria-pressed={value === icon}
            aria-label={`Icône ${icon}`}
            className={cx(
              "flex h-[34px] w-[34px] items-center justify-center rounded-lg border text-base transition-colors",
              value === icon ? "border-accent bg-accent/15" : "border-hairline hover:bg-raised",
            )}>
            {icon}
          </button>
        ))}
      </div>
      <input value={value} onChange={(e) => update(e.target.value)} maxLength={4}
        aria-label="Autre émoji"
        placeholder="ou un autre émoji…" className={inputCls} />
    </div>
  );
}

// ── Import CSV ───────────────────────────────────────────────────────

/** Bouton "Importer" + modale (upload CSV, lien modèle, doc du format) —
 * pas basé sur `Modal` : l'action reçoit le texte du fichier lu côté
 * client, pas un `FormData` de champs de formulaire. */
export function ImportButton({
  label = "Importer", templateHref, templateLabel = "Télécharger le modèle CSV",
  columns, notes, action, icon,
}: {
  label?: string;
  templateHref: string;
  templateLabel?: string;
  columns: string;
  notes: string;
  action: (csvText: string) => Promise<ActionResult & { count?: number }>;
  icon?: React.ReactNode;
}) {
  const id = useId();
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<string | null>(null);
  const [pending, start] = useTransition();
  const close = () => { setOpen(false); setError(null); setResult(null); };

  return (
    <>
      <Button variant="secondary" icon={icon} onClick={() => setOpen(true)}>{label}</Button>
      <Dialog open={open} onClose={close} labelledBy={id} className="max-w-[560px]">
        <DialogHeader id={id} title={label} onClose={close} />
        <div className="flex flex-col gap-3 p-5">
          <a href={templateHref} className="self-start text-sm text-accent-deep hover:text-ink">{templateLabel}</a>
          <input type="file" accept=".csv,text/csv" aria-label="Fichier CSV"
            className="block w-full text-sm text-ink-soft file:mr-3 file:rounded-lg file:border-0 file:bg-raised file:px-3 file:py-1.5 file:text-sm file:text-ink"
            onChange={(e) => {
              const file = e.target.files?.[0];
              if (!file) return;
              start(async () => {
                setError(null); setResult(null);
                const text = await file.text();
                const r = await action(text);
                if (r.ok) {
                  const msg = `${r.count} ligne(s) importée(s)`;
                  setResult(msg);
                  toast(msg);
                } else setError(r.error);
                e.target.value = "";
              });
            }} />
          <p className="m-0 text-xs leading-relaxed text-neutral-faint">
            Colonnes attendues : <code className="font-mono text-ink-soft">{columns}</code>. {notes}
          </p>
          <div aria-live="polite">
            {pending && <p className="m-0 text-sm text-neutral-faint">Import en cours…</p>}
            {result && <p className="m-0 text-sm text-success">{result}</p>}
          </div>
          {error && <p role="alert" className={ERROR_BOX}>{error}</p>}
        </div>
        <div className="flex justify-end border-t border-hairline bg-sunk px-5 py-3.5">
          <Button variant="ghost" onClick={close}>Fermer</Button>
        </div>
      </Dialog>
    </>
  );
}

// ── Confirmation ─────────────────────────────────────────────────────

const CONFIRM_WINDOW_MS = 4000;

/** Action destructrice en deux clics : le premier arme le bouton (4 s),
 * le second exécute. Plus de `window.confirm`, bloquant et hors charte.
 * `confirm` décrit l'action ; il est annoncé aux lecteurs d'écran quand
 * le bouton s'arme. */
export function ConfirmButton({ label, confirm, action, children, doneMessage }: {
  label: string; confirm: string;
  action: () => Promise<ActionResult>;
  children?: React.ReactNode;
  doneMessage?: string;
}) {
  const toast = useToast();
  const [armed, setArmed] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();
  const timer = useRef<number | undefined>(undefined);

  useEffect(() => () => window.clearTimeout(timer.current), []);

  const disarm = () => { window.clearTimeout(timer.current); setArmed(false); };

  return (
    // `relative` : la zone d'annonce masquée (sr-only, en position absolue)
    // reste dans le conteneur ; sinon elle s'échappe des tableaux à
    // défilement horizontal et élargit la page.
    <span className="relative inline-flex items-center gap-2">
      <button
        type="button"
        disabled={pending}
        aria-label={armed ? `${confirm} Clique à nouveau pour confirmer.` : undefined}
        title={armed ? confirm : label}
        onBlur={disarm}
        onKeyDown={(e) => e.key === "Escape" && disarm()}
        onClick={() => {
          if (!armed) {
            setError(null);
            setArmed(true);
            timer.current = window.setTimeout(() => setArmed(false), CONFIRM_WINDOW_MS);
            return;
          }
          disarm();
          start(async () => {
            const r = await action();
            if (!r.ok) setError(r.error);
            else if (doneMessage) toast(doneMessage);
          });
        }}
        className={cx(
          "inline-flex items-center justify-center gap-1.5 rounded-lg border px-3.5 py-2 text-[13px] font-medium transition-colors disabled:opacity-50",
          armed ? "border-danger bg-danger text-ground-deep" : "border-hairline text-danger hover:border-danger/50 hover:bg-danger/10",
        )}
      >
        {pending ? "…" : armed ? "Confirmer ?" : (children ?? label)}
      </button>
      <span className="sr-only" aria-live="polite">{armed ? confirm : ""}</span>
      {error && <span role="alert" className="text-xs text-danger">{error}</span>}
    </span>
  );
}
