import test from "node:test";
import assert from "node:assert/strict";

test("backend configuration is documented without shipping secrets", async () => {
  const example = await import("node:fs/promises").then((fs) => fs.readFile(new URL("../.env.example", import.meta.url), "utf8"));
  assert.match(example, /OWNER_NOTIFICATION_EMAIL=imarnhowlader9@gmail.com/);
  assert.match(example, /RESEND_API_KEY=re_xxxxxxxxx/);
  assert.doesNotMatch(example, /re_[A-Za-z0-9]{20,}/);
});

test("production entry point and database migration are configured", async () => {
  const [manifest, schema, backend] = await Promise.all([
    import("node:fs/promises").then((fs) => fs.readFile(new URL("../package.json", import.meta.url), "utf8")),
    import("node:fs/promises").then((fs) => fs.readFile(new URL("../db/schema.sql", import.meta.url), "utf8")),
    import("node:fs/promises").then((fs) => fs.readFile(new URL("../server-postgres.js", import.meta.url), "utf8"))
  ]);
  assert.match(manifest, /"start"\s*:\s*"node server-postgres\.js"/);
  assert.match(schema, /firebase_uid TEXT NOT NULL/);
  assert.match(schema, /CREATE TABLE IF NOT EXISTS email_deliveries/);
  assert.match(backend, /verifyIdToken/);
  assert.match(backend, /app\.post\("\/api\/admin\/orders\/:id\/verify"/);
});
