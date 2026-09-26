import { prisma } from "@/lib/prisma";
import { requireEditor, logAction } from "@/lib/auth";
import { toCsv } from "@/lib/csv";
import { registrationWhere } from "@/lib/registrations";

const COLUMNS = ["email", "langue", "newsletter", "statut", "inscrit_le", "confirme_le"];

/** Export CSV des pré-inscriptions (filtres de l'écran). Données
 * personnelles : l'export est tracé dans le journal (nombre de lignes,
 * pas les adresses), et les cellules sont protégées contre l'injection
 * de formules — une adresse saisie sur la landing pourrait commencer par `=`. */
export async function GET(req: Request) {
  let editor;
  try {
    editor = await requireEditor();
  } catch {
    return new Response("Non authentifié", { status: 401 });
  }

  const sp = new URL(req.url).searchParams;
  const filters = { q: sp.get("q") ?? undefined, langue: sp.get("langue") ?? undefined, statut: sp.get("statut") ?? undefined };
  const rows = await prisma.landingPreRegistration.findMany({
    where: registrationWhere(filters),
    orderBy: [{ createdAt: "desc" }, { id: "asc" }],
    select: { email: true, locale: true, consentNewsletter: true, confirmedAt: true, createdAt: true },
  });
  await logAction(editor.id, "exported_preregistrations", "preregistration", "bulk", { count: rows.length });

  const csv = toCsv(
    rows.map((r) => ({
      email: r.email, langue: r.locale, newsletter: r.consentNewsletter ? "1" : "0",
      statut: r.confirmedAt ? "confirmee" : "attente",
      inscrit_le: r.createdAt.toISOString(), confirme_le: r.confirmedAt?.toISOString() ?? "",
    })),
    COLUMNS,
    { safe: true },
  );

  const day = new Date().toISOString().slice(0, 10);
  return new Response("﻿" + csv, {  // BOM : Excel lit l'UTF-8 correctement
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="playlink-preinscriptions-${day}.csv"`,
      "Cache-Control": "no-store",
    },
  });
}
