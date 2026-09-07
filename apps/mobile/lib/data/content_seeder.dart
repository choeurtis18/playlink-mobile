import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import 'database.dart';

/// Le snapshot embarqué dans le binaire (§06) : `content_v{n}.json` de
/// version la plus haute présente dans `assets/content/`.
class EmbeddedSnapshot {
  const EmbeddedSnapshot({required this.version, required this.assetPath});
  final int version;
  final String assetPath;
}

Future<EmbeddedSnapshot?> findEmbeddedSnapshot() async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final re = RegExp(r'assets/content/content_v(\d+)\.json$');
  EmbeddedSnapshot? best;
  for (final path in manifest.listAssets()) {
    final m = re.firstMatch(path);
    if (m == null) continue;
    final v = int.parse(m.group(1)!);
    if (best == null || v > best.version) {
      best = EmbeddedSnapshot(version: v, assetPath: path);
    }
  }
  return best;
}

/// Seed au premier lancement, ou si le binaire embarque une version plus
/// récente que celle installée. Renvoie true si un seed a eu lieu.
Future<bool> seedIfNeeded(AppDatabase db) async {
  final embedded = await findEmbeddedSnapshot();
  if (embedded == null) {
    throw StateError('Aucun snapshot de contenu embarqué dans le binaire');
  }
  final meta = await db.select(db.contentMeta).getSingleOrNull();
  if (meta != null && meta.version >= embedded.version) return false;

  final raw = await rootBundle.loadString(embedded.assetPath);
  await applySnapshot(db, jsonDecode(raw) as Map<String, dynamic>);
  return true;
}

String? _tr(Object? translations) =>
    translations == null ? null : jsonEncode(translations);

/// Remplace le contenu d'un bloc, dans une transaction : l'app ne voit
/// jamais un état intermédiaire. Servira aussi au swap OTA (A3).
Future<void> applySnapshot(AppDatabase db, Map<String, dynamic> snap) async {
  final version = snap['version'] as int;
  final games = (snap['games'] as List).cast<Map<String, dynamic>>();
  final badges = (snap['badges'] as List? ?? const []).cast<Map<String, dynamic>>();
  final assets = (snap['assets'] as List? ?? const []).cast<Map<String, dynamic>>();

  await db.transaction(() async {
    // Ordre inverse des clés étrangères.
    await db.delete(db.cards).go();
    await db.delete(db.ruleSlides).go();
    await db.delete(db.categories).go();
    await db.delete(db.games).go();
    await db.delete(db.badges).go();
    await db.delete(db.contentAssets).go();

    await db.batch((b) {
      for (final g in games) {
        b.insert(
          db.games,
          GamesCompanion.insert(
            id: g['id'] as String,
            slug: g['slug'] as String,
            name: g['name'] as String,
            description: Value(g['description'] as String?),
            icon: Value(g['icon'] as String?),
            colorMain: g['colorMain'] as String,
            colorSecondary: g['colorSecondary'] as String,
            sortOrder: g['order'] as int,
            translationsJson: Value(_tr(g['translations'])),
          ),
        );
        for (final s in (g['ruleSlides'] as List? ?? const []).cast<Map<String, dynamic>>()) {
          b.insert(
            db.ruleSlides,
            RuleSlidesCompanion.insert(
              id: s['id'] as String,
              gameId: g['id'] as String,
              sortOrder: s['order'] as int,
              title: s['title'] as String,
              content: s['content'] as String,
              imageRef: Value(s['imageRef'] as String?),
              translationsJson: Value(_tr(s['translations'])),
            ),
          );
        }
        for (final c in (g['categories'] as List).cast<Map<String, dynamic>>()) {
          b.insert(
            db.categories,
            CategoriesCompanion.insert(
              id: c['id'] as String,
              gameId: g['id'] as String,
              slug: c['slug'] as String,
              name: c['name'] as String,
              description: Value(c['description'] as String?),
              icon: Value(c['icon'] as String?),
              sortOrder: c['order'] as int,
              tier: Value(c['tier'] as String? ?? 'free'),
              translationsJson: Value(_tr(c['translations'])),
            ),
          );
          for (final cd in (c['cards'] as List).cast<Map<String, dynamic>>()) {
            b.insert(
              db.cards,
              CardsCompanion.insert(
                id: cd['id'] as String,
                categoryId: c['id'] as String,
                text_: cd['text'] as String,
                intensity: cd['intensity'] as int,
                tagsJson: jsonEncode(cd['tags'] ?? const []),
                canonicalTagsJson: jsonEncode(cd['canonicalTags'] ?? const []),
                sortOrder: cd['order'] as int? ?? 0,
                tier: Value(cd['tier'] as String? ?? 'free'),
                translationsJson: Value(_tr(cd['translations'])),
              ),
            );
          }
        }
      }
      for (final bd in badges) {
        b.insert(
          db.badges,
          BadgesCompanion.insert(
            key: bd['key'] as String,
            name: bd['name'] as String,
            description: bd['description'] as String,
            icon: bd['icon'] as String,
            sortOrder: bd['order'] as int? ?? 0,
            translationsJson: Value(_tr(bd['translations'])),
          ),
        );
      }
      for (final a in assets) {
        b.insert(
          db.contentAssets,
          ContentAssetsCompanion.insert(
            ref: a['ref'] as String,
            file: a['file'] as String,
            hash: a['hash'] as String,
            bytes: a['bytes'] as int,
            type: a['type'] as String,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });

    await db.into(db.contentMeta).insertOnConflictUpdate(
          ContentMetaCompanion(
            id: const Value(1),
            version: Value(version),
            installedAt: Value(DateTime.now()),
          ),
        );
  });
}
