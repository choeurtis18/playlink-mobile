import { test } from "node:test";
import assert from "node:assert/strict";
import { breakdown, buildMetrics, classifySource, metricPart } from "./landing-stats-core.ts";

const OWN = "playlink-game.fr";

test("classifySource : types de source", () => {
  assert.equal(classifySource("$direct", OWN), "direct");
  assert.equal(classifySource("", OWN), "direct");
  assert.equal(classifySource(null, OWN), "direct");
  assert.equal(classifySource("www.google.com", OWN), "organic");
  assert.equal(classifySource("google.fr", OWN), "organic");
  assert.equal(classifySource("duckduckgo.com", OWN), "organic");
  assert.equal(classifySource("l.instagram.com", OWN), "social");
  assert.equal(classifySource("t.co", OWN), "social");
  assert.equal(classifySource("www.reddit.com", OWN), "social");
  assert.equal(classifySource("mail.google.com", OWN), "email");
  assert.equal(classifySource("outlook.live.com", OWN), "email");
  assert.equal(classifySource("producthunt.com", OWN), "referral");
});

test("classifySource : navigation interne ignorée", () => {
  assert.equal(classifySource("playlink-game.fr", OWN), null);
  assert.equal(classifySource("www.playlink-game.fr", OWN), null);
  assert.equal(classifySource("localhost", OWN), null);
});

test("metricPart : clés sûres", () => {
  assert.equal(metricPart("Action-Verite"), "action-verite");
  assert.equal(metricPart("a b/c"), "a-b-c");
  assert.equal(metricPart(""), null);
  assert.equal(metricPart(null), null);
});

test("buildMetrics : jours, familles, valeurs", () => {
  const m = buildMetrics({
    totals: [["2026-09-20", "$pageview", 10, 7], ["2026-09-20", "demo_started", 3, 3], ["2026-09-20", "autre", 5, 5]],
    games: [["2026-09-20", "demo_started", "icebreaker", 2], ["2026-09-20", "demo_completed", "icebreaker", 1]],
    categories: [["2026-09-20", "icebreaker", "deep-talk", 2]],
    pageviews: [
      ["2026-09-20", "$direct", "FR", "fr", 6],
      ["2026-09-20", "www.google.com", "BE", "fr", 3],
      ["2026-09-20", "playlink-game.fr", "FR", "en", 1],
    ],
  }, OWN);
  const d = m.get("2026-09-20")!;
  assert.equal(d.get("landing.views"), 10);
  assert.equal(d.get("landing.visitors"), 7);
  assert.equal(d.get("landing.demo_started"), 3);
  assert.equal(d.has("landing.autre"), false);
  assert.equal(d.get("landing.game_started.icebreaker"), 2);
  assert.equal(d.get("landing.game_completed.icebreaker"), 1);
  assert.equal(d.get("landing.category.icebreaker/deep-talk"), 2);
  assert.equal(d.get("landing.source.direct"), 6);
  assert.equal(d.get("landing.source.organic"), 3);
  assert.equal(d.get("landing.referrer.google.com"), 3);
  assert.equal(d.has("landing.referrer.playlink-game.fr"), false, "interne : ni source ni site d'origine");
  assert.equal(d.get("landing.country.FR"), 7);
  assert.equal(d.get("landing.locale.en"), 1);
});

test("breakdown : somme par clé, tri décroissant", () => {
  const rows = [
    { metric: "landing.source.direct", value: 2 },
    { metric: "landing.source.social", value: 5 },
    { metric: "landing.source.direct", value: 4 },
    { metric: "landing.views", value: 100 },
  ];
  assert.deepEqual(breakdown(rows, "source"), [{ key: "direct", value: 6 }, { key: "social", value: 5 }]);
});
