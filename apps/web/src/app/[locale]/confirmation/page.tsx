import type { Metadata } from "next";
import { getTranslations, setRequestLocale } from "next-intl/server";
import { postBackoffice } from "@/lib/backoffice";
import { SimplePage } from "@/components/SimplePage";

// Page de destination du lien de l'e-mail de confirmation (double opt-in).
// Jamais indexée, jamais mise en cache : chaque jeton ne sert qu'une fois.
export const dynamic = "force-dynamic";
export const metadata: Metadata = { robots: { index: false, follow: false } };

export default async function ConfirmationPage({
  params,
  searchParams,
}: {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ token?: string }>;
}) {
  const [{ locale }, { token }] = await Promise.all([params, searchParams]);
  setRequestLocale(locale);
  const t = await getTranslations("confirmation");

  const res = token ? await postBackoffice<{ ok: boolean }>("/api/landing/pre-register/confirm", { token }) : null;
  const ok = Boolean(res?.ok);

  return (
    <SimplePage kicker={t("kicker")} title={ok ? t("okTitle") : t("koTitle")} locale={locale} backLabel={t("back")}>
      <p>{ok ? t("okBody") : t("koBody")}</p>
    </SimplePage>
  );
}
