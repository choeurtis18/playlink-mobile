/** Éventail de 4 cartes aux couleurs des jeux — même logo que la landing. */
const FAN = [
  { rotate: -26, gradient: "linear-gradient(135deg,#7C3AED,#EC4899)" },
  { rotate: -9, gradient: "linear-gradient(135deg,#0EA5E9,#06B6D4)" },
  { rotate: 9, gradient: "linear-gradient(135deg,#059669,#10B981)" },
  { rotate: 26, gradient: "linear-gradient(135deg,#f23a6b,#ff6b93)" },
];

export function Logo() {
  return (
    <span className="flex items-center gap-2.5">
      <span aria-hidden className="relative block h-[26px] w-7 flex-none">
        {FAN.map((c) => (
          <span
            key={c.rotate}
            className="absolute bottom-0 left-2 h-[18px] w-3 origin-bottom rounded-[3px]"
            style={{ background: c.gradient, transform: `rotate(${c.rotate}deg)` }}
          />
        ))}
      </span>
      <span className="flex flex-col">
        <span className="font-display text-[19px] font-semibold leading-[1.1] tracking-[-0.02em] text-ink">Playlink</span>
        <span className="font-mono text-[10px] uppercase tracking-[0.14em] text-neutral-faint">Back-office</span>
      </span>
    </span>
  );
}
