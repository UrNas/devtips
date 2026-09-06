import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listPayments(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM payments LIMIT 50");
}

export async function getPayments(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM payments WHERE id = $1", [id]);
}
