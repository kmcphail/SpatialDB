-- Table schema only
---------------------
SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "counties" (gid serial,
"statefp" char(2),
"countyfp" char(3),
"countyns" char(8),
"geoid" char(5),
"name" varchar(25),
"namelsad" varchar(35),
"lsad" char(2),
"classfp" char(2),
"mtfcc" char(5),
"csafp" char(3),
"cbsafp" char(5),
"metdivfp" char(5),
"funcstat" char(1),
"aland" numeric,
"awater" numeric,
"intptlat" double precision,
"intptlon" double precision);
ALTER TABLE "counties" ADD PRIMARY KEY (gid);
SELECT AddGeometryColumn('','counties','geom','4326','MULTIPOLYGON',2);
INSERT INTO "counties" ( ---------------
----------------------------------------
-- File too large to include all values
