"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "./prisma";
import { requireEditor, logAction } from "./auth";
import { normalizeTags } from "@playlink/content-schema/tag-mapping.ts";
import {
  CardInput, CategoryInput, GameInput, BadgeInput, SlideInput, TranslationInput,
} from "./validation";

export type ActionResult = { ok: true } | { ok: false; error: string };

/**
 * Traduit les erreurs Prisma en messages lisibles.
 *
 * Brut, une violation de contrainte s'affiche
 * « Invalid `prisma.game.create()` invocation… » : l'éditeur ne sait ni ce
 * qui a échoué, ni quoi corriger.
 */
function humanize(e: unknown): string {
  const err = e as { code?: string; meta?: { target?: string[]; field_name?: string } };
  const field = err.meta?.target?.join(", ");
  switch (err.code) {
    case "P2002": {
      // La contrainte composite (gameId, slug) parle d'un champ que
      // l'éditeur ne voit pas dans le formulaire : on nomme ce qu'il a saisi.
      if (err.meta?.target?.includes("slug")) {
        return "Ce slug est déjà utilisé — choisis-en un autre.";
      }
      if (err.meta?.target?.includes("key")) {
        return "Cette clé de badge existe déjà.";
      }
      return `Cette valeur existe déjà${field ? ` (${field})` : ""} — choisis-en une autre.`;
    }
    case "P2003": return "Référence invalide : le jeu ou la catégorie visé n'existe pas.";
    case "P2025": return "Cet élément n'existe plus — il a peut-être été supprimé entre-temps.";
    case "P2000": return `Valeur trop longue${field ? ` pour ${field}` : ""}.`;
    default: return e instanceof Error ? e.message : "Erreur inconnue";
  }
}

/** Enveloppe commune : éditeur requis, erreurs renvoyées plutôt que jetées. */
async function run(fn: (adminId: string) => Promise<void>, paths: string[]): Promise<ActionResult> {
  try {
    const editor = await requireEditor();
    await fn(editor.id);
    for (const p of paths) revalidatePath(p);
    return { ok: true };
  } catch (e) {
    return { ok: false, error: humanize(e) };
  }
}

const field = (f: FormData, k: string) => {
  const v = f.get(k);
  return v === null || v === "" ? null : String(v);
};

// ── Cartes ────────────────────────────────────────────────────────────

export async function saveCard(id: string | null, form: FormData): Promise<ActionResult> {
  return run(async (adminId) => {
    const parsed = CardInput.safeParse({
      text: form.get("text"),
      intensity: form.get("intensity"),
      categoryId: form.get("categoryId"),
      tags: form.get("tags") ?? "",
      active: form.get("active") === "on",
      order: form.get("order") ?? 0,
    });
    if (!parsed.success) throw new Error(parsed.error.issues[0].message);

    // Les tags canoniques sont recalculés à chaque écriture : saisir "Amitié"
    // avec une majuscule ne doit pas casser silencieusement l'archétype.
    const data = { ...parsed.data, canonicalTags: normalizeTags(parsed.data.tags) };

    if (id) {
      await prisma.card.update({ where: { id }, data });
      await logAction(adminId, "updated_card", "card", id, { text: data.text.slice(0, 60) });
    } else {
      const created = await prisma.card.create({ data: { ...data, originalLocale: "fr" } });
      await logAction(adminId, "created_card", "card", created.id, { text: data.text.slice(0, 60) });
    }
  }, ["/cartes", "/", "/publication"]);
}

export async function deleteCard(id: string): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.card.delete({ where: { id } });
    await logAction(adminId, "deleted_card", "card", id);
  }, ["/cartes", "/", "/publication"]);
}

export async function toggleCardActive(id: string, active: boolean): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.card.update({ where: { id }, data: { active } });
    await logAction(adminId, active ? "activated_card" : "deactivated_card", "card", id);
  }, ["/cartes", "/"]);
}

// ── Traductions ───────────────────────────────────────────────────────

