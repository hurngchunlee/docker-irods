#!/bin/bash

# genresp.sh
# Generates responses for iRODS' setup_irods.sh script.
# Zone SID, agent key, database admin, and admin password are all randomized.

RESPFILE=$1

SCHEMA_URI="file:///var/lib/irods/configuration_schemas" 

echo "irods" > $RESPFILE                          # service account user ID
echo "irods" >> $RESPFILE                         # service account group ID
echo "1"     >> $RESPFILE                         # service role: provider 
echo "PostgreSQL" >> $RESPFILE                    # database type 
echo $IRODS_ICAT_DBSERVER >> $RESPFILE            # database hostname
echo $IRODS_ICAT_DBPORT >> $RESPFILE              # database port
echo $IRODS_ICAT_DBNAME >> $RESPFILE              # database DB name
echo $IRODS_ICAT_DBUSER >> $RESPFILE              # database username
echo "yes" >> $RESPFILE                           # confirm database settings
echo $IRODS_ICAT_DBPASS >> $RESPFILE              # database password
echo "DCCN" >> $RESPFILE                          # database password salt
echo $IRODS_ZONE_NAME >> $RESPFILE                # zone name
echo $IRODS_ZONE_PORT >> $RESPFILE                # zone port 
echo $IRODS_DATA_PORT_RANGE_BEG >> $RESPFILE      # transport starting port #
echo $IRODS_DATA_PORT_RANGE_END >> $RESPFILE      # transport ending port #
echo $IRODS_CONTROLPLANE_PORT >> $RESPFILE        # control plane port
echo $SCHEMA_URI >> $RESPFILE                     # schema validation URI
echo $IRODS_ADMIN_USER >> $RESPFILE               # iRODS admin account name
echo "yes" >> $RESPFILE                           # confirm server settings
echo $IRODS_ZONE_KEY >> $RESPFILE                 # ZONE key
echo $IRODS_NEGOTIATION_KEY >> $RESPFILE          # negotiation key
echo $IRODS_CONTROLPLANE_KEY >> $RESPFILE         # control plane key
echo $IRODS_ADMIN_PASS >> $RESPFILE               # iRODS admin account password
echo "/var/lib/irods/Vault" >> $RESPFILE          # defautl vault path
echo "yes" >> $RESPFILE                           # confirm iRODS settings
