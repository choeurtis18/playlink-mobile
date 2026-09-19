"use client";

import { useState, useTransition } from "react";
import type { ActionResult } from "@/lib/actions";

/**
 * Liste réordonnable par glisser-déposer (API HTML5 native, pas de
 * dépendance externe). L'ordre visuel est optimiste : on réordonne l'état
 * local immédiatement au drop, puis on persiste en arrière-plan.
 *
 * `renderItem` reçoit `onDragStart`, à poser sur une poignée `draggable`
 * (voir `DragHandle`) à l'intérieur de la ligne — pas sur la ligne entière,
 * pour qu'un clic sur un bouton d'action (Éditer, Supprimer) ne démarre
 * jamais un drag par erreur.
 */
export function DragList<T extends { id: string }>({
  items, reorder, renderItem, className,
}: {
  items: T[];
  reorder: (ids: string[]) => Promise<ActionResult>;
  renderItem: (item: T, onDragStart: () => void) => React.ReactNode;
  className?: string;
}) {
  const [order, setOrder] = useState(items);
  const [dragId, setDragId] = useState<string | null>(null);
  const [, start] = useTransition();

  // L'ordre côté serveur peut changer sans passer par ce composant (ex.
  // édition d'un élément qui touche son `order` via le formulaire standard,
  // ou un autre éditeur qui réordonne en parallèle) — resynchroniser au
  // prochain rendu, sauf pendant un drag en cours.
  if (!dragId && items.map((i) => i.id).join() !== order.map((i) => i.id).join()) {
    setOrder(items);
  }

  const onDrop = (targetId: string) => {
    if (!dragId || dragId === targetId) { setDragId(null); return; }
    const next = [...order];
    const from = next.findIndex((i) => i.id === dragId);
    const to = next.findIndex((i) => i.id === targetId);
    const [moved] = next.splice(from, 1);
    next.splice(to, 0, moved);
    setOrder(next);
    setDragId(null);
    start(async () => { await reorder(next.map((i) => i.id)); });
  };

  return (
    <div className={className}>
      {order.map((item) => (
        <div key={item.id}
          onDragOver={(e) => e.preventDefault()}
          onDrop={() => onDrop(item.id)}
          className={dragId === item.id ? "opacity-40" : ""}>
          {renderItem(item, () => setDragId(item.id))}
        </div>
      ))}
    </div>
  );
}

/** Poignée de drag — un petit élément dédié dans la ligne, pas la ligne
 * entière, pour ne pas capter les clics sur les boutons d'action voisins. */
export function DragHandle({ onDragStart, className }: { onDragStart: () => void; className?: string }) {
  return (
    <span draggable onDragStart={onDragStart}
      className={`inline-flex cursor-grab items-center justify-center text-neutral-faint hover:text-ink active:cursor-grabbing ${className ?? ""}`}
      title="Glisser pour réordonner">
      ⠿
    </span>
  );
}
