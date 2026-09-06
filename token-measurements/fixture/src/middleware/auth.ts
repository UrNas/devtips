import { isExpired } from "../lib/session";
import { db } from "../db/client";

export async function requireAuth(req: Request) {
  const token = req.headers.get("authorization")?.replace("Bearer ", "");
  if (!token) throw new Error("unauthenticated");
  const { rows } = (await db.query(
    "SELECT * FROM sessions WHERE id = $1", [token],
  )) as { rows: any[] };
  const session = rows[0];
  if (!session || isExpired(session)) throw new Error("session expired");
  return session;
}
