FROM postgres
ADD initdb.sh /docker-entrypoint-initdb.d/
