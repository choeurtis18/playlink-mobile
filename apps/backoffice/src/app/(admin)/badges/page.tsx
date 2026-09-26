import { CheckCircleIcon, ClockIcon, WarningIcon } from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { PageHeader } from "@/components/ui";
import { BADGE_RULES, badgeRule } from "@/lib/badge-rules";
import { CreatePlannedBadge, DeleteBadgeButton, EditBadgeButton, NewBadgeButton } from "./BadgeEditor";

export const dynamic = "force-dynamic";
export const metadata = { title: "Badges" };

export default async function Badges() {
  const badges = await prisma.badge.findMany({ orderBy: [{ order: "asc" }, { id: "asc" }] });
  const missing = BADGE_RULES.filter((r) => !badges.some((b) => b.key === r.key));
  const known = BADGE_RULES.map((r) => r.key);

  return (
    <>
      <PageHeader
        title={<>Badges <span className="font-sans text-lg font-medium tracking-normal text-neutral-faint">{badges.length}</span></>}
        description="Métadonnées uniquement. La règle d’attribution vit dans le code de l’app et s’évalue localement en fin de partie — la clé fait le lien."
        actions={<NewBadgeButton known={known} />}
      />

      <ul className="m-0 grid list-none grid-cols-[repeat(auto-fill,minmax(min(100%,320px),1fr))] gap-3 p-0">
        {badges.map((b) => {
          const rule = badgeRule(b.key);
          return (
            <li key={b.id} className="flex items-start gap-3.5 rounded-[14px] border border-hairline bg-surface p-4 transition-[border-color,transform] duration-200 hover:-translate-y-0.5 hover:border-hairline-firm">
              <span aria-hidden className="flex h-12 w-12 flex-none items-center justify-center rounded-xl bg-raised text-2xl">{b.icon}</span>
              <div className="flex min-w-0 flex-1 flex-col gap-[3px]">
                <h2 className="m-0 text-[15px] font-semibold">{b.name}</h2>
                <p className="m-0 text-[13px] leading-[1.45] text-ink-soft">{b.description}</p>
                <code className="font-mono text-[11px] text-neutral-faint">{b.key}</code>
                <p className={`m-0 mt-1.5 flex items-start gap-1.5 text-xs ${!rule ? "text-warning" : rule.live ? "text-neutral-faint" : "text-blue"}`}>
                  {!rule ? <WarningIcon aria-hidden className="mt-px shrink-0" /> : rule.live ? <CheckCircleIcon aria-hidden className="mt-px shrink-0" /> : <ClockIcon aria-hidden className="mt-px shrink-0" />}
                  <span>{!rule ? "Aucune règle dans l’app pour cette clé : ce badge ne se débloque jamais." : `Règle : ${rule.rule}`}</span>
                </p>
              </div>
              <div className="flex flex-none flex-col items-center gap-1">
                <EditBadgeButton badge={b} known={known} />
                <DeleteBadgeButton id={b.id} name={b.name} />
              </div>
            </li>
          );
        })}
      </ul>

      {missing.length > 0 && (
        <section aria-labelledby="missing-badges" className="mt-5 flex flex-col gap-3 rounded-[14px] border border-dashed border-hairline-firm p-4">
          <h2 id="missing-badges" className="m-0 text-sm font-semibold">
            {missing.length} badge{missing.length > 1 ? "s" : ""} prévu{missing.length > 1 ? "s" : ""} dans l’app, absent{missing.length > 1 ? "s" : ""} de la base
          </h2>
          <ul className="m-0 flex list-none flex-wrap gap-2 p-0">
            {missing.map((r) => (
              <li key={r.key} className="inline-flex items-center gap-2 rounded-lg border border-hairline bg-surface px-2.5 py-1.5 text-xs">
                <span aria-hidden>{r.defaults.icon}</span>
                <code className="font-mono text-accent-deep">{r.key}</code>
                <span className="text-ink-soft">{r.rule}</span>
                <CreatePlannedBadge badgeKey={r.key} name={r.defaults.name} />
              </li>
            ))}
          </ul>
        </section>
      )}
    </>
  );
}
