// Parseur du format texte de `pg_dump --data-only` : des blocs
//   COPY public.table (col, "col2", …) FROM stdin;
//   <lignes TSV>
//   \.
// Le TSV de Postgres échappe \t \n \r \\ et code NULL par \N.

export type Row = Record<string, string | null>;

/** Décode les séquences d'échappement TSV de Postgres. */
function unescape(v: string): string {
  let out = '';
  for (let i = 0; i < v.length; i++) {
    if (v[i] !== '\\') { out += v[i]; continue; }
    const n = v[++i];
    out += n === 't' ? '\t' : n === 'n' ? '\n' : n === 'r' ? '\r'
         : n === '\\' ? '\\' : n === 'b' ? '\b' : n === 'f' ? '\f' : n;
  }
  return out;
}

/**
 * Décode un littéral tableau Postgres : `{a,b}`, `{"a,b",c}`, `{}`.
 * Les éléments contenant virgule, accolade ou guillemet sont entre guillemets.
 */
export function parsePgArray(raw: string | null): string[] {
  if (raw === null || raw === '' || raw === '{}') return [];
  const body = raw.replace(/^\{/, '').replace(/\}$/, '');
  const out: string[] = [];
  let cur = '', inQuotes = false;
  for (let i = 0; i < body.length; i++) {
    const c = body[i];
    if (inQuotes) {
      if (c === '\\') { cur += body[++i]; }
      else if (c === '"') { inQuotes = false; }
      else cur += c;
    } else if (c === '"') inQuotes = true;
    else if (c === ',') { out.push(cur); cur = ''; }
    else cur += c;
  }
  if (cur !== '' || body.endsWith(',')) out.push(cur);
  return out;
}

/** Extrait toutes les tables d'un dump, indexées par nom sans le schéma. */
export function parseDump(sql: string): Map<string, Row[]> {
  const tables = new Map<string, Row[]>();
  const lines = sql.split('\n');
  let table: string | null = null;
  let cols: string[] = [];
  let rows: Row[] = [];

  for (const line of lines) {
    if (table === null) {
      const m = line.match(/^COPY (?:public\.)?"?(\w+)"? \(([^)]+)\) FROM stdin;$/);
      if (m) {
        table = m[1];
        cols = m[2].split(',').map((c) => c.trim().replace(/^"|"$/g, ''));
        rows = [];
      }
      continue;
    }
    if (line === '\\.') {
      tables.set(table, rows);
      table = null;
      continue;
    }
    const values = line.split('\t');
    const row: Row = {};
    cols.forEach((c, i) => {
      const v = values[i];
      row[c] = v === '\\N' || v === undefined ? null : unescape(v);
    });
    rows.push(row);
  }
  return tables;
}

export const bool = (v: string | null) => v === 't';
export const int = (v: string | null) => (v === null ? 0 : parseInt(v, 10));
export const date = (v: string | null) => (v === null ? new Date() : new Date(v + 'Z'));
