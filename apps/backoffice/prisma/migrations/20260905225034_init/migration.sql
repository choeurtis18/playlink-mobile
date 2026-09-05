-- CreateEnum
CREATE TYPE "Tier" AS ENUM ('free', 'premium');

-- CreateTable
CREATE TABLE "games" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "colorMain" TEXT NOT NULL,
    "colorSecondary" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "order" INTEGER NOT NULL DEFAULT 0,
    "originalLocale" TEXT NOT NULL DEFAULT 'fr',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_translations" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "game_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_rules" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "rules" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_rules_translations" (
    "id" TEXT NOT NULL,
    "rulesId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "rules" TEXT NOT NULL,

    CONSTRAINT "game_rules_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_rule_slides" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "imageRef" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "game_rule_slides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_rule_slide_translations" (
    "id" TEXT NOT NULL,
    "slideId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,

    CONSTRAINT "game_rule_slide_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "order" INTEGER NOT NULL DEFAULT 0,
    "tier" "Tier" NOT NULL DEFAULT 'free',
    "originalLocale" TEXT NOT NULL DEFAULT 'fr',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "category_translations" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "category_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cards" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "intensity" INTEGER NOT NULL DEFAULT 3,
    "tags" TEXT[],
    "canonicalTags" TEXT[],
    "active" BOOLEAN NOT NULL DEFAULT true,
    "order" INTEGER NOT NULL DEFAULT 0,
    "tier" "Tier" NOT NULL DEFAULT 'free',
    "originalLocale" TEXT NOT NULL DEFAULT 'fr',
    "sourceCustomCardId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "cards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "card_translations" (
    "id" TEXT NOT NULL,
    "cardId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "text" TEXT NOT NULL,

    CONSTRAINT "card_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "badges" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "icon" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "badges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "badge_translations" (
    "id" TEXT NOT NULL,
    "badgeId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "badge_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "legal_contents" (
    "id" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'fr',
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "legal_contents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "content_releases" (
    "id" SERIAL NOT NULL,
    "version" INTEGER NOT NULL,
    "snapshotUrl" TEXT NOT NULL,
    "changelog" TEXT,
    "publishedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "content_releases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "accounts" (
    "id" TEXT NOT NULL,
    "clerkId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'fr',
    "premiumUntil" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profiles" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "avatar" TEXT,
    "tagScores" JSONB NOT NULL DEFAULT '{}',
    "localId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "synced_sessions" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "clientSessionId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'fr',
    "playerCount" INTEGER NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL,
    "finishedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "synced_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "synced_session_players" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "profileId" TEXT NOT NULL,
    "score" INTEGER NOT NULL DEFAULT 0,
    "tagScoresGained" JSONB NOT NULL DEFAULT '{}',

    CONSTRAINT "synced_session_players_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "earned_badges" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "badgeKey" TEXT NOT NULL,
    "earnedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "earned_badges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "card_likes" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "cardId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "card_likes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "custom_cards" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "gameId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "intensity" INTEGER NOT NULL DEFAULT 3,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "custom_cards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_users" (
    "id" TEXT NOT NULL,
    "clerkId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'editor',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "admin_users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hourly_stats" (
    "id" TEXT NOT NULL,
    "bucket" TIMESTAMP(3) NOT NULL,
    "metric" TEXT NOT NULL,
    "value" INTEGER NOT NULL,
    "dims" JSONB,

    CONSTRAINT "hourly_stats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_stats" (
    "id" TEXT NOT NULL,
    "day" DATE NOT NULL,
    "metric" TEXT NOT NULL,
    "value" INTEGER NOT NULL,
    "dims" JSONB,

    CONSTRAINT "daily_stats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "adminId" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "meta" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "games_name_key" ON "games"("name");

-- CreateIndex
CREATE UNIQUE INDEX "games_slug_key" ON "games"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "game_translations_gameId_locale_key" ON "game_translations"("gameId", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "game_rules_gameId_key" ON "game_rules"("gameId");

-- CreateIndex
CREATE UNIQUE INDEX "game_rules_translations_rulesId_locale_key" ON "game_rules_translations"("rulesId", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "game_rule_slide_translations_slideId_locale_key" ON "game_rule_slide_translations"("slideId", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "categories_gameId_slug_key" ON "categories"("gameId", "slug");

-- CreateIndex
CREATE UNIQUE INDEX "category_translations_categoryId_locale_key" ON "category_translations"("categoryId", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "cards_sourceCustomCardId_key" ON "cards"("sourceCustomCardId");

-- CreateIndex
CREATE INDEX "cards_categoryId_active_idx" ON "cards"("categoryId", "active");

-- CreateIndex
CREATE INDEX "cards_intensity_idx" ON "cards"("intensity");

-- CreateIndex
CREATE UNIQUE INDEX "card_translations_cardId_locale_key" ON "card_translations"("cardId", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "badges_key_key" ON "badges"("key");

-- CreateIndex
CREATE UNIQUE INDEX "badge_translations_badgeId_locale_key" ON "badge_translations"("badgeId", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "legal_contents_key_locale_key" ON "legal_contents"("key", "locale");

-- CreateIndex
CREATE UNIQUE INDEX "content_releases_version_key" ON "content_releases"("version");

-- CreateIndex
CREATE UNIQUE INDEX "accounts_clerkId_key" ON "accounts"("clerkId");

-- CreateIndex
CREATE UNIQUE INDEX "accounts_email_key" ON "accounts"("email");

-- CreateIndex
CREATE UNIQUE INDEX "profiles_accountId_localId_key" ON "profiles"("accountId", "localId");

-- CreateIndex
CREATE INDEX "synced_sessions_accountId_finishedAt_idx" ON "synced_sessions"("accountId", "finishedAt");

-- CreateIndex
CREATE UNIQUE INDEX "synced_sessions_accountId_clientSessionId_key" ON "synced_sessions"("accountId", "clientSessionId");

-- CreateIndex
CREATE UNIQUE INDEX "synced_session_players_sessionId_profileId_key" ON "synced_session_players"("sessionId", "profileId");

-- CreateIndex
CREATE UNIQUE INDEX "earned_badges_accountId_badgeKey_key" ON "earned_badges"("accountId", "badgeKey");

-- CreateIndex
CREATE INDEX "card_likes_cardId_idx" ON "card_likes"("cardId");

-- CreateIndex
CREATE UNIQUE INDEX "card_likes_accountId_cardId_key" ON "card_likes"("accountId", "cardId");

-- CreateIndex
CREATE INDEX "custom_cards_accountId_idx" ON "custom_cards"("accountId");

-- CreateIndex
CREATE UNIQUE INDEX "admin_users_clerkId_key" ON "admin_users"("clerkId");

-- CreateIndex
CREATE UNIQUE INDEX "admin_users_email_key" ON "admin_users"("email");

-- CreateIndex
CREATE INDEX "hourly_stats_metric_bucket_idx" ON "hourly_stats"("metric", "bucket");

-- CreateIndex
CREATE UNIQUE INDEX "hourly_stats_bucket_metric_key" ON "hourly_stats"("bucket", "metric");

-- CreateIndex
CREATE INDEX "daily_stats_metric_day_idx" ON "daily_stats"("metric", "day");

-- CreateIndex
CREATE UNIQUE INDEX "daily_stats_day_metric_key" ON "daily_stats"("day", "metric");

-- CreateIndex
CREATE INDEX "audit_logs_entity_entityId_idx" ON "audit_logs"("entity", "entityId");

-- CreateIndex
CREATE INDEX "audit_logs_createdAt_idx" ON "audit_logs"("createdAt");

-- AddForeignKey
ALTER TABLE "game_translations" ADD CONSTRAINT "game_translations_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_rules" ADD CONSTRAINT "game_rules_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_rules_translations" ADD CONSTRAINT "game_rules_translations_rulesId_fkey" FOREIGN KEY ("rulesId") REFERENCES "game_rules"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_rule_slides" ADD CONSTRAINT "game_rule_slides_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_rule_slide_translations" ADD CONSTRAINT "game_rule_slide_translations_slideId_fkey" FOREIGN KEY ("slideId") REFERENCES "game_rule_slides"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories" ADD CONSTRAINT "categories_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "category_translations" ADD CONSTRAINT "category_translations_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cards" ADD CONSTRAINT "cards_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cards" ADD CONSTRAINT "cards_sourceCustomCardId_fkey" FOREIGN KEY ("sourceCustomCardId") REFERENCES "custom_cards"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "card_translations" ADD CONSTRAINT "card_translations_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "cards"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "badge_translations" ADD CONSTRAINT "badge_translations_badgeId_fkey" FOREIGN KEY ("badgeId") REFERENCES "badges"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "synced_sessions" ADD CONSTRAINT "synced_sessions_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "synced_session_players" ADD CONSTRAINT "synced_session_players_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "synced_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "synced_session_players" ADD CONSTRAINT "synced_session_players_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "earned_badges" ADD CONSTRAINT "earned_badges_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "earned_badges" ADD CONSTRAINT "earned_badges_badgeKey_fkey" FOREIGN KEY ("badgeKey") REFERENCES "badges"("key") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "card_likes" ADD CONSTRAINT "card_likes_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "card_likes" ADD CONSTRAINT "card_likes_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "cards"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custom_cards" ADD CONSTRAINT "custom_cards_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custom_cards" ADD CONSTRAINT "custom_cards_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "custom_cards" ADD CONSTRAINT "custom_cards_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
