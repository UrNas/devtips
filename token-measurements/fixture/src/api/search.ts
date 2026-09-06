import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listSearch(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM search LIMIT 50");
}

export async function getSearch(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM search WHERE id = $1", [id]);
}
