"use client";

import { useState, useTransition } from "react";
import { Button, Field, Textarea } from "@/components/ui";
import { importCards, publishRelease } from "@/lib/actions";

export function PublishButton({ changes }: { changes: number }) {
  const [changelog, setChangelog] = useState("");
  const [result, setResult] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();

  return (
    <div className="flex flex-col gap-3">
      <Field label="Changelog" hint="Ce que change cette version, pour ton propre suivi.">
        <Textarea rows={2} value={changelog} onChange={(e) => setChangelog(e.target.value)}
          placeholder={changes ? `${changes} cartes modifiées` : "Corrections diverses"} />
      </Field>
      <div className="flex items-center gap-3">
        <Button disabled={pending}
          onClick={() => {
            if (!window.confirm("Publier une nouvelle version ? Les apps la téléchargeront au prochain lancement.")) return;
            start(async () => {
              setError(null); setResult(null);
              const r = await publishRelease(changelog);
              if (r.ok) { setResult(`Version ${r.version} publiée`); setChangelog(""); }
              else setError(r.error);
            });
          }}>
          {pending ? "Publication…" : "Publier la version suivante"}
        </Button>
        {result && <span className="text-sm text-green-400">{result}</span>}
        {error && <span className="text-sm text-red-400">{error}</span>}
      </div>
    </div>
  );
}

export function ImportForm() {
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<string | null>(null);
  const [pending, start] = useTransition();

  return (
    <div>
      <input type="file" accept=".csv,text/csv"
        className="block w-full text-sm text-ink-soft file:mr-3 file:rounded file:border-0 file:bg-raised file:px-3 file:py-1.5 file:text-sm file:text-ink"
        onChange={(e) => {
          const file = e.target.files?.[0];
          if (!file) return;
          start(async () => {
            setError(null); setResult(null);
            const text = await file.text();
            const r = await importCards(text);
            if (r.ok) setResult(`${r.count} cartes importées`);
            else setError(r.error);
            e.target.value = "";
          });
        }} />
      <p className="mt-2 text-xs text-neutral-faint">
        Colonnes attendues : <code>id, jeu, categorie, texte, intensite, tags, actif, ordre, texte_en</code>.
        Une ligne avec <code>id</code> met à jour, sans <code>id</code> crée. Tout ou rien : une erreur annule l&apos;import entier.
      </p>
      {pending && <p className="mt-2 text-sm text-neutral-faint">Import en cours…</p>}
      {result && <p className="mt-2 text-sm text-green-400">{result}</p>}
      {error && <p className="mt-2 text-sm text-red-400">{error}</p>}
    </div>
  );
}
