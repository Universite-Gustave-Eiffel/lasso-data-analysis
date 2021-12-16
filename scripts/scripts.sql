/* Various working queries to viusalise some interrogation points*/

-- Tag list
SELECT distinct  * FROM noisecapture_tag;

/* Filtrer sur les tags */

select nt.pk_track, record_utc, time_length , noise_level from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
where ntt.pk_tag not in (6) /* remove indoor results*/
limit 20 
;


select nt.pk_track, record_utc, time_length , noise_level,tag_name from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where ntt.pk_tag not in (6) /* remove indoor results*/
and tag_name = 'animals'    /*only animal sounds*/
limit 20 
;


select nt.pk_track, record_utc, time_length , noise_level,tag_name from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where ntt.pk_tag not in (6) /* remove indoor results*/
and tag_name = 'animals'    /*only animal sounds*/
and time_length >= 900 /*duration in seconds, 900 s = 15 minutes*/
/*limit 20*/ 
;

select nt.pk_track, record_utc, time_length , noise_level,tag_name from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where tag_name in ('animals', 'water')    /*only animal sounds*/
--limit 20
;

-- table with indoor and test track: 89 044 tracks
select distinct nt.pk_track from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where ntag.tag_name = 'indoor' or ntag.tag_name =  'test'    /*track recorded indoor or tests*/
;

select distinct nt.pk_track, tag_name from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where ntag.tag_name in ( 'indoor', 'test')    /*track recorded indoor or tests*/
;



-- Track geom reconstruction
select * from noisecapture_track nt 
left join noisecapture_dump_track_envelope ndte on  nt.pk_track = ndte.pk_track

-- filtering with ST_Covered_by ?
-- Select france : 1 line, multipolygon Métropole + DOM
select admin, geog from countries c where c."admin"  = 'France';


-- track n°272787 has indoor and test tags, should return 2 records
select * from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/
where nt.pk_track = 272787
;

/* recalage UTC -> temps local*/

/* filtrer sur l'emprise du track  < 625 m2*/
/* Recréer la géométrie du track à partir des points*/
/* ST_MinimumBoundingCircle() // geom
 * ST_MinimumBoundingRadius() // geom
 * ST_Area(noisecapture_track_frame::geom)
 * */


-- Work on GPS accuracy
/* filtrer sur la précision GPS*/
select count(pk_point) from noisecapture_point; /*59 685 328 points*/
select distinct accuracy from noisecapture_point np ;/* 883 484 valeurs distinctes*/

select count(accuracy) from noisecapture_point np where  accuracy  < 20; /*50 196 305 points ont une précision inférieure à 20 m*/

/* Précision = 0 ?*/
select count(pk_point) from noisecapture_point np2 where accuracy = 0; /*10 783 602 points*/

/*Précision moyenne du track*/
select count(pk_track) from noisecapture_track nt ; /*260422 tracks*/
select count(*) from (select pk_track from noisecapture_point np2 group by pk_track) as pk_track_tabl ; /*260419 tracks*/

/*142 547 tracks (54%) avec une précision moyenne > 0 et < 20 */
select count(*) from 
(select pk_track, avg(accuracy) as mean_acc from noisecapture_point np group by pk_track order by mean_acc) as mean_acc 
where mean_acc  > 0 and mean_acc <20 ;

 
--
select * from france_tracks;

-- join track data
SELECT  ft.pk_track, record_utc, time_length, pleasantness, noise_level, track_uuid FROM france_tracks as ft
join noisecapture_track as nt  on ft.pk_track = nt.pk_track;


-- tags data
SELECT ft.pk_track, tag_name FROM france_tracks as ft
INNER JOIN noisecapture_track_tag ntt ON ft.pk_track = ntt.pk_track /* Add track tags*/
INNER JOIN noisecapture_tag ntag ON ntag.pk_tag = ntt.pk_tag /* Add track tags*/

-- List of available drivers provided by OGR_fdw
SELECT driver
FROM unnest(ogr_fdw_drivers()) AS driver
ORDER BY driver;


/* Quick look into GADM28 data */
select *  from gadm28 g where name_0 = 'France'

select distinct type_5 from gadm28 g  where name_0 = 'France'

/*Generates download link for sound sample*/
select record_utc, concat('https://data.noise-planet.org/raw/', substring(user_uuid, 1, 2),'/', substring(user_uuid, 3, 2),'/', substring(user_uuid, 5, 2),'/',user_uuid,'/','track_',track_uuid,'.zip') download  
from noisecapture_track nt, noisecapture_user nu 
where nt.pk_user = nu.pk_user 
--and nt.record_utc > NOW()::date - 1 
order by record_utc DESC LIMIT 30;

select  concat('https://data.noise-planet.org/raw/', substring(user_uuid, 1, 2),'/', substring(user_uuid, 3, 2),'/', substring(user_uuid, 5, 2),'/',user_uuid,'/','track_',track_uuid,'.zip') download from france_tracks ft, noisecapture_track nt, noisecapture_user nu where nt.pk_track = ft.pk_track and nt.pk_user = nu.pk_user 