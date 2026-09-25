import { getTranslations } from "next-intl/server";

/** Adresse de contact et de responsable de traitement (RGPD), en attendant
 * une adresse sur le domaine. Également citée dans les pages légales. */
export const CONTACT_EMAIL = "gamesplaylink@gmail.com";

export async function Footer({ locale }: { locale: string }) {
  const t = await getTranslations("footer");
  const links = [
    { href: `/${locale}/mentions-legales`, label: t("legal") },
    { href: `/${locale}/confidentialite`, label: t("privacy") },
    { href: `/${locale}/cgu`, label: t("terms") },
    { href: `/${locale}/cookies`, label: t("cookies") },
    { href: `/${locale}/supprimer-mes-donnees`, label: t("deleteData") },
  ];

  return (
    <footer className="overflow-clip border-t border-hairline bg-ground-deep px-6 pt-12">
      <div className="mx-auto flex max-w-[1200px] flex-col gap-8">
        <div className="flex flex-wrap items-start justify-between gap-6">
          <div className="flex flex-col gap-2 text-sm text-neutral-faint">
            <span className="font-semibold text-ink">© {new Date().getFullYear()} Playlink</span>
            <span>
              {t("controller")}{" "}
              <a href={`mailto:${CONTACT_EMAIL}`} className="text-ink-soft underline hover:text-ink">
                {CONTACT_EMAIL}
              </a>
            </span>
          </div>
          <nav aria-label={t("nav")} className="flex flex-wrap gap-[22px] font-mono text-xs tracking-[0.04em]">
            {links.map((l) => (
              <a key={l.href} href={l.href} className="text-neutral-faint transition-colors hover:text-ink">
                {l.label}
              </a>
            ))}
          </nav>
        </div>
        {/* Filigrane : le mot-marque en très grand, qui s'efface vers le bas. */}
        <div
          aria-hidden
          className="-mb-[0.12em] select-none font-display text-[clamp(90px,21vw,300px)] font-semibold leading-[0.8] tracking-[-0.05em] text-transparent"
          style={{ background: "linear-gradient(180deg, #2a2733 0%, #060509 92%)", WebkitBackgroundClip: "text", backgroundClip: "text" }}
        >
          Playlink
        </div>
      </div>
    </footer>
  );
}
