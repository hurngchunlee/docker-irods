FROM centos:7

# install required packages
RUN ( yum -y install epel-release wget \
                     patch sudo which nc \
                     git zlib \
                     openssl openssl-libs \
                     httpd mod_ssl ca-certificates)

# install iRODS repository
RUN rpm --import https://packages.irods.org/irods-signing-key.asc \
 && wget -qO - https://packages.irods.org/renci-irods.yum.repo | tee /etc/yum.repos.d/renci-irods.yum.repo

# create temporary directory
RUN ( mkdir -p /tmp )
WORKDIR /tmp

# install required iRODS runtime and libraries
RUN yum -y install irods-runtime irods-externals-boost1.60.0-0 irods-externals-jansson2.7-0

# install Davrods
ARG davrods_version=4.2_1.1.1
ARG davrods_github_tag=$davrods_version
RUN ( wget https://github.com/UtrechtUniversity/davrods/releases/download/$davrods_github_tag/davrods-$davrods_version-1.el7.centos.x86_64.rpm )
RUN ( rpm -ivh davrods-$davrods_version-1.el7.centos.x86_64.rpm )
RUN ( mv /etc/httpd/conf.d/davrods-vhost.conf /etc/httpd/conf.d/davrods-vhost.conf.org )

# cleanup RPMs
RUN ( yum clean all && rm -rf *.rpm )

# environment variables
ENV IRODS_ICAT_HOST=irods-icat
ENV IRODS_ZONE_PORT=1247
ENV IRODS_ZONE_NAME=rdmtst

COPY fix_irods_environment.py /
RUN chmod +x /fix_irods_environment.py

# mountable volumes for necessary configuration files
# the executable 'run-httpd.sh' expects the following files to be provided
# and will move them into proper locations before starting the HTTPd searvice
#
# The expected files:
#   - davrods-vhost.conf: the Apache configuration for the WebDAV vhost
#   - icat.pem: the public key for DavRods to connect to iCAT over SSL
#   - irods_environment.json: runtime environment of iRODS
#   - server.crt: certificate of the HTTPd/WebDAV service
#   - server.key: private key of the HTTPd/WebDAV service
#   - server-ca-chain.crt: chain of certificates used to sign the server.crt (not needed for self-signed certificate)
VOLUME [ "/config" ]

# start httpd
COPY run-httpd.sh /opt/run-httpd.sh
RUN ( chmod +x /opt/run-httpd.sh )
EXPOSE 443 4321
CMD ["/opt/run-httpd.sh"]
