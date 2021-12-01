create extension postgis;


/* voir depuis où on se connecte à la base
 * tunnel SSH == connexion localhost
 * */
SELECT boot_val,reset_val
FROM pg_settings
WHERE name='listen_addresses';



/*Lister les contraintes d'une table */
SELECT con.*
       FROM pg_catalog.pg_constraint con
            INNER JOIN pg_catalog.pg_class rel
                       ON rel.oid = con.conrelid
            INNER JOIN pg_catalog.pg_namespace nsp
                       ON nsp.oid = connamespace
       WHERE nsp.nspname = 'public' /*nom du schéma*/
             AND rel.relname = 'noisecapture_track_tag'; /*nom de la table*/

             
/*Remove all foreign key constraints*/
alter table noisecapture_track DROP CONSTRAINT noisecapture_track_pk_party_fkey;
alter table noisecapture_track DROP CONSTRAINT noisecapture_track_pk_user_fkey;
alter table noisecapture_area DROP CONSTRAINT noisecapture_area_pk_party_fkey;
alter table noisecapture_area_profile DROP CONSTRAINT noisecapture_area_profile_fk;
alter table noisecapture_dump_track_envelope DROP CONSTRAINT noisecapture_dump_track_envelope_pk_track_fkey;
alter table noisecapture_freq DROP CONSTRAINT noisecapture_freq_pk_point_fkey;
alter table noisecapture_point DROP CONSTRAINT noisecapture_point_pk_track_fkey;
alter table noisecapture_freq DROP CONSTRAINT noisecapture_freq_pk_point_fkey;
alter table noisecapture_process_queue DROP CONSTRAINT noisecapture_process_queue_pk_track_fkey;
alter table noisecapture_track_tag DROP CONSTRAINT noisecapture_track_tag_pk_tag_fkey;
alter table noisecapture_track_tag DROP CONSTRAINT noisecapture_track_tag_pk_track_fkey;


/*Liste des tables*/
SELECT * FROM information_schema.tables WHERE table_schema = 'public' and table_type = 'BASE TABLE';

/* Drop all tables*/
DROP TABLE IF EXISTS noisecapture_area_cluster CASCADE;
DROP TABLE IF EXISTS noisecapture_country_track CASCADE;
DROP TABLE IF EXISTS noisecapture_process_queue CASCADE;
DROP TABLE IF EXISTS noisecapture_stats_last_tracks CASCADE;
DROP TABLE IF EXISTS noisecapture_area_profile CASCADE;
DROP TABLE IF EXISTS noisecapture_dump_track_envelope CASCADE;
DROP TABLE IF EXISTS noisecapture_track_frame CASCADE;
DROP TABLE IF EXISTS noisecapture_tag CASCADE;
DROP TABLE IF EXISTS gadm28 CASCADE;
DROP TABLE IF EXISTS noisecapture_area CASCADE;
DROP TABLE IF EXISTS noisecapture_freq CASCADE;
DROP TABLE IF EXISTS noisecapture_party CASCADE;
DROP TABLE IF EXISTS noisecapture_user CASCADE;
DROP TABLE IF EXISTS noisecapture_track CASCADE;
DROP TABLE IF EXISTS noisecapture_track_tag CASCADE;
DROP TABLE IF EXISTS noisecapture_point CASCADE;