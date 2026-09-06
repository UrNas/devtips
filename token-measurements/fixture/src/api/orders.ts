import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listOrders(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM orders LIMIT 50");
}

export async function getOrders(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM orders WHERE id = $1", [id]);
}
