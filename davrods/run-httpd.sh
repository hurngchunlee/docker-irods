#!/bin/bash

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/* /tmp/httpd*

# settle files for running the service
if [ -f /config/icat.pem ]; then
    cp /config/icat.pem /etc/httpd/irods/icat.pem
    chmod 0644 /etc/httpd/irods/icat.pem
fi

if [ -f /config/davrods-vhost.conf ]; then
    if [ -f /etc/httpd/conf.d/davrods-vhost.conf ]; then
        cp /etc/httpd/conf.d/davrods-vhost.conf /etc/httpd/conf.d/davrods-vhost.conf.org
    fi
    cp /config/davrods-vhost.conf /etc/httpd/conf.d/davrods-vhost.conf

    sed -i "s/tempZone/${IRODS_ZONE_NAME}/" /etc/httpd/conf.d/davrods-vhost.conf
    sed -i "s/ServerName davrods/ServerName ${HOSTNAME}/" /etc/httpd/conf.d/davrods-vhost.conf
    sed -i "s/DavRodsServer icat 1247/DavRodsServer ${IRODS_ICAT_HOST} ${IRODS_ZONE_PORT}/" /etc/httpd/conf.d/davrods-vhost.conf

    chmod 0644 /etc/httpd/conf.d/davrods-vhost.conf

    if [ -f /etc/httpd/conf.d/ssl.conf ]; then
        mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.bak
    fi
fi

if [ -f /config/irods_environment.json ]; then
    cp /config/irods_environment.json /etc/httpd/irods/irods_environment.json
    /fix_irods_environment.py
    chmod 0644 /etc/httpd/irods/irods_environment.json
fi

if [ -f /config/server.crt ]; then
    cp /config/server.crt /etc/httpd/irods/server.crt
    chmod 0444 /etc/httpd/irods/server.crt
fi

if [ -f /config/server.key ]; then
    cp /config/server.key /etc/httpd/irods/server.key
    chmod 0400 /etc/httpd/irods/server.key
fi

if [ -f /config/server-ca-chain.crt ]; then
    cp /config/server-ca-chain.crt /etc/httpd/irods/server-ca-chain.crt
    chmod 0444 /etc/httpd/irods/server-ca-chain.crt
fi

# Wait for iCAT to become available
echo "Waiting for netcat message from iCAT ..."
nc -l -p 4321

# start the apache daemon
## TODO: report this symbolic link workaround to DavRODS team
if [ -f /usr/lib/libirods_client.so ]; then
    ln -s /usr/lib/libirods_client.so /usr/lib64/libirods_client.so.4.2.0
fi

exec /usr/sbin/apachectl -DFOREGROUND
