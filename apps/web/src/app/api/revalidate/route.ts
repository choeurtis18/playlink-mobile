import { timingSafeEqual } from "node:crypto";
import { revalidateTag } from "next/cache";
import { NextResponse } from "next/server";
import { CONTENT_TAGS, type ContentTag } from "@/lib/backoffice";

/** Appelé par le back-office après chaque modification : invalide les
 * données en cache et les pages qui en dépendent. Protégé par le même
 * secret que les écritures (LANDING_API_SECRET). */
export async function POST(req: Request) {
  const expected = process.env.LANDING_API_SECRET;
  if (!expected) return NextResponse.json({ error: "unavailable" }, { status: 503 });
  const given = Buffer.from(req.headers.get("authorization")?.replace(/^Bearer /, "") ?? "");
  const secret = Buffer.from(expected);
  if (given.length !== secret.length || !timingSafeEqual(given, secret)) {
    return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  }

  const body = (await req.json().catch(() => null)) as { tags?: unknown } | null;
  const asked = Array.isArray(body?.tags) ? body.tags : CONTENT_TAGS;
  const tags = asked.filter((t): t is ContentTag => (CONTENT_TAGS as readonly unknown[]).includes(t));
  for (const tag of tags) revalidateTag(tag);
  return NextResponse.json({ ok: true, revalidated: tags });
}
