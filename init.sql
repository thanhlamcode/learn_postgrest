-- Create schema API
CREATE SCHEMA IF NOT EXISTS api;

-- Tạo bảng mẫu
CREATE TABLE IF NOT EXISTS api.todos (
 id SERIAL PRIMARY KEY,
 done BOOLEAN NOT NULL DEFAULT FALSE,
 task TEXT NOT NULL,
 due timestamptz
);

INSERT INTO api.todos (task) VALUES
('finish tutorial 0'), ('pat self on back');

DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'web_anon') THEN
CREATE ROLE web_anon NOLOGIN;
END IF;
END$$;

GRANT USAGE ON SCHEMA api TO web_anon;
GRANT SELECT ON api.todos TO web_anon;

DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticator') THEN
CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'mysecretpassword';
END IF;
END$$;

GRANT web_anon TO authenticator;
