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