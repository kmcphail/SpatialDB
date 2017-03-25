CREATE TABLE ebd.eBird (
  GLOBAL_UNIQUE_IDENTIFIER    char(50),
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

-- Create Indexes
----
CREATE INDEX ebird_common_name_gix ON "ebd"."ebird" USING BTREE (common_name);
CREATE INDEX ebird_geom_gix ON "ebd"."ebird" USING GIST (geom);

-- Get the Spatial Data Ready
-------------------------------
--Add the geom field for holding spatial data
ALTER TABLE "ebd"."ebird" ADD COLUMN geom geometry(Geometry,4326);

--Add the spatial dat to the new column
UPDATE "ebd"."ebird"
set geom = ST_SetSRID(ST_MakePoint(longitude,latitude),4326);
WHERE geom IS NULL;

-- Create Index on the geom field
CREATE INDEX ebird_geom_gix ON "ebd"."ebird" USING GIST (geom);

-- Cleanup and optimize the data
VACUUM ANALYZE "ebd"."ebird";


