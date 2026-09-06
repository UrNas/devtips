import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listSessions(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM sessions LIMIT 50");
}

export async function getSessions(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM sessions WHERE id = $1", [id]);
}
