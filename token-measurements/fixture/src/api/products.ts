import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listProducts(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM products LIMIT 50");
}

export async function getProducts(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM products WHERE id = $1", [id]);
}
