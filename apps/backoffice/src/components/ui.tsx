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

/** Modale de formulaire : soumet une Server Action et affiche son erreur. */
export function Modal({ title, open, onClose, action, children }: {
  title: string; open: boolean; onClose: () => void;
  action: (form: FormData) => Promise<ActionResult>;
  children: React.ReactNode;
}) {
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto bg-black/70 p-6"
      onClick={(e) => e.target === e.currentTarget && onClose()}>
      <div className="w-full max-w-lg rounded-lg border border-hairline bg-surface p-5">
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
