"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { RocketLaunchIcon } from "@phosphor-icons/react/dist/ssr";
import { Button, Field, Textarea, useToast } from "@/components/ui";
import { publishRelease } from "@/lib/actions";

/** Publication en deux temps : « Publier » demande confirmation sur place
 * (plus de boîte de dialogue du navigateur), puis crée la version. */
export function PublishButton({ changes, nextVersion }: { changes: number; nextVersion: number }) {
  const toast = useToast();
  const router = useRouter();
  const [changelog, setChangelog] = useState("");
  const [confirming, setConfirming] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();

  const publish = () =>
    start(async () => {
      setError(null);
      const r = await publishRelease(changelog);
      setConfirming(false);
      if (r.ok) {
        setChangelog("");
        toast(`Version ${r.version} publiée`);
        router.refresh();
      } else {
        setError(r.error);
        toast("Publication échouée", "error");
      }
    });

  return (
    <div className="flex flex-col gap-3.5">
      <Field label="Changelog" hint="Ce que change cette version, pour ton propre suivi.">
        <Textarea rows={2} value={changelog} onChange={(e) => setChangelog(e.target.value)}
          placeholder={changes ? `${changes} modification${changes > 1 ? "s" : ""} de contenu` : "Corrections diverses"} />
      </Field>
      <div className="flex flex-wrap items-center gap-3">
        {!confirming ? (
          <Button icon={<RocketLaunchIcon aria-hidden />} disabled={pending} onClick={() => setConfirming(true)}>
            Publier la v{nextVersion}
          </Button>
        ) : (
          <div role="group" aria-label="Confirmer la publication" className="flex flex-wrap items-center gap-3">
            <Button icon={<RocketLaunchIcon aria-hidden />} disabled={pending} onClick={publish} autoFocus>
              {pending ? "Publication…" : `Confirmer la v${nextVersion}`}
            </Button>
            <span className="text-[13px] text-ink-soft">Les apps la téléchargeront au prochain lancement.</span>
            {!pending && <button type="button" onClick={() => setConfirming(false)} className="text-[13px] text-neutral-faint hover:text-ink">Annuler</button>}
          </div>
        )}
      </div>
      {error && <p role="alert" className="m-0 rounded-lg border border-danger/40 bg-danger/10 px-3 py-2 text-sm text-danger">{error}</p>}
    </div>
  );
}
