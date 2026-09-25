"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { OPEN_COOKIES_EVENT, readConsent, writeConsent } from "@/lib/consent";

const APPEAR_DELAY_MS = 1400;

/** Bandeau de consentement. Trois choix de même poids visuel accessible :
 * tout accepter, fonctionnels seulement (= refuser), ou régler. Aucun
 * cookie non essentiel n'est posé avant un choix, et fermer n'est pas
 * accepter : il n'y a pas de croix. Rouvrable depuis le pied de page. */
export function CookieBanner({ policyHref }: { policyHref: string }) {
  const t = useTranslations("cookies");
  const [mounted, setMounted] = useState(false);
  const [open, setOpen] = useState(false);
  const [prefs, setPrefs] = useState(false);
  const [analytics, setAnalytics] = useState(false);
  const firstButton = useRef<HTMLButtonElement>(null);
  const reopened = useRef(false);

  useEffect(() => {
    const consent = readConsent();
    let timer = 0;
    if (!consent) {
      setMounted(true);
      timer = window.setTimeout(() => setOpen(true), APPEAR_DELAY_MS);
    }
    const onOpen = () => {
      const current = readConsent();
      setAnalytics(current?.analytics ?? false);
      setPrefs(true);
      setMounted(true);
      reopened.current = true;
      requestAnimationFrame(() => setOpen(true));
    };
    window.addEventListener(OPEN_COOKIES_EVENT, onOpen);
    return () => {
      window.clearTimeout(timer);
      window.removeEventListener(OPEN_COOKIES_EVENT, onOpen);
    };
  }, []);

  // Rouvert volontairement : le focus va au bandeau. À l'apparition
  // automatique, on ne vole pas le focus de la page.
  useEffect(() => {
    if (open && reopened.current) firstButton.current?.focus();
  }, [open]);

  function decide(granted: boolean) {
    writeConsent(granted);
    setOpen(false);
    reopened.current = false;
  }

  if (!mounted) return null;

  return (
    <div
      role="dialog"
      aria-label={t("label")}
      aria-hidden={!open}
      inert={!open}
      className={`fixed bottom-4 left-4 z-[60] flex w-[min(420px,calc(100vw-32px))] flex-col gap-3.5 rounded-[20px] border border-hairline-firm bg-surface/95 p-[22px] shadow-[0_30px_60px_-20px_rgb(6_5_9/0.9)] backdrop-blur-[16px] transition-[transform,opacity] duration-[600ms,400ms] ease-[cubic-bezier(.2,.8,.2,1)] ${
        open ? "translate-y-0 opacity-100" : "pointer-events-none translate-y-[calc(100%+40px)] opacity-0"
      }`}
    >
      <p className="m-0 text-sm leading-[1.55] text-ink-soft">
        <strong className="text-ink">{t("title")}</strong> {t("body")}{" "}
        <a href={policyHref} className="text-accent-deep underline hover:text-ink">{t("policy")}</a>
      </p>

      {prefs && (
        <div className="flex flex-col gap-2.5 rounded-xl border border-hairline bg-sunk p-3.5">
          <div className="flex justify-between gap-3 text-sm">
            <span>
              {t("functional")} <span className="text-neutral-faint">{t("functionalHint")}</span>
            </span>
            <span className="font-mono text-[11px] uppercase text-neutral-faint">{t("always")}</span>
          </div>
          <div className="flex items-center justify-between gap-3 text-sm">
            <span id="pl-analytics-label">
              {t("analytics")} <span className="text-neutral-faint">{t("analyticsHint")}</span>
            </span>
            <button
              type="button"
              role="switch"
              aria-checked={analytics}
              aria-labelledby="pl-analytics-label"
              onClick={() => setAnalytics((a) => !a)}
              className="relative h-6 w-10 shrink-0 rounded-xl border border-hairline-firm p-0 transition-colors duration-[250ms]"
              style={{ background: analytics ? "var(--color-accent)" : "var(--color-raised)" }}
            >
              <span
                className="absolute left-0.5 top-0.5 h-[18px] w-[18px] rounded-full bg-ink transition-transform duration-[250ms]"
                style={{ transform: analytics ? "translateX(16px)" : "none" }}
              />
            </button>
          </div>
        </div>
      )}

      <div className="flex flex-wrap gap-2">
        <button
          ref={firstButton}
          type="button"
          onClick={() => decide(true)}
          className="rounded-full px-4 py-2.5 text-sm font-bold text-ground-deep"
          style={{ background: "var(--gradient-accent)" }}
        >
          {t("acceptAll")}
        </button>
        <button
          type="button"
          onClick={() => decide(prefs ? analytics : false)}
          className="rounded-full border border-hairline-firm px-4 py-2.5 text-sm font-semibold text-ink transition-colors hover:border-neutral"
        >
          {prefs ? t("save") : t("functionalOnly")}
        </button>
        <button
          type="button"
          aria-expanded={prefs}
          onClick={() => setPrefs((p) => !p)}
          className="px-1.5 py-2.5 text-sm font-semibold text-ink-soft underline hover:text-ink"
        >
          {prefs ? t("hidePrefs") : t("managePrefs")}
        </button>
      </div>
    </div>
  );
}
