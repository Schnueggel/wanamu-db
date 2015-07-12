#!/bin/bash

: ${DB_USER:=wanamu}
: ${DB_PASSWORD:=wanamu}
: ${DB_NAME:=wanamu}
: ${DB_ENCODING:=UTF-8}

{ gosu postgres postgres --single -jE <<-EOSQL
    CREATE USER "$DB_USER" WITH PASSWORD '$DB_PASSWORD';
EOSQL
} && { gosu postgres postgres --single -jE <<-EOSQL
    CREATE DATABASE "$DB_NAME" WITH OWNER="$DB_USER" TEMPLATE=template0 ENCODING='$DB_ENCODING';
EOSQL
} && { gosu postgres postgres --single -jE <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE "$DB_NAME" TO "$DB_USER";
EOSQL
} && { gosu postgres postgres --single -jE $DB_NAME <<-EOSQL
    ALTER DEFAULT PRIVILEGES
    IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "$DB_USER";
EOSQL
} && { gosu postgres postgres --single -jE $DB_NAME <<-EOSQL
    ALTER DEFAULT PRIVILEGES
    IN SCHEMA public
    GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO "$DB_USER";
EOSQL
}