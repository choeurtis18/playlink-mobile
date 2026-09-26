import type { Prisma } from "@prisma/client";
import { prisma } from "./prisma";

// Journal d'activité lisible : traduit les lignes brutes d'AuditLog
// (`updated_card`, `card`, id) en « Carte modifiée — « Ton pire date ? » ».

export type ActivityIcon = "edit" | "create" | "delete" | "import" | "publish" | "site" | "order" | "translate" | "toggle";

const ACTIONS: Record<string, { label: string; icon: ActivityIcon }> = {
  created_card: { label: "Carte créée", icon: "create" },
  updated_card: { label: "Carte modifiée", icon: "edit" },
  deleted_card: { label: "Carte supprimée", icon: "delete" },
  activated_card: { label: "Carte activée", icon: "toggle" },
  deactivated_card: { label: "Carte désactivée", icon: "toggle" },
  imported_cards: { label: "Cartes importées", icon: "import" },
  saved_translation: { label: "Traduction enregistrée", icon: "translate" },
  deleted_translation: { label: "Traduction supprimée", icon: "translate" },
  created_category: { label: "Catégorie créée", icon: "create" },
  updated_category: { label: "Catégorie modifiée", icon: "edit" },
  deleted_category: { label: "Catégorie supprimée", icon: "delete" },
  toggled_preview_eligible: { label: "Démo de la landing", icon: "site" },
  created_game: { label: "Jeu créé", icon: "create" },
  updated_game: { label: "Jeu modifié", icon: "edit" },
  reordered_games: { label: "Jeux réordonnés", icon: "order" },
  imported_games: { label: "Jeux importés", icon: "import" },
  created_slide: { label: "Slide de règles créée", icon: "create" },
  updated_slide: { label: "Slide de règles modifiée", icon: "edit" },
  deleted_slide: { label: "Slide de règles supprimée", icon: "delete" },
  reordered_slides: { label: "Slides réordonnées", icon: "order" },
  created_badge: { label: "Badge créé", icon: "create" },
  updated_badge: { label: "Badge modifié", icon: "edit" },
  deleted_badge: { label: "Badge supprimé", icon: "delete" },
  updated_site_content: { label: "Site mis à jour", icon: "site" },
  updated_landing_texts: { label: "Textes du site mis à jour", icon: "site" },
  updated_landing_settings: { label: "Réglages du site mis à jour", icon: "site" },
  published_site: { label: "Site publié", icon: "site" },
  published_release: { label: "Version publiée", icon: "publish" },
  deleted_preregistration: { label: "Pré-inscription supprimée", icon: "delete" },
  exported_preregistrations: { label: "Pré-inscriptions exportées", icon: "import" },
};

export type ActivityEntry = {
  id: string;
  label: string;
  detail: string;
  icon: ActivityIcon;
  /** Code brut, affiché en petit (utile pour recouper avec la base). */
  code: string;
  createdAt: Date;
  editor: string | null;
};

type Meta = Record<string, unknown> | null;
const str = (v: unknown) => (typeof v === "string" ? v : null);
const quote = (s: string, max = 60) => `« ${s.length > max ? `${s.slice(0, max - 1)}…` : s} »`;

/** Dernières lignes du journal, avec le nom de ce qu'elles touchent
 * (lu en base par lots : une requête par type d'entité, pas par ligne). */
export async function recentActivity(take = 6, where?: Prisma.AuditLogWhereInput): Promise<ActivityEntry[]> {
  // Par défaut, sans les synchros automatiques des stats (une par nuit).
  const logs = await prisma.auditLog.findMany({ where: where ?? { entity: { not: "stats" } }, orderBy: { createdAt: "desc" }, take });
  const ids = (entity: string) =>
    [...new Set(logs.filter((l) => l.entity === entity && !["bulk", "default"].includes(l.entityId)).map((l) => l.entityId))];

  const adminIds = [...new Set(logs.map((l) => l.adminId).filter((x): x is string => !!x))];
  const [cards, categories, games, slides, badges, admins] = await Promise.all([
    prisma.card.findMany({ where: { id: { in: ids("card") } }, select: { id: true, text: true } }),
    prisma.category.findMany({ where: { id: { in: ids("category") } }, select: { id: true, name: true, game: { select: { name: true } } } }),
    prisma.game.findMany({ where: { id: { in: ids("game") } }, select: { id: true, name: true } }),
    prisma.gameRuleSlide.findMany({ where: { id: { in: ids("slide") } }, select: { id: true, title: true, game: { select: { name: true } } } }),
    prisma.badge.findMany({ where: { id: { in: ids("badge") } }, select: { id: true, name: true } }),
    prisma.adminUser.findMany({ where: { id: { in: adminIds } }, select: { id: true, email: true } }),
  ]);
  const name = new Map<string, string>([
    ...cards.map((c) => [c.id, quote(c.text)] as const),
    ...categories.map((c) => [c.id, `${c.name} · ${c.game.name}`] as const),
    ...games.map((g) => [g.id, g.name] as const),
    ...slides.map((s) => [s.id, `${s.title} · ${s.game.name}`] as const),
    ...badges.map((b) => [b.id, b.name] as const),
  ]);
  const editor = new Map(admins.map((a) => [a.id, a.email.split("@")[0]]));

  return logs.map((l) => {
    const known = ACTIONS[l.action];
    const meta = l.meta as Meta;
    return {
      id: l.id,
      label: known?.label ?? l.action,
      detail: detailOf(l.action, l.entityId, meta, name),
      icon: known?.icon ?? "edit",
      code: `${l.entity}.${l.action.split("_")[0]}`,
      createdAt: l.createdAt,
      editor: l.adminId ? editor.get(l.adminId) ?? null : null,
    };
  });
}

