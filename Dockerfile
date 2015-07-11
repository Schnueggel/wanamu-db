#@IgnoreInspection BashAddShebang
FROM postgres

RUN mkdir /var/pgdumps
VOLUME /var/pgdumps
ENV PGDUMPS=/var/pgdumps

RUN mkdir /scripts

ADD scripts/dump.sh /scripts/
ADD scripts/initdb.sh /docker-entrypoint-initdb.d/
