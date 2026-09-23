"use client";

import { useMemo, useState } from "react";
import { useTranslations } from "next-intl";
import type { PreviewCategory } from "@/lib/backoffice";

/** Démo jouable de la landing : un aperçu du flux carte-swipeable, pas un
 * simulateur complet. Aucun tirage aléatoire, aucun score — cette logique
 * reste dans l'app (CLAUDE.md, règle offline-first). Le swipe est un geste
 * décoratif : boutons "suivant/précédent" toujours présents en dessous
 * (plan landing §07 — alternative accessible obligatoire). */
export function PreviewDemo({
  categories,
  locale,
}: {
  categories: PreviewCategory[];
  locale: string;
}) {
  const t = useTranslations("demo");
  const [categoryIndex, setCategoryIndex] = useState(0);
  const [cardIndex, setCardIndex] = useState(0);
  const [dragX, setDragX] = useState(0);
  const [dragging, setDragging] = useState(false);
  const [dragStartX, setDragStartX] = useState(0);

  const category = categories[categoryIndex];
  const card = category?.cards[cardIndex];
  const cardText = useMemo(() => {
    if (!card) return "";
    return card.translations[locale]?.text ?? card.text;
  }, [card, locale]);

  if (categories.length === 0 || !category) {
    return (
      <div className="rounded-2xl border border-dashed border-hairline-firm bg-surface/50 px-6 py-16 text-center text-sm text-neutral-faint">
        {t("comingSoon")}
      </div>
    );
  }

  function goTo(delta: number) {
    setDragX(0);
    setCardIndex((i) => {
      const total = category.cards.length;
      return (i + delta + total) % total;
    });
  }

  function selectCategory(i: number) {
    setCategoryIndex(i);
    setCardIndex(0);
    setDragX(0);
  }

  const rotation = dragX / 18;

  return (
    <div className="flex flex-col gap-6">
      <div className="flex flex-wrap gap-2" role="tablist" aria-label={t("categoryLabel")}>
        {categories.map((cat, i) => (
          <button
            key={cat.slug}
            role="tab"
            aria-selected={i === categoryIndex}
            onClick={() => selectCategory(i)}
            className={`rounded-full border px-4 py-2 text-sm font-medium transition ${
              i === categoryIndex
                ? "text-ink"
                : "border-hairline text-ink-soft hover:border-hairline-firm hover:text-ink"
            }`}
            // L'onglet actif porte la couleur du jeu en bordure + halo léger
            // plutôt qu'en aplat : le blanc sur ces teintes claires tombait
            // sous 4.5:1 (Icebreaker 2.4:1), et assombrir l'aplat effacerait
            // la couleur du jeu.
            style={
              i === categoryIndex
                ? {
                    borderColor: cat.game.colorMain,
                    background: `color-mix(in srgb, ${cat.game.colorMain} 18%, var(--color-surface))`,
                  }
                : undefined
            }
          >
            {cat.translations[locale]?.name ?? cat.name}
          </button>
        ))}
      </div>

      <div className="relative mx-auto w-full max-w-sm select-none" style={{ perspective: "1000px" }}>
        <div
          key={card?.id}
          className="relative flex min-h-64 flex-col justify-between rounded-3xl border border-hairline-firm p-7 shadow-2xl motion-safe:animate-[card-enter_0.35s_ease-out]"
          style={{
            background: `linear-gradient(155deg, ${category.game.colorMain}, ${category.game.colorSecondary})`,
            transform: dragging ? `translateX(${dragX}px) rotate(${rotation}deg)` : undefined,
            transition: dragging ? "none" : "transform 0.25s ease-out",
            touchAction: "pan-y",
          }}
          onPointerDown={(e) => {
            setDragging(true);
            setDragStartX(e.clientX);
            e.currentTarget.setPointerCapture(e.pointerId);
          }}
          onPointerMove={(e) => {
            if (!dragging) return;
            setDragX(e.clientX - dragStartX);
          }}
          onPointerUp={() => {
            setDragging(false);
            if (Math.abs(dragX) > 80) goTo(dragX > 0 ? -1 : 1);
            else setDragX(0);
          }}
          onPointerLeave={() => dragging && setDragging(false)}
        >
          {/* Voile sombre : le blanc seul tombe à 2.4:1 sur les jeux aux
              couleurs claires (Icebreaker, Dégât Débat) — sous le minimum
              WCAG AA. Le dégradé du jeu reste visible autour et derrière. */}
          <div aria-hidden className="absolute inset-0 rounded-3xl bg-black/45" />
          <span className="relative font-mono text-xs uppercase tracking-widest text-white/80">
            {category.game.name}
          </span>
          <p className="relative font-[family-name:var(--font-display)] text-2xl font-semibold leading-snug text-white">
            {cardText}
          </p>
          <span className="relative text-xs text-white/80">
            {t("cardOf", { n: cardIndex + 1, total: category.cards.length })}
          </span>
        </div>
      </div>

      <div className="flex items-center justify-center gap-4">
        <button
          onClick={() => goTo(-1)}
          aria-label={t("prev")}
          className="flex h-11 w-11 items-center justify-center rounded-full border border-hairline text-ink-soft transition hover:border-hairline-firm hover:text-ink"
        >
          ←
        </button>
        <button
          onClick={() => goTo(1)}
          aria-label={t("next")}
          className="flex h-11 w-11 items-center justify-center rounded-full border border-hairline text-ink-soft transition hover:border-hairline-firm hover:text-ink"
        >
          →
        </button>
      </div>
    </div>
  );
}