export async function saveTranslation(form: FormData): Promise<ActionResult> {
  return run(async (adminId) => {
    const parsed = TranslationInput.safeParse({
      cardId: form.get("cardId"), locale: form.get("locale") ?? "en", text: form.get("text"),
    });
    if (!parsed.success) throw new Error(parsed.error.issues[0].message);
    const { cardId, locale, text } = parsed.data;
    await prisma.cardTranslation.upsert({
      where: { cardId_locale: { cardId, locale } },
      create: { cardId, locale, text }, update: { text },
    });
    await logAction(adminId, "saved_translation", "card", cardId, { locale });
  }, ["/traductions", "/cartes", "/"]);
}

export async function deleteTranslation(cardId: string, locale: string): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.cardTranslation.delete({ where: { cardId_locale: { cardId, locale } } });
    await logAction(adminId, "deleted_translation", "card", cardId, { locale });
  }, ["/traductions", "/cartes", "/"]);
}

// ── Catégories ────────────────────────────────────────────────────────

export async function saveCategory(id: string | null, form: FormData): Promise<ActionResult> {
  return run(async (adminId) => {
    const parsed = CategoryInput.safeParse({
      name: form.get("name"), slug: form.get("slug"),
      description: field(form, "description"), icon: field(form, "icon"),
      order: form.get("order") ?? 0, gameId: form.get("gameId"),
    });
    if (!parsed.success) throw new Error(parsed.error.issues[0].message);

    if (id) {
      await prisma.category.update({ where: { id }, data: parsed.data });
      await logAction(adminId, "updated_category", "category", id);
    } else {
      const c = await prisma.category.create({ data: { ...parsed.data, originalLocale: "fr" } });
      await logAction(adminId, "created_category", "category", c.id);
    }
  }, ["/jeux", "/categories", "/cartes", "/"]);
}

export async function deleteCategory(id: string): Promise<ActionResult> {
  return run(async (adminId) => {
    const n = await prisma.card.count({ where: { categoryId: id } });
    // Supprimer en cascade effacerait les cartes sans que l'éditeur le voie.
    if (n > 0) throw new Error(`${n} cartes rattachées — vide la catégorie d'abord`);
    await prisma.category.delete({ where: { id } });
    await logAction(adminId, "deleted_category", "category", id);
  }, ["/jeux", "/categories", "/cartes", "/"]);
}

// ── Jeux ──────────────────────────────────────────────────────────────

export async function saveGame(id: string | null, form: FormData): Promise<ActionResult> {
  return run(async (adminId) => {
    const parsed = GameInput.safeParse({
      name: form.get("name"), slug: form.get("slug"),
      description: field(form, "description"), icon: field(form, "icon"),
      colorMain: form.get("colorMain"), colorSecondary: form.get("colorSecondary"),
      active: form.get("active") === "on", order: form.get("order") ?? 0,
    });
    if (!parsed.success) throw new Error(parsed.error.issues[0].message);

    if (id) {
      await prisma.game.update({ where: { id }, data: parsed.data });
      await logAction(adminId, "updated_game", "game", id);
    } else {
      const g = await prisma.game.create({ data: { ...parsed.data, originalLocale: "fr" } });
      await logAction(adminId, "created_game", "game", g.id);
    }
  }, ["/jeux", "/categories", "/", "/publication"]);
}

/** Réordonne les jeux après un drag & drop, même principe que `reorderSlides`. */
export async function reorderGames(ids: string[]): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.$transaction(
      ids.map((id, i) => prisma.game.update({ where: { id }, data: { order: i } })),
    );
    await logAction(adminId, "reordered_games", "game", "bulk", { count: ids.length });
  }, ["/jeux", "/categories", "/", "/publication"]);
}

// ── Badges ────────────────────────────────────────────────────────────

