"use client";

import { useActionState, useEffect, useRef, useState } from "react";
import { useTranslations } from "next-intl";
import { preRegister, type PreRegisterState } from "@/app/[locale]/actions";
import { capture } from "@/lib/analytics";

const CONFETTI_COLORS = [
  ["#7C3AED", "#EC4899"], ["#0EA5E9", "#06B6D4"], ["#DC2626", "#F97316"], ["#059669", "#10B981"],
  ["#D97706", "#F59E0B"], ["#7C3AED", "#8B5CF6"], ["#1D4ED8", "#3B82F6"], ["#BE185D", "#EC4899"],
];

export function PreRegisterForm({ locale, texts, privacyHref }: {
  locale: string;
  texts: { button: string; consent: string; success: string };
  privacyHref: string;
}) {
  const t = useTranslations("notif");
  const [state, action, pending] = useActionState<PreRegisterState, FormData>(preRegister, { status: "idle" });
  // Horodatage du premier rendu côté navigateur : sert à repérer les
  // envois de robots (formulaire rempli instantanément).
  const [startedAt, setStartedAt] = useState(0);
  const [clientError, setClientError] = useState<"email" | "consent" | null>(null);
  const confettiRef = useRef<HTMLDivElement>(null);

  useEffect(() => setStartedAt(Date.now()), []);

  useEffect(() => {
    if (state.status !== "done") return;
    burst(confettiRef.current);
    capture("preregister_submitted", { locale, pending: state.pending });
  }, [state, locale]);

  const error = clientError ?? (state.status === "error" ? state.reason : null);

  // Même contrôle côté navigateur que côté serveur, pour une erreur
  // immédiate et en texte (jamais la bulle native du navigateur).
  function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    const f = new FormData(e.currentTarget);
    const email = String(f.get("email") ?? "").trim();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) {
      e.preventDefault();
      setClientError("email");
    } else if (f.get("consent") !== "on") {
      e.preventDefault();
      setClientError("consent");
    } else {
      setClientError(null);
    }
  }

  return (
    <div className="relative">
      <div ref={confettiRef} aria-hidden className="pointer-events-none absolute left-1/2 top-1/2 z-[3] h-0 w-0" />
      {state.status === "done" ? (
        <div role="status" className="flex flex-col gap-3.5 rounded-[20px] border border-hairline bg-surface p-7">
          <span aria-hidden className="flex h-11 w-11 items-center justify-center rounded-full bg-success/15 text-[22px] font-bold text-success">✓</span>
          <p className="m-0 font-display text-[26px] font-semibold leading-[1.15]">
            {state.pending ? t("pendingTitle") : texts.success}
          </p>
          <p className="m-0 text-sm text-neutral-faint">
            {state.pending ? t("pendingBody", { email: state.email }) : t("doneBody", { email: state.email })}
          </p>
        </div>
      ) : (
        <form action={action} onSubmit={onSubmit} noValidate className="flex flex-col gap-3.5">
          <input type="hidden" name="locale" value={locale} />
          <input type="hidden" name="startedAt" value={startedAt} />
          {/* Champ piège : invisible pour un humain, rempli par les robots.
              Rien en coordonnées négatives : un débord rendrait le bloc
              parent défilable au focus. */}
          <div aria-hidden className="pointer-events-none absolute h-px w-px overflow-clip opacity-0">
            <label>
              Website
              <input type="text" name="website" tabIndex={-1} autoComplete="off" />
            </label>
          </div>

          <label htmlFor="pl-email" className="text-sm font-semibold text-ink">{t("emailLabel")}</label>
          <div className="flex flex-wrap gap-2">
            <input
              id="pl-email"
              name="email"
              type="email"
              autoComplete="email"
              inputMode="email"
              placeholder={t("placeholder")}
              aria-invalid={error === "email" || undefined}
              aria-describedby="pl-form-msg"
              onChange={() => clientError === "email" && setClientError(null)}
              className={`min-w-0 flex-[1_1_220px] rounded-[14px] border bg-surface px-4 py-[15px] text-base text-ink outline-none transition-colors focus:border-accent ${
                error === "email" ? "border-danger" : "border-hairline-firm"
              }`}
            />
            <button
              type="submit"
              disabled={pending}
              className="rounded-[14px] px-[22px] py-[15px] text-base font-bold text-ground-deep transition-transform duration-200 hover:-translate-y-0.5 disabled:opacity-60"
              style={{ background: "var(--gradient-accent)" }}
            >
              {pending ? t("sending") : texts.button}
            </button>
          </div>
          <label className="flex cursor-pointer items-start gap-3 text-sm leading-normal text-ink-soft">
            <input
              type="checkbox"
              name="consent"
              aria-invalid={error === "consent" || undefined}
              aria-describedby="pl-form-msg"
              onChange={() => clientError === "consent" && setClientError(null)}
              className="mt-[3px] h-[18px] w-[18px] shrink-0 accent-accent"
            />
            <span>
              {texts.consent}{" "}
              {t.rich("privacy", {
                link: (chunk) => (
                  <a href={privacyHref} className="text-accent-deep underline hover:text-ink">
                    {chunk}
                  </a>
                ),
              })}
            </span>
          </label>
          <p id="pl-form-msg" role="alert" className="m-0 min-h-5 text-sm font-medium text-danger">
            {error && t(`errors.${error}`)}
          </p>
        </form>
      )}
    </div>
  );
}

/** Pluie de mini-cartes aux couleurs des jeux (Web Animations API),
 * rien en mouvement réduit. Les éléments se retirent seuls. */
function burst(host: HTMLElement | null) {
  if (!host || window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
  for (let k = 0; k < 22; k++) {
    const [a, b] = CONFETTI_COLORS[k % CONFETTI_COLORS.length];
    const el = document.createElement("span");
    el.style.cssText = `position:absolute;left:-7px;top:-10px;width:14px;height:20px;border-radius:4px;background:linear-gradient(135deg,${a},${b});box-shadow:0 4px 10px rgba(6,5,9,.4)`;
    host.appendChild(el);
    const angle = Math.random() * Math.PI * 2;
    const dist = 120 + Math.random() * 200;
    const rot = (Math.random() - 0.5) * 720;
    el.animate(
      [
        { transform: "translate(0,0) rotate(0) scale(.4)", opacity: 1 },
        { transform: `translate(${Math.cos(angle) * dist}px, ${Math.sin(angle) * dist - 60}px) rotate(${rot}deg) scale(1)`, opacity: 1, offset: 0.6 },
        { transform: `translate(${Math.cos(angle) * dist * 1.1}px, ${Math.sin(angle) * dist + 80}px) rotate(${rot * 1.3}deg) scale(.9)`, opacity: 0 },
      ],
      { duration: 1500 + Math.random() * 600, easing: "cubic-bezier(.2,.7,.3,1)", fill: "forwards" },
    ).onfinish = () => el.remove();
  }
}
