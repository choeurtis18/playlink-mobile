import { setRequestLocale, getTranslations } from "next-intl/server";

export default async function HomePage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations("hero");
  const tFooter = await getTranslations("footer");

  return (
    <main className="mx-auto flex min-h-screen max-w-3xl flex-col justify-center gap-6 px-6 py-24">
      <p className="font-mono text-xs uppercase tracking-[0.18em] text-accent">
        {t("eyebrow")}
      </p>
      <h1 className="text-balance font-[family-name:var(--font-display)] text-4xl font-semibold leading-tight tracking-tight sm:text-5xl">
        {t("title")}
      </h1>
      <p className="max-w-[60ch] text-lg text-ink-soft">{t("lede")}</p>
      {/* Formulaire désactivé tant que la capture d'email n'est pas tranchée
          (voir plan landing — point ouvert). Marqueur visuel volontaire. */}
      <p className="inline-flex w-fit items-center gap-2 rounded-full border border-hairline-firm px-4 py-2 font-mono text-xs text-neutral-faint">
        {t("cta")} — {t("eyebrow")}
      </p>

      <footer className="mt-16 flex gap-6 border-t border-hairline pt-6 font-mono text-xs text-neutral-faint">
        <a href={`/${locale}/mentions-legales`} className="hover:text-ink">
          {tFooter("legal")}
        </a>
        <a href={`/${locale}/confidentialite`} className="hover:text-ink">
          {tFooter("privacy")}
        </a>
        <a href={`/${locale}/cgu`} className="hover:text-ink">
          {tFooter("terms")}
        </a>
        <a href={`/${locale}/cookies`} className="hover:text-ink">
          {tFooter("cookies")}
        </a>
      </footer>
    </main>
  );
}
