export type MarqueeItem = { text: string; gradient: string };

const MIN_PER_ROW = 8;

/** Deux rangées de vraies cartes qui défilent en sens opposés (70 s / 85 s).
 * Chaque rangée est doublée pour boucler sans à-coup : l'animation va de 0
 * à -50 %, pile la longueur d'une copie. La copie est masquée aux lecteurs
 * d'écran, qui ne lisent chaque carte qu'une fois. */
export function Marquee({ items, label }: { items: MarqueeItem[]; label: string }) {
  if (items.length < 4) return null;
  const rows = [items.filter((_, i) => i % 2 === 0), items.filter((_, i) => i % 2 === 1)].map(fill);

  return (
    <section
      aria-label={label}
      className="flex flex-col gap-3 overflow-clip border-y border-hairline bg-ground-deep py-[22px]"
      style={{
        maskImage: "linear-gradient(90deg, transparent, #000 10%, #000 90%, transparent)",
        WebkitMaskImage: "linear-gradient(90deg, transparent, #000 10%, #000 90%, transparent)",
      }}
    >
      {rows.map((row, r) => (
        <div
          key={r}
          className="flex w-max motion-safe:animate-[pl-marquee_linear_infinite] hover:[animation-play-state:paused]"
          style={{ animationDuration: r === 0 ? "70s" : "85s", animationDirection: r === 0 ? "normal" : "reverse" }}
        >
          {[0, 1].map((copy) => (
            // Espace final en padding (pas en gap entre les copies) : -50 % doit
            // tomber pile au début de la seconde copie, sinon la boucle saute.
            <ul key={copy} aria-hidden={copy === 1 ? true : undefined} className="m-0 flex list-none gap-3 p-0 pr-3">
              {row.map((item, i) => (
                <li
                  key={i}
                  className="flex items-center gap-2.5 whitespace-nowrap rounded-full border border-hairline bg-surface px-[18px] py-2.5 text-[15px] text-ink-soft"
                >
                  <span aria-hidden className="h-2 w-2 shrink-0 rounded-full" style={{ background: item.gradient }} />
                  {item.text}
                </li>
              ))}
            </ul>
          ))}
        </div>
      ))}
    </section>
  );
}

/** Une rangée trop courte laisserait un vide à droite sur grand écran avant
 * la boucle : on la répète jusqu'à un minimum d'éléments. */
function fill(row: MarqueeItem[]): MarqueeItem[] {
  if (row.length === 0) return row;
  const out = [...row];
  while (out.length < MIN_PER_ROW) out.push(...row);
  return out;
}
