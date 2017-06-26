#!/bin/bash

if [ "$1" == "irods" ]; then

    # Wait for iCAT to become available
    echo "waiting for netcat message from iCAT ..."
    nc -l -p 4321

    if [ -f /etc/irods/.provisioned ]; then

        echo "skipping iRODS provisioning ..."

        if [ ! -f /var/lib/irods/.irods/irods_environment.json ]; then
            mkdir -p /var/lib/irods/.irods
            cp /etc/irods/irods_environment.json /var/lib/irods/.irods/irods_environment.json
        fi
    else
        echo "provisioning iRODS resource ..."
        /genresp.sh /response.txt
        cat /response.txt | python /var/lib/irods/scripts/setup_irods.py

        cp /var/lib/irods/.irods/irods_environment.json /etc/irods/irods_environment.json

        touch /etc/irods/.provisioned
    fi

    chown -R irods:irods /var/lib/irods
    chown -R irods:irods /etc/irods

    echo "starting iRODS service ..."

    su - irods -c "/irods_login.sh ${IRODS_ADMIN_PASS}"

    /etc/init.d/irods restart

    echo "resource ${HOSTNAME} ready!"

    sleep infinity
fi

exec "$@"
