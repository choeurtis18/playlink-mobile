// Éventail de 4 cartes aux couleurs de jeux (Action ou Vérité, Icebreaker,
// Qui de nous) + l'accent de marque. CSS pur : pas d'image à charger pour
// un élément présent sur chaque écran.
const FAN = [
  { from: "#7C3AED", to: "#EC4899", rotate: -26 },
  { from: "#0EA5E9", to: "#06B6D4", rotate: -9 },
  { from: "#059669", to: "#10B981", rotate: 9 },
  { from: "#f23a6b", to: "#ff6b93", rotate: 26 },
];

/** `size` = largeur de l'éventail en px ; les cartes suivent la même
 * proportion que dans le design (30 × 28, cartes 14 × 20). */
export function LogoMark({ size = 30 }: { size?: number }) {
  const k = size / 30;
  return (
    <span aria-hidden className="relative block shrink-0" style={{ width: size, height: 28 * k }}>
      {FAN.map((c) => (
        <span
          key={c.from}
          className="absolute bottom-0"
          style={{
            left: 8 * k,
            width: 14 * k,
            height: 20 * k,
            borderRadius: 4 * k,
            background: `linear-gradient(135deg, ${c.from}, ${c.to})`,
            transformOrigin: "50% 100%",
            transform: `rotate(${c.rotate}deg)`,
          }}
        />
      ))}
    </span>
  );
}
