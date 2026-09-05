import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

// L'app interroge cet endpoint au lancement (§06, workflow A2/A3).
// Si `version` dépasse celle installée, elle télécharge `snapshotUrl` en
// tâche de fond et bascule le contenu au redémarrage suivant.
//
// Le contenu ne change qu'environ une fois par mois : un cache court côté
// CDN suffit largement et évite de réveiller la base à chaque lancement.
export const revalidate = 300;

export async function GET() {
  const release = await prisma.contentRelease.findFirst({
    // Exclut une release en cours de publication (URL pas encore écrite) :
    // l'app tenterait sinon de télécharger une chaîne vide.
    where: { snapshotUrl: { not: "" } },
    orderBy: { version: "desc" },
    select: { version: true, snapshotUrl: true, changelog: true, publishedAt: true },
  });

  // Aucune release publiée : l'app garde son snapshot embarqué. Ce n'est pas
  // une erreur — répondre 404 ferait échouer le check côté app.
  if (!release) {
    return NextResponse.json({ version: 0, snapshotUrl: null, changelog: null });
  }

  return NextResponse.json(release, {
    headers: { "Cache-Control": "public, s-maxage=300, stale-while-revalidate=3600" },
  });
}
