import { db } from "../db/client";
import { requireAuth } from "../middleware/auth";

export async function listWebhooks(req: Request) {
  await requireAuth(req);
  return db.query("SELECT * FROM webhooks LIMIT 50");
}

export async function getWebhooks(req: Request, id: string) {
  await requireAuth(req);
  return db.query("SELECT * FROM webhooks WHERE id = $1", [id]);
}
