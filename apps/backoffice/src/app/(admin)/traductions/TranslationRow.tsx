"use client";

import { useState, useTransition } from "react";
import { CheckCircleIcon, WarningCircleIcon } from "@phosphor-icons/react/dist/ssr";
import { useToast } from "@/components/ui";
import { saveTranslation } from "@/lib/actions";

/** Édition FR ↔ EN en regard, enregistrée en quittant le champ. En mode
 * « à traduire », la ligne disparaît de la liste une fois traduite. */
export function TranslationRow({ id, fr, en, meta, color }: {
  id: string; fr: string; en: string | null; meta: string; color: string;
}) {
  const toast = useToast();
  const [value, setValue] = useState(en ?? "");
  const [status, setStatus] = useState<null | "ok" | string>(null);
  const [pending, start] = useTransition();
  const dirty = value.trim() !== (en ?? "").trim();

  const save = () => {
    if (!dirty || !value.trim()) return;
    start(async () => {
      const fd = new FormData();
      fd.set("cardId", id); fd.set("locale", "en"); fd.set("text", value);
      const r = await saveTranslation(fd);
      setStatus(r.ok ? "ok" : r.error);
      toast(r.ok ? "Traduction enregistrée" : r.error, r.ok ? "success" : "error");
    });
  };

  return (
    <li className="grid grid-cols-1 gap-3 border-t border-hairline px-[18px] py-3.5 md:grid-cols-2 md:gap-5">
      <div className="flex flex-col gap-1.5">
        <span lang="fr" className="text-sm leading-normal text-ink-soft">{fr}</span>
        <span className="flex items-center gap-1.5 text-[11.5px] text-neutral-faint">
          <span aria-hidden className="h-1.5 w-1.5 rounded-full" style={{ background: color }} />{meta}
        </span>
      </div>
      <div className="flex items-start gap-2.5">
        <textarea
          lang="en"
          value={value}
          rows={2}
          aria-label={`Traduction anglaise de « ${fr.slice(0, 60)} »`}
          onChange={(e) => { setValue(e.target.value); setStatus(null); }}
          onBlur={save}
          placeholder="Traduction anglaise…"
          className="w-full resize-y rounded-lg border border-hairline bg-ground px-[11px] py-[9px] text-[13.5px] leading-normal text-ink placeholder:text-neutral-faint focus:border-accent focus:outline-none"
        />
        <span aria-live="polite" className="flex w-[70px] flex-none items-center gap-1 pt-2.5 text-xs">
          {pending ? <span className="text-neutral-faint">Envoi…</span>
            : status === "ok" ? <span className="flex items-center gap-1 text-success"><CheckCircleIcon aria-hidden weight="fill" />Enregistré</span>
            : status ? <span className="flex items-center gap-1 text-danger" title={status}><WarningCircleIcon aria-hidden weight="fill" />Erreur</span>
            : dirty ? <span className="text-warning">Modifié</span> : null}
        </span>
      </div>
    </li>
  );
}
