# debian based PostgreSQL container from docker hub
FROM postgres:9.6.3
RUN if [ ! -d /docker-entrypoint-initdb.d ]; then mkdir /docker-entrypoint-initdb.d; fi
COPY init-icat-db.sh /docker-entrypoint-initdb.d