export async function saveBadge(id: string | null, form: FormData): Promise<ActionResult> {
  return run(async (adminId) => {
    const parsed = BadgeInput.safeParse({
      key: form.get("key"), name: form.get("name"),
      description: form.get("description"), icon: form.get("icon"),
      order: form.get("order") ?? 0,
    });
    if (!parsed.success) throw new Error(parsed.error.issues[0].message);

    if (id) {
      await prisma.badge.update({ where: { id }, data: parsed.data });
      await logAction(adminId, "updated_badge", "badge", id);
    } else {
      const b = await prisma.badge.create({ data: parsed.data });
      await logAction(adminId, "created_badge", "badge", b.id);
    }
  }, ["/badges", "/"]);
}

export async function deleteBadge(id: string): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.badge.delete({ where: { id } });
    await logAction(adminId, "deleted_badge", "badge", id);
  }, ["/badges", "/"]);
}

// ── Slides de règles ──────────────────────────────────────────────────

export async function saveSlide(id: string | null, form: FormData): Promise<ActionResult> {
  return run(async (adminId) => {
    const parsed = SlideInput.safeParse({
      gameId: form.get("gameId"), title: form.get("title"),
      content: form.get("content"), order: form.get("order") ?? 0,
    });
    if (!parsed.success) throw new Error(parsed.error.issues[0].message);

    if (id) {
      await prisma.gameRuleSlide.update({ where: { id }, data: parsed.data });
      await logAction(adminId, "updated_slide", "slide", id);
    } else {
      const s = await prisma.gameRuleSlide.create({ data: parsed.data });
      await logAction(adminId, "created_slide", "slide", s.id);
    }
  }, ["/regles", "/"]);
}

export async function deleteSlide(id: string): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.gameRuleSlide.delete({ where: { id } });
    await logAction(adminId, "deleted_slide", "slide", id);
  }, ["/regles", "/"]);
}

/** Réordonne les slides d'un jeu après un drag & drop : `ids` dans le
 * nouvel ordre visuel devient le nouvel `order` (0, 1, 2…). */
export async function reorderSlides(ids: string[]): Promise<ActionResult> {
  return run(async (adminId) => {
    await prisma.$transaction(
      ids.map((id, i) => prisma.gameRuleSlide.update({ where: { id }, data: { order: i } })),
    );
    await logAction(adminId, "reordered_slides", "slide", "bulk", { count: ids.length });
  }, ["/regles", "/"]);
}

// ── Import CSV ────────────────────────────────────────────────────────

/**
 * Import transactionnel : soit toutes les lignes passent, soit aucune.
 * Un import à moitié appliqué laisserait le catalogue dans un état que
 * l'éditeur ne peut pas raisonner.
 *
 * Une ligne avec `id` met à jour la carte existante ; sans `id`, elle crée.
 */
export async function importCards(csvText: string): Promise<ActionResult & { count?: number }> {
  try {
    const editor = await requireEditor();
    const { parseCsv } = await import("./csv");
    const rows = parseCsv(csvText);
    if (!rows.length) return { ok: false, error: "CSV vide ou en-tête manquant" };

    const categories = await prisma.category.findMany({
      select: { id: true, name: true, game: { select: { name: true } } },
    });
    const findCategory = (jeu: string, cat: string) =>
      categories.find((c) => c.game.name === jeu.trim() && c.name === cat.trim());

    // Tout valider avant d'écrire : signaler la ligne fautive est plus utile
    // qu'échouer à mi-parcours.
    const ops = rows.map((r, i) => {
      const line = i + 2;
      const text = (r.texte ?? "").trim();
      if (!text) throw new Error(`Ligne ${line} : texte vide`);

      const intensity = parseInt(r.intensite ?? "3", 10);
      if (!(intensity >= 1 && intensity <= 5)) throw new Error(`Ligne ${line} : intensité "${r.intensite}" hors 1-5`);

      const category = findCategory(r.jeu ?? "", r.categorie ?? "");
      if (!category) throw new Error(`Ligne ${line} : catégorie introuvable — "${r.jeu} / ${r.categorie}"`);

      const tags = (r.tags ?? "").split("|").map((t) => t.trim()).filter(Boolean);
      return {
        id: (r.id ?? "").trim() || null,
        data: {
          text, intensity, categoryId: category.id, tags,
          canonicalTags: normalizeTags(tags),
          active: r.actif !== "0",
          order: parseInt(r.ordre ?? "0", 10) || 0,
        },
        textEn: (r.texte_en ?? "").trim(),
      };
    });

    await prisma.$transaction(async (tx) => {
      for (const op of ops) {
        const card = op.id
          ? await tx.card.update({ where: { id: op.id }, data: op.data })
          : await tx.card.create({ data: { ...op.data, originalLocale: "fr" } });

        if (op.textEn) {
          await tx.cardTranslation.upsert({
            where: { cardId_locale: { cardId: card.id, locale: "en" } },
            create: { cardId: card.id, locale: "en", text: op.textEn },
            update: { text: op.textEn },
          });
        }
      }
    });

    await logAction(editor.id, "imported_cards", "card", "bulk", { count: ops.length });
    revalidatePath("/cartes"); revalidatePath("/"); revalidatePath("/traductions");
    return { ok: true, count: ops.length };
  } catch (e) {
    return { ok: false, error: humanize(e) };
  }
}

