// Publie une version de contenu (§06) : upload du snapshot sur Vercel Blob
// puis enregistrement de la ContentRelease. Tant qu'une release n'est pas
// publiée, l'édition au back-office reste invisible des apps.
//
//   node --experimental-strip-types publish-release.ts [--version N] [--changelog "…"] [--local]

import { readFileSync, existsSync } from 'node:fs';
import { PrismaClient } from '@prisma/client';
import { SnapshotSchema } from '@playlink/content-schema/snapshot.ts';

const prisma = new PrismaClient();
const args = process.argv.slice(2);
const argOf = (n: string) => { const i = args.indexOf(n); return i < 0 ? null : args[i + 1]; };
const LOCAL = args.includes('--local');

async function main() {
  const version = parseInt(argOf('--version') ?? '1', 10);
  const path = new URL(`../apps/mobile/assets/content/content_v${version}.json`, import.meta.url).pathname;
  if (!existsSync(path)) throw new Error(`snapshot introuvable : ${path}`);

  const raw = readFileSync(path, 'utf8');
  // Revalider avant publication : une fois en ligne, toutes les apps le lisent.
  const parsed = SnapshotSchema.safeParse(JSON.parse(raw));
  if (!parsed.success) throw new Error('snapshot invalide, publication refusée');
  if (parsed.data.version !== version) throw new Error(`version incohérente : fichier v${parsed.data.version}`);

  let url: string;
  if (LOCAL) {
    // Mode hors-ligne : le snapshot embarqué dans le binaire suffit pour la
    // v1, l'upload Blob n'est nécessaire que pour les mises à jour OTA.
    url = `local://content_v${version}.json`;
    console.log('— mode local, pas d\'upload Blob —');
  } else {
    const token = process.env.BLOB_READ_WRITE_TOKEN;
    if (!token) throw new Error('BLOB_READ_WRITE_TOKEN manquant (ou utilise --local)');
    const { put } = await import('@vercel/blob');
    const blob = await put(`content/content_v${version}.json`, raw, {
      access: 'public', token, contentType: 'application/json',
      addRandomSuffix: false, allowOverwrite: false,
    });
    url = blob.url;
    console.log(`uploadé → ${url}`);
  }

  const release = await prisma.contentRelease.upsert({
    where: { version },
    create: { version, snapshotUrl: url, changelog: argOf('--changelog') ?? `Version ${version}` },
    update: { snapshotUrl: url, changelog: argOf('--changelog') ?? undefined },
  });

  console.log(`\nrelease v${release.version} publiée le ${release.publishedAt.toISOString()}`);
  console.log(`url : ${release.snapshotUrl}`);
}

main().catch((e) => { console.error('✗', e.message); process.exit(1); }).finally(() => prisma.$disconnect());
