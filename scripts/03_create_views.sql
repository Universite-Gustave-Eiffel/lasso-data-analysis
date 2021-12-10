/* View creation scripts
*/


-- 6827 tracks contains animals tag, are not indoors or test
create or replace view tracks_of_interest as
select nt.pk_track, record_utc, time_length , noise_level,tag_name from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where time_length < 900 -- filter records longer than 15 minutes
--and tag_name in ('animals')    /*only animal sounds*/
and nt.pk_track not in ( -- filter tracks that are also taggued indoor or test
  select distinct nt.pk_track from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where ntag.tag_name = 'indoor' or ntag.tag_name =  'test'    /*track recorded indoor or tests*/
  );



/* Spatial filtering 
 * Returns 5319 records (9293 if not area filter)
 * 44s execution time
 * store result in a MATERIALIZED view
 * */ 
 
 CREATE MATERIALIZED VIEW france_tracks as (
  select * from (
    select * from (
      select pk_track, ST_Area(geog) as sqm_area, geog from (
        -- compute area of the envelop of points
        select pk_track, st_envelope(ST_Collect(np2.the_geom))::geography geog  -- compute envelope in geography type (because WGS84)
        from noisecapture_point np2 where pk_track in  (
          select pk_track from 
            (select pk_track, percentile_cont(0.5) within group ( order by accuracy ) as median_acc from noisecapture_point np 
              where np.pk_track in (select pk_track from tracks_of_interest) 
              group by pk_track order by median_acc) as median_acc -- compute median accuracy of the track
            where median_acc  > 0 and median_acc <20 -- filter mean accurary
           ) group by pk_track ) as subquery
      ) as subquery2
 -- filter tracks recorded in a large area ( larger than 25 x 25 m)
where sqm_area < 625 -- filtering by area
 ) as spatial_query 
where ST_Intersects(geog, (select geog from countries c where c."admin"  = 'France'))
);

-- Create index
CREATE UNIQUE INDEX idx_france_tracks ON france_tracks (pk_track);
CREATE INDEX ix_france_tracks_geog_gist ON france_tracks USING gist(geog);
analyze france_tracks;


-- Refresh view
REFRESH MATERIALIZED VIEW france_tracks;