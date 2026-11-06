CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  firebase_uid TEXT NOT NULL,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  phone TEXT NOT NULL,
  product_name TEXT NOT NULL,
  package_name TEXT NOT NULL,
  amount INTEGER NOT NULL CHECK (amount > 0),
  payment_method TEXT NOT NULL CHECK (payment_method IN ('bKash', 'Nagad', 'Sun Money')),
  transaction_id TEXT NOT NULL,
  account_type TEXT,
  account_info_json JSONB,
  description TEXT,
  payment_status TEXT NOT NULL DEFAULT 'Pending',
  order_status TEXT NOT NULL DEFAULT 'Awaiting payment verification',
  document_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  verified_at TIMESTAMPTZ
);
CREATE UNIQUE INDEX IF NOT EXISTS orders_transaction_key ON orders(phone, transaction_id);
CREATE INDEX IF NOT EXISTS orders_firebase_uid_idx ON orders(firebase_uid);

CREATE TABLE IF NOT EXISTS email_deliveries (
  id BIGSERIAL PRIMARY KEY,
  order_id TEXT NOT NULL REFERENCES orders(id),
  recipient TEXT NOT NULL,
  kind TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  attempts INTEGER NOT NULL DEFAULT 0,
  last_error TEXT,
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(order_id, recipient, kind)
);
