import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, existsSync } from 'node:fs';
import { SnapshotSchema, AssetRefSchema, CardSchema } from './snapshot.ts';

test('une référence d\'asset doit être asset://{hash}.{ext}', () => {
  assert.ok(AssetRefSchema.safeParse('asset://4961952c65edd64d.gif').success);
  // Une URL réseau est refusée : l'app doit fonctionner hors-ligne.
  assert.ok(!AssetRefSchema.safeParse('https://cdn.example.com/a.gif').success);
  assert.ok(!AssetRefSchema.safeParse('asset://sans-extension').success);
});

test('l\'intensité est bornée à 1-5', () => {
  const base = { id: 'x', text: 't', tags: [], canonicalTags: [], order: 0, tier: 'free' as const };
  assert.ok(CardSchema.safeParse({ ...base, intensity: 3 }).success);
  assert.ok(!CardSchema.safeParse({ ...base, intensity: 0 }).success);
  assert.ok(!CardSchema.safeParse({ ...base, intensity: 6 }).success);
});

test('une carte sans texte est refusée', () => {
  const r = CardSchema.safeParse({
    id: 'x', text: '', intensity: 3, tags: [], canonicalTags: [], order: 0, tier: 'free',
  });
  assert.ok(!r.success);
});

// Ce test vaut garde-fou de non-régression : si build-snapshot.ts produit
// un jour un format invalide, il échoue ici plutôt qu'en production.
const SNAP = new URL('../../../apps/mobile/assets/content/content_v1.json', import.meta.url).pathname;
test('le snapshot v1 généré est valide', { skip: !existsSync(SNAP) }, () => {
  const parsed = SnapshotSchema.safeParse(JSON.parse(readFileSync(SNAP, 'utf8')));
  assert.ok(parsed.success, JSON.stringify(parsed.error?.issues.slice(0, 3), null, 2));

  const s = parsed.data!;
  assert.equal(s.originalLocale, 'fr');

  // Toute référence d'image doit exister dans le bloc assets, sinon l'app
  // afficherait une slide cassée hors-ligne.
  const declared = new Set(s.assets.map((a) => a.ref));
  for (const g of s.games)
    for (const sl of g.ruleSlides)
      if (sl.imageRef) assert.ok(declared.has(sl.imageRef), `asset manquant : ${sl.imageRef}`);
});
