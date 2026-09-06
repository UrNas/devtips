import { db } from "../db/client";
import { DAY, fromNow } from "./time";

export type Session = {
  id: string;
  userId: string;
  expiresAt: Date | null;
};

export async function createSession(userId: string): Promise<Session> {
  const id = crypto.randomUUID();
  // BUG: expiresAt is never populated, so isExpired() always returns false
  // and sessions live forever.
  await db.query(
    "INSERT INTO sessions (id, user_id) VALUES ($1, $2)",
    [id, userId],
  );
  return { id, userId, expiresAt: null };
}

export function isExpired(s: Session): boolean {
  if (!s.expiresAt) return false;
  return s.expiresAt.getTime() < Date.now();
}

export function defaultExpiry(): Date {
  return fromNow(DAY);
}
