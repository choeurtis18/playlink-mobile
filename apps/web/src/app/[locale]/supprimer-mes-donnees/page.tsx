import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { SimplePage } from "@/components/SimplePage";
import { CONTACT_EMAIL } from "@/components/Footer";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }): Promise<Metadata> {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "deleteData" });
  return {
    title: t("metaTitle"),
    alternates: { canonical: `/${locale}/supprimer-mes-donnees`, languages: { fr: "/fr/supprimer-mes-donnees", en: "/en/supprimer-mes-donnees" } },
  };
}

/** Droit à l'effacement (RGPD, art. 17). Demande par e-mail au
 * responsable de traitement, traitée depuis le back-office (écran
 * Pré-inscriptions) : pas de suppression en libre-service, qui
 * permettrait d'effacer l'inscription de quelqu'un d'autre sans preuve
 * que l'adresse lui appartient. */
export default async function DeleteDataPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("deleteData");
  const mailto = `mailto:${CONTACT_EMAIL}?subject=${encodeURIComponent(t("mailSubject"))}&body=${encodeURIComponent(t("mailBody"))}`;

  return (
    <SimplePage kicker={t("kicker")} title={t("title")} locale={locale} backLabel={t("back")}>
      <p>{t("intro")}</p>
      <p>{t("how")}</p>
      <p>
        <a
          href={mailto}
          className="inline-flex rounded-full px-6 py-3.5 text-base font-bold text-ground-deep no-underline hover:text-ground-deep"
          style={{ background: "var(--gradient-accent)" }}
        >
          {t("cta")}
        </a>
      </p>
      <p className="text-sm text-neutral-faint">{t("delay", { email: CONTACT_EMAIL })}</p>
    </SimplePage>
  );
}
