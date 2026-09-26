/** Échappe une valeur CSV (RFC 4180) : guillemets doublés si nécessaire. */
export function csvCell(v: unknown): string {
  const s = v === null || v === undefined ? "" : String(v);
  return /[",\n\r]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}

/** Neutralise une valeur qu'un tableur prendrait pour une formule
 * (`=HYPERLINK(…)`, `+`, `-`, `@`, tabulation, retour chariot) : une
 * apostrophe devant la fait lire comme du texte (OWASP, « CSV injection »).
 * Pour les exports de données saisies par des inconnus (e-mails de la
 * landing) ; pas pour les exports réimportables (cartes), où l'apostrophe
 * s'ajouterait au texte. */
export function formulaSafe(v: unknown): unknown {
  return typeof v === "string" && /^[=+\-@\t\r]/.test(v) ? `'${v}` : v;
}

export function toCsv(rows: Record<string, unknown>[], columns: string[], { safe = false }: { safe?: boolean } = {}): string {
  const cell = (v: unknown) => csvCell(safe ? formulaSafe(v) : v);
  const head = columns.map(cell).join(",");
  const body = rows.map((r) => columns.map((c) => cell(r[c])).join(",")).join("\n");
  return `${head}\n${body}\n`;
}

/** Parse un CSV en respectant les guillemets et les retours à la ligne inclus. */
export function parseCsv(text: string): Record<string, string>[] {
  const rows: string[][] = [];
  let row: string[] = [], cur = "", inQuotes = false;

  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQuotes) {
      if (c === '"') {
        if (text[i + 1] === '"') { cur += '"'; i++; }
        else inQuotes = false;
      } else cur += c;
    } else if (c === '"') inQuotes = true;
    else if (c === ",") { row.push(cur); cur = ""; }
    else if (c === "\n") { row.push(cur); rows.push(row); row = []; cur = ""; }
    else if (c !== "\r") cur += c;
  }
  if (cur !== "" || row.length) { row.push(cur); rows.push(row); }

  const [header, ...body] = rows.filter((r) => r.some((c) => c !== ""));
  if (!header) return [];
  return body.map((r) => Object.fromEntries(header.map((h, i) => [h.trim(), r[i] ?? ""])));
}
