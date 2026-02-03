-- CREATE DATABASE diam_template;

CREATE TYPE user_type AS ENUM ('regular', 'bot', 'guest');

CREATE TABLE IF NOT EXISTS users (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username_hash BYTEA UNIQUE,
    email_hash BYTEA,
    phone_hash BYTEA,
    seed_phrase_hash BYTEA,
    opaque_record BYTEA NOT NULL,
    server_public_key BYTEA NOT NULL,
    user_type user_type NOT NULL DEFAULT 'regular',
    is_verified BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sessions (
    uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_uuid UUID NOT NULL REFERENCES users(uuid) ON DELETE CASCADE,
    session_key_hash BYTEA NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_uuid, session_key_hash)
);

CREATE INDEX IF NOT EXISTS idx_users_username_hash ON users(username_hash);
CREATE INDEX IF NOT EXISTS idx_users_email_hash ON users(email_hash);
CREATE INDEX IF NOT EXISTS idx_users_phone_hash ON users(phone_hash);
CREATE INDEX IF NOT EXISTS idx_users_seed_hash ON users(seed_phrase_hash);
CREATE INDEX IF NOT EXISTS idx_sessions_user_uuid ON sessions(user_uuid);
CREATE INDEX IF NOT EXISTS idx_sessions_expires_at ON sessions(expires_at);

/*
    update pg_database
       set datistemplate = true,
           datallowconn = false
    where  datname = 'diam_template';
*/
