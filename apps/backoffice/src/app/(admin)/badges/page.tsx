import { prisma } from "@/lib/prisma";

export const dynamic = "force-dynamic";

// Rappel : le back-office ne gère QUE les métadonnées. La règle d'attribution
// est une fonction Dart identifiée par la clé du badge, évaluée sur l'appareil
// en fin de partie (§01, décision tranchée).
const RULES: Record<string, string> = {
  first_win: "1er point marqué, tous jeux confondus",
  party_legend: "20 points cumulés au total",
  centurion: "100 points cumulés au total",
  social_butterfly: "5 parties à 4 joueurs ou plus",
  truth_seeker: "10 cartes taguées vérité gagnées",
  three_peat: "3 parties gagnées d'affilée dans une session",
  explorer: "Au moins 1 partie dans chacun des 8 jeux",
  night_owl: "Une partie terminée entre 2 h et 5 h",
  polyglot: "Jouer en FR et en EN",
  author: "Créer 5 cartes personnalisées",
  curator: "Liker 20 cartes (compte requis)",
  marathon: "50 parties terminées",
};

export default async function Badges() {
  const badges = await prisma.badge.findMany({ orderBy: { order: "asc" } });
  const missing = Object.keys(RULES).filter((k) => !badges.some((b) => b.key === k));

  return (
    <>
      <h1 className="mb-2 text-2xl font-semibold">Badges</h1>
      <p className="mb-6 max-w-prose text-sm text-neutral-faint">
        Métadonnées uniquement. La règle d&apos;attribution vit dans le code de
        l&apos;app et s&apos;évalue localement en fin de partie.
      </p>

      <div className="grid gap-3 md:grid-cols-2">
        {badges.map((b) => (
          <div key={b.id} className="rounded-lg border border-hairline bg-surface p-4">
            <div className="flex items-start gap-3">
              <span className="text-2xl">{b.icon}</span>
              <div className="min-w-0">
                <div className="font-medium">{b.name}</div>
                <div className="text-sm text-ink-soft">{b.description}</div>
                <code className="mt-1 block text-xs text-neutral-faint">{b.key}</code>
                {RULES[b.key] && <div className="mt-2 text-xs text-neutral-faint">Règle : {RULES[b.key]}</div>}
              </div>
            </div>
          </div>
        ))}
      </div>

      {missing.length > 0 && (
        <div className="mt-6 rounded-lg border border-hairline bg-surface p-4">
          <div className="mb-2 text-sm font-medium">
            {missing.length} badges proposés au blueprint, absents de la base
          </div>
          <div className="flex flex-wrap gap-2">
            {missing.map((k) => (
              <span key={k} className="rounded border border-hairline bg-raised px-2 py-1 text-xs">
                <code>{k}</code> <span className="text-neutral-faint">— {RULES[k]}</span>
              </span>
            ))}
          </div>
        </div>
      )}
    </>
  );
}
