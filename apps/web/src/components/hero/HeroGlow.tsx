"use client";

import { useEffect, useRef } from "react";

/** Halo qui suit la souris dans la section parente. Souris uniquement : au
 * doigt, un halo qui saute au point touché distrait plus qu'il n'éclaire.
 * Déplacé par transform (aucun re-rendu React). */
export function HeroGlow() {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const glow = ref.current;
    const section = glow?.parentElement;
    if (!glow || !section) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    const onMove = (e: PointerEvent) => {
      if (e.pointerType !== "mouse") return;
      const r = section.getBoundingClientRect();
      glow.style.transform = `translate(${e.clientX - r.left - 320}px, ${e.clientY - r.top - 320}px)`;
    };
    section.addEventListener("pointermove", onMove);
    return () => section.removeEventListener("pointermove", onMove);
  }, []);

  return (
    <div
      ref={ref}
      aria-hidden
      className="pointer-events-none absolute left-0 top-0 h-[640px] w-[640px] rounded-full transition-transform duration-500 ease-[cubic-bezier(.2,.8,.2,1)]"
      style={{
        // `transform` en style (pas la classe translate-x de Tailwind, qui
        // écrit la propriété `translate` et s'additionnerait au suivi).
        transform: "translate(-9999px, 0)",
        background: "radial-gradient(circle, rgb(242 58 107 / 0.16) 0%, rgb(124 58 237 / 0.08) 40%, transparent 70%)",
      }}
    />
  );
}
