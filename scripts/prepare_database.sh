# demande le mot de passe de l'utilisateur postgres
sudo -u postgres /usr/lib/postgresql/14/bin/pg_restore --schema-only -d noisecapture -W /home/ame/dump-noisecapture-29_08_2017to28_08_2020_pgv10.15_postgisv2.5.backup

# DROP Foreign key Constraints
sudo -u postgres psql -U postgres -d noisecapture -a -f "/home/ame/drop_foreign_keys.sql"

# Load data
sudo -u postgres /usr/lib/postgresql/14/bin/pg_restore -j 2 --data-only -d noisecapture -W /home/ame/dump-noisecapture-29_08_2017to28_08_2020_pgv10.15_postgisv2.5.backup