"use client";

import { useEffect, useMemo, useReducer, useState, useTransition } from "react";
import type { Icon } from "@phosphor-icons/react";
import {
  CheckCircleIcon, CircleIcon, EnvelopeSimpleIcon, GameControllerIcon, InfoIcon, InstagramLogoIcon,
  MagnifyingGlassIcon, PlayCircleIcon, RedditLogoIcon, RocketLaunchIcon, ShareNetworkIcon, SparkleIcon,
  TiktokLogoIcon,
} from "@phosphor-icons/react/dist/ssr";
import { DEMO_DECK_SIZES, LANDING_SECTIONS, type LandingKey } from "@playlink/content-schema/landing-keys.ts";
import { Button, Card, Input, PageHeader, Segmented, Switch, Textarea, useToast } from "@/components/ui";
import { publishSite } from "@/lib/actions";
import {
  changeCount, enIssues, exposedCards, publishPayload, sectionStatus, type SectionId, type SectionStatus,
} from "./draft";
import { SitePreview } from "./SitePreview";
import type { EditorGame, SiteDraft, SiteSettings } from "./types";

const SECTION_ICONS: Record<SectionId, Icon> = {
  hero: SparkleIcon,
  games: GameControllerIcon,
  demo: PlayCircleIcon,
  about: InfoIcon,
  notif: EnvelopeSimpleIcon,
  social: ShareNetworkIcon,
  seo: MagnifyingGlassIcon,
};

const STATUS: Record<SectionStatus, { dot: string; label: string }> = {
  dirty: { dot: "bg-warning", label: "Modifié, non publié" },
  missing: { dot: "bg-danger", label: "Traduction EN à revoir" },
  ok: { dot: "bg-success", label: "Complet" },
};

const INTENSITY_LABELS = ["Tranquille", "Léger", "Normal", "Épicé", "Sans filtre"];
const MAX_FEATURED = 8;

type Action =
  | { type: "text"; key: LandingKey; locale: "fr" | "en"; value: string }
  | { type: "setting"; name: keyof SiteSettings; value: SiteSettings[keyof SiteSettings] }
  | { type: "eligible"; id: string }
  | { type: "reset"; to: SiteDraft };

function reducer(state: SiteDraft, action: Action): SiteDraft {
  switch (action.type) {
    case "text":
      return { ...state, texts: { ...state.texts, [action.key]: { ...state.texts[action.key], [action.locale]: action.value } } };
    case "setting":
      return { ...state, settings: { ...state.settings, [action.name]: action.value } };
    case "eligible":
      return { ...state, eligible: { ...state.eligible, [action.id]: !state.eligible[action.id] } };
    case "reset":
      return action.to;
  }
}

const relative = (iso: string) => {
  const min = Math.floor((Date.now() - new Date(iso).getTime()) / 60_000);
  if (min < 1) return "à l’instant";
  if (min < 60) return `il y a ${min} min`;
  if (min < 24 * 60) return `il y a ${Math.floor(min / 60)} h`;
  return `le ${new Date(iso).toLocaleDateString("fr-FR", { day: "numeric", month: "short" })}`;
};

/** Éditeur « Contenu du site » : sections à gauche, textes FR/EN et
 * réglages au centre, aperçu en direct à droite (≥ 1280 px ; en dessous,
 * sections en pastilles au-dessus et aperçu en dessous). Rien n'est
 * enregistré avant « Publier sur le site ». */
