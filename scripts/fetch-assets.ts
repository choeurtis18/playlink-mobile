// Téléchargement des assets référencés par les slides de règles (§07).
//
// Les fichiers sont nommés par le HASH de leur contenu : deux slides
// partageant la même image ne la stockent qu'une fois, et un contenu modifié
// produit un nom différent — ce qui rend le cache OTA trivialement correct.
//
// Destination : apps/mobile/assets/content/ (embarqué dans le binaire).
//
//   node --experimental-strip-types fetch-assets.ts

import { createHash } from 'node:crypto';
import { mkdirSync, writeFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const BASE = process.env.LEGACY_ASSETS_BASE_URL;
const OUT = new URL('../apps/mobile/assets/content/', import.meta.url).pathname;

type Manifest = { ref: string; file: string; hash: string; bytes: number; type: string };

async function main() {
  if (!BASE) throw new Error('LEGACY_ASSETS_BASE_URL manquante');
  mkdirSync(OUT, { recursive: true });

  const slides = await prisma.gameRuleSlide.findMany({
    where: { imageRef: { not: null } },
    select: { id: true, imageRef: true },
  });
  console.log(`${slides.length} slides avec image\n`);

  // imageRef vaut `asset://{fichier}` — le nom d'origine dans le bucket.
  const byFile = new Map<string, string[]>();
  for (const s of slides) {
    const f = s.imageRef!.replace('asset://', '');
    byFile.set(f, [...(byFile.get(f) ?? []), s.id]);
  }
  console.log(`${byFile.size} fichiers distincts à télécharger\n`);

  const manifest: Manifest[] = [];
  const remap = new Map<string, string>(); // ancien nom → asset://{hash}.ext
  let downloaded = 0, skipped = 0, failed = 0;

  for (const [file, slideIds] of byFile) {
    const url = `${BASE}/rule-slides/${file}`;
    try {
      const res = await fetch(url);
      if (!res.ok) { console.log(`  ✗ ${file} — HTTP ${res.status}`); failed++; continue; }
      const buf = Buffer.from(await res.arrayBuffer());
      const hash = createHash('sha256').update(buf).digest('hex').slice(0, 16);
      const ext = (file.split('.').pop() ?? 'gif').toLowerCase();
      const name = `${hash}.${ext}`;
      const dest = join(OUT, name);

      if (existsSync(dest)) skipped++;
      else { writeFileSync(dest, buf); downloaded++; }

      manifest.push({ ref: `asset://${name}`, file: name, hash, bytes: buf.length, type: ext });
      remap.set(file, `asset://${name}`);
      process.stdout.write(`\r  ${downloaded + skipped}/${byFile.size} …`);
    } catch (e) {
      console.log(`\n  ✗ ${file} — ${(e as Error).message}`);
      failed++;
    }
  }
  console.log();

  // Réécrit les références vers le nom par hash, une fois le fichier obtenu.
  let updated = 0;
  for (const [oldFile, newRef] of remap) {
    const r = await prisma.gameRuleSlide.updateMany({
      where: { imageRef: `asset://${oldFile}` },
      data: { imageRef: newRef },
    });
    updated += r.count;
  }

  writeFileSync(join(OUT, 'assets-manifest.json'), JSON.stringify(manifest, null, 2) + '\n');

  const total = manifest.reduce((s, m) => s + m.bytes, 0);
  console.log(`\ntéléchargés   ${downloaded}`);
  console.log(`déjà présents ${skipped}`);
  console.log(`échecs        ${failed}`);
  console.log(`slides mises à jour ${updated}`);
  console.log(`poids total   ${(total / 1024 / 1024).toFixed(1)} Mo`);
  if (failed) process.exit(1);
}

main().catch((e) => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
