## Prepare noisecapture database
## an empty postgis database is required
## The folowing steps were used to save disk space.
## since no new data will be added, the foreign key constraints are not required

# Recreate the schema without loading the data
# This commands need to know the postgres user password
sudo -u postgres /usr/lib/postgresql/14/bin/pg_restore --schema-only -d noisecapture -W /home/ame/dump-noisecapture-29_08_2017to28_08_2020_pgv10.15_postgisv2.5.backup

# DROP Foreign key Constraints to save disk space
sudo -u postgres psql -U postgres -d noisecapture -a -f "/home/ame/01_drop_foreign_keys.sql"

# Load data after removing the foreign key constraints
sudo -u postgres /usr/lib/postgresql/14/bin/pg_restore -j 2 --data-only -d noisecapture -W /home/ame/dump-noisecapture-29_08_2017to28_08_2020_pgv10.15_postgisv2.5.backup

# Download NaturalEarth data
# this will be used to subset countries for studies
##  data (10m Admin 0 – Countries version 4.10)
wget https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip

## unzip the data
## if needed, install unzip : sudo apt install unzip
mkdir ne_10m_admin_0_countries
unzip ne_10m_admin_0_countries.zip -d ne_10m_admin_0_countries

# We will used the OGR Foreign data wraper so it needs to be installed
sudo apt install postgresql-10-ogr-fdw
