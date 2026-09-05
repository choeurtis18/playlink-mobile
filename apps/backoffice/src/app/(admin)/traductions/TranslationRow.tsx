"use client";

import { useState, useTransition } from "react";
import { saveTranslation } from "@/lib/actions";

/** Édition inline FR↔EN : on voit l'original en regard de sa traduction. */
export function TranslationRow({ id, fr, en }: { id: string; fr: string; en: string | null }) {
  const [value, setValue] = useState(en ?? "");
  const [saved, setSaved] = useState<null | "ok" | string>(null);
  const [pending, start] = useTransition();
  const dirty = value.trim() !== (en ?? "").trim();

  const save = () => {
    if (!dirty || !value.trim()) return;
    start(async () => {
      const fd = new FormData();
      fd.set("cardId", id); fd.set("locale", "en"); fd.set("text", value);
      const r = await saveTranslation(fd);
      setSaved(r.ok ? "ok" : r.error);
    });
  };

  return (
    <tr className="border-t border-hairline align-top">
      <td className="w-1/2 p-2 text-ink-soft">{fr}</td>
      <td className="w-1/2 p-2">
        <div className="flex gap-2">
          <textarea
            value={value} rows={2}
            onChange={(e) => { setValue(e.target.value); setSaved(null); }}
            onBlur={save}
            placeholder="Traduction anglaise…"
            className="w-full rounded border border-hairline bg-ground px-2 py-1 text-sm focus:border-accent focus:outline-none"
          />
          <span className="w-16 shrink-0 pt-1 text-xs">
            {pending ? <span className="text-neutral-faint">…</span>
              : saved === "ok" ? <span className="text-green-400">✓</span>
              : saved ? <span className="text-red-400" title={saved}>✗</span>
              : dirty ? <span className="text-neutral-faint">modifié</span> : null}
          </span>
        </div>
      </td>
    </tr>
  );
}
