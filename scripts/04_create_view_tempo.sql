/* Temporal View creation scripts
*/

create or replace VIEW view_tracks_tempo as
select nt.pk_track, record_utc, time_length , noise_level,tag_name from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where time_length > 5
and nt.pk_track not in ( -- filter tracks that are also taggued indoor or test
  select distinct nt.pk_track from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where ntag.tag_name = 'indoor' or ntag.tag_name =  'test'    /*track recorded indoor or tests*/
  );

DROP MATERIALIZED VIEW IF EXISTS tracks_view;

CREATE MATERIALIZED VIEW tracks_view as (
 select ft.pk_track, track_uuid, record_utc, time_length, noise_level, pleasantness, 
concat('https://data.noise-planet.org/raw/', substring(user_uuid, 1, 2),'/', substring(user_uuid, 3, 2),'/', substring(user_uuid, 5, 2),'/',user_uuid,'/','track_',track_uuid,'.zip') download, 
geog from (
  select * from (
    select * from (
      select pk_track, ST_Area(geog) as sqm_area, geog from (
        -- compute area of the envelop of points
select pk_track, st_envelope(ST_Collect(np2.the_geom))::geography geog  -- compute envelope in geography type (because WGS84)
        from noisecapture_point np2 where pk_track in  (
          select pk_track from 
            (select pk_track, percentile_cont(0.5) within group ( order by accuracy ) as median_acc from noisecapture_point np 
              where np.pk_track in (select pk_track from view_tracks_tempo) 
              group by pk_track order by median_acc) as median_acc -- compute median accuracy of the track
            where median_acc  > 0 -- filter mean accurary
           ) group by pk_track ) as subquery
      ) as subquery2
 ) as spatial_query 
) as ft join noisecapture_track nt on nt.pk_track = ft.pk_track 
join  noisecapture_user nu  ON nt.pk_user = nu.pk_user 
);

-- Create index
CREATE UNIQUE INDEX idx_tracks_view ON tracks_view (pk_track);
CREATE INDEX ix_tracks_view_geog_gist ON tracks_view USING gist(geog);
analyze tracks_view;


-- Refresh view if changes in tracks_of_interest
REFRESH MATERIALIZED VIEW tracks_view;
