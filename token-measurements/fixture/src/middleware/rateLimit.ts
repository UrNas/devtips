const hits = new Map<string, number>();
export function rateLimit(key: string, max = 100) {
  const n = (hits.get(key) ?? 0) + 1;
  hits.set(key, n);
  return n <= max;
}
