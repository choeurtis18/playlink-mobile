"use client";

import { useRef, useState, useTransition } from "react";
import { Button, Field, Input, Textarea } from "@/components/ui";
import { saveSiteContent, uploadHeroImage } from "@/lib/actions";
import type { Game, SiteContent, SiteContentTranslation } from "@prisma/client";

type SiteContentWithTranslations = (SiteContent & { translations: SiteContentTranslation[] }) | null;

function t(site: SiteContentWithTranslations, locale: string) {
  return site?.translations.find((tr) => tr.locale === locale);
}

/** Convertit une Date en valeur de <input type="date"> (YYYY-MM-DD),
 * sans dépendance date — le formulaire n'a besoin que du jour. */
function toDateInputValue(d: Date | null | undefined) {
  if (!d) return "";
  return new Date(d).toISOString().slice(0, 10);
}

export function SiteContentForm({
  siteContent,
  games,
}: {
  siteContent: SiteContentWithTranslations;
  games: Game[];
}) {
  const fr = t(siteContent, "fr");
  const en = t(siteContent, "en");

  const [heroImageUrl, setHeroImageUrl] = useState(siteContent?.heroImageUrl ?? "");
  const [heroImageAlt, setHeroImageAlt] = useState(siteContent?.heroImageAlt ?? "");
  const [featured, setFeatured] = useState<string[]>(siteContent?.featuredGameIds ?? []);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [uploading, startUpload] = useTransition();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [saveError, setSaveError] = useState<string | null>(null);
  const [saved, setSaved] = useState(false);
  const [pending, startSave] = useTransition();

  function toggleFeatured(gameId: string) {
    setFeatured((prev) =>
      prev.includes(gameId) ? prev.filter((id) => id !== gameId) : [...prev, gameId]
    );
  }

  function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploadError(null);
    startUpload(async () => {
      const fd = new FormData();
      fd.set("file", file);
      const r = await uploadHeroImage(fd);
      if (r.ok && r.url) {
        setHeroImageUrl(r.url);
        setHeroImageAlt(""); // nouvelle image = nouveau texte alternatif requis
      } else if (!r.ok) {
        setUploadError(r.error);
      }
    });
  }

  return (
    <form
      className="flex flex-col gap-6 rounded-lg border border-hairline bg-surface p-5"
      action={(fd) => {
        fd.set("heroImageUrl", heroImageUrl);
        fd.set("heroImageAlt", heroImageAlt);
        featured.forEach((id) => fd.append("featuredGameIds", id));
        startSave(async () => {
          const r = await saveSiteContent(fd);
          if (r.ok) { setSaveError(null); setSaved(true); setTimeout(() => setSaved(false), 3000); }
          else setSaveError(r.error);
        });
      }}
    >
      <section className="flex flex-col gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-faint">Statut de sortie</h3>
        <Field label="Date de sortie" hint="Vide ou future : le site affiche « Bientôt disponible ». Passée : le badge disparaît.">
          <Input type="date" name="releaseDate" defaultValue={toDateInputValue(siteContent?.releaseDate)} />
        </Field>
      </section>

      <section className="grid grid-cols-1 gap-6 md:grid-cols-2">
        <div className="flex flex-col gap-3">
          <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-faint">Héros — Français</h3>
          <Field label="Titre"><Input name="heroTitleFr" defaultValue={fr?.heroTitle} required maxLength={200} /></Field>
          <Field label="Texte d'accroche"><Textarea name="heroLedeFr" rows={3} defaultValue={fr?.heroLede} required maxLength={500} /></Field>
          <Field label="Libellé du bouton"><Input name="ctaLabelFr" defaultValue={fr?.ctaLabel} required maxLength={80} /></Field>
        </div>
        <div className="flex flex-col gap-3">
          <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-faint">Héros — Anglais</h3>
          <Field label="Title"><Input name="heroTitleEn" defaultValue={en?.heroTitle} required maxLength={200} /></Field>
          <Field label="Lede"><Textarea name="heroLedeEn" rows={3} defaultValue={en?.heroLede} required maxLength={500} /></Field>
          <Field label="Button label"><Input name="ctaLabelEn" defaultValue={en?.ctaLabel} required maxLength={80} /></Field>
        </div>
      </section>

      <section className="flex flex-col gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-faint">Image du héros</h3>
        <div className="flex flex-wrap items-start gap-4">
          {heroImageUrl && (
            // eslint-disable-next-line @next/next/no-img-element -- Blob externe, next/image inutile ici
            <img src={heroImageUrl} alt={heroImageAlt || "Aperçu — texte alternatif manquant"}
              className="h-24 w-40 rounded border border-hairline object-cover" />
          )}
          <div className="flex flex-col gap-2">
            <input ref={fileInputRef} type="file" accept="image/*" onChange={handleFileChange}
              className="text-sm text-ink-soft" disabled={uploading} />
            {uploading && <span className="text-xs text-neutral-faint">Envoi en cours…</span>}
            {uploadError && <span className="text-xs text-red-400">{uploadError}</span>}
          </div>
        </div>
        <Field
          label="Texte alternatif de l'image"
          hint="Obligatoire dès qu'une image est renseignée — accessibilité et référencement (plan landing §07)."
        >
          <Input
            value={heroImageAlt}
            onChange={(e) => setHeroImageAlt(e.target.value)}
            required={!!heroImageUrl}
            maxLength={300}
            placeholder="Décris ce que montre l'image"
          />
        </Field>
      </section>

      <section className="flex flex-col gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-faint">Réseaux sociaux</h3>
        <div className="grid grid-cols-1 gap-3 md:grid-cols-3">
          <Field label="Instagram"><Input type="url" name="instagramUrl" defaultValue={siteContent?.instagramUrl ?? ""} placeholder="https://instagram.com/…" /></Field>
          <Field label="TikTok"><Input type="url" name="tiktokUrl" defaultValue={siteContent?.tiktokUrl ?? ""} placeholder="https://tiktok.com/@…" /></Field>
          <Field label="Reddit"><Input type="url" name="redditUrl" defaultValue={siteContent?.redditUrl ?? ""} placeholder="https://reddit.com/r/…" /></Field>
        </div>
      </section>

      <section className="flex flex-col gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-faint">Jeux mis en avant</h3>
        <p className="text-xs text-neutral-faint">Affichés sur la landing dans l&apos;ordre où ils apparaissent ci-dessous.</p>
        <div className="flex flex-wrap gap-2">
          {games.map((g) => (
            <label key={g.id}
              className={`cursor-pointer rounded-full border px-3 py-1.5 text-sm transition ${
                featured.includes(g.id)
                  ? "border-accent bg-accent/10 text-ink"
                  : "border-hairline text-ink-soft hover:bg-ground"
              }`}>
              <input type="checkbox" className="sr-only" checked={featured.includes(g.id)}
                onChange={() => toggleFeatured(g.id)} />
              {g.name}
            </label>
          ))}
        </div>
      </section>

      {saveError && <p className="rounded border border-red-900 bg-red-950/40 px-3 py-2 text-sm text-red-300">{saveError}</p>}
      <div className="flex items-center gap-3">
        <Button type="submit" disabled={pending || uploading}>{pending ? "Enregistrement…" : "Enregistrer"}</Button>
        {saved && <span className="text-sm text-green-400">Enregistré</span>}
      </div>
    </form>
  );
}
