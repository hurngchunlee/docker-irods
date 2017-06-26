#!/bin/bash

if [ -f /etc/irods/.resc_provisioned ]; then

    echo "resource hierachy already provisioned."
    ilsresc --tree

else

    ## create the following resource hierarchy:
    #
    # replResc:replication
    # ├── passRescNL:passthru
    # │   └── randRescNL:random
    # │       ├── passRescNL_1:passthru
    # │       │   └── vaultNL_1:unixfilesystem
    # │       └── passRescNL_2:passthru
    # │           └── vaultNL_2:unixfilesystem
    # └── passRescOL:passthru
    #     └── randRescOL:random
    #         ├── passRescOL_1:passthru
    #         │   └── vaultOL_1:unixfilesystem
    #         └── passRescOL_2:passthru
    #             └── vaultOL_2:unixfilesystem

    iadmin mkresc replResc replication

    iadmin mkresc passRescOL passthru '' 'write=1.0;read=0.5'
    iadmin mkresc randRescOL random
    iadmin mkresc passRescOL_1 passthru
    iadmin mkresc vaultOL_1 unixfilesystem ${IRODS_RESOURCE_OL}:/var/lib/irods/Vault/1
    iadmin mkresc passRescOL_2 passthru
    iadmin mkresc vaultOL_2 unixfilesystem ${IRODS_RESOURCE_OL}:/var/lib/irods/Vault/2

    iadmin mkresc passRescNL passthru '' 'read=1.0;write=0.5'
    iadmin mkresc randRescNL random
    iadmin mkresc passRescNL_1 passthru
    iadmin mkresc vaultNL_1 unixfilesystem ${IRODS_RESOURCE_NL}:/var/lib/irods/Vault/1
    iadmin mkresc passRescNL_2 passthru
    iadmin mkresc vaultNL_2 unixfilesystem ${IRODS_RESOURCE_NL}:/var/lib/irods/Vault/2

    iadmin addchildtoresc passRescOL_1 vaultOL_1
    iadmin addchildtoresc passRescOL_2 vaultOL_2
    iadmin addchildtoresc randRescOL passRescOL_1
    iadmin addchildtoresc randRescOL passRescOL_2

    iadmin addchildtoresc passRescNL_1 vaultNL_1
    iadmin addchildtoresc passRescNL_2 vaultNL_2
    iadmin addchildtoresc randRescNL passRescNL_1
    iadmin addchildtoresc randRescNL passRescNL_2

    iadmin addchildtoresc passRescOL randRescOL
    iadmin addchildtoresc passRescNL randRescNL

    iadmin addchildtoresc replResc passRescOL
    iadmin addchildtoresc replResc passRescNL

    touch /etc/irods/.resc_provisioned

fi
