#!/bin/bash

: ${WU_DB_USER:=wanamu}
: ${WU_DB_PASSWORD:=wanamu}
: ${WU_DB_NAME:=wanamu}
: ${DB_ENCODING:=UTF-8}

{ gosu postgres postgres --single -jE <<-EOSQL
    CREATE USER "$WU_DB_USER" WITH PASSWORD '$WU_DB_PASSWORD';
EOSQL
} && { gosu postgres postgres --single -jE <<-EOSQL
    CREATE DATABASE "$WU_DB_NAME" WITH OWNER="$WU_DB_USER" TEMPLATE=template0 ENCODING='$DB_ENCODING';
EOSQL
} && { gosu postgres postgres --single -jE <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE "$WU_DB_NAME" TO "$WU_DB_USER";
EOSQL
} && { gosu postgres postgres --single -jE $WU_DB_NAME <<-EOSQL
    ALTER DEFAULT PRIVILEGES
    IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO "$DB_USER";
EOSQL
} && { gosu postgres postgres --single -jE $WU_DB_NAME <<-EOSQL
    ALTER DEFAULT PRIVILEGES
    IN SCHEMA public
    GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO "$WU_DB_USER";
EOSQL
}