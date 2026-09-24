"use client";

import { useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { Link, usePathname } from "@/i18n/navigation";
import { routing } from "@/i18n/routing";
import type { LandingSectionId } from "@/lib/backoffice";
import { LogoMark } from "./Logo";

const NAV = [
  { id: "jeux", key: "games" },
  { id: "demo", key: "demo" },
  { id: "apropos", key: "about" },
  { id: "reseaux", key: "social" },
] as const;

/** En-tête fixe de la landing : logo, navigation par ancres, choix de la
 * langue, CTA pré-inscription, barre de progression du scroll. Sous 900 px,
 * la navigation passe dans un menu plein écran (burger). */
export function Header({ locale, sections }: { locale: string; sections: LandingSectionId[] }) {
  const links = NAV.filter((n) => sections.includes(n.id));
  // Sans section de pré-inscription, le CTA n'aurait nulle part où mener.
  const hasNotif = sections.includes("notif");
  const t = useTranslations("nav");
  const pathname = usePathname();
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const progressRef = useRef<HTMLDivElement>(null);
  const burgerRef = useRef<HTMLButtonElement>(null);
  const menuRef = useRef<HTMLDivElement>(null);

  // Barre de progression : écrite directement dans le style (transform
  // seulement), une fois par frame. Un setState à chaque événement scroll
  // re-rendrait tout l'en-tête des dizaines de fois par seconde.
  useEffect(() => {
    let frame = 0;
    const update = () => {
      frame = 0;
      const el = document.scrollingElement ?? document.documentElement;
      const max = el.scrollHeight - el.clientHeight;
      if (progressRef.current) {
        progressRef.current.style.transform = `scaleX(${max > 0 ? el.scrollTop / max : 0})`;
      }
      setScrolled(el.scrollTop > 8);
    };
    const onScroll = () => {
      if (!frame) frame = requestAnimationFrame(update);
    };
    update();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    return () => {
      cancelAnimationFrame(frame);
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
    };
  }, []);

  // Menu ouvert : le reste de la page devient inerte (ni focus clavier ni
  // lecteur d'écran), le scroll de fond est bloqué, Échap referme. Passer
  // en vue large referme aussi : le menu n'existe pas au-delà de 900 px.
  useEffect(() => {
    if (!menuOpen) return;
    const outside = document.querySelectorAll<HTMLElement>("main, footer");
    outside.forEach((el) => (el.inert = true));
    const { overflow } = document.body.style;
    document.body.style.overflow = "hidden";
    menuRef.current?.querySelector<HTMLElement>("a")?.focus({ preventScroll: true });

    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") close();
    };
    const wide = window.matchMedia("(min-width: 900px)");
    const onWide = () => wide.matches && setMenuOpen(false);
    window.addEventListener("keydown", onKey);
    wide.addEventListener("change", onWide);
    return () => {
      outside.forEach((el) => (el.inert = false));
      document.body.style.overflow = overflow;
      window.removeEventListener("keydown", onKey);
      wide.removeEventListener("change", onWide);
    };
  }, [menuOpen]);

  function close() {
    setMenuOpen(false);
    burgerRef.current?.focus({ preventScroll: true });
  }

  // Ancre absolue : depuis une page légale, « Jeux » ramène à l'accueil ;
  // sur l'accueil, le navigateur défile simplement jusqu'à la section.
  const anchor = (id: string) => `/${locale}#${id}`;

  return (
    <>
      <header
        className={`fixed inset-x-0 top-0 z-50 border-b bg-ground/70 backdrop-blur-[16px] backdrop-saturate-[1.4] transition-colors duration-300 ${
          scrolled ? "border-hairline" : "border-transparent"
        }`}
      >
        <div className="mx-auto flex h-[72px] max-w-[1200px] items-center gap-7 px-[clamp(16px,4vw,24px)]">
          <a href={anchor("top")} aria-label={t("home")} className="flex items-center gap-3 text-ink hover:text-ink">
            <LogoMark />
            <span className="font-display text-[22px] font-semibold tracking-[-0.02em]">Playlink</span>
          </a>

          <nav aria-label={t("main")} className="hidden gap-[26px] text-[15px] font-medium min-[900px]:flex">
            {links.map((s) => (
              <a key={s.id} href={anchor(s.id)} className="text-ink-soft transition-colors hover:text-ink">
                {t(s.key)}
              </a>
            ))}
          </nav>

          <div className="ml-auto flex items-center gap-3.5">
            <div
              role="group"
              aria-label={t("language")}
              className="flex rounded-full border border-hairline p-[3px] font-mono text-[11px] font-semibold tracking-[0.08em]"
            >
              {routing.locales.map((l) => (
                <Link
                  key={l}
                  href={pathname}
                  locale={l}
                  aria-current={l === locale ? "true" : undefined}
                  lang={l}
                  className={`rounded-full px-2.5 py-1.5 uppercase transition-colors ${
                    l === locale ? "bg-ink text-ground" : "text-neutral-faint hover:text-ink"
                  }`}
                >
                  {l}
                </Link>
              ))}
            </div>

            {hasNotif && <a
              href={anchor("notif")}
              className="hidden items-center gap-2 rounded-full border border-accent px-4 py-2.5 text-sm font-semibold text-ink transition-colors hover:bg-accent-wash hover:text-ink min-[640px]:flex"
            >
              <span className="h-[7px] w-[7px] rounded-full bg-accent motion-safe:animate-[pl-pulse_2.2s_infinite]" />
              {t("cta")}
            </a>}

            <button
              ref={burgerRef}
              type="button"
              onClick={() => (menuOpen ? close() : setMenuOpen(true))}
              aria-expanded={menuOpen}
              aria-controls="pl-menu"
              aria-label={menuOpen ? t("closeMenu") : t("openMenu")}
              className="relative z-[71] h-11 w-11 rounded-full border border-hairline-firm bg-surface/60 min-[900px]:hidden"
            >
              <BurgerBar open={menuOpen} top={17} rotate={45} />
              <BurgerBar open={menuOpen} top={25} rotate={-45} />
            </button>
          </div>
        </div>
        <div
          ref={progressRef}
          aria-hidden
          className="absolute -bottom-px left-0 h-0.5 w-full origin-left scale-x-0"
          style={{ background: "linear-gradient(90deg, #7C3AED, #f23a6b, #ff6b93)" }}
        />
      </header>

      <div
        id="pl-menu"
        ref={menuRef}
        role="dialog"
        aria-modal="true"
        aria-label={t("menu")}
        // Toujours monté (transition d'opacité) mais hors de portée quand
        // il est fermé : ni clic, ni focus, ni lecture.
        inert={!menuOpen}
        className={`fixed inset-x-0 top-0 z-40 flex h-dvh flex-col gap-8 bg-ground/[0.97] px-6 pb-8 pt-24 backdrop-blur-[20px] transition-opacity duration-[350ms] min-[900px]:hidden ${
          menuOpen ? "opacity-100" : "pointer-events-none opacity-0"
        }`}
      >
        <nav aria-label={t("mobile")} className="flex flex-col">
          {links.map((s, i) => (
            <a
              key={s.id}
              href={anchor(s.id)}
              onClick={() => setMenuOpen(false)}
              className="flex items-baseline justify-between border-b border-hairline py-[18px] font-display text-4xl font-semibold tracking-[-0.02em] text-ink hover:text-ink"
              style={{
                transform: menuOpen ? "none" : "translateY(24px)",
                opacity: menuOpen ? 1 : 0,
                transition: `transform .5s cubic-bezier(.2,.8,.2,1) ${menuOpen ? 80 + i * 60 : 0}ms, opacity .4s ${menuOpen ? 80 + i * 60 : 0}ms`,
              }}
            >
              {t(s.key)}
              <span className="font-mono text-xs tracking-[0.14em] text-neutral-faint">{String(i + 1).padStart(2, "0")}</span>
            </a>
          ))}
        </nav>
        <div className="mt-auto flex flex-col gap-3.5">
          {hasNotif && (
            <a
              href={anchor("notif")}
              onClick={() => setMenuOpen(false)}
              className="flex items-center justify-center rounded-full px-6 py-4 text-base font-bold text-ground-deep hover:text-ground-deep"
              style={{ background: "var(--gradient-accent)" }}
            >
              {t("notify")}
            </a>
          )}
          <p className="text-center font-mono text-[11px] uppercase tracking-[0.14em] text-neutral-faint">{t("soon")}</p>
        </div>
      </div>
    </>
  );
}

function BurgerBar({ open, top, rotate }: { open: boolean; top: number; rotate: number }) {
  return (
    <span
      className="absolute left-3.5 h-0.5 w-4 rounded-[1px] bg-ink"
      style={{
        top: open ? 21 : top,
        transform: open ? `rotate(${rotate}deg)` : "none",
        transition: "transform .35s cubic-bezier(.2,.8,.2,1), top .35s",
      }}
    />
  );
}
