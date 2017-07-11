FROM centos:7

MAINTAINER Hurng-Chun Lee <h.lee@donders.ru.nl>

RUN yum -y install epel-release wget curl nc which
RUN rpm --import https://packages.irods.org/irods-signing-key.asc \
 && wget -qO - https://packages.irods.org/renci-irods.yum.repo | tee /etc/yum.repos.d/renci-irods.yum.repo
RUN yum -y install irods-server irods-database-plugin-postgres irods-devel \
 irods-externals-clang3.8-0 irods-externals-cmake3.5.2-0.x86_64 \
 irods-externals-imagemagick7.0.3-0.x86_64 \
 && useradd -d /var/lib/irods irods \
 && yum clean all \
 && rm -rf /var/cache/yum/* \
 && rm -rf /tmp/*

RUN yum -y install sudo

## installing irods_training package
RUN yum -y install gcc gcc-c++ unzip openssl-devel rpm-build
COPY irods_training_installer.sh /
RUN chmod +x /irods_training_installer.sh && /irods_training_installer.sh

## environment variables for container runtime
ENV IRODS_ADMIN_USER=irods
ENV IRODS_ADMIN_PASS=test123
ENV IRODS_ZONE_NAME=rdmtst
ENV IRODS_ZONE_KEY=TEMPORARY_zone_key
ENV IRODS_ZONE_PORT=1247
ENV IRODS_NEGOTIATION_KEY=TEMPORARY_32byte_negotiation_key
ENV IRODS_ICAT_DBSERVER=icat-db
ENV IRODS_ICAT_DBPORT=5432
ENV IRODS_ICAT_DBNAME=ICAT
ENV IRODS_ICAT_DBUSER=irods
ENV IRODS_ICAT_DBPASS=test123
ENV IRODS_CONTROLPLANE_PORT=1248
ENV IRODS_CONTROLPLANE_KEY=TEMPORARY__32byte_ctrl_plane_key
ENV IRODS_DATA_PORT_RANGE_BEG=20000
ENV IRODS_DATA_PORT_RANGE_END=20199

## iRODS resource server names
ENV IRODS_RESOURCE_OL=irods-resource-ol
ENV IRODS_RESOURCE_NL=irods-resource-nl

## iRODS webdav server name
ENV IRODS_WEBDAV_HOST=webdav

## copy scripts
COPY genresp.sh docker-entrypoint.sh irods_login.sh mkresc.sh /
RUN chmod +x /genresp.sh /docker-entrypoint.sh /irods_login.sh /mkresc.sh

## data volumes
VOLUME "/etc/irods" "/var/lib/irods/iRODS/server/log" "/var/lib/irods/Vault"

## network ports
EXPOSE 4321 $IRODS_ZONE_PORT $IRODS_CONTROLPLANE_PORT $IRODS_DATA_PORT_RANGE_BEG-$IRODS_DATA_PORT_RANGE_END

## entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["irods"]
