"use client";

import { useState, useTransition } from "react";
import { DotsSixVerticalIcon } from "@phosphor-icons/react/dist/ssr";
import type { ActionResult } from "@/lib/actions";

/**
 * Liste réordonnable par glisser-déposer (API HTML5 native, pas de
 * dépendance externe) ou au clavier (flèches sur la poignée). L'ordre
 * visuel est optimiste : on réordonne l'état local immédiatement, puis on
 * persiste en arrière-plan.
 *
 * `renderItem` reçoit `onDragStart` et `onMove`, à passer à `DragHandle`
 * à l'intérieur de la ligne — pas sur la ligne entière, pour qu'un clic
 * sur un bouton d'action (Éditer, Supprimer) ne démarre jamais un drag.
 */
export function DragList<T extends { id: string }>({
  items, reorder, renderItem, className, label = (i) => i.id,
}: {
  items: T[];
  reorder: (ids: string[]) => Promise<ActionResult>;
  renderItem: (item: T, onDragStart: () => void, onMove: (dir: -1 | 1) => void) => React.ReactNode;
  className?: string;
  /** Nom lu par les lecteurs d'écran après un déplacement au clavier. */
  label?: (item: T) => string;
}) {
  const [order, setOrder] = useState(items);
  const [dragId, setDragId] = useState<string | null>(null);
  const [announce, setAnnounce] = useState("");
  const [, start] = useTransition();

  // L'ordre côté serveur peut changer sans passer par ce composant (ex.
  // édition d'un élément qui touche son `order` via le formulaire standard,
  // ou un autre éditeur qui réordonne en parallèle) — resynchroniser au
  // prochain rendu, sauf pendant un drag en cours.
  if (!dragId && items.map((i) => i.id).join() !== order.map((i) => i.id).join()) {
    setOrder(items);
  }

  const commit = (next: T[]) => {
    setOrder(next);
    start(async () => { await reorder(next.map((i) => i.id)); });
  };

  const onDrop = (targetId: string) => {
    if (!dragId || dragId === targetId) { setDragId(null); return; }
    const next = [...order];
    const from = next.findIndex((i) => i.id === dragId);
    const to = next.findIndex((i) => i.id === targetId);
    const [moved] = next.splice(from, 1);
    next.splice(to, 0, moved);
    setDragId(null);
    commit(next);
  };

  const move = (id: string, dir: -1 | 1) => {
    const from = order.findIndex((i) => i.id === id);
    const to = from + dir;
    if (to < 0 || to >= order.length) return;
    const next = [...order];
    [next[from], next[to]] = [next[to], next[from]];
    commit(next);
    setAnnounce(`${label(next[to])} : position ${to + 1} sur ${next.length}`);
    // La ligne a été re-rendue ailleurs : on remet le focus sur sa poignée.
    requestAnimationFrame(() => document.querySelector<HTMLElement>(`[data-drag-handle="${id}"]`)?.focus());
  };

  return (
    <div className={className}>
      {order.map((item) => (
        <div key={item.id}
          onDragOver={(e) => e.preventDefault()}
          onDrop={() => onDrop(item.id)}
          className={`transition-opacity ${dragId === item.id ? "opacity-40" : ""}`}>
          {renderItem(item, () => setDragId(item.id), (dir) => move(item.id, dir))}
        </div>
      ))}
      <span className="sr-only" aria-live="polite">{announce}</span>
    </div>
  );
}

/** Poignée de déplacement : glisser à la souris, ou focus puis ↑ / ↓. */
export function DragHandle({ onDragStart, onMove, id, label, className }: {
  onDragStart: () => void;
  onMove?: (dir: -1 | 1) => void;
  /** Identifiant de l'élément, pour lui rendre le focus après un déplacement. */
  id?: string;
  label?: string;
  className?: string;
}) {
  return (
    <button
      type="button"
      draggable
      onDragStart={onDragStart}
      data-drag-handle={id}
      aria-label={label ? `Déplacer ${label} (flèches haut et bas)` : "Déplacer (flèches haut et bas)"}
      title="Glisser, ou flèches ↑ ↓, pour réordonner"
      onKeyDown={(e) => {
        if (!onMove) return;
        if (e.key === "ArrowUp") { e.preventDefault(); onMove(-1); }
        if (e.key === "ArrowDown") { e.preventDefault(); onMove(1); }
      }}
      className={`inline-flex cursor-grab items-center justify-center rounded-md text-lg text-neutral-faint hover:text-ink active:cursor-grabbing ${className ?? ""}`}
    >
      <DotsSixVerticalIcon aria-hidden />
    </button>
  );
}
