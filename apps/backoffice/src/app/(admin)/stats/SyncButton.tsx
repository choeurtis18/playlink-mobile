"use client";

import { useTransition } from "react";
import { ArrowsClockwiseIcon } from "@phosphor-icons/react/dist/ssr";
import { Button, useToast } from "@/components/ui";
import { syncLandingStatsNow } from "@/lib/actions";

/** Synchro manuelle (le cron la fait chaque nuit) : utile la première
 * fois, pour rattraper jusqu'à 90 jours d'historique. */
export function SyncButton({ days, label = "Synchroniser", variant = "secondary" }: { days: number; label?: string; variant?: "primary" | "secondary" }) {
  const toast = useToast();
  const [pending, start] = useTransition();
  return (
    <Button
      variant={variant}
      disabled={pending}
      icon={<ArrowsClockwiseIcon aria-hidden className={pending ? "motion-safe:animate-spin" : ""} />}
      onClick={() => start(async () => {
        const r = await syncLandingStatsNow(days);
        toast(r.ok ? `Stats synchronisées (${days} jours)` : r.error, r.ok ? "success" : "error");
      })}
    >
      {pending ? "Synchronisation…" : label}
    </Button>
  );
}
