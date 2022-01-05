#!/bin/bash
## Prepare noisecapture database
## an empty postgis database is required
## The following steps were used to save disk space.
## since no new data will be added, the foreign key constraints are not required

# Recreate the schema without loading the data
# This commands need to know the postgres user password
sudo -u postgres /usr/lib/postgresql/14/bin/pg_restore --schema-only -d noisecapture -W ~/dump-noisecapture-29_08_2017to28_08_2020_pgv10.15_postgisv2.5.backup

# DROP Foreign key Constraints to save disk space
#sudo -u postgres psql -U postgres -d noisecapture -a -f "$HOME/01_drop_foreign_keys.sql"

# Load data after removing the foreign key constraints
sudo -u postgres /usr/lib/postgresql/14/bin/pg_restore -j 2 --data-only -d noisecapture -W ~/dump-noisecapture-29_08_2017to28_08_2020_pgv10.15_postgisv2.5.backup

# We will used the OGR Foreign data wrapper to get NaturalEarth data so it needs to be installed
sudo apt install postgresql-10-ogr-fdw
