import { ImageResponse } from "next/og";
import { getSiteConfig, landingTexts } from "@/lib/backoffice";

// Image de partage (Open Graph / X), générée à la construction dans chaque
// langue : éventail de 4 cartes (le logo) + titre du héros, sur le fond
// de la landing. Le mot entre astérisques du titre passe en rose.
export const alt = "Playlink";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

const FAN = [
  ["#7C3AED", "#EC4899", -26],
  ["#0EA5E9", "#06B6D4", -9],
  ["#059669", "#10B981", 9],
  ["#f23a6b", "#ff6b93", 26],
] as const;

export default async function OgImage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const texts = landingTexts(await getSiteConfig(), locale);
  // Un mot = un élément : le moteur d'image ne sait pas faire couler du
  // texte mêlé à des <span>, il les empile. Mot mis en valeur = en rose.
  const words = texts["hero.title"]
    .split(/\*([^*]+)\*/)
    .flatMap((part, i) => part.split(/\s+/).filter(Boolean).map((w) => ({ w, pink: i % 2 === 1 })));
  const eyebrow = texts["hero.eyebrow"].toUpperCase();
  // Police réduite aux caractères affichés : tous, sinon une lettre
  // manquante retombe sur une autre police.
  const font = await loadFont(words.map((x) => x.w).join("") + eyebrow + "Playlink");

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          background: "radial-gradient(ellipse 60% 70% at 85% 30%, #2b121c 0%, #0b0a0f 70%)",
          color: "#f3f1ec",
          padding: "72px 80px",
          fontFamily: font ? "Fraunces" : "serif",
        }}
      >
        <div style={{ display: "flex", flexDirection: "column", justifyContent: "space-between", width: 720 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 18 }}>
            <div style={{ display: "flex", position: "relative", width: 60, height: 56 }}>
              {FAN.map(([a, b, r]) => (
                <div
                  key={a + r}
                  style={{
                    position: "absolute",
                    left: 16,
                    bottom: 0,
                    width: 28,
                    height: 40,
                    borderRadius: 8,
                    background: `linear-gradient(135deg, ${a}, ${b})`,
                    transformOrigin: "50% 100%",
                    transform: `rotate(${r}deg)`,
                  }}
                />
              ))}
            </div>
            <div style={{ fontSize: 44, fontWeight: 600, letterSpacing: -1 }}>Playlink</div>
          </div>
          <div style={{ display: "flex", flexWrap: "wrap", columnGap: 16, fontSize: 64, fontWeight: 600, lineHeight: 1.04, letterSpacing: -2 }}>
            {words.map((x, i) => (
              <span key={i} style={{ color: x.pink ? "#ff6b93" : "#f3f1ec" }}>
                {x.w}
              </span>
            ))}
          </div>
          <div style={{ display: "flex", fontSize: 24, letterSpacing: 4, color: "#c7c2d1" }}>
            {eyebrow}
          </div>
        </div>
        <div style={{ display: "flex", position: "relative", flex: 1 }}>
          {FAN.map(([a, b, r], i) => (
            <div
              key={a + r}
              style={{
                position: "absolute",
                left: 120 + i * 18,
                top: 70 + Math.abs(i - 1.5) * 16,
                width: 190,
                height: 260,
                borderRadius: 24,
                border: "2px solid rgba(255,255,255,0.14)",
                background: `linear-gradient(135deg, ${a}, ${b})`,
                transform: `rotate(${r * 0.8}deg)`,
                boxShadow: "0 30px 60px -20px rgba(6,5,9,0.9)",
              }}
            />
          ))}
        </div>
      </div>
    ),
    { ...size, fonts: font ? [{ name: "Fraunces", data: font, weight: 600, style: "normal" }] : [] },
  );
}

/** Fraunces 600, limitée aux caractères utiles. Sans réseau au moment de
 * la construction, l'image est générée avec la police par défaut plutôt
 * que de faire échouer le build. */
async function loadFont(text: string): Promise<ArrayBuffer | null> {
  try {
    const css = await (
      await fetch(`https://fonts.googleapis.com/css2?family=Fraunces:wght@600&text=${encodeURIComponent(text)}`)
    ).text();
    const url = css.match(/src: url\((.+?)\) format\('(?:opentype|truetype)'\)/)?.[1];
    return url ? await (await fetch(url)).arrayBuffer() : null;
  } catch {
    return null;
  }
}
