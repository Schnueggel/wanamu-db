FROM postgres
ADD scripts/initdb.sh /docker-entrypoint-initdb.d/
