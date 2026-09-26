import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { SimplePage } from "@/components/SimplePage";
import { unsubscribe } from "./actions";

// Page du lien « Te désinscrire » de l'e-mail de bienvenue. La
// désinscription demande un clic : une simple visite ne suffit pas, sinon
// les antivirus de messagerie, qui ouvrent les liens pour les analyser,
// désinscriraient les gens à leur insu.
export const dynamic = "force-dynamic";
export const metadata: Metadata = { robots: { index: false, follow: false } };

export default async function UnsubscribePage({
  params,
  searchParams,
}: {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ id?: string; t?: string; etat?: string }>;
}) {
  const [{ locale }, { id, t: token, etat }] = await Promise.all([params, searchParams]);
  setRequestLocale(locale);
  const t = await getTranslations("unsubscribe");
  const help = (
    <p className="text-sm text-neutral-faint">
      {t("help")} <a href={`/${locale}/supprimer-mes-donnees`} className="underline hover:text-ink">{t("helpLink")}</a>
    </p>
  );

  if (etat === "ok") {
    return (
      <SimplePage kicker={t("kicker")} title={t("okTitle")} locale={locale} backLabel={t("back")}>
        <p role="status">{t("okBody")}</p>
      </SimplePage>
    );
  }
  if (etat === "ko" || !id || !token) {
    return (
      <SimplePage kicker={t("kicker")} title={t("koTitle")} locale={locale} backLabel={t("back")}>
        <p>{t("koBody")}</p>
        {help}
      </SimplePage>
    );
  }
  return (
    <SimplePage kicker={t("kicker")} title={t("title")} locale={locale} backLabel={t("stay")}>
      <p>{t("body")}</p>
      <form action={unsubscribe}>
        <input type="hidden" name="locale" value={locale} />
        <input type="hidden" name="id" value={id} />
        <input type="hidden" name="t" value={token} />
        <button
          type="submit"
          className="inline-flex cursor-pointer rounded-full border-0 px-6 py-3.5 text-base font-bold text-ground-deep"
          style={{ background: "var(--gradient-accent)" }}
        >
          {t("cta")}
        </button>
      </form>
    </SimplePage>
  );
}
