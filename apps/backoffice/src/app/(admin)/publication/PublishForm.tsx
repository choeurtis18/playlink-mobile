"use client";

import { useState, useTransition } from "react";
import { Button, Field, Textarea } from "@/components/ui";
import { publishRelease } from "@/lib/actions";

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
