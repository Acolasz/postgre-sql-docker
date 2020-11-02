#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER docker;
	CREATE DATABASE docker;
	GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
	CREATE TABLE IF NOT EXISTS products (
		id serial PRIMARY KEY, 
		name VARCHAR(45) UNIQUE NOT NULL
	);
EOSQL