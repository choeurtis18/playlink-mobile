"use client";

import { useId, useState } from "react";

// Deux mesures d'échelles différentes (vues ≫ pré-inscriptions) : deux
// graphiques alignés sur le même axe du temps, jamais un double axe.
// Une ligne verticale commune et une seule infobulle les relient.

const VIEWS = "#f23a6b";
const SIGNUPS = "#3d8fe6"; // validé (bande de luminosité, daltonisme) sur le fond #17151d

const nf = new Intl.NumberFormat("fr-FR");
const tickFmt = new Intl.DateTimeFormat("fr-FR", { day: "2-digit", month: "short", timeZone: "UTC" });
const tipFmt = new Intl.DateTimeFormat("fr-FR", { weekday: "long", day: "numeric", month: "long", timeZone: "UTC" });
const asDate = (day: string) => new Date(`${day}T00:00:00Z`);

export function TrendCharts({ days, views, signups }: { days: string[]; views: number[]; signups: number[] }) {
  const id = useId();
  const [hover, setHover] = useState<number | null>(null);
  const n = days.length;
  const W = 600;
  const x = (i: number) => (n > 1 ? (i / (n - 1)) * W : W / 2);
  const pct = (i: number) => (n > 1 ? (i / (n - 1)) * 100 : 50);
  const maxV = Math.max(1, ...views);
  const maxS = Math.max(1, ...signups);

  const H1 = 150;
  const yV = (v: number) => H1 - 4 - (v / maxV) * (H1 - 12);
  const line = views.map((v, i) => `${i ? "L" : "M"}${x(i).toFixed(1)},${yV(v).toFixed(1)}`).join(" ");
  const H2 = 80;
  const bw = Math.max(2, Math.min(18, (W / Math.max(1, n)) * 0.55));

  const ticks = [0, 0.33, 0.66, 1].map((t) => Math.round(t * (n - 1))).filter((v, i, a) => a.indexOf(v) === i);
  const move = (dir: number) => setHover((h) => Math.min(n - 1, Math.max(0, (h ?? (dir > 0 ? -1 : n)) + dir)));

  return (
    <div className="flex flex-col gap-3">
      <div
        role="group"
        tabIndex={0}
        aria-label="Vues et pré-inscriptions par jour. Flèches gauche et droite pour parcourir les jours."
        aria-describedby={hover !== null ? `${id}-tip` : undefined}
        onKeyDown={(e) => {
          if (e.key === "ArrowRight") { e.preventDefault(); move(1); }
          if (e.key === "ArrowLeft") { e.preventDefault(); move(-1); }
          if (e.key === "Escape") setHover(null);
        }}
        onBlur={() => setHover(null)}
        onPointerLeave={() => setHover(null)}
        className="relative rounded-md outline-offset-4"
      >
        <Panel label="Vues" max={maxV} color={VIEWS} height={H1}>
          {[0.5].map((g) => <line key={g} x1="0" x2={W} y1={H1 * g} y2={H1 * g} stroke="#2a2733" strokeDasharray="3 4" vectorEffect="non-scaling-stroke" />)}
          <path d={`${line} L${x(n - 1)},${H1} L${x(0)},${H1} Z`} fill="rgb(242 58 107 / 0.12)" />
          <path d={line} fill="none" stroke={VIEWS} strokeWidth={2} strokeLinejoin="round" vectorEffect="non-scaling-stroke" />
        </Panel>
        <Panel label="Pré-inscriptions" max={maxS} color={SIGNUPS} height={H2} bars>
          {signups.map((v, i) => {
            const h = v ? Math.max(3, (v / maxS) * (H2 - 6)) : 0;
            const left = Math.min(W - bw, Math.max(0, x(i) - bw / 2));
            return h ? <rect key={i} x={left} y={H2 - h} width={bw} height={h} rx={2} fill={SIGNUPS} opacity={hover === null || hover === i ? 1 : 0.55} /> : null;
          })}
        </Panel>

        {/* Zones de survol (plus larges que les marques) + ligne verticale. */}
        <div className="absolute inset-0 flex">
          {days.map((d, i) => <div key={d} className="h-full flex-1" onPointerEnter={() => setHover(i)} />)}
        </div>
        {hover !== null && (
          <>
            <div aria-hidden className="pointer-events-none absolute inset-y-0 w-px bg-ink/40" style={{ left: `${pct(hover)}%` }} />
            <div
              id={`${id}-tip`}
              role="status"
              className="pointer-events-none absolute top-2 z-10 whitespace-nowrap rounded-lg border border-hairline-firm bg-raised px-3 py-2 text-xs shadow-[0_12px_24px_rgb(0_0_0/0.4)]"
              style={pct(hover) > 70 ? { right: `calc(${100 - pct(hover)}% + 10px)` } : { left: `calc(${pct(hover)}% + 10px)` }}
            >
              <div className="mb-1 text-neutral-faint">{tipFmt.format(asDate(days[hover]))}</div>
              <div className="flex items-center gap-2"><span aria-hidden className="h-0.5 w-3" style={{ background: VIEWS }} /><strong className="text-ink">{nf.format(views[hover])}</strong> <span className="text-ink-soft">vues</span></div>
              <div className="flex items-center gap-2"><span aria-hidden className="h-0.5 w-3" style={{ background: SIGNUPS }} /><strong className="text-ink">{nf.format(signups[hover])}</strong> <span className="text-ink-soft">pré-inscriptions</span></div>
            </div>
          </>
        )}
      </div>

      <div aria-hidden className="relative h-4 font-mono text-[11px] text-neutral-faint">
        {ticks.map((i) => (
          <span key={i} className="absolute whitespace-nowrap" style={{ left: `${pct(i)}%`, transform: `translateX(${i === 0 ? "0" : i === n - 1 ? "-100%" : "-50%"})` }}>
            {tickFmt.format(asDate(days[i]))}
          </span>
        ))}
      </div>

      <p className="m-0 text-xs text-neutral-faint">Le dernier jour est la journée en cours, encore incomplète.</p>

      <details className="text-xs text-neutral-faint">
        <summary className="cursor-pointer select-none hover:text-ink">Voir les données en tableau</summary>
        <div className="mt-2 max-h-64 overflow-y-auto rounded-lg border border-hairline">
          <table className="w-full border-collapse text-[12.5px]">
            <thead className="sticky top-0 bg-raised text-left text-neutral-faint">
              <tr><th className="px-3 py-1.5 font-medium">Jour</th><th className="px-3 py-1.5 text-right font-medium">Vues</th><th className="px-3 py-1.5 text-right font-medium">Pré-inscriptions</th></tr>
            </thead>
            <tbody className="text-ink-soft">
              {days.map((d, i) => (
                <tr key={d} className="border-t border-hairline">
                  <td className="px-3 py-1">{tickFmt.format(asDate(d))}</td>
                  <td className="px-3 py-1 text-right tabular-nums">{nf.format(views[i])}</td>
                  <td className="px-3 py-1 text-right tabular-nums">{nf.format(signups[i])}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </details>
    </div>
  );
}

function Panel({ label, max, color, height, bars = false, children }: {
  label: string; max: number; color: string; height: number; bars?: boolean; children: React.ReactNode;
}) {
  return (
    <div className="mb-2 last:mb-0">
      <div className="mb-1 flex items-baseline justify-between text-xs">
        <span className="flex items-center gap-1.5 text-ink-soft">
          <span aria-hidden className={bars ? "h-2 w-2 rounded-sm" : "h-0.5 w-3"} style={{ background: color }} />{label}
        </span>
        <span className="font-mono text-[11px] text-neutral-faint">max {nf.format(max)}</span>
      </div>
      <svg viewBox={`0 0 600 ${height}`} preserveAspectRatio="none" aria-hidden className="block w-full overflow-visible" style={{ height }}>
        <line x1="0" x2="600" y1={height} y2={height} stroke="#3a3548" vectorEffect="non-scaling-stroke" />
        {children}
      </svg>
    </div>
  );
}