export function SiteEditor({ initial, games, initialSection, lastPublishedAt }: {
  initial: SiteDraft;
  games: EditorGame[];
  initialSection: string;
  lastPublishedAt: string | null;
}) {
  const toast = useToast();
  const [saved, setSaved] = useState(initial);
  const [draft, dispatch] = useReducer(reducer, initial);
  const [section, setSection] = useState(initialSection as SectionId);
  const [published, setPublished] = useState(lastPublishedAt);
  const [error, setError] = useState<string | null>(null);
  /** Publication réussie mais landing non prévenue : cause à corriger. */
  const [syncWarning, setSyncWarning] = useState<string | null>(null);
  const [pending, start] = useTransition();

  const count = changeCount(saved, draft);
  const dirty = count > 0;
  const issues = useMemo(() => enIssues(draft), [draft]);

  // Quitter la page avec des modifications non publiées : le navigateur
  // demande confirmation.
  useEffect(() => {
    if (!dirty) return;
    const warn = (e: BeforeUnloadEvent) => e.preventDefault();
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, [dirty]);

  const go = (id: SectionId) => {
    setSection(id);
    // Lien partageable vers la section, sans recharger la page.
    window.history.replaceState(null, "", `?sec=${id}`);
  };

  const publish = () =>
    start(async () => {
      setError(null);
      const r = await publishSite(publishPayload(saved, draft));
      if (r.ok) {
        setSaved(draft);
        setPublished(new Date().toISOString());
        if (r.notify && !r.notify.ok) {
          setSyncWarning(r.notify.reason);
          toast("Site publié, mais la landing n’a pas été prévenue", "error");
        } else {
          setSyncWarning(null);
          toast("Site publié — landing prévenue, visible en quelques secondes");
        }
      } else {
        setError(r.error);
        toast("Publication refusée", "error");
      }
    });

  const current = LANDING_SECTIONS.find((s) => s.id === section)!;
  const set = <K extends keyof SiteSettings>(name: K, value: SiteSettings[K]) => dispatch({ type: "setting", name, value });

  return (
    <>
      <PageHeader
        title="Contenu du site"
        description="Textes FR/EN de la landing, section par section. La mise en page reste fixe."
        actions={
          <>
            <span className={`flex items-center gap-2 rounded-full border px-3 py-1.5 text-[13px] ${dirty ? "border-warning/40 text-ink" : "border-hairline text-ink-soft"}`}>
              <span aria-hidden className={`h-[7px] w-[7px] rounded-full ${dirty ? "bg-warning" : "bg-success"}`} />
              <span aria-live="polite">
                {dirty
                  ? `${count} modification${count > 1 ? "s" : ""} non publiée${count > 1 ? "s" : ""}`
                  : published ? `En ligne · publié ${relative(published)}` : "En ligne"}
              </span>
            </span>
            {dirty && <Button variant="ghost" onClick={() => { dispatch({ type: "reset", to: saved }); setError(null); }}>Annuler</Button>}
            <Button onClick={publish} disabled={!dirty || pending} icon={<RocketLaunchIcon aria-hidden />}>
              {pending ? "Publication…" : "Publier sur le site"}
            </Button>
          </>
        }
      />

      {error && <p role="alert" className="mb-4 rounded-lg border border-danger/40 bg-danger/10 px-3 py-2 text-sm text-danger">{error}</p>}
      {syncWarning && (
        <div role="alert" className="mb-4 flex flex-col gap-1 rounded-lg border border-warning/40 bg-warning/10 px-3.5 py-2.5 text-sm">
          <strong className="font-semibold text-warning">Publié, mais la landing n’a pas été prévenue</strong>
          <span className="text-ink-soft">
            Cause : {syncWarning}. Les textes sont bien enregistrés ; la landing les affichera d’elle-même sous 5 minutes environ.
            Corrige la configuration Vercel pour une mise à jour immédiate.
          </span>
        </div>
      )}

      <div className="grid items-start gap-4 min-[1280px]:grid-cols-[210px_minmax(0,1fr)_minmax(0,380px)]">
        <nav aria-label="Sections de la page" className="flex flex-wrap gap-1.5 min-[1280px]:sticky min-[1280px]:top-[76px] min-[1280px]:flex-col min-[1280px]:gap-0.5 min-[1280px]:rounded-[14px] min-[1280px]:border min-[1280px]:border-hairline min-[1280px]:bg-surface min-[1280px]:p-2">
          <p className="m-0 hidden px-2.5 pb-1.5 pt-1 font-mono text-[10px] uppercase tracking-[0.14em] text-neutral-faint min-[1280px]:block">Sections de la page</p>
          {LANDING_SECTIONS.map((s, i) => {
            const IconCmp = SECTION_ICONS[s.id as SectionId];
            const status = STATUS[sectionStatus(s.id as SectionId, saved, draft, issues)];
            const on = s.id === section;
            return (
              <button
                key={s.id}
                type="button"
                onClick={() => go(s.id as SectionId)}
                aria-current={on ? "true" : undefined}
                className={`flex items-center gap-2.5 rounded-lg border px-2.5 py-2 text-left text-[13.5px] font-medium transition-colors min-[1280px]:border-transparent ${
                  on ? "border-accent bg-raised text-ink" : "border-hairline text-ink-soft hover:bg-raised hover:text-ink"
                }`}
              >
                <span aria-hidden className="hidden font-mono text-[10px] text-neutral-faint min-[1280px]:inline">{String(i + 1).padStart(2, "0")}</span>
                <IconCmp aria-hidden className="shrink-0 text-base" />
                <span className="flex-1">{s.label}</span>
                <span aria-hidden title={status.label} className={`h-[7px] w-[7px] shrink-0 rounded-full ${status.dot}`} />
                <span className="sr-only">({status.label})</span>
              </button>
            );
          })}
        </nav>

        <div className="flex min-w-0 flex-col gap-3.5">
          <section aria-labelledby="sec-title" className="overflow-hidden rounded-[14px] border border-hairline bg-surface">
            <div className="flex items-center justify-between gap-3 border-b border-hairline bg-sunk px-[18px] py-3.5">
              <h2 id="sec-title" className="m-0 flex items-center gap-2.5 text-[15px] font-semibold">
                {(() => { const I = SECTION_ICONS[section]; return <I aria-hidden className="text-lg text-accent-deep" />; })()}
                {current.label}
              </h2>
              <span aria-hidden className="hidden gap-10 pr-2 font-mono text-[10px] uppercase tracking-[0.14em] text-neutral-faint sm:flex">
                <span>FR</span><span>EN</span>
              </span>
            </div>
            {current.fields.map((f, i) => {
              const key = f.key as LandingKey;
              const value = draft.texts[key];
              const issue = issues.get(key);
              const Field = f.multiline ? Textarea : Input;
              return (
                <div key={key} className={`flex flex-col gap-2 px-[18px] py-3.5 ${i ? "border-t border-hairline" : ""}`}>
                  <div className="flex items-baseline justify-between gap-2.5">
                    <span className="text-[13px] font-semibold">{f.label}</span>
                    <code className="font-mono text-[11px] text-neutral-faint">{key}</code>
                  </div>
                  <div className="grid grid-cols-[repeat(auto-fit,minmax(min(100%,220px),1fr))] gap-2.5">
                    <Field
                      counter
                      maxLength={f.max}
                      rows={f.multiline ? 3 : undefined}
                      value={value.fr}
                      placeholder={f.fr}
                      aria-label={`${f.label} (français)`}
                      onChange={(e: React.ChangeEvent<HTMLInputElement & HTMLTextAreaElement>) => dispatch({ type: "text", key, locale: "fr", value: e.target.value })}
                    />
                    <div className="flex flex-col gap-1">
                      <Field
                        counter
                        maxLength={f.max}
                        rows={f.multiline ? 3 : undefined}
                        value={value.en}
                        placeholder={value.fr}
                        aria-label={`${f.label} (anglais)`}
                        aria-describedby={issue ? `${key}-issue` : undefined}
                        onChange={(e: React.ChangeEvent<HTMLInputElement & HTMLTextAreaElement>) => dispatch({ type: "text", key, locale: "en", value: e.target.value })}
                      />
                      {issue && (
                        <span id={`${key}-issue`} className="text-[11px] text-warning">
                          {issue === "missing" ? "Traduction manquante — la landing EN affiche le FR" : "Le FR a changé — l’anglais est encore le texte d’origine"}
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </section>

          {section === "hero" && (
            <Card className="flex flex-col gap-2.5">
              <h3 className="m-0 text-sm font-semibold">Statut de sortie</h3>
              <div className="flex flex-wrap items-center gap-3">
                <Input type="date" aria-label="Date de sortie" className="w-auto" value={draft.settings.releaseDate} onChange={(e) => set("releaseDate", e.target.value)} />
                <span className="text-[13px] text-neutral-faint">
                  {draft.settings.releaseDate && new Date(draft.settings.releaseDate) <= new Date()
                    ? "Date passée : le sur-titre devient « Disponible sur iOS & Android »."
                    : "Vide ou à venir : le sur-titre ci-dessus s’affiche (« Bientôt… »)."}
                </span>
              </div>
            </Card>
          )}

          {section === "games" && (
            <Card className="flex flex-col gap-3">
              <div className="flex flex-wrap items-baseline justify-between gap-3">
                <h3 className="m-0 text-sm font-semibold">Jeux affichés</h3>
                <span className="text-xs text-neutral-faint">{draft.settings.featuredGameIds.length} / {MAX_FEATURED} · l’ordre suit la page Jeux</span>
              </div>
              <div className="grid grid-cols-[repeat(auto-fill,minmax(170px,1fr))] gap-2">
                {games.map((g) => {
                  const on = draft.settings.featuredGameIds.includes(g.id);
                  const full = !on && draft.settings.featuredGameIds.length >= MAX_FEATURED;
                  return (
                    <button
                      key={g.id}
                      type="button"
                      aria-pressed={on}
                      disabled={full}
                      title={!g.active ? "Jeu inactif : masqué sur la landing" : undefined}
                      onClick={() => set("featuredGameIds", on ? draft.settings.featuredGameIds.filter((id) => id !== g.id) : [...draft.settings.featuredGameIds, g.id])}
                      className={`flex items-center gap-2.5 rounded-[10px] border px-2.5 py-2 text-left text-[13px] transition-colors disabled:opacity-40 ${
                        on ? "border-accent bg-accent/10 text-ink" : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink"
                      }`}
                    >
                      <span aria-hidden className="flex h-7 w-7 flex-none items-center justify-center rounded-lg text-sm" style={{ background: `linear-gradient(135deg, ${g.colorMain}, ${g.colorSecondary})` }}>{g.icon}</span>
                      <span className="flex-1">{g.name}{!g.active && <span className="text-neutral-faint"> (inactif)</span>}</span>
                      {on ? <CheckCircleIcon weight="fill" aria-hidden className="text-base text-accent" /> : <CircleIcon aria-hidden className="text-base text-neutral-faint" />}
                    </button>
                  );
                })}
              </div>
            </Card>
          )}

          {section === "demo" && (
            <Card className="flex flex-col gap-4">
              <div className="flex flex-wrap gap-5">
                <div className="flex flex-col gap-1.5">
                  <span className="text-[13px] font-semibold">Taille du deck</span>
                  <Segmented
                    label="Taille du deck"
                    options={DEMO_DECK_SIZES.map((n) => ({ value: n as number, label: `${n} cartes` }))}
                    value={draft.settings.demoDeckSize}
                    onChange={(v) => set("demoDeckSize", v)}
                  />
                </div>
                <div className="flex flex-col gap-1.5">
                  <span className="text-[13px] font-semibold">Intensité max. exposée</span>
                  <Segmented
                    label="Intensité maximale exposée au public"
                    options={INTENSITY_LABELS.map((title, i) => ({ value: i + 1, label: String(i + 1), title }))}
                    value={draft.settings.demoMaxIntensity}
                    onChange={(v) => set("demoMaxIntensity", v)}
                  />
                  <span className="text-xs text-neutral-faint">{INTENSITY_LABELS[draft.settings.demoMaxIntensity - 1]}</span>
                </div>
              </div>
              <div className="flex flex-col gap-2.5">
                <div className="flex flex-wrap items-baseline justify-between gap-3">
                  <h3 className="m-0 text-[13px] font-semibold">Catégories jouables dans la démo</h3>
                  <span className="text-xs text-neutral-faint">
                    {Object.values(draft.eligible).filter(Boolean).length} cochées · {exposedCards(games, draft.eligible, draft.settings.demoMaxIntensity)} cartes exposées
                  </span>
                </div>
                {games.map((g) => (
                  <div key={g.id} className="flex flex-wrap items-center gap-2.5 py-1">
                    <span className="flex w-[150px] items-center gap-2 text-[13px] text-ink-soft">
                      <span aria-hidden>{g.icon}</span>{g.name}
                    </span>
                    <div className="flex flex-1 flex-wrap gap-1.5">
                      {g.categories.length === 0 && <span className="text-xs text-neutral-faint">Aucune catégorie</span>}
                      {g.categories.map((c) => {
                        const on = !!draft.eligible[c.id];
                        return (
                          <button
                            key={c.id}
                            type="button"
                            aria-pressed={on}
                            onClick={() => dispatch({ type: "eligible", id: c.id })}
                            className={`rounded-full border px-3 py-1 text-[12.5px] transition-colors ${
                              on ? "border-accent bg-accent/12 text-ink" : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink"
                            }`}
                          >
                            {c.name}
                          </button>
                        );
                      })}
                    </div>
                  </div>
                ))}
                <p className="m-0 text-xs text-neutral-faint">Seules les cartes actives des jeux actifs, jusqu’à l’intensité choisie, sont exposées au public.</p>
              </div>
            </Card>
          )}

          {section === "notif" && (
            <Card className="flex items-center gap-3.5">
              <Switch label="Double opt-in" checked={draft.settings.doubleOptIn} onChange={(v) => set("doubleOptIn", v)} />
              <span className="flex flex-col gap-0.5">
                <span className="text-sm font-semibold">Double opt-in</span>
                <span className="text-xs text-neutral-faint">Envoie un e-mail de confirmation avant de compter l’inscription — meilleure délivrabilité, moins de fausses adresses.</span>
              </span>
            </Card>
          )}

          {section === "social" && (
            <Card className="flex flex-col gap-3">
              <h3 className="m-0 text-sm font-semibold">Liens</h3>
              {([
                ["instagramUrl", "Instagram", InstagramLogoIcon, "https://instagram.com/…"],
                ["tiktokUrl", "TikTok", TiktokLogoIcon, "https://tiktok.com/@…"],
                ["redditUrl", "Reddit", RedditLogoIcon, "https://reddit.com/r/…"],
              ] as const).map(([name, label, IconCmp, placeholder]) => (
                <label key={name} className="flex items-center gap-2.5">
                  <IconCmp aria-hidden className="w-5 shrink-0 text-lg text-ink-soft" />
                  <Input type="url" aria-label={label} placeholder={placeholder} value={draft.settings[name]} onChange={(e) => set(name, e.target.value)} />
                </label>
              ))}
              <span className="text-xs text-neutral-faint">Un réseau sans lien est masqué sur la landing ; sans aucun lien, la section disparaît.</span>
            </Card>
          )}
        </div>

        <SitePreview section={section} draft={draft} games={games} />
      </div>
    </>
  );
}
