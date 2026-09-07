// Miroir de `packages/content-schema/src/tag-mapping.test.ts` : mêmes cas,
// mêmes attendus. Une divergence ici = un archétype faux dans l'app.
import 'package:flutter_test/flutter_test.dart';
import 'package:playlink/core/tag_mapping.dart';

void main() {
  test('14 tags canoniques, chacun avec un archétype', () {
    expect(canonicalTags.length, 14);
    for (final t in canonicalTags) {
      expect(tagTypeMap[t], isNotNull, reason: 'archétype manquant : $t');
    }
  });

  test('un tag canonique se normalise en lui-même', () {
    for (final t in canonicalTags) {
      expect(normalizeTag(t), t);
    }
  });

  test('normalisation : casse et espaces ignorés', () {
    expect(normalizeTag('  Amitié '), 'amitié');
    expect(normalizeTag('HUMOUR'), 'humour');
  });

  test('normalisation : synonymes vers le tag canonique', () {
    expect(normalizeTag('ami'), 'amitié');
    expect(normalizeTag('rire'), 'humour');
    expect(normalizeTag('séduction'), 'flirt');
    expect(normalizeTag('politique'), 'société');
  });

  test('tag inconnu → null, et il est écarté de la liste', () {
    expect(normalizeTag('licorne'), isNull);
    expect(normalizeTags(['licorne', 'humour']), ['humour']);
  });

  test('normalizeTags dédoublonne les synonymes du même tag', () {
    expect(normalizeTags(['ami', 'groupe', 'amitié']), ['amitié']);
  });

  test('archétype = tag dominant', () {
    expect(getPlayerType({'humour': 3, 'vérité': 2, 'ambition': 1}), 'Le Clown de service');
    expect(getPlayerType({'stratégie': 8}), 'Le Stratège');
  });

  test('aucun point marqué → Le Mystérieux', () {
    expect(getPlayerType({}), 'Le Mystérieux');
    expect(getPlayerType({'humour': 0}), 'Le Mystérieux');
  });

  test("tag inconnu dominant → L'Inclassable", () {
    expect(getPlayerType({'licorne': 5}), "L'Inclassable");
  });

  test('égalité : le premier inséré gagne (tri stable du TS)', () {
    expect(getPlayerType({'flirt': 2, 'humour': 2}), 'Le Séducteur');
    expect(getPlayerType({'humour': 2, 'flirt': 2}), 'Le Clown de service');
  });
}
