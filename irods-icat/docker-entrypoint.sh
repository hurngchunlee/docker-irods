#!/bin/bash

if [ "$1" == "irods" ]; then

    # Wait for postgres to become available
    while ! nc -w 1 ${IRODS_ICAT_DBSERVER} ${IRODS_ICAT_DBPORT} &> /dev/null; do
        echo "waiting for database server ${IRODS_ICAT_DBSERVER} ..."
        sleep 5
    done

    if [ -f /etc/irods/.provisioned ]; then

        echo "skipping iRODS provisioning ..."

        if [ ! -f /var/lib/irods/.irods/irods_environment.json ]; then
            mkdir -p /var/lib/irods/.irods
            cp /etc/irods/irods_environment.json /var/lib/irods/.irods/irods_environment.json
        fi

        if [ ! -f /var/lib/irods/.odbc.ini ]; then
            cp /etc/irods/.odbc.ini /var/lib/irods/.odbc.ini
        fi

    else

        echo "provisioning iRODS ..."
        /genresp.sh /response.txt

        cat /response.txt | python /var/lib/irods/scripts/setup_irods.py

        cp /var/lib/irods/.irods/irods_environment.json /etc/irods/irods_environment.json
        cp /var/lib/irods/.odbc.ini /etc/irods/.odbc.ini

        touch /etc/irods/.provisioned
    fi

    chown -R irods:irods /var/lib/irods
    chown -R irods:irods /etc/irods

    /etc/init.d/irods restart

    # Wait for iCAT port to become available
    while ! nc -w 1 $(hostname) 1247 &> /dev/null; do
        echo "waiting for icat server ..."
        sleep 5
    done
    sleep 5

    su - irods -c "/irods_login.sh ${IRODS_ADMIN_PASS}"

    # create resources
    su - irods -c "IRODS_RESOURCE_OL=${IRODS_RESOURCE_OL} IRODS_RESOURCE_NL=${IRODS_RESOURCE_NL} /mkresc.sh"

    echo "kickoff ${IRODS_RESOURCE_OL}" | nc ${IRODS_RESOURCE_OL} 4321
    echo "kickoff ${IRODS_RESOURCE_NL}" | nc ${IRODS_RESOURCE_NL} 4321

    echo "iCAT ${HOSTNAME} ready!"

    sleep infinity
fi

exec "$@"
