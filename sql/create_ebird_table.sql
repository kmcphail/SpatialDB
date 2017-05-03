--
-- eBird Data import
--
-- Create the inital table of eBird Data. 
--  this table created from a modified version of 
--  information found here: https://github.com/weecology/retriever/issues/90
--
CREATE TABLE ebd.ebird (
  GLOBAL_UNIQUE_IDENTIFIER      char(50), 
    LAST_EDITED_DATE            date,
    TAXONOMIC_ORDER             numeric,
    CATEGORY                    varchar(20),    
    COMMON_NAME                 varchar(70),  
    SCIENTIFIC_NAME             varchar(70),
    SUBSPECIES_COMMON_NAME      varchar(70),
    SUBSPECIES_SCIENTIFIC_NAME  varchar(70),
    OBSERVATION_COUNT           varchar(8),
    BREEDING_BIRD_ATLAS_CODE    char(2),
    AGE_SEX                     text,
    COUNTRY                     varchar(50),
    COUNTRY_CODE                char(2),
    STATE_PROVINCE              varchar(50),
    STATE_CODE                  char(10),
    COUNTY                      varchar(50),
    COUNTY_CODE                 char(12),
    IBA_CODE                    char(16),
    BCR_CODE                    varchar(50),
    USFWS_CODE                  varchar(50),
    ATLAS_BLOCK                 varchar(255),
    LOCALITY                    text,
    LOCALITY_ID                 char(10),
    LOCALITY_TYPE               char(2),
    LATITUDE                    double precision,
    LONGITUDE                   double precision,
    OBSERVATION_DATE            date,
    TIME_OBSERVATIONS_STARTED   time,
    OBSERVER_ID                 char(12),
    FIRST_NAME                  text,
    LAST_NAME                   text, 
    SAMPLING_EVENT_IDENTIFIER   char(12),
    PROTOCOL_TYPE               varchar(50),
    PROJECT_CODE                varchar(20),
    DURATION_MINUTES            int,
    EFFORT_DISTANCE_KM          real,
    EFFORT_AREA_HA              real,
    NUMBER_OBSERVERS            int,
    ALL_SPECIES_REPORTED        int,
    GROUP_IDENTIFIER            varchar(10),
    HAS_MEDIA                   int,
    APPROVED                    int,
    REVIEWED                    int,
    REASON                      char(17),
    TRIP_COMMENTS               text,
    SPECIES_COMMENTS            text,
    X                           text
);


-- Import the data that you downloaded from eBird

-- This is a sample of the command structure to copy the TXT file downloaded from
--  eBird to the database. This assumes you have donloaded the .tar file to the same
--  system as the database and are using the command in PSQL

-- Use these commands to extract the text file from the tarball:
   -- tar xvf ebd_COUNTRYCODE_relMONTH-YEAR.tar
   -- gunzip ebd_COUNTRYCODE_relMONTH-YEAR.txt.gz


COPY "ebd"."ebird"  -- 'ebd' is our schema and 'ebird' is our table
    FROM E'/home/icfadmin/ebd_US/ebd_US_relFeb-2017.txt' -- include the path and file name
    HEADER -- indicate if there is a heard row
    CSV  -- even though it's a tab delimited, we specify CSV
    QUOTE E'\5' -- since single and double quotes can be used in text, 
                --  we use a stange character as quotes to avoid mistakes
    DELIMITER E'\t' -- specify the tab (\t) as the DELIMITER
;

-- Wait to do the steps below until all of the data has been imported. 

-- Create Indexes
-----------------

-- Index for common_name, used lower() to make case insensitive searchers easier 
CREATE INDEX ebird_common_name_idx ON "ebd"."ebird" ((lower(common_name)));
-- Index for the GUID although the GUID isn't actually unique...
CREATE INDEX ebird_global_unique_identifier_idx ON "ebd"."ebird" (global_unique_identifier);

-- Create Truely Unique ID (UID)
ALTER TABLE "ebd"."ebird" ADD COLUMN uid SERIAL PRIMARY KEY;
-- Index for UID
CREATE INDEX ebird_uid_idx ON "ebd"."ebird" (uid);


-- Get the Spatial Data Ready
-------------------------------
--Add the geom field for holding spatial data
ALTER TABLE "ebd"."ebird" ADD COLUMN geom geometry(Geometry,4326);

--Add the spatial data to the new column
UPDATE "ebd"."ebird"
set geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);
WHERE geom IS NULL;

-- Create Index on the geom field
CREATE INDEX ebird_geom_gix ON "ebd"."ebird" USING GIST (geom);

-- Create geohash index and cluster the ebird items according to their location.
--  This step clusters (or organizes) records in teh table according to their location
--  Guidance for this step was found in PostGIS in Action, Second Edition (Regina O. Obe and Leo S. Hsu, 2015)
CREATE INDEX ebird_geohash_idx ON ebd.ebird (ST_GeoHash(geom));
CLUSTER ebd.ebird USING ebird_geohash_idx;

-- Cleanup the data table and recalculate statistics.
VACUUM ANALYZE "ebd"."ebird";