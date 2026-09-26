// Textes éditables de la landing (apps/web), section par section.
//
// Source unique partagée par trois consommateurs qui ne doivent jamais
// diverger : la validation Zod du back-office (clé inconnue ou trop longue
// = refus), l'éditeur « Contenu du site » (libellés, compteurs), et le site
// (typage + repli quand le back-office est injoignable ou qu'une clé n'a
// pas encore de valeur).
//
// Les libellés d'interface (boutons de la démo, messages d'erreur…) n'en
// font pas partie : ils vivent dans apps/web/src/messages, car ils changent
// avec le code, pas avec le marketing.

import { z } from 'zod';

export type LandingField = {
  key: string;
  label: string;
  max: number;
  multiline: boolean;
  fr: string;
  en: string;
};

export type LandingSection = {
  id: string;
  label: string;
  /** Ancre de la section sur la landing, vide si elle n'en a pas. */
  anchor: string;
  fields: readonly LandingField[];
};

const f = (key: string, label: string, max: number, multiline: boolean, fr: string, en: string): LandingField =>
  ({ key, label, max, multiline, fr, en });

export const LANDING_SECTIONS = [
  { id: 'hero', label: 'Héros', anchor: '', fields: [
    f('hero.eyebrow', 'Sur-titre', 40, false, 'Bientôt sur iOS & Android', 'Coming soon to iOS & Android'),
    // *mot* : mis en valeur par le dégradé animé du héros.
    f('hero.title', 'Titre (*mot* = mis en valeur)', 120, false,
      'Le jeu qui a *brisé* plus d’amitiés que les groupes WhatsApp.',
      'The game that has *ended* more friendships than WhatsApp groups.'),
    f('hero.lede', 'Accroche', 220, true,
      '8 jeux de soirée, jouables entre amis sur un seul téléphone. Hors-ligne, sans compte — on se le passe, les scores se cumulent.',
      '8 party games, played with friends on a single phone. Offline, no account — pass it around, scores add up.'),
    f('hero.ctaPrimary', 'Bouton principal', 32, false, 'Découvrir les jeux', 'Explore the games'),
    f('hero.ctaSecondary', 'Bouton secondaire', 32, false, 'Me prévenir à la sortie', 'Notify me at launch'),
  ] },
  { id: 'games', label: 'Jeux', anchor: '#jeux', fields: [
    f('games.kicker', 'Sur-titre', 30, false, '01 — Les jeux', '01 — The games'),
    f('games.title', 'Titre', 80, false, '8 jeux, une seule appli.', '8 games, one app.'),
    f('games.lede', 'Texte', 200, true,
      'Chaque jeu a son propre univers de cartes — de l’ambiance légère à l’intensité qui pousse à se dévoiler.',
      'Every game has its own deck — from easy-going to the kind of intense that gets people talking.'),
  ] },
  { id: 'demo', label: 'Démo jouable', anchor: '#demo', fields: [
    f('demo.title', 'Titre', 80, false, 'Essaie avant de télécharger.', 'Try before you download.'),
    f('demo.lede', 'Texte', 200, true,
      'Choisis un jeu, une catégorie, une intensité — et joue une vraie partie à trois, comme dans l’app.',
      'Pick a game, a category, an intensity — and play a real three-player round, just like in the app.'),
  ] },
  { id: 'about', label: 'Comment ça marche', anchor: '#apropos', fields: [
    f('about.title', 'Titre (*passage* = en retrait)', 80, false, 'Un téléphone. *Tout le monde autour.*', 'One phone. *Everyone around it.*'),
    f('about.step1', 'Étape 1 — titre', 60, false, 'Choisis le jeu et l’intensité', 'Pick the game and intensity'),
    f('about.step1Body', 'Étape 1 — texte', 160, true,
      'De « Soft » à « Trash » : c’est vous qui décidez jusqu’où la soirée peut aller.',
      'From “Soft” to “Trash”: you decide how far the night can go.'),
    f('about.step2', 'Étape 2 — titre', 60, false, 'Passe le téléphone', 'Pass the phone'),
    f('about.step2Body', 'Étape 2 — texte', 160, true,
      'Pas de multi-appareils, pas de réseau. Un seul téléphone circule autour de la table.',
      'No multiple devices, no network. One phone goes around the table.'),
    f('about.step3', 'Étape 3 — titre', 60, false, 'Les scores se cumulent', 'Scores add up'),
    f('about.step3Body', 'Étape 3 — texte', 160, true,
      'D’une partie à l’autre, l’app garde la mémoire de qui a tout avoué — et qui a tout esquivé.',
      'Game after game, the app remembers who confessed everything — and who dodged it all.'),
  ] },
  { id: 'notif', label: 'Pré-inscription', anchor: '#notif', fields: [
    f('notif.title', 'Titre', 80, false, 'Sois prévenu·e le jour de la sortie.', 'Be the first to know on launch day.'),
    f('notif.lede', 'Texte', 200, true,
      'Un seul e-mail, quand l’app arrive sur les stores. Pas de spam, désinscription en un clic.',
      'One single email when the app hits the stores. No spam, one-click unsubscribe.'),
    f('notif.button', 'Bouton', 24, false, 'Me prévenir', 'Notify me'),
    f('notif.consent', 'Case de consentement', 240, true,
      'J’accepte que Playlink conserve mon e-mail pour me prévenir de la sortie de l’app.',
      'I agree that Playlink keeps my email to notify me when the app launches.'),
    f('notif.success', 'Message de succès', 120, false,
      'Merci ! Tu recevras une notif à la sortie de l’app.',
      'Thanks! You’ll get a heads-up when the app launches.'),
  ] },
  { id: 'social', label: 'Réseaux', anchor: '#reseaux', fields: [
    f('social.title', 'Titre', 80, false, 'Des défis et des updates, sur les réseaux.', 'Challenges and updates, on socials.'),
  ] },
  { id: 'seo', label: 'SEO & partage', anchor: '', fields: [
    f('meta.title', 'Titre de la page', 60, false,
      'Playlink — Les jeux de soirée, bientôt sur mobile',
      'Playlink — Party games, coming soon to mobile'),
    f('meta.description', 'Description', 160, true,
      '8 jeux pour animer vos soirées entre amis : Action ou Vérité, Mime, Dilemme et plus. L’application Playlink arrive bientôt sur iOS et Android.',
      '8 games to liven up your nights with friends: Truth or Dare, Charades, Would You Rather and more. Playlink is coming soon to iOS and Android.'),
  ] },
] as const satisfies readonly LandingSection[];

