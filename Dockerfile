#@IgnoreInspection BashAddShebang
FROM postgres

RUN mkdir /var/lib/postgresql/dump
VOLUME /var/lib/postgresql/dump
ENV PGDUMPS=/var/lib/postgresql/dump

RUN mkdir /scripts

ADD scripts/dump.sh /scripts/
ADD scripts/initdb.sh /docker-entrypoint-initdb.d/
