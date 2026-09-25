import { NextResponse } from "next/server";
import { unstable_cache as cache } from "next/cache";
import { prisma } from "@/lib/prisma";
import { PUBLIC_API_HEADERS } from "@/lib/landing-api";

// Pages légales de la landing (clés `site.legal`, `site.privacy`,
// `site.terms`, `site.cookies`), en Markdown. Publiques et lues par
// apps/web ; tant qu'une page n'est pas saisie ici, le site affiche son
// texte par défaut. Exclues du snapshot de l'app (lib/snapshot.ts).
const getLegal = cache(
  () =>
    prisma.legalContent.findMany({
      where: { key: { startsWith: "site." } },
      select: { key: true, locale: true, title: true, content: true, updatedAt: true },
    }),
  ["legal-content"],
  { tags: ["legal-content"], revalidate: 3600 },
);

export async function GET() {
  const rows = await getLegal();
  return NextResponse.json(
    { pages: rows.map((r) => ({ ...r, key: r.key.slice("site.".length) })) },
    { headers: PUBLIC_API_HEADERS },
  );
}
