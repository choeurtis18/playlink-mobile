import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';

// Vue localisée du contenu. FR est le texte principal ; une autre langue
// se lit dans `translationsJson` et retombe sur FR si absente (CLAUDE.md).

Map<String, dynamic> _decode(String? json) =>
    json == null ? const {} : (jsonDecode(json) as Map<String, dynamic>);

/// Traduction d'un champ d'objet : `{en: {name: …}}`.
String _field(String? json, String locale, String key, String fallback) {
  if (locale == 'fr') return fallback;
  final t = _decode(json)[locale];
  if (t is Map && t[key] is String && (t[key] as String).isNotEmpty) return t[key] as String;
  return fallback;
}

String? _fieldOpt(String? json, String locale, String key, String? fallback) {
  if (locale == 'fr') return fallback;
  final t = _decode(json)[locale];
  if (t is Map && t[key] is String) return t[key] as String;
  return fallback;
}

/// Traduction d'une carte : `{en: "texte"}`.
String _cardText(String? json, String locale, String fallback) {
  if (locale == 'fr') return fallback;
  final t = _decode(json)[locale];
  return (t is String && t.isNotEmpty) ? t : fallback;
}

class GameVm {
  const GameVm({
    required this.id, required this.slug, required this.name, required this.description,
    required this.icon, required this.colorMain, required this.colorSecondary,
    required this.sortOrder, required this.categoryCount, required this.cardCount,
  });
  final String id, slug, name;
  final String? description, icon;
  final String colorMain, colorSecondary;
  final int sortOrder, categoryCount, cardCount;

  /// Pour Devine le mot et Thé ou café, le curseur règle la difficulté,
  /// pas le degré de gêne (slides de règles).
  bool get intensityIsDifficulty => slug == 'devine-mot' || slug == 'the-cafe';

  /// Devine le mot : trois indices maximum par carte (slides de règles).
  int? get hintsPerCard => slug == 'devine-mot' ? 3 : null;
}

class CategoryVm {
  const CategoryVm({
    required this.id, required this.gameId, required this.slug, required this.name,
    required this.description, required this.icon, required this.sortOrder,
    required this.tier, required this.cardCount,
  });
  final String id, gameId, slug, name, tier;
  final String? description, icon;
  final int sortOrder, cardCount;
}

class CardVm {
  const CardVm({
    required this.id, required this.categoryId, required this.text,
    required this.intensity, required this.tags, required this.canonicalTags,
  });
  final String id, categoryId, text;
  final int intensity;
  final List<String> tags, canonicalTags;
}

class SlideVm {
  const SlideVm({required this.id, required this.sortOrder, required this.title,
      required this.content, required this.imageAsset});
  final String id, title, content;
  final int sortOrder;
  /// Chemin d'asset Flutter, résolu depuis `asset://{file}` — ou null.
  final String? imageAsset;
}

class ContentRepository {
  ContentRepository(this.db);
  final AppDatabase db;

  Future<int> installedVersion() async =>
      (await db.select(db.contentMeta).getSingleOrNull())?.version ?? 0;

  /// Nombre de cartes actives par catégorie, en une requête.
  Future<Map<String, int>> _cardCounts() async {
    final catId = db.cards.categoryId;
    final n = db.cards.id.count();
    final q = db.selectOnly(db.cards)..addColumns([catId, n])..groupBy([catId]);
    final rows = await q.get();
    return {for (final r in rows) r.read(catId)!: r.read(n)!};
  }

  Future<List<GameVm>> games(String locale) async {
    final counts = await _cardCounts();
    final cats = await db.select(db.categories).get();
    final byGame = <String, List<Category>>{};
    for (final c in cats) {
      byGame.putIfAbsent(c.gameId, () => []).add(c);
    }
    final rows = await (db.select(db.games)
          ..orderBy([(g) => OrderingTerm.asc(g.sortOrder)]))
        .get();
    return [
      for (final g in rows)
        GameVm(
          id: g.id, slug: g.slug,
          name: _field(g.translationsJson, locale, 'name', g.name),
          description: _fieldOpt(g.translationsJson, locale, 'description', g.description),
          icon: g.icon, colorMain: g.colorMain, colorSecondary: g.colorSecondary,
          sortOrder: g.sortOrder,
          categoryCount: byGame[g.id]?.length ?? 0,
          cardCount: (byGame[g.id] ?? const []).fold(0, (s, c) => s + (counts[c.id] ?? 0)),
        ),
    ];
  }

  Future<GameVm?> gameBySlug(String slug, String locale) async {
    final all = await games(locale);
    for (final g in all) {
      if (g.slug == slug) return g;
    }
    return null;
  }

  Future<List<CategoryVm>> categories(String gameId, String locale) async {
    final counts = await _cardCounts();
    final rows = await (db.select(db.categories)
          ..where((c) => c.gameId.equals(gameId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
    return [
      for (final c in rows)
        CategoryVm(
          id: c.id, gameId: c.gameId, slug: c.slug,
          name: _field(c.translationsJson, locale, 'name', c.name),
          description: _fieldOpt(c.translationsJson, locale, 'description', c.description),
          icon: c.icon, sortOrder: c.sortOrder, tier: c.tier,
          cardCount: counts[c.id] ?? 0,
        ),
    ];
  }

  Future<List<CardVm>> cards(String categoryId, String locale) async {
    final rows = await (db.select(db.cards)
          ..where((c) => c.categoryId.equals(categoryId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
    return [
      for (final c in rows)
        CardVm(
          id: c.id, categoryId: c.categoryId,
          text: _cardText(c.translationsJson, locale, c.text_),
          intensity: c.intensity,
          tags: (jsonDecode(c.tagsJson) as List).cast<String>(),
          canonicalTags: (jsonDecode(c.canonicalTagsJson) as List).cast<String>(),
        ),
    ];
  }

  Future<List<SlideVm>> slides(String gameId, String locale) async {
    final rows = await (db.select(db.ruleSlides)
          ..where((s) => s.gameId.equals(gameId))
          ..orderBy([(s) => OrderingTerm.asc(s.sortOrder)]))
        .get();
    return [
      for (final s in rows)
        SlideVm(
          id: s.id, sortOrder: s.sortOrder,
          title: _field(s.translationsJson, locale, 'title', s.title),
          content: _field(s.translationsJson, locale, 'content', s.content),
          imageAsset: s.imageRef == null
              ? null
              : 'assets/content/${s.imageRef!.replaceFirst('asset://', '')}',
        ),
    ];
  }
}
