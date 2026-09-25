"use client";

import { useEffect } from "react";
import { usePathname } from "@/i18n/navigation";
import { capture, setAnalyticsConsent } from "@/lib/analytics";
import { CONSENT_CHANGED_EVENT, readConsent, type Consent } from "@/lib/consent";
import { OPEN_DEMO_EVENT, type OpenDemoDetail } from "@/lib/demo-events";

/** Relie le consentement à PostHog et envoie les événements qui ne
 * viennent pas d'un composant précis : pages vues, ouverture de la démo,
 * et clics marqués dans le HTML serveur :
 *   <a data-analytics="social_link_clicked" data-analytics-platform="tiktok">
 * Sans consentement, `capture` ne fait rien. */
export function AnalyticsProvider({ locale }: { locale: string }) {
  const pathname = usePathname();

  useEffect(() => {
    setAnalyticsConsent(readConsent()?.analytics ?? false);
    const onConsent = (e: Event) => {
      const granted = (e as CustomEvent<Consent>).detail.analytics;
      // Accord donné sur cette page : la page vue compte aussi.
      setAnalyticsConsent(granted).then(() => granted && capture("$pageview", { locale }));
    };
    window.addEventListener(CONSENT_CHANGED_EVENT, onConsent);
    return () => window.removeEventListener(CONSENT_CHANGED_EVENT, onConsent);
  }, [locale]);

  useEffect(() => {
    capture("$pageview", { locale });
  }, [pathname, locale]);

  useEffect(() => {
    const onOpenDemo = (e: Event) => capture("demo_opened", { gameSlug: (e as CustomEvent<OpenDemoDetail>).detail.gameSlug });
    const onClick = (e: MouseEvent) => {
      const el = (e.target as HTMLElement | null)?.closest<HTMLElement>("[data-analytics]");
      if (!el) return;
      const event = el.dataset.analytics;
      if (event === "social_link_clicked") capture(event, { platform: el.dataset.analyticsPlatform ?? "" });
      else if (event === "cta_clicked") capture(event, { cta: el.dataset.analyticsCta ?? "" });
    };
    window.addEventListener(OPEN_DEMO_EVENT, onOpenDemo);
    document.addEventListener("click", onClick);
    return () => {
      window.removeEventListener(OPEN_DEMO_EVENT, onOpenDemo);
      document.removeEventListener("click", onClick);
    };
  }, []);

  return null;
}
