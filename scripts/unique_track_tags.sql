
CREATE TABLE unique_tracks_tag 
AS
SELECT pk_track , the_geom, measure_count , record_utc , pleasantness ,
noise_level , time_length , admin, tz_name1st , tz_name_postgre,
utc_format , local_hour 
  FROM tracks_tag

DELETE FROM unique_tracks_tag a USING (
      SELECT MIN(ctid) as ctid, pk_track
        FROM unique_tracks_tag 
        GROUP BY pk_track HAVING COUNT(*) > 1
      ) b
      WHERE a.pk_track = b.pk_track
      AND a.ctid <> b.ctid

DROP MATERIALIZED VIEW IF EXISTS unique_tagged_tracks;

CREATE MATERIALIZED VIEW unique_tagged_tracks as (
	select * from unique_tracks_tag 
)