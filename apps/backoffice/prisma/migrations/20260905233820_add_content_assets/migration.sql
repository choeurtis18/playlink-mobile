-- CreateTable
CREATE TABLE "content_assets" (
    "ref" TEXT NOT NULL,
    "file" TEXT NOT NULL,
    "hash" TEXT NOT NULL,
    "bytes" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "content_assets_pkey" PRIMARY KEY ("ref")
);
