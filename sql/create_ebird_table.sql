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
-- See sample_copy_ebird_data.sql file for details

-- Wait to do the steps below until all of the data has been imported. 

-- Create Indexes
-----------------

-- Index for common_name, used lower() to make case insensitive searchers easier 
CREATE INDEX ebird_common_name_idx ON "ebd"."ebird" ((lower(common_name)));
-- Index for the GUID although the GUID isn't actually unique...
CREATE INDEX ebird_global_unique_identifier_idx ON "ebd"."ebird" (global_unique_identifier);

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

-- Cleanup the data table.
VACUUM "ebd"."ebird";

--Since our data will be primarily used for spatial queries
--  I've going to cluser records based on their location.
CLUSTER "ebd"."ebird" USING ebird_geom_gix;

-- Finally, I'll ask the database to update teh statistics 
--  vacuuming is unnecessary since it was done above.
ANALYZE "ebd"."ebird";