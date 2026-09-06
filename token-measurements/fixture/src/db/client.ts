export const db = {
  async query(sql: string, params: unknown[] = []) {
    return { rows: [], sql, params };
  },
};
