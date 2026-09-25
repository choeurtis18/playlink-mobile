import type { Metadata } from "next";
import type { ReactNode } from "react";
import { NextIntlClientProvider } from "next-intl";
import { getMessages, getTranslations, setRequestLocale } from "next-intl/server";
import { Fraunces, Inter_Tight, JetBrains_Mono } from "next/font/google";
import { getSiteConfig, landingTexts, landingSections } from "@/lib/backoffice";
import { SITE_URL } from "@/lib/site-url";
import { Header } from "@/components/Header";
import { Footer } from "@/components/Footer";
import { RevealRoot } from "@/components/RevealRoot";
import { CookieBanner } from "@/components/CookieBanner";
import { AnalyticsProvider } from "@/components/AnalyticsProvider";

// Auto-hébergées par next/font : aucune requête vers Google au chargement,
// et des polices de repli ajustées pour éviter le saut de mise en page.
const fraunces = Fraunces({
  subsets: ["latin"],
  axes: ["opsz"],
  style: ["normal", "italic"],
  variable: "--font-fraunces",
  display: "swap",
});
const interTight = Inter_Tight({ subsets: ["latin"], variable: "--font-inter-tight", display: "swap" });
// Mono : petites étiquettes seulement. Pas de préchargement, pour laisser
// la bande passante du premier affichage au titre (Fraunces) et au texte.
const jetbrainsMono = JetBrains_Mono({ subsets: ["latin"], variable: "--font-jetbrains-mono", display: "swap", preload: false });
import { notFound } from "next/navigation";
import type { Locale } from "@/i18n/routing";
import { routing } from "@/i18n/routing";

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ locale: string }>;
}): Promise<Metadata> {
  const { locale } = await params;
  const texts = landingTexts(await getSiteConfig(), locale);
  const title = texts["meta.title"];
  const description = texts["meta.description"];

  return {
    // Rend absolues toutes les URL relatives ci-dessous (canonical, image
    // de partage) : les réseaux sociaux ignorent une image en chemin relatif.
    metadataBase: new URL(SITE_URL),
    title,
    description,
    applicationName: "Playlink",
    alternates: {
      canonical: `/${locale}`,
      languages: { fr: "/fr", en: "/en", "x-default": "/fr" },
    },
    openGraph: {
      title,
      description,
      url: `/${locale}`,
      siteName: "Playlink",
      locale: locale === "en" ? "en_US" : "fr_FR",
      alternateLocale: locale === "en" ? "fr_FR" : "en_US",
      type: "website",
    },
    twitter: {
      card: "summary_large_image",
      title,
      description,
    },
  };
}

export default async function LocaleLayout({
  children,
  params,
}: {
  children: ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  if (!routing.locales.includes(locale as Locale)) {
    notFound();
  }
  setRequestLocale(locale);
  // next-intl 3.x n'hérite pas les messages automatiquement : sans cette
  // prop, tout `useTranslations` dans un Client Component lève MISSING_MESSAGE.
  const [messages, site, tNav] = await Promise.all([getMessages(), getSiteConfig(), getTranslations("nav")]);

  return (
    <html lang={locale} className={`${fraunces.variable} ${interTight.variable} ${jetbrainsMono.variable}`}>
      <body className="bg-ground text-ink font-sans antialiased">
        <NextIntlClientProvider messages={messages}>
          {/* Premier élément atteint au clavier : saute l'en-tête. Invisible
              tant qu'il n'a pas le focus. */}
          <a
            href="#top"
            className="fixed left-4 top-3 z-[80] -translate-y-24 rounded-full bg-ink px-4 py-2.5 text-sm font-semibold text-ground transition-transform focus:translate-y-0 focus:text-ground"
          >
            {tNav("skip")}
          </a>
          <Header locale={locale} sections={landingSections(site)} />
          {/* Réserve la hauteur du header fixe. */}
          <div aria-hidden className="h-[72px]" />
          <main id="top" tabIndex={-1} className="outline-none">{children}</main>
          <Footer locale={locale} />
          <RevealRoot locale={locale} />
          <CookieBanner policyHref={`/${locale}/cookies`} />
          <AnalyticsProvider locale={locale} />
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
