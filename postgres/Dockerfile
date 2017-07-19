# debian based PostgreSQL container from docker hub
FROM postgres:9.6.3
RUN if [ ! -d /docker-entrypoint-initdb.d ]; then mkdir /docker-entrypoint-initdb.d; fi

# environment variables used for initialising iCAT database
ENV IRODS_ICAT_DBNAME=ICAT
ENV IRODS_ICAT_DBUSER=icat
ENV IRODS_ICAT_DBPASS=test123

COPY init-icat-db.sh /docker-entrypoint-initdb.d
