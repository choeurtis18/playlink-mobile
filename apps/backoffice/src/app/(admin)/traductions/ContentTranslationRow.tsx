"use client";

import { useState, useTransition } from "react";
import { CheckCircleIcon, WarningCircleIcon } from "@phosphor-icons/react/dist/ssr";
import { useToast } from "@/components/ui";
import { saveContentTranslation } from "@/lib/actions";
import type { ContentKind } from "@/lib/validation";
import type { TranslatableField } from "@/lib/content-translations";


const inputCls = "w-full rounded-lg border border-hairline bg-ground px-[11px] py-[9px] text-[13.5px] leading-normal text-ink placeholder:text-neutral-faint focus:border-accent focus:outline-none";

/** Un jeu, une catégorie, une slide ou un badge : champs français à
 * gauche, anglais à droite. Enregistré quand le focus quitte la ligne
 * (tous les champs ensemble, pour ne pas valider un nom sans sa
 * description obligatoire). */
export function ContentTranslationRow({ kind, id, title, context, icon, fields }: {
  kind: ContentKind; id: string; title: string; context?: string; icon?: string | null; fields: TranslatableField[];
}) {
  const toast = useToast();
  const initial = Object.fromEntries(fields.map((f) => [f.key, f.en]));
  const [saved, setSaved] = useState(initial);
  const [values, setValues] = useState(initial);
  const [status, setStatus] = useState<null | "ok" | string>(null);
  const [pending, start] = useTransition();
  const dirty = fields.some((f) => (values[f.key] ?? "").trim() !== (saved[f.key] ?? "").trim());

  const save = () => {
    if (!dirty || pending) return;
    start(async () => {
      const r = await saveContentTranslation(kind, id, values);
      if (r.ok) { setSaved(values); setStatus("ok"); toast("Traduction enregistrée"); }
      else { setStatus(r.error); toast(r.error, "error"); }
    });
  };

  return (
    <li
      onBlur={(e) => { if (!e.currentTarget.contains(e.relatedTarget as Node | null)) save(); }}
      className="flex flex-col gap-3 border-t border-hairline px-[18px] py-4 first:border-t-0"
    >
      <div className="flex items-center gap-2.5">
        {icon && <span aria-hidden className="text-lg">{icon}</span>}
        <h3 className="m-0 text-sm font-semibold">{title}</h3>
        {context && <span className="text-xs text-neutral-faint">{context}</span>}
        <span aria-live="polite" className="ml-auto flex items-center gap-1 text-xs">
          {pending ? <span className="text-neutral-faint">Envoi…</span>
            : status === "ok" && !dirty ? <span className="flex items-center gap-1 text-success"><CheckCircleIcon aria-hidden weight="fill" />Enregistré</span>
            : status && status !== "ok" ? <span className="flex items-center gap-1 text-danger"><WarningCircleIcon aria-hidden weight="fill" />{status}</span>
            : dirty ? <span className="text-warning">Modifié</span> : null}
        </span>
      </div>
      {fields.map((f) => {
        const label = `${f.label} en anglais — ${title}`;
        const value = values[f.key] ?? "";
        const set = (v: string) => { setValues((s) => ({ ...s, [f.key]: v })); setStatus(null); };
        return (
          <div key={f.key} className="grid grid-cols-1 gap-2 md:grid-cols-2 md:gap-5">
            <div className="flex flex-col gap-1">
              <span className="font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint">{f.label}</span>
              <span lang="fr" className="whitespace-pre-wrap text-sm leading-normal text-ink-soft">{f.fr || <em className="text-neutral-faint">(vide en français)</em>}</span>
            </div>
            {f.multiline ? (
              <textarea lang="en" rows={f.fr.length > 160 ? 5 : 2} value={value} maxLength={f.max} aria-label={label}
                placeholder="Traduction anglaise…" onChange={(e) => set(e.target.value)} className={`${inputCls} resize-y`} />
            ) : (
              <input lang="en" value={value} maxLength={f.max} aria-label={label}
                placeholder="Traduction anglaise…" onChange={(e) => set(e.target.value)} className={`${inputCls} self-end`} />
            )}
          </div>
        );
      })}
    </li>
  );
}
