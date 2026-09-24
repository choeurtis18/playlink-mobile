import { test } from "node:test";
import assert from "node:assert/strict";
import { ranking, reduce, stageOf, startGame, type Action, type GameState } from "./game.ts";

const players = [
  { id: "a", name: "Alex", avatar: "🦊" },
  { id: "s", name: "Sam", avatar: "🐙" },
  { id: "l", name: "Léa", avatar: "🦄" },
];
const deck = [1, 2, 3, 4].map((n) => ({ id: `c${n}`, text: `Carte ${n}`, intensity: 2 }));
const run = (s: GameState, ...actions: Action[]) => actions.reduce(reduce, s);
const turn = (point: boolean): Action[] => [{ type: "reveal" }, { type: "openVote" }, { type: "vote", point }];

test("déroulé : tour (face cachée) → carte → vote → tour du joueur suivant", () => {
  let s = startGame(players, deck);
  assert.equal(stageOf(s), "turn");
  s = reduce(s, { type: "reveal" });
  assert.equal(stageOf(s), "card");
  assert.equal(s.index, 0, "voir la carte ne la consomme pas");
  s = reduce(s, { type: "openVote" });
  assert.equal(stageOf(s), "vote");
  s = reduce(s, { type: "vote", point: true });
  assert.equal(stageOf(s), "turn");
  assert.equal(s.index, 1);
  assert.equal(s.players[s.currentPlayer].name, "Sam");
  assert.equal(s.scores.a, 1);
});

test("les actions hors étape sont ignorées (pas de vote sans avoir vu la carte)", () => {
  const s = startGame(players, deck);
  assert.equal(reduce(s, { type: "vote", point: true }), s);
  assert.equal(reduce(s, { type: "openVote" }), s);
});

test("les joueurs tournent en boucle, la partie finit après la dernière carte", () => {
  const s = run(startGame(players, deck), ...turn(true), ...turn(false), ...turn(true), ...turn(true));
  assert.equal(stageOf(s), "results");
  assert.deepEqual(s.scores, { a: 2, s: 0, l: 1 }, "4e carte = retour à Alex");
});

test("classement et égalité", () => {
  const win = run(startGame(players, deck), ...turn(true), ...turn(false), ...turn(true), ...turn(true));
  const r = ranking(win);
  assert.deepEqual(r.ranked.map((p) => p.name), ["Alex", "Léa", "Sam"]);
  assert.equal(r.tie, false);
  const tie = run(startGame(players, deck.slice(0, 2)), ...turn(true), ...turn(true));
  assert.equal(ranking(tie).tie, true);
});

test("indices (Devine le mot) : décompte par carte, plancher à zéro, remis à chaque tour", () => {
  let s = run(startGame(players, deck, 3), { type: "reveal" }, { type: "useHint" }, { type: "useHint" });
  assert.equal(s.hintsLeft, 1);
  s = run(s, { type: "useHint" }, { type: "useHint" });
  assert.equal(s.hintsLeft, 0);
  s = run(s, { type: "openVote" }, { type: "vote", point: false });
  assert.equal(s.hintsLeft, 3);
});
