/* Filtrer sur les tags */

select nt.pk_track, record_utc, time_length , noise_level from noisecapture_track as nt 
INNER JOIN noisecapture_track_tag ntt ON nt.pk_track = ntt.pk_track /* Add track tags*/
where ntt.pk_tag not in (6) /* remove indoor results*/
limit 20 
;

/* recalage UTC -> temps local*/

/* filtrer sur l'emprise du track  < 625 m2*/
/* ST_MinimumBoundingCircle() // geom
 * ST_MinimumBoundingRadius() // geom
 * ST_Area(noisecapture_track_frame::geom)
 * */

/* filtrer sur la précision GPS*/
select count(pk_point) from noisecapture_point; /*59 685 328 points*/
select distinct accuracy from noisecapture_point np ;/* 883 484 valeurs distinctes*/

select count(accuracy) from noisecapture_point np where  accuracy  < 20; /*50 196 305 points ont une précision inférieure à 20 m*/

/* Précision = 0 ?*/
select count(pk_point) from noisecapture_point np2 where accuracy = 0; /*10 783 602 points*/

/*Précision moyenne du track*/
select count(pk_track) from noisecapture_track nt ; /*260422 tracks*/
select count(*) from (select pk_track from noisecapture_point np2 group by pk_track) as pk_track_tabl ; /*260419 tracks*/
/*142 547 track avec une précision moyenne > 0 et < 20 */
select count(*) from 
(select pk_track, avg(accuracy) as mean_acc from noisecapture_point np group by pk_track order by mean_acc) as mean_acc 
where mean_acc  > 0 and mean_acc <20 ;



select (select count(pk_point) from noisecapture_point np2 where accuracy = 0)/(select count(pk_point) from noisecapture_point);
