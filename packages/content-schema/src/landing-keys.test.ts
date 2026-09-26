import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  LANDING_FIELDS,
  LANDING_KEYS,
  LandingTextInputSchema,
  defaultLandingTexts,
  landingEnGaps,
  stripEmphasis,
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

test('landingEnGaps : FR personnalisé sans EN à jour', () => {
  const d = { fr: defaultLandingTexts('fr'), en: defaultLandingTexts('en') };
  assert.deepEqual(landingEnGaps([]), [], 'rien de personnalisé');
  assert.deepEqual(
    landingEnGaps([{ locale: 'fr', key: 'hero.title', value: d.fr['hero.title'] }]),
    [],
    'FR identique au défaut : pas un écart',
  );
  assert.deepEqual(
    landingEnGaps([{ locale: 'fr', key: 'hero.title', value: 'Playlink' }]),
    [{ key: 'hero.title', sectionId: 'hero' }],
    'FR modifié, EN absent',
  );
  assert.deepEqual(
    landingEnGaps([
      { locale: 'fr', key: 'hero.title', value: 'Playlink' },
      { locale: 'en', key: 'hero.title', value: `  ${d.en['hero.title']} ` },
    ]),
    [{ key: 'hero.title', sectionId: 'hero' }],
    'EN resté au texte par défaut',
  );
  assert.deepEqual(
    landingEnGaps([
      { locale: 'fr', key: 'hero.title', value: 'Playlink' },
      { locale: 'en', key: 'hero.title', value: 'Playlink' },
    ]),
    [],
    'EN renseigné',
  );
});

test('landingEnGaps avec dates : l\'EN est à jour s\'il a été enregistré après le FR', () => {
  const d = defaultLandingTexts('en');
  const fr = (at: string) => ({ locale: 'fr', key: 'hero.title', value: 'Playlink', updatedAt: at });
  const en = (value: string, at: string) => ({ locale: 'en', key: 'hero.title', value, updatedAt: at });
  const gap = [{ key: 'hero.title', sectionId: 'hero' }];
  assert.deepEqual(landingEnGaps([fr('2026-09-01T10:00:00Z')]), gap, 'EN jamais enregistré');
  assert.deepEqual(
    landingEnGaps([fr('2026-09-01T10:00:00Z'), en(d['hero.title'], '2026-09-02T10:00:00Z')]),
    [],
    'EN par défaut confirmé après le FR',
  );
  assert.deepEqual(
    landingEnGaps([fr('2026-09-03T10:00:00Z'), en('Playlink EN', '2026-09-02T10:00:00Z')]),
    gap,
    'FR modifié après l\'EN',
  );
  assert.deepEqual(
    landingEnGaps([fr('2026-09-03T10:00:00.900Z'), en('Playlink EN', '2026-09-03T10:00:00.100Z')]),
    [],
    'FR et EN publiés ensemble',
  );
  assert.deepEqual(landingEnGaps([fr('2026-09-01T10:00:00Z'), en('  ', '2026-09-02T10:00:00Z')]), gap, 'EN vide');
});

test('étoiles : gardées dans les titres, retirées ailleurs', () => {
  assert.equal(stripEmphasis('Les jeux qui ont *brisé* des amitiés'), 'Les jeux qui ont brisé des amitiés');
  assert.equal(stripEmphasis('Note * isolée'), 'Note * isolée');
  const t = resolveLandingTexts({ fr: { 'hero.title': 'Le *jeu*', 'hero.lede': 'Qui a *brisé* tout' } }, 'fr');
  assert.equal(t['hero.title'], 'Le *jeu*');
  assert.equal(t['hero.lede'], 'Qui a brisé tout');
});
