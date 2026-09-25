"use client";

import { useEffect } from "react";
import { usePathname } from "@/i18n/navigation";

const EASE = "cubic-bezier(.2,.8,.2,1)";

/** Apparitions au scroll, pour toute la page, avec un seul observer.
 *
 * Marquage côté serveur, sans composant client par élément :
 *   <p data-reveal data-delay="80">…</p>   → glisse et apparaît
 *   <span data-count="1500" data-suffix="+">1 500+</span> → compte de 0
 *
 * Le HTML serveur reste lisible tel quel : un élément n'est masqué qu'ici,
 * après hydratation, et seulement s'il est SOUS le bord de l'écran. Ce qui
 * est déjà visible au chargement ne clignote donc jamais (le héros anime
 * son entrée en CSS). Sans JavaScript, ou en mouvement réduit, tout
 * s'affiche directement. */
export function RevealRoot({ locale }: { locale: string }) {
  const pathname = usePathname();

  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    if (!("IntersectionObserver" in window)) return;

    const els = Array.from(document.querySelectorAll<HTMLElement>("[data-reveal], [data-count]"))
      .filter((el) => el.getBoundingClientRect().top > window.innerHeight);
    const format = new Intl.NumberFormat(locale === "en" ? "en-US" : "fr-FR");

    for (const el of els) {
      if (el.hasAttribute("data-reveal")) el.style.opacity = "0";
      if (el.dataset.count) el.textContent = `0${el.dataset.suffix ?? ""}`;
    }

    const io = new IntersectionObserver(
      (entries) => {
        for (const en of entries) {
          if (!en.isIntersecting) continue;
          const el = en.target as HTMLElement;
          io.unobserve(el);
          if (el.hasAttribute("data-reveal")) {
            el.style.opacity = "";
            el.animate(
              [{ opacity: 0, transform: "translateY(26px)" }, { opacity: 1, transform: "none" }],
              { duration: 800, delay: Number(el.dataset.delay ?? 0), easing: EASE, fill: "backwards" },
            );
          }
          if (el.dataset.count) countUp(el, Number(el.dataset.count), el.dataset.suffix ?? "", format);
        }
      },
      { threshold: 0.15, rootMargin: "0px 0px -40px 0px" },
    );
    els.forEach((el) => io.observe(el));

    return () => {
      io.disconnect();
      // Changement de langue ou de page : ne jamais laisser un élément
      // masqué par un observer qui n'existe plus.
      els.forEach((el) => (el.style.opacity = ""));
    };
  }, [pathname, locale]);

  return null;
}

function countUp(el: HTMLElement, to: number, suffix: string, format: Intl.NumberFormat) {
  const start = performance.now();
  const duration = 1400;
  const step = (now: number) => {
    const p = Math.min(1, (now - start) / duration);
    const eased = 1 - Math.pow(1 - p, 4);
    el.textContent = format.format(Math.round(to * eased)) + suffix;
    if (p < 1) requestAnimationFrame(step);
  };
  requestAnimationFrame(step);
}
