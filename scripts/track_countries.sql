DROP MATERIALIZED VIEW IF EXISTS tracks_countries;
CREATE MATERIALIZED VIEW tracks_countries as (

select nt.pk_track, the_geom, measure_count, record_utc, pleasantness, noise_level, time_length, admin, tz_name1st, utc_format, tzn.name as tz_name_postgre,
extract (hour FROM (CAST(record_utc AS timestamp) at TIME zone tzn.name)) as local_hour

from noisecapture_track nt
	inner join 
	noisecapture_track_frame ntf
	on nt.pk_track = ntf.pk_track 
	inner join 
	countries c 
	ON ST_Intersects(st_setsrid(c.geog, 4326), st_setsrid(ntf.the_geom, 4326))
	inner join 
	timezones t 
	ON St_Intersects(st_setsrid(t.geom, 4326), st_setsrid(ntf.the_geom, 4326))
	inner join 
	pg_timezone_names tzn
	on substring(tzn.name, 7) LIKE concat(t.tz_name1st,'%')
	
)

select format(,'dd-MM-yyyy hh');

SELECT PostGIS_version();
SELECT PostGIS_full_version();