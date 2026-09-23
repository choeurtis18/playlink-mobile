-- AlterTable
ALTER TABLE "categories" ADD COLUMN     "previewEligible" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "site_content" (
    "id" TEXT NOT NULL DEFAULT 'default',
    "releaseDate" TIMESTAMP(3),
    "heroImageUrl" TEXT,
    "heroImageAlt" TEXT,
    "instagramUrl" TEXT,
    "tiktokUrl" TEXT,
    "redditUrl" TEXT,
    "featuredGameIds" TEXT[],
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "site_content_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "site_content_translations" (
    "id" TEXT NOT NULL,
    "siteContentId" TEXT NOT NULL,
    "locale" TEXT NOT NULL,
    "heroTitle" TEXT NOT NULL,
    "heroLede" TEXT NOT NULL,
    "ctaLabel" TEXT NOT NULL,

    CONSTRAINT "site_content_translations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "site_content_translations_siteContentId_locale_key" ON "site_content_translations"("siteContentId", "locale");

-- AddForeignKey
ALTER TABLE "site_content_translations" ADD CONSTRAINT "site_content_translations_siteContentId_fkey" FOREIGN KEY ("siteContentId") REFERENCES "site_content"("id") ON DELETE CASCADE ON UPDATE CASCADE;
