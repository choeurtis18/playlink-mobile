import { test } from "node:test";
import assert from "node:assert/strict";
import { csvCell, formulaSafe, parseCsv, toCsv } from "./csv.ts";

test("csvCell : guillemets, virgules, retours à la ligne", () => {
  assert.equal(csvCell("a"), "a");
  assert.equal(csvCell('dit "oui"'), '"dit ""oui"""');
  assert.equal(csvCell("a,b"), '"a,b"');
  assert.equal(csvCell(null), "");
});

test("formulaSafe : neutralise les débuts de formule", () => {
  for (const v of ["=1+1", "+33", "-2", "@SUM(A1)", "\tx", "\rx"]) assert.equal(formulaSafe(v), `'${v}`);
  assert.equal(formulaSafe("jean@exemple.fr"), "jean@exemple.fr");
  assert.equal(formulaSafe(42), 42);
});

test("toCsv : safe seulement sur demande, relu par parseCsv", () => {
  const rows = [{ email: '=HYPERLINK("http://x","clic")', n: 1 }];
  assert.equal(toCsv(rows, ["email", "n"]), 'email,n\n"=HYPERLINK(""http://x"",""clic"")",1\n');
  const safe = toCsv(rows, ["email", "n"], { safe: true });
  assert.deepEqual(parseCsv(safe), [{ email: `'=HYPERLINK("http://x","clic")`, n: "1" }]);
});
