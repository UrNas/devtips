import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listUsers(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM users LIMIT 50");
}

export async function getUsers(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM users WHERE id = $1", [id]);
}