/**
 * Import en masse de jeux et catégories, dans le même CSV.
 *
 * Une ligne où `categorie_slug` est vide crée/met à jour le JEU
 * (`jeu_slug` upsert) ; une ligne où il est rempli crée/met à jour une
 * CATÉGORIE rattachée à ce jeu. `jeu_slug` seul suffit alors — les autres
 * colonnes jeu_* sont ignorées sur ces lignes (le jeu existe déjà, créé
 * par sa propre ligne, avant ou après peu importe l'ordre).
 */
export async function importGames(csvText: string): Promise<ActionResult & { count?: number }> {
  try {
    const editor = await requireEditor();
    const { parseCsv } = await import("./csv");
    const rows = parseCsv(csvText);
    if (!rows.length) return { ok: false, error: "CSV vide ou en-tête manquant" };

    const gameOps: { slug: string; data: Record<string, unknown> }[] = [];
    const catOps: { gameSlug: string; slug: string; data: Record<string, unknown> }[] = [];

    for (let i = 0; i < rows.length; i++) {
      const r = rows[i];
      const line = i + 2;
      const gameSlug = (r.jeu_slug ?? "").trim();
      if (!gameSlug) throw new Error(`Ligne ${line} : jeu_slug vide`);

      const catSlug = (r.categorie_slug ?? "").trim();
      if (!catSlug) {
        // Ligne jeu.
        const name = (r.jeu_nom ?? "").trim();
        if (!name) throw new Error(`Ligne ${line} : jeu_nom vide`);
        const colorMain = (r.jeu_couleur1 ?? "").trim();
        const colorSecondary = (r.jeu_couleur2 ?? "").trim();
        if (!/^#[0-9A-Fa-f]{6}$/.test(colorMain)) throw new Error(`Ligne ${line} : jeu_couleur1 "${colorMain}" invalide (format #RRGGBB)`);
        if (!/^#[0-9A-Fa-f]{6}$/.test(colorSecondary)) throw new Error(`Ligne ${line} : jeu_couleur2 "${colorSecondary}" invalide (format #RRGGBB)`);
        gameOps.push({
          slug: gameSlug,
          data: {
            name, slug: gameSlug,
            description: (r.jeu_description ?? "").trim() || null,
            icon: (r.jeu_icone ?? "").trim() || null,
            colorMain, colorSecondary,
            active: r.jeu_actif !== "0",
            order: parseInt(r.jeu_ordre ?? "0", 10) || 0,
          },
        });
      } else {
        // Ligne catégorie, rattachée au jeu de cette même ligne.
        const name = (r.categorie_nom ?? "").trim();
        if (!name) throw new Error(`Ligne ${line} : categorie_nom vide`);
        catOps.push({
          gameSlug,
          slug: catSlug,
          data: {
            name, slug: catSlug,
            description: (r.categorie_description ?? "").trim() || null,
            icon: (r.categorie_icone ?? "").trim() || null,
            order: parseInt(r.categorie_ordre ?? "0", 10) || 0,
          },
        });
      }
    }

    let count = 0;
    await prisma.$transaction(async (tx) => {
      for (const op of gameOps) {
        await tx.game.upsert({
          where: { slug: op.slug },
          create: { ...op.data, originalLocale: "fr" } as never,
          update: op.data,
        });
        count++;
      }
      for (const op of catOps) {
        const game = await tx.game.findUnique({ where: { slug: op.gameSlug }, select: { id: true } });
        if (!game) throw new Error(`Catégorie "${op.slug}" : jeu "${op.gameSlug}" introuvable`);
        await tx.category.upsert({
          where: { gameId_slug: { gameId: game.id, slug: op.slug } },
          create: { ...op.data, gameId: game.id, originalLocale: "fr" } as never,
          update: op.data,
        });
        count++;
      }
    });

    await logAction(editor.id, "imported_games", "game", "bulk", { count });
    revalidatePath("/jeux"); revalidatePath("/categories"); revalidatePath("/"); revalidatePath("/publication");
    return { ok: true, count };
  } catch (e) {
    return { ok: false, error: humanize(e) };
  }
}

// ── Publication d'une release ─────────────────────────────────────────

/**
 * Fige l'état courant du contenu dans une nouvelle version.
 *
 * Le snapshot est généré ici puis uploadé sur Blob : tant qu'une release
 * n'est pas publiée, l'édition reste invisible des apps (§06).
 */
export async function publishRelease(changelog: string): Promise<ActionResult & { version?: number }> {
  try {
    const editor = await requireEditor();
    const { buildSnapshot } = await import("./snapshot");
    const { SnapshotSchema } = await import("@playlink/content-schema/snapshot.ts");

    const last = await prisma.contentRelease.findFirst({ orderBy: { version: "desc" } });
    const version = (last?.version ?? 0) + 1;

    const snapshot = await buildSnapshot(version);
    const parsed = SnapshotSchema.safeParse(snapshot);
    if (!parsed.success) {
      return { ok: false, error: `Snapshot invalide : ${parsed.error.issues[0]?.path.join(".")} — ${parsed.error.issues[0]?.message}` };
    }

    const token = process.env.BLOB_READ_WRITE_TOKEN;
    if (!token) return { ok: false, error: "BLOB_READ_WRITE_TOKEN absent" };

    // La version est réservée AVANT l'upload. Sinon un échec entre l'upload
    // et l'écriture en base laisserait un fichier orphelin sur Blob : la
    // tentative suivante réutiliserait le même numéro, que Blob refuserait
    // (allowOverwrite:false) — publication bloquée définitivement.
    const reserved = await prisma.contentRelease.create({
      data: { version, snapshotUrl: "", changelog: changelog.trim() || `Version ${version}` },
    });

    let blobUrl: string;
    try {
      const { put } = await import("@vercel/blob");
      const blob = await put(`content/content_v${version}.json`, JSON.stringify(snapshot), {
        access: "public", token, contentType: "application/json",
        addRandomSuffix: false, allowOverwrite: false,
      });
      blobUrl = blob.url;
    } catch (e) {
      // Libère le numéro pour que la prochaine tentative reparte proprement.
      await prisma.contentRelease.delete({ where: { id: reserved.id } });
      throw e;
    }

    await prisma.contentRelease.update({
      where: { id: reserved.id },
      data: { snapshotUrl: blobUrl },
    });
    const blob = { url: blobUrl };
    await logAction(editor.id, "published_release", "release", String(version), { url: blob.url });

    revalidatePath("/publication"); revalidatePath("/");
    return { ok: true, version };
  } catch (e) {
    return { ok: false, error: humanize(e) };
  }
}
