#!/bin/bash

: ${WANAMU_DB_DATA?:= "Db data location needed"}
: ${WANAMU_DB_SUPERUSER?:= "WANAMU_DB_SUPERUSER needed"}
: ${WANAMU_DB_SUPERPASSWORD?:= "WANAMU_DB_SUPERPASSWORD needed"}

cat <<EOF > docker-compose.yml
wanamudb:
  restart: always
  image: "api.wanamu.com:5043/wanamudb"
  ports:
    - 5432:5432
  environment:
    DB_NAME: wanamu
    POSTGRES_PASSWORD: $WANAMU_DB_SUPERUSER
    POSTGRES_USER: $WANAMU_DB_SUPERPASSWORD
    DB_USER:
    DB_PASS:
  volumes:
    - $WANAMU_DB_DATA:/var/lib/postgresql/data
    - /var/lib/postgresql/dumps:/var/lib/postgresql/dumps

EOF

