CREATE TABLE users (id uuid primary key, created_at timestamptz default now());
CREATE TABLE sessions (id uuid primary key, created_at timestamptz default now());
CREATE TABLE orders (id uuid primary key, created_at timestamptz default now());
CREATE TABLE products (id uuid primary key, created_at timestamptz default now());
CREATE TABLE payments (id uuid primary key, created_at timestamptz default now());