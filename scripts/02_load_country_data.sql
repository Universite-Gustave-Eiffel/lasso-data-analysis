-- Create staging schema for temporary datasets
CREATE SCHEMA if not exists staging;

/* Install the OGR foreign Data wrapper to access shapefiles within PostGIS
sudo apt install postgresql-10-ogr-fdw
*/
CREATE EXTENSION ogr_fdw;

-- Check extension version
select ogr_fdw_version();

-- Load NaturalEarth Data with OGR Foreign data wrapper
-- see Regina Obe presentation: https://www.youtube.com/watch?v=MALBdg_BwOA


drop server if exists fds_ne cascade;
create server fds_ne
    foreign data wrapper ogr_fdw
    options(datasource
'/vsizip/vsicurl/https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip',
 format 'ESRI Shapefile')
 
 -- Import 
import foreign schema ogr_all from server fds_ne into staging;

-- Copy data from fds_ne to a table
create table countries as
select * from staging.ne_10m_admin_0_countries nmac ;

-- rename table
ALTER TABLE IF EXISTS ne_10m_admin_0_countries
RENAME TO countries;

-- convert to geography type as raw data is in WGS84 (EPSG 4326)
-- force type of each feature to Multipolygon 
alter table public.countries
alter column geom type geography(MULTIPOLYGON,4326) using
ST_Multi(geom)::geography(MULTIPOLYGON,4326)

-- rename geom column to geography column
alter table countries rename geom to geog

-- create spatial index on geog column
create index ix_countries_geog_gist on countries using gist(geog);


/* Load Timezone data from topopjson file
 * source : https://gist.github.com/tschaub/cc70281ce4df5358eac38b34409b9ef9
 * based on NaturalEarth timezone data
 */
drop server if exists fds_tz cascade;
create server fds_tz
    foreign data wrapper ogr_fdw
    options(datasource
'/vsicurl/https://gist.githubusercontent.com/tschaub/cc70281ce4df5358eac38b34409b9ef9/raw/d152ba9e83d7733d9fb5f37f52202c0fcead834a/timezones.json',
 format 'TopoJSON')
 
  -- Import 
import foreign schema ogr_all from server fds_tz into staging;

-- Copy data from fds_tz to a table
create table timezones as
select * from staging.ne_10m_time_zones tz ;

-- rename table
ALTER TABLE IF EXISTS ne_10m_time_zones
RENAME TO timezones;