import Link from "next/link";
import type { Icon } from "@phosphor-icons/react";
import {
  CheckCircleIcon, DownloadSimpleIcon, EnvelopeSimpleIcon, NewspaperIcon, UserMinusIcon, UsersIcon,
} from "@phosphor-icons/react/dist/ssr";
import { prisma } from "@/lib/prisma";
import { ButtonLink, EmptyState, PageHeader } from "@/components/ui";
import { relativeTime } from "@/lib/activity";
import { registrationWhere, type RegistrationFilters } from "@/lib/registrations";
import { RegistrationFiltersBar, RegistrationRow, TABLE_ID } from "./Registrations";

export const dynamic = "force-dynamic";
export const metadata = { title: "Pré-inscriptions" };

const PER_PAGE = 50;
const DAY = 24 * 60 * 60 * 1000;
const nf = new Intl.NumberFormat("fr-FR");
const pct = new Intl.NumberFormat("fr-FR", { style: "percent", maximumFractionDigits: 0 });
const fullDate = new Intl.DateTimeFormat("fr-FR", { timeZone: "Europe/Paris", dateStyle: "long", timeStyle: "short" });

export default async function Inscriptions({ searchParams }: { searchParams: Promise<RegistrationFilters & { page?: string }> }) {
  const sp = await searchParams;
  const page = Math.max(1, parseInt(sp.page ?? "1", 10) || 1);
  const where = registrationWhere(sp);
  const now = new Date();

  const [all, last24h, newsletter, confirmed, removed30d, total, rows] = await Promise.all([
    prisma.landingPreRegistration.count(),
    prisma.landingPreRegistration.count({ where: { createdAt: { gte: new Date(now.getTime() - DAY) } } }),
    prisma.landingPreRegistration.count({ where: { consentNewsletter: true } }),
    prisma.landingPreRegistration.count({ where: { confirmedAt: { not: null } } }),
    prisma.auditLog.count({ where: { action: { in: ["deleted_preregistration", "unsubscribed_preregistration"] }, createdAt: { gte: new Date(now.getTime() - 30 * DAY) } } }),
    prisma.landingPreRegistration.count({ where }),
    prisma.landingPreRegistration.findMany({
      where,
      // `id` en dernier : ordre stable entre deux pages à date égale.
      orderBy: [{ createdAt: "desc" }, { id: "asc" }],
      skip: (page - 1) * PER_PAGE,
      take: PER_PAGE,
      select: { id: true, email: true, locale: true, consentNewsletter: true, confirmedAt: true, createdAt: true },
    }),
  ]);

  const rate = (n: number) => (all ? pct.format(n / all) : "—");
  const kpis: { label: string; value: string; sub: string; icon: Icon }[] = [
    { label: "Pré-inscriptions", value: nf.format(all), sub: last24h ? `+${nf.format(last24h)} en 24 h` : "Aucune en 24 h", icon: UsersIcon },
    { label: "Consentement newsletter", value: rate(newsletter), sub: `${nf.format(newsletter)} adresse${newsletter > 1 ? "s" : ""}`, icon: NewspaperIcon },
    { label: "Adresse confirmée", value: rate(confirmed), sub: all - confirmed ? `${nf.format(all - confirmed)} en attente de clic` : "Aucune en attente", icon: CheckCircleIcon },
    { label: "Désinscriptions · 30 j", value: nf.format(removed30d), sub: "Lien de l’e-mail ou effacement ici", icon: UserMinusIcon },
  ];

  const pages = Math.max(1, Math.ceil(total / PER_PAGE));
  const qs = (over: Record<string, string | undefined>) => {
    const p = new URLSearchParams();
    for (const [k, v] of Object.entries({ ...sp, ...over })) if (v) p.set(k, v);
    return `?${p}`;
  };
  const filters = { q: sp.q, langue: sp.langue, statut: sp.statut };
  const filtered = total !== all;
  const exportQs = new URLSearchParams(Object.entries(filters).filter((e): e is [string, string] => !!e[1])).toString();

  return (
    <>
      <PageHeader
        title="Pré-inscriptions"
        description="Adresses laissées sur la landing pour être prévenu de la sortie. Données personnelles : exporte-les seulement quand c’est utile, et efface une adresse dès qu’on te le demande."
        actions={all > 0 && (
          <ButtonLink href={`/api/export/inscriptions${exportQs ? `?${exportQs}` : ""}`} icon={<DownloadSimpleIcon aria-hidden />}>
            Export CSV{filtered ? ` (${nf.format(total)})` : ""}
          </ButtonLink>
        )}
      />

      <ul className="m-0 mb-6 grid list-none grid-cols-[repeat(auto-fit,minmax(190px,1fr))] gap-3 p-0">
        {kpis.map((k) => (
          <li key={k.label} className="flex flex-col gap-1.5 rounded-[14px] border border-hairline bg-surface p-4">
            <span className="flex items-center gap-1.5 text-xs text-neutral-faint"><k.icon aria-hidden className="text-sm" />{k.label}</span>
            <span className="text-[26px] font-semibold tracking-[-0.02em]">{k.value}</span>
            <span className="text-xs text-neutral-faint">{k.sub}</span>
          </li>
        ))}
      </ul>

      {all === 0 ? (
        <EmptyState icon={<EnvelopeSimpleIcon />} title="Aucune pré-inscription pour l’instant">
          Les adresses laissées dans le formulaire de la landing apparaîtront ici.
        </EmptyState>
      ) : (
        <>
          <RegistrationFiltersBar sp={sp} />

          {/* `relative` : les textes masqués (sr-only, en absolu) restent dans la zone de défilement au lieu d’élargir la page. */}
          <div id={TABLE_ID} tabIndex={-1} className="relative overflow-x-auto rounded-[14px] border border-hairline bg-surface focus:outline-none">
            <table className="w-full border-collapse text-[13.5px] leading-[1.45]">
              <caption className="sr-only">Pré-inscriptions{filtered ? " filtrées" : ""}, page {page} sur {pages}</caption>
              <thead className="text-left font-mono text-[10.5px] uppercase tracking-[0.08em] text-neutral-faint">
                <tr>
                  <th className="px-3.5 py-3 font-medium">E-mail</th>
                  <th className="px-3.5 py-3 font-medium">Langue</th>
                  <th className="px-3.5 py-3 font-medium">Statut</th>
                  <th className="px-3.5 py-3 font-medium">Newsletter</th>
                  <th className="px-3.5 py-3 font-medium">Inscription</th>
                  <th className="relative px-3.5 py-3"><span className="sr-only">Actions</span></th>
                </tr>
              </thead>
              <tbody>
                {rows.map((r) => (
                  <RegistrationRow key={r.id} r={{
                    id: r.id, email: r.email, locale: r.locale, newsletter: r.consentNewsletter, confirmed: !!r.confirmedAt,
                    created: relativeTime(r.createdAt, now), createdFull: fullDate.format(r.createdAt),
                  }} />
                ))}
                {!rows.length && (
                  <tr><td colSpan={6} className="px-8 py-8 text-center text-neutral-faint">Aucune pré-inscription ne correspond aux filtres.</td></tr>
                )}
              </tbody>
            </table>
          </div>

          <div className="mt-3 flex flex-wrap items-center justify-between gap-3 text-xs text-neutral-faint">
            <p className="m-0" aria-live="polite">
              {filtered ? `${nf.format(total)} adresse${total > 1 ? "s" : ""} sur ${nf.format(all)}` : `${nf.format(total)} adresse${total > 1 ? "s" : ""}`}
              {pages > 1 && ` · page ${page} / ${pages}`}
            </p>
            {pages > 1 && (
              <nav aria-label="Pagination" className="flex gap-2">
                {page > 1 && <Link href={qs({ page: String(page - 1) })} className="rounded-lg border border-hairline px-3 py-1.5 text-ink-soft hover:text-ink">← Précédent</Link>}
                {page < pages && <Link href={qs({ page: String(page + 1) })} className="rounded-lg border border-hairline px-3 py-1.5 text-ink-soft hover:text-ink">Suivant →</Link>}
              </nav>
            )}
          </div>
        </>
      )}
    </>
  );
}
