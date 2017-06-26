# iRODS Docker Containers

This repository contains containerised iRODS components:

- `icat-db`: PostgreSQL
- `irods-icat`: iRODS iCAT server
- `irods-resc`: iRODS resource servers

The intetion is to provide a functioning iRODS instanace with the following resource hierachy:

```
replResc:replication
├── passRescNL:passthru
│   └── randRescNL:random
│       ├── passRescNL_1:passthru
│       │   └── vaultNL_1:unixfilesystem
│       └── passRescNL_2:passthru
│           └── vaultNL_2:unixfilesystem
└── passRescOL:passthru
    └── randRescOL:rand 
    ├── passRescOL_1:passthru
    │   └── vaultOL_1:unixfilesystem
    └── passRescOL_2:passthru
    └── vaultOL_2:unixfilesystem
```

## build and run containers

The three iRODS components are built and orchestrated via `docker-compose`.  To build the containers, do

```bash
$ docker-compose --build --force-rm
```

To run and orchestrate the containers, use

```bash
$ docker-compose up
```

## data persistency

Each container exposes volumes for data persistency.  The list of volumes are provided in the table below:

| container  | path in container               | usage                         |
|------------|---------------------------------|-------------------------------|
| icat-db    | /var/lib/postgresql/data        | database storage              |
| irods-icat | /etc/irods                      | iCAT configuration            |
| irods-icat | /var/lib/irods/iRODS/server/log | iCAT server log               |
| irods-resc | /etc/irods                      | resource server configuration |
| irods-resc | /var/lib/irods/iRODS/server/log | resource server log           |
| irods-resc | /var/lib/irods/Vault            | resource server data vault    |

For iRODS services, the setup script (`/var/lib/irods/scripts/setup_irods.py`) is only executed when the file `/etc/irods/.provisioned` is not presented.  The file `/etc/irods/.provisioned` is also created when the setup script is executed successfully.

## environment variables

There are several environment variables can be set for setting up iRODS.  The variables are feeded into the iRODS setup script (`/var/lib/irods/scripts/setup_irods.py`) for the first startup.  They are summarised below:

|   variable name           | default value                    |  container |
|---------------------------|----------------------------------|------------|
| IRODS_ICAT_DBSERVER       | icat-db                          | irods-icat |
| IRODS_ICAT_DBPORT         | 5432                             | irods-icat |
| IRODS_ICAT_DBNAME         | ICAT                             | irods-icat |
| IRODS_ICAT_DBUSER         | irods                            | irods-icat |  
| IRODS_ICAT_DBPASS         | test123                          | irods-icat |
| IRODS_RESOURCE_OL         | irods-resc-ol                    | irods-icat |
| IRODS_RESOURCE_NL         | irods-resc-nl                    | irods-icat | 
| IRODS_ZONE_NAME           | rdmtst                           | irods-icat, irods-resc |
| IRODS_ZONE_PORT           | 1247                             | irods-icat, irods-resc |
| IRODS_DATA_PORT_RANGE_BEG | 20000                            | irods-icat, irods-resc |
| IRODS_DATA_PORT_RANGE_END | 20199                            | irods-icat, irods-resc |
| IRODS_CONTROLPLAN_PORT    | 1248                             | irods-icat, irods-resc |
| IRODS_ADMIN_USER          | irods                            | irods-icat, irods-resc |
| IRODS_ADMIN_PASS          | test123                          | irods-icat, irods-resc |
| IRODS_ZONE_KEY            | TEMPORARY_zone_key               | irods-icat, irods-resc |
| IRODS_NEGOTIATION_KEY     | TEMPORARY_32byte_negotiation_key | irods-icat, irods-resc |
| IRODS_CONTROLPLANE_KEY    | TEMPORARY__32byte_ctrl_plane_key | irods-icat, irods-resc |

## PostgreSQL server variables

The environment variables IRODS_ICAT_DB(SERVER|PORT|NAME|USER|PASS) have to match the setup in the `icat-db` container that is based on the official [PostgreSQL container](https://hub.docker.com/r/_/postgres/).
