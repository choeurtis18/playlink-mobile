import Link from "next/link";
import { DownloadSimpleIcon } from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { ButtonLink, PageHeader } from "@/components/ui";
import type { ContentKind } from "@/lib/validation";
import { CardsTab } from "./CardsTab";
import { ContentTab } from "./ContentTab";
import { missingByKind } from "@/lib/content-translations";

export const dynamic = "force-dynamic";

const TABS: { type: string; label: string; kind: ContentKind | null }[] = [
  { type: "cartes", label: "Cartes", kind: null },
  { type: "jeux", label: "Jeux", kind: "game" },
  { type: "categories", label: "Catégories", kind: "category" },
  { type: "regles", label: "Règles", kind: "slide" },
  { type: "badges", label: "Badges", kind: "badge" },
];

export default async function Traductions({
  searchParams,
}: {
  searchParams: Promise<{ type?: string; jeu?: string; categorie?: string; q?: string; page?: string; tout?: string }>;
}) {
  const sp = await searchParams;
  const tab = TABS.find((t) => t.type === sp.type) ?? TABS[0];

  // Reste à faire par onglet (petits volumes, hors cartes).
  const [cardsMissing, byKind] = await Promise.all([
    prisma.card.count({ where: { translations: { none: { locale: "en" } } } }),
    missingByKind(),
  ]);
  const missing = TABS.map((t) => (t.kind ? byKind[t.kind] : cardsMissing));

  return (
    <>
      <PageHeader
        title="Traductions"
        description="Un élément non traduit est servi en français dans l’app en anglais — d’où un mélange de langues."
        actions={<ButtonLink href="/api/export/cards" icon={<DownloadSimpleIcon aria-hidden />}>Export CSV des cartes</ButtonLink>}
      />

      <nav aria-label="Type de contenu" className="relative mb-5 flex gap-1 overflow-x-auto border-b border-hairline [scrollbar-width:none]">
        {TABS.map((t, i) => {
          const on = t === tab;
          return (
            <Link
              key={t.type}
              href={t.type === "cartes" ? "/traductions" : `/traductions?type=${t.type}`}
              aria-current={on ? "page" : undefined}
              className={`-mb-px flex shrink-0 items-center gap-2 border-b-2 px-3 py-2.5 text-sm font-medium transition-colors ${on ? "border-accent text-ink" : "border-transparent text-ink-soft hover:text-ink"}`}
            >
              {t.label}
              <span className={`rounded-full px-1.5 py-0.5 font-mono text-[10px] font-semibold ${missing[i] ? "bg-warning/15 text-warning" : "bg-success/15 text-success"}`}>
                {missing[i] ? missing[i] : "✓"}
                <span className="sr-only">{missing[i] ? " à traduire" : " tout est traduit"}</span>
              </span>
            </Link>
          );
        })}
      </nav>

      {tab.kind ? <ContentTab kind={tab.kind} sp={sp} /> : <CardsTab sp={sp} />}
    </>
  );
}
