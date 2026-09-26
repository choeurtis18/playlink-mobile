import {
  LANDING_FIELDS, LANDING_SECTIONS, type LandingKey,
} from "@playlink/content-schema/landing-keys.ts";
import type { SitePublishPayload } from "@/lib/actions";
import type { SiteDraft, SiteSettings } from "./types";

// Logique pure de l'éditeur « Contenu du site » : différences avec la
// version publiée, statut de chaque section, charge envoyée à publishSite.

export type SectionId = (typeof LANDING_SECTIONS)[number]["id"];

/** Réglages rattachés à chaque section (les textes le sont par leur clé). */
const SECTION_SETTINGS: Partial<Record<SectionId, (keyof SiteSettings)[]>> = {
  hero: ["releaseDate"],
  games: ["featuredGameIds"],
  demo: ["demoDeckSize", "demoMaxIntensity"],
  notif: ["doubleOptIn"],
  social: ["instagramUrl", "tiktokUrl", "redditUrl"],
};

const sameSetting = (a: SiteSettings[keyof SiteSettings], b: SiteSettings[keyof SiteSettings]) =>
  Array.isArray(a) && Array.isArray(b) ? a.length === b.length && a.every((x) => b.includes(x)) : a === b;

/** EN confirmé « à jour » sans être modifié : réenregistré tel quel. */
const enConfirmed = (saved: SiteDraft, draft: SiteDraft, key: LandingKey) =>
  !!saved.enStale[key] && !draft.enStale[key] && draft.texts[key].en === saved.texts[key].en;

export function changedTexts(saved: SiteDraft, draft: SiteDraft) {
  const out: { locale: "fr" | "en"; key: LandingKey; value: string }[] = [];
  for (const f of LANDING_FIELDS) {
    const key = f.key as LandingKey;
    for (const locale of ["fr", "en"] as const) {
      if (draft.texts[key][locale] !== saved.texts[key][locale]) out.push({ locale, key, value: draft.texts[key][locale] });
    }
    if (enConfirmed(saved, draft, key)) out.push({ locale: "en", key, value: draft.texts[key].en });
  }
  return out;
}

/** État « publié » après une publication réussie : un FR modifié sans son
 * EN rend l'anglais en retard ; un EN modifié ou confirmé est à jour. */
export function afterPublish(saved: SiteDraft, draft: SiteDraft): SiteDraft {
  const enStale: SiteDraft["enStale"] = {};
  for (const f of LANDING_FIELDS) {
    const key = f.key as LandingKey;
    const frEdited = draft.texts[key].fr !== saved.texts[key].fr;
    const enTouched = draft.texts[key].en !== saved.texts[key].en || enConfirmed(saved, draft, key);
    enStale[key] = enTouched ? false : frEdited ? draft.texts[key].fr.trim() !== f.fr.trim() : !!draft.enStale[key];
  }
  return { ...draft, enStale };
}

export function changedSettings(saved: SiteDraft, draft: SiteDraft) {
  return (Object.keys(draft.settings) as (keyof SiteSettings)[]).filter((k) => !sameSetting(draft.settings[k], saved.settings[k]));
}

export function changedEligibility(saved: SiteDraft, draft: SiteDraft) {
  return Object.keys(draft.eligible)
    .filter((id) => draft.eligible[id] !== saved.eligible[id])
    .map((categoryId) => ({ categoryId, previewEligible: draft.eligible[categoryId] }));
}

/** Nombre de modifications non publiées (un texte FR et son EN comptent
 * pour deux ; une catégorie de la démo pour une). */
export function changeCount(saved: SiteDraft, draft: SiteDraft) {
  return changedTexts(saved, draft).length + changedSettings(saved, draft).length + changedEligibility(saved, draft).length;
}

export function publishPayload(saved: SiteDraft, draft: SiteDraft): SitePublishPayload {
  return {
    texts: changedTexts(saved, draft),
    settings: { ...draft.settings, featuredGameIds: [...draft.settings.featuredGameIds] },
    eligibility: changedEligibility(saved, draft),
  };
}

/** Clés dont l'anglais manque ou n'a pas suivi le FR. */
/** Avertissements EN, en direct pendant l'édition :
 * - `missing` : EN vide (la landing EN affiche le FR) ;
 * - `stale` : FR personnalisé modifié sans l'EN, ou déjà en retard en
 *   base et pas encore confirmé. */
export function enIssues(saved: SiteDraft, draft: SiteDraft): Map<LandingKey, "missing" | "stale"> {
  const issues = new Map<LandingKey, "missing" | "stale">();
  for (const f of LANDING_FIELDS) {
    const key = f.key as LandingKey;
    const t = draft.texts[key];
    if (!t.en.trim()) { issues.set(key, "missing"); continue; }
    if (!t.fr.trim() || t.fr.trim() === f.fr.trim()) continue;
    if (t.en !== saved.texts[key].en) continue;
    if (t.fr !== saved.texts[key].fr || draft.enStale[key]) issues.set(key, "stale");
  }
  return issues;
}

export type SectionStatus = "dirty" | "missing" | "ok";

export function sectionStatus(id: SectionId, saved: SiteDraft, draft: SiteDraft, issues: Map<LandingKey, unknown>): SectionStatus {
  const section = LANDING_SECTIONS.find((s) => s.id === id)!;
  const keys = section.fields.map((f) => f.key as LandingKey);
  const textDirty = keys.some((k) => draft.texts[k].fr !== saved.texts[k].fr || draft.texts[k].en !== saved.texts[k].en);
  const settingsDirty = (SECTION_SETTINGS[id] ?? []).some((k) => !sameSetting(draft.settings[k], saved.settings[k]));
  const eligibilityDirty = id === "demo" && changedEligibility(saved, draft).length > 0;
  if (textDirty || settingsDirty || eligibilityDirty) return "dirty";
  return keys.some((k) => issues.has(k)) ? "missing" : "ok";
}

/** Cartes que la démo publique peut tirer : catégories cochées des jeux
 * actifs, jusqu'à l'intensité maximale (même filtre que
 * /api/preview-content). */
export function exposedCards(
  games: { active: boolean; categories: { id: string; byIntensity: number[] }[] }[],
  eligible: Record<string, boolean>,
  maxIntensity: number,
) {
  return games
    .filter((g) => g.active)
    .flatMap((g) => g.categories)
    .filter((c) => eligible[c.id])
    .reduce((sum, c) => sum + c.byIntensity.slice(0, maxIntensity).reduce((a, b) => a + b, 0), 0);
}
