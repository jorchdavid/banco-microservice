CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    status VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reference VARCHAR(50) UNIQUE NOT NULL,
    account_id UUID NOT NULL,
    type VARCHAR(20) NOT NULL,
    amount NUMERIC(14,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);