export type LandingKey = (typeof LANDING_SECTIONS)[number]['fields'][number]['key'];
export type LandingTexts = Record<LandingKey, string>;

export const LANDING_FIELDS: readonly LandingField[] = LANDING_SECTIONS.flatMap((s) => s.fields);
export const LANDING_KEYS = LANDING_FIELDS.map((x) => x.key) as LandingKey[];

const FIELD_BY_KEY = new Map(LANDING_FIELDS.map((x) => [x.key, x]));

export function isLandingKey(key: string): key is LandingKey {
  return FIELD_BY_KEY.has(key);
}

/** Textes par défaut d'une langue — le repli du site et la valeur initiale
 * de l'éditeur. */
export function defaultLandingTexts(locale: 'fr' | 'en'): LandingTexts {
  return Object.fromEntries(LANDING_FIELDS.map((x) => [x.key, x[locale]])) as LandingTexts;
}

/** Champs où `*mot*` met en valeur (dégradé du héros, passage en retrait
 * de « Comment ça marche »). Ailleurs, les étoiles s'afficheraient telles
 * quelles : elles sont retirées au rendu. */
export const EMPHASIS_KEYS: ReadonlySet<string> = new Set(['hero.title', 'about.title']);

/** Retire les marques `*mot*` (garde le mot). Une étoile isolée reste. */
export function stripEmphasis(text: string): string {
  return text.replace(/\*([^*\n]+)\*/g, '$1');
}

/** Complète des textes partiels : valeur de la langue → valeur FR (langue
 * d'origine, CLAUDE.md) → texte par défaut. Une chaîne vide compte comme
 * absente, pour qu'un champ EN laissé vide au back-office ne produise pas
 * un trou sur la page. */
