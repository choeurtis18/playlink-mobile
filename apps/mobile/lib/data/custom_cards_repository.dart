import 'package:drift/drift.dart';

import '../core/deck.dart';
import 'database.dart';
import 'providers.dart' show newId;

/// Une carte personnalisée (C1–C3), rattachée à l'appareil en V1 sans
/// compte (voir `CustomCards` en base). Pas de tags : les cartes perso ne
/// contribuent ni à l'archétype ni à `truth_seeker`.
class CustomCardVm {
  const CustomCardVm({
    required this.id,
    required this.gameId,
    required this.categoryId,
    required this.text,
    required this.intensity,
    required this.active,
    required this.createdAt,
  });
  final String id, gameId, categoryId, text;
  final int intensity;
  final bool active;
  final DateTime createdAt;
}

class CustomCardsRepository {
  CustomCardsRepository(this.db);
  final AppDatabase db;

  /// Toutes les cartes créées sur l'appareil, plus récentes d'abord — pour
  /// l'écran « Mes cartes ».
  Future<List<CustomCardVm>> all() async {
    final rows = await (db.select(db.customCards)
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .get();
    return rows.map(_toVm).toList();
  }

  /// Cartes actives d'UNE catégorie — pour rejoindre le pool officiel avant
  /// tirage (C2).
  Future<List<CustomCardVm>> activeFor(String categoryId) async {
    final rows = await (db.select(db.customCards)
          ..where((c) => c.categoryId.equals(categoryId) & c.active.equals(true)))
        .get();
    return rows.map(_toVm).toList();
  }

  Future<int> countAll() => db.customCards.count().getSingle();

  CustomCardVm _toVm(CustomCard c) => CustomCardVm(
        id: c.id,
        gameId: c.gameId,
        categoryId: c.categoryId,
        text: c.text_,
        intensity: c.intensity,
        active: c.active,
        createdAt: c.createdAt,
      );

  Future<void> create({
    required String gameId,
    required String categoryId,
    required String text,
    int intensity = intensityDefault,
  }) async {
    final now = DateTime.now();
    await db.into(db.customCards).insert(
          CustomCardsCompanion.insert(
            id: newId(),
            gameId: gameId,
            categoryId: categoryId,
            text_: text,
            intensity: Value(intensity),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> updateText(String id, String text) async {
    await (db.update(db.customCards)..where((c) => c.id.equals(id))).write(
      CustomCardsCompanion(text_: Value(text), updatedAt: Value(DateTime.now())),
    );
  }

  /// Désactive/réactive sans supprimer (C3) — sort du pool de tirage sans
  /// perdre la carte.
  Future<void> setActive(String id, bool active) async {
    await (db.update(db.customCards)..where((c) => c.id.equals(id))).write(
      CustomCardsCompanion(active: Value(active), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> delete(String id) async {
    await (db.delete(db.customCards)..where((c) => c.id.equals(id))).go();
  }
}
