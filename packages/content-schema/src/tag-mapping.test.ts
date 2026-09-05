import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  CANONICAL_TAGS, normalizeTag, normalizeTags, getPlayerType, TAG_TYPE_MAP,
} from './tag-mapping.ts';

test('14 tags canoniques, chacun avec un archétype', () => {
  assert.equal(CANONICAL_TAGS.length, 14);
  for (const t of CANONICAL_TAGS) assert.ok(TAG_TYPE_MAP[t], `archétype manquant : ${t}`);
});

test('un tag canonique se normalise en lui-même', () => {
  for (const t of CANONICAL_TAGS) assert.equal(normalizeTag(t), t);
});

test('normalisation : casse et espaces ignorés', () => {
  assert.equal(normalizeTag('  Amitié '), 'amitié');
  assert.equal(normalizeTag('HUMOUR'), 'humour');
});

test('normalisation : synonymes vers le tag canonique', () => {
  assert.equal(normalizeTag('ami'), 'amitié');
  assert.equal(normalizeTag('rire'), 'humour');
  assert.equal(normalizeTag('séduction'), 'flirt');
  assert.equal(normalizeTag('politique'), 'société');
});

test('tag inconnu → null, et il est écarté de la liste', () => {
  assert.equal(normalizeTag('licorne'), null);
  assert.deepEqual(normalizeTags(['licorne', 'humour']), ['humour']);
});

test('normalizeTags dédoublonne les synonymes du même tag', () => {
  // 'ami' et 'groupe' mènent tous deux à 'amitié' : une seule entrée.
  assert.deepEqual(normalizeTags(['ami', 'groupe', 'amitié']), ['amitié']);
});

test('archétype = tag dominant', () => {
  assert.equal(getPlayerType({ humour: 3, vérité: 2, ambition: 1 }), 'Le Clown de service');
  assert.equal(getPlayerType({ stratégie: 8 }), 'Le Stratège');
});

test('aucun point marqué → Le Mystérieux', () => {
  assert.equal(getPlayerType({}), 'Le Mystérieux');
  assert.equal(getPlayerType({ humour: 0 }), 'Le Mystérieux');
});

test('tag inconnu dominant → L\'Inclassable', () => {
  assert.equal(getPlayerType({ licorne: 5 }), "L'Inclassable");
});
