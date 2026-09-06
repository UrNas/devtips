import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listHealth(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM health LIMIT 50");
}

export async function getHealth(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM health WHERE id = $1", [id]);
}
