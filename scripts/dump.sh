#!/usr/bin/env bash

: ${DB_NAME:=wanamu}
: ${POSTGRES_USER?:="Postgres super user"}
: ${POSTGRES_PASSWORD?:="Postgres super password"}
: ${PGDUMPS:=/var/pgdumps}

chown -R postgres "$PGDUMPS"

if [ $# -ne 1 ]
  then
    echo "Invalid arguments supplied"
    echo "Argument dump filename needed"
    exit 0
fi

gosu postgres pg_dump $DB_NAME -f "$PGDUMPS/$1"
