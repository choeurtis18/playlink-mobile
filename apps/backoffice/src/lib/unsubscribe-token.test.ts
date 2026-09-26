import { test } from "node:test";
import assert from "node:assert/strict";
import { checkUnsubscribeToken, unsubscribeToken } from "./unsubscribe-token.ts";

const S = "secret-de-test";

test("jeton : stable, propre à l'inscription et au secret", () => {
  const t = unsubscribeToken("reg1", S);
  assert.equal(t.length, 32);
  assert.match(t, /^[A-Za-z0-9_-]+$/);
  assert.equal(unsubscribeToken("reg1", S), t);
  assert.notEqual(unsubscribeToken("reg2", S), t);
  assert.notEqual(unsubscribeToken("reg1", "autre"), t);
});

test("vérification : bon jeton seulement", () => {
  const t = unsubscribeToken("reg1", S);
  assert.equal(checkUnsubscribeToken("reg1", t, S), true);
  assert.equal(checkUnsubscribeToken("reg2", t, S), false);
  assert.equal(checkUnsubscribeToken("reg1", t.slice(0, -1) + (t.endsWith("A") ? "B" : "A"), S), false);
  assert.equal(checkUnsubscribeToken("reg1", "court", S), false);
  assert.equal(checkUnsubscribeToken("reg1", t, ""), false);
});
