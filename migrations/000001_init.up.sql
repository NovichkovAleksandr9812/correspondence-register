CREATE SCHEMA correspondence;

CREATE TABLE correspondence.users (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    full_name VARCHAR(100) NOT NULL CHECK (char_length(full_name) BETWEEN 3 AND 100)
);

CREATE TABLE correspondence.letter (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    number BIGINT NOT NULL DEFAULT 1,
    date TIMESTAMPTZ NOT NULL,
    title VARCHAR(1000) NOT NULL CHECK (char_length(title) BETWEEN 1 AND 1000),
    user_id INTEGER NOT NULL REFERENCES correspondence.users(id)
);