function detailOf(action: string, entityId: string, meta: Meta, name: Map<string, string>): string {
  const count = typeof meta?.count === "number" ? meta.count : null;
  if (entityId === "bulk" && count !== null) return `${count} élément${count > 1 ? "s" : ""}`;
  if (action === "published_release") return `v${entityId}`;
  // Jamais l'adresse (effacée) : la langue suffit à situer la ligne.
  if (action === "deleted_preregistration") return `Adresse effacée (RGPD)${str(meta?.locale) ? ` · ${str(meta?.locale)!.toUpperCase()}` : ""}`;
  if (action === "toggled_preview_eligible") {
    const label = name.get(entityId) ?? "Catégorie supprimée";
    return `${label} → ${meta?.previewEligible ? "jouable" : "retirée"}`;
  }
  if (action.endsWith("_translation")) {
    const locale = str(meta?.locale)?.toUpperCase();
    return `${name.get(entityId) ?? "Carte supprimée"}${locale ? ` (${locale})` : ""}`;
  }
  if (action === "published_site") {
    const keys = Array.isArray(meta?.keys) ? meta.keys.length : 0;
    const cats = typeof meta?.categories === "number" ? meta.categories : 0;
    const parts = [keys && `${keys} texte${keys > 1 ? "s" : ""}`, cats && `${cats} catégorie${cats > 1 ? "s" : ""} de la démo`].filter(Boolean);
    return parts.length ? parts.join(", ") : "réglages";
  }
  if (action === "updated_landing_texts" && Array.isArray(meta?.keys)) {
    // Clés tracées sous la forme « fr:hero.title » → « hero.title (FR) ».
    const keys = meta.keys
      .filter((k): k is string => typeof k === "string")
      .map((k) => { const [locale, key] = k.split(":"); return key ? `${key} (${locale.toUpperCase()})` : k; });
    return keys.length > 3 ? `${keys.slice(0, 3).join(", ")}… (${keys.length})` : keys.join(", ");
  }
  const found = name.get(entityId);
  if (found) return found;
  // Élément supprimé depuis : le texte gardé dans la trace, sinon rien.
  const text = str(meta?.text);
  return text ? quote(text) : action.startsWith("deleted_") ? "" : "Élément supprimé depuis";
}

const TZ = "Europe/Paris";
const time = new Intl.DateTimeFormat("fr-FR", { timeZone: TZ, hour: "2-digit", minute: "2-digit" });
const day = new Intl.DateTimeFormat("fr-FR", { timeZone: TZ, day: "numeric", month: "short" });
const dayKey = new Intl.DateTimeFormat("fr-CA", { timeZone: TZ, year: "numeric", month: "2-digit", day: "2-digit" });

/** « à l'instant », « il y a 12 min », « il y a 3 h », « hier · 22:40 »,
 * « 12 sept. · 09:15 » — heure de Paris. */
export function relativeTime(date: Date, now = new Date()): string {
  const minutes = Math.floor((now.getTime() - date.getTime()) / 60_000);
  if (minutes < 1) return "à l’instant";
  if (minutes < 60) return `il y a ${minutes} min`;
  if (minutes < 6 * 60) return `il y a ${Math.floor(minutes / 60)} h`;
  const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);
  if (dayKey.format(date) === dayKey.format(now)) return `aujourd’hui · ${time.format(date)}`;
  if (dayKey.format(date) === dayKey.format(yesterday)) return `hier · ${time.format(date)}`;
  return `${day.format(date)} · ${time.format(date)}`;
}

/** Jour calendaire à Paris (AAAA-MM-JJ), pour regrouper par date. */
export const parisDay = (date: Date) => dayKey.format(date);
