-- AlterTable
ALTER TABLE "site_content" ADD COLUMN     "demoDeckSize" INTEGER NOT NULL DEFAULT 5,
ADD COLUMN     "demoMaxIntensity" INTEGER NOT NULL DEFAULT 3,
ADD COLUMN     "doubleOptIn" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "landing_texts" (
    "id" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "landing_texts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "landing_pre_registrations" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'fr',
    "consentNewsletter" BOOLEAN NOT NULL,
    "confirmToken" TEXT,
    "confirmedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "landing_pre_registrations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "landing_texts_locale_key_key" ON "landing_texts"("locale", "key");

-- CreateIndex
CREATE UNIQUE INDEX "landing_pre_registrations_email_key" ON "landing_pre_registrations"("email");

-- CreateIndex
CREATE UNIQUE INDEX "landing_pre_registrations_confirmToken_key" ON "landing_pre_registrations"("confirmToken");

-- CreateIndex
CREATE INDEX "landing_pre_registrations_createdAt_idx" ON "landing_pre_registrations"("createdAt");


-- Reprise des 3 textes déjà saisis au back-office (SiteContentTranslation)
-- vers leurs clés LandingText. `ctaLabel` était le bouton « prévenez-moi »,
-- d'où `hero.ctaSecondary`. Les anciennes lignes restent en place : la
-- landing déjà déployée les lit encore via /api/site-config.
INSERT INTO "landing_texts" ("id", "locale", "key", "value", "updatedAt")
SELECT gen_random_uuid()::text, t."locale", k."key", k."value", CURRENT_TIMESTAMP
FROM "site_content_translations" t
CROSS JOIN LATERAL (VALUES
  ('hero.title', t."heroTitle"),
  ('hero.lede', t."heroLede"),
  ('hero.ctaSecondary', t."ctaLabel")
) AS k("key", "value")
WHERE t."siteContentId" = 'default' AND btrim(k."value") <> ''
ON CONFLICT ("locale", "key") DO NOTHING;
