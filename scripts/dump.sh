#!/usr/bin/env bash

: ${WU_DB_NAME:=wanamu}
: ${POSTGRES_USER?:="Postgres super user"}
: ${POSTGRES_PASSWORD?:="Postgres super password"}
: ${WU_DB_DUMP:=/var/pgdumps}

chown -R postgres "$WU_DB_DUMP"

if [ $# -ne 1 ]
  then
    echo "Invalid arguments supplied"
    echo "Argument dump filename needed"
    exit 0
fi

gosu postgres pg_dump $WU_DB_NAME -f "$WU_DB_DUMP/$1"