export function resolveLandingTexts(
  texts: Partial<Record<string, Partial<Record<string, string>>>>,
  locale: string,
): LandingTexts {
  const pick = (loc: string, key: string) => {
    const v = texts[loc]?.[key];
    return v && v.trim() ? v : undefined;
  };
  const fallback = defaultLandingTexts(locale === 'en' ? 'en' : 'fr');
  return Object.fromEntries(
    LANDING_KEYS.map((key) => {
      const text = pick(locale, key) ?? pick('fr', key) ?? fallback[key];
      return [key, EMPHASIS_KEYS.has(key) ? text : stripEmphasis(text)];
    }),
  ) as LandingTexts;
}

/** Écart toléré entre deux écritures d'une même publication (FR et EN
 * enregistrés dans la même transaction, à quelques millisecondes près). */
const SAME_PUBLISH_MS = 2000;

/** Textes que l'anglais n'a pas suivis : le FR a été personnalisé au
 * back-office, et l'EN est vide, jamais enregistré, ou plus ancien que le
 * FR. La landing EN affiche alors un texte qui ne correspond plus au FR.
 *
 * Avec les dates (`updatedAt`, lignes lues en base) : l'EN est à jour dès
 * qu'il a été enregistré après le FR — même identique au texte par
 * défaut (« L'anglais est à jour » au back-office). Sans date : l'EN
 * resté au texte par défaut compte comme non suivi.
 * Renvoie la clé et sa section, dans l'ordre de la page. */
export function landingEnGaps(
  rows: readonly { locale: string; key: string; value: string; updatedAt?: Date | string | null }[],
): { key: LandingKey; sectionId: string }[] {
  const row = (locale: string, key: string) => rows.find((r) => r.locale === locale && r.key === key);
  const time = (d: Date | string | null | undefined) => (d ? new Date(d).getTime() : NaN);
  const gaps: { key: LandingKey; sectionId: string }[] = [];
  for (const section of LANDING_SECTIONS) {
    for (const field of section.fields) {
      const fr = row('fr', field.key);
      const frText = fr?.value.trim() ?? '';
      if (!frText || frText === field.fr.trim()) continue;
      const en = row('en', field.key);
      const enText = en?.value.trim() ?? '';
      const frAt = time(fr?.updatedAt), enAt = time(en?.updatedAt);
      const stale = !enText
        || (Number.isFinite(frAt) && Number.isFinite(enAt)
          ? frAt - enAt > SAME_PUBLISH_MS
          : enText === field.en.trim());
      if (stale) gaps.push({ key: field.key as LandingKey, sectionId: section.id });
    }
  }
  return gaps;
}

/** Une entrée éditée au back-office. Le texte peut être vide (EN pas encore
 * traduit) mais jamais plus long que la limite de sa clé. */
export const LandingTextInputSchema = z
  .object({
    locale: z.enum(['fr', 'en']),
    key: z.string().refine(isLandingKey, { message: 'Clé de texte inconnue.' }),
    value: z.string().trim(),
  })
  .superRefine((v, ctx) => {
    const field = FIELD_BY_KEY.get(v.key);
    if (field && v.value.length > field.max) {
      ctx.addIssue({ code: 'custom', path: ['value'], message: `« ${field.label} » : ${field.max} caractères maximum.` });
    }
    if (field && v.locale === 'fr' && !v.value) {
      ctx.addIssue({ code: 'custom', path: ['value'], message: `« ${field.label} » : le texte FR est obligatoire.` });
    }
  });
export type LandingTextInput = z.infer<typeof LandingTextInputSchema>;

/** Réglages de la démo jouable, bornés comme l'éditeur les propose. */
export const DEMO_DECK_SIZES = [3, 4, 5, 6] as const;
export const DemoSettingsSchema = z.object({
  deckSize: z.coerce.number().int().min(3).max(6),
  maxIntensity: z.coerce.number().int().min(1).max(5),
});
export type DemoSettings = z.infer<typeof DemoSettingsSchema>;
export const DEFAULT_DEMO_SETTINGS: DemoSettings = { deckSize: 5, maxIntensity: 3 };
