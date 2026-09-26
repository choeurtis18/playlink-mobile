import { test } from "node:test";
import assert from "node:assert/strict";
import { adminNotifyEmail, adminSignupEmail, confirmationEmail, esc, welcomeEmail } from "./email.ts";

test("esc : caractères HTML", () => {
  assert.equal(esc(`<a href="x">'&'</a>`), "&lt;a href=&quot;x&quot;&gt;&#39;&amp;&#39;&lt;/a&gt;");
});

test("welcomeEmail : langue, liens démo et désinscription, réseaux", () => {
  const fr = welcomeEmail("a@b.fr", "fr", { instagramUrl: "https://instagram.com/playlink" });
  assert.match(fr.subject, /prévenu·e/);
  assert.match(fr.html, /lang="fr"/);
  assert.match(fr.html, /\/fr#demo/);
  assert.match(fr.html, /\/fr\/supprimer-mes-donnees/);
  assert.match(fr.html, /Instagram/);
  assert.doesNotMatch(fr.html, /TikTok/);
  assert.match(fr.text, /Te désinscrire : https:\/\/.+\/fr\/supprimer-mes-donnees/);
  const en = welcomeEmail("a@b.fr", "en");
  assert.match(en.html, /lang="en"/);
  assert.match(en.html, /\/en#demo/);
  assert.doesNotMatch(en.html, /Follow Playlink/);
  assert.equal(welcomeEmail("a@b.fr", "de").html.includes('lang="fr"'), true);
});

test("adminSignupEmail : adresse échappée, répondre à l'inscrit", () => {
  const evil = `"<script>"@x.fr`;
  const m = adminSignupEmail("admin@x.fr", { email: evil, locale: "en", total: 1234, last24h: 3, doubleOptIn: true });
  assert.equal(m.to, "admin@x.fr");
  assert.equal(m.replyTo, evil);
  assert.doesNotMatch(m.html, /<script>/);
  assert.match(m.html, /1 234 au total|1 234 au total/);
  assert.match(m.html, /Anglais \(EN\)/);
  assert.match(m.html, /\/inscriptions/);
});

test("confirmationEmail : lien de confirmation", () => {
  const m = confirmationEmail("a@b.fr", "fr", "https://playlink-game.fr/fr/confirmation?token=abc&x=1");
  assert.match(m.html, /token=abc&amp;x=1/);
  assert.match(m.text, /token=abc&x=1/);
});

test("adminNotifyEmail : défaut, off", () => {
  const prev = process.env.ADMIN_NOTIFY_EMAIL;
  delete process.env.ADMIN_NOTIFY_EMAIL;
  assert.equal(adminNotifyEmail(), "gamesplaylink@gmail.com");
  process.env.ADMIN_NOTIFY_EMAIL = "off";
  assert.equal(adminNotifyEmail(), null);
  process.env.ADMIN_NOTIFY_EMAIL = " moi@x.fr ";
  assert.equal(adminNotifyEmail(), "moi@x.fr");
  if (prev === undefined) delete process.env.ADMIN_NOTIFY_EMAIL; else process.env.ADMIN_NOTIFY_EMAIL = prev;
});
