import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  LANDING_FIELDS,
  LANDING_KEYS,
  LandingTextInputSchema,
  defaultLandingTexts,
  resolveLandingTexts,
} from './landing-keys.ts';

test('les clés sont uniques', () => {
  assert.equal(new Set(LANDING_KEYS).size, LANDING_KEYS.length);
});

test('chaque texte par défaut tient dans sa limite, en FR comme en EN', () => {
  for (const f of LANDING_FIELDS) {
    assert.ok(f.fr.length <= f.max, `${f.key} (fr) dépasse ${f.max}`);
    assert.ok(f.en.length <= f.max, `${f.key} (en) dépasse ${f.max}`);
    assert.ok(f.fr && f.en, `${f.key} sans texte par défaut`);
  }
});

test('repli : langue demandée, puis FR, puis texte par défaut', () => {
  const texts = resolveLandingTexts(
    { fr: { 'hero.title': 'Titre FR', 'games.title': 'Jeux FR' }, en: { 'hero.title': 'EN title', 'games.title': '  ' } },
    'en',
  );
  assert.equal(texts['hero.title'], 'EN title');
  assert.equal(texts['games.title'], 'Jeux FR', 'un EN vide retombe sur le FR');
  assert.equal(texts['demo.title'], defaultLandingTexts('en')['demo.title']);
});

test('validation : clé inconnue, texte trop long, FR vide', () => {
  assert.equal(LandingTextInputSchema.safeParse({ locale: 'fr', key: 'hero.nope', value: 'x' }).success, false);
  assert.equal(LandingTextInputSchema.safeParse({ locale: 'fr', key: 'notif.button', value: 'x'.repeat(25) }).success, false);
  assert.equal(LandingTextInputSchema.safeParse({ locale: 'fr', key: 'hero.title', value: '   ' }).success, false);
  assert.equal(LandingTextInputSchema.safeParse({ locale: 'en', key: 'hero.title', value: '' }).success, true);
});
