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