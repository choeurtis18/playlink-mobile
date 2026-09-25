import { prisma } from "@/lib/prisma";
import { SiteContentForm } from "./SiteContentForm";
import { PreviewEligibleList } from "./PreviewEligibleList";

export const dynamic = "force-dynamic";

export default async function Site() {
  const [siteContent, games] = await Promise.all([
    prisma.siteContent.findUnique({
      where: { id: "default" },
      include: { translations: true },
    }),
    prisma.game.findMany({
      orderBy: { order: "asc" },
      include: { categories: { orderBy: { order: "asc" } } },
    }),
  ]);

  return (
    <div className="flex flex-col gap-8">
      <div>
        <h1 className="font-display text-[32px] font-semibold tracking-[-0.025em]">Site (landing page)</h1>
        <p className="mt-1 text-sm text-neutral-faint">
          Contenu de la landing publique (apps/web). La structure de la page reste fixe — seul ce
          contenu est modifiable.
        </p>
      </div>

      <SiteContentForm siteContent={siteContent} games={games} />

      <div>
        <h2 className="mb-3 text-lg font-semibold">Échantillon jouable</h2>
        <p className="mb-4 text-sm text-neutral-faint">
          Catégories dont les cartes actives sont exposées par <code>GET /api/preview-content</code>{" "}
          pour la démo jouable du site. Choisis un échantillon représentatif — les cartes d&apos;intensité
          élevée restent visibles au public si leur catégorie est cochée.
        </p>
        <PreviewEligibleList games={games} />
      </div>
    </div>
  );
}
