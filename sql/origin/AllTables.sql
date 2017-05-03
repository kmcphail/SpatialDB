CREATE TABLE "county" (

"gid" int4 NOT NULL DEFAULT nextval('census.county_gid_seq'::regclass),

"statefp" varchar(2) COLLATE "default",

"countyfp" varchar(3) COLLATE "default",

"name" varchar(100) COLLATE "default",

"namelsad" varchar(100) COLLATE "default",

"lsad" varchar(2) COLLATE "default",

"classfp" varchar(2) COLLATE "default",

"aland" numeric,

"awater" numeric,

"intptlat" varchar(11) COLLATE "default",

"intptlon" varchar(12) COLLATE "default",

"geom" "public"."geometry",

"state_code" char(10) COLLATE "default",

"state" varchar(2) COLLATE "default",

CONSTRAINT "county_pkey" PRIMARY KEY ("gid") ,

CONSTRAINT "county_gid_key" UNIQUE ("gid")

)

WITHOUT OIDS;



CREATE INDEX "county_geom_idx" ON "county" USING gist ("geom" "public"."gist_geometry_ops_2d");

CREATE UNIQUE INDEX "county_gid_idx" ON "county" USING btree ("gid" "pg_catalog"."int4_ops" ASC NULLS LAST);

CREATE INDEX "county_name_idx" ON "county" USING btree ("name" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE INDEX "counties_geohash_idx" ON "county" USING btree (st_geohash(geom) "pg_catalog"."text_ops" ASC NULLS LAST, st_geohash(geom) "pg_catalog"."text_ops" ASC NULLS LAST);

ALTER TABLE "county" CLUSTER ON "counties_geohash_idx";

ALTER TABLE "county" OWNER TO "geog574";



CREATE TABLE "state" (

"gid" int4 NOT NULL DEFAULT nextval('census.state_gid_seq'::regclass),

"region" varchar(2) COLLATE "default",

"division" varchar(2) COLLATE "default",

"statefp" varchar(2) COLLATE "default" NOT NULL,

"stusps" varchar(2) COLLATE "default",

"name" varchar(100) COLLATE "default",

"aland" numeric,

"awater" numeric,

"intptlat" varchar(11) COLLATE "default",

"intptlon" varchar(12) COLLATE "default",

"geom" "public"."geometry",

"state_code" char(10) COLLATE "default",

CONSTRAINT "state_pkey" PRIMARY KEY ("gid", "statefp") ,

CONSTRAINT "state_code_key" UNIQUE ("state_code"),

CONSTRAINT "stusps_key" UNIQUE ("stusps")

)

WITHOUT OIDS;



CREATE INDEX "state_geom_idx" ON "state" USING gist ("geom" "public"."gist_geometry_ops_2d");

CREATE UNIQUE INDEX "state_gid_idx" ON "state" USING btree ("gid" "pg_catalog"."int4_ops" ASC NULLS LAST);

CREATE UNIQUE INDEX "state_statefp_idx" ON "state" USING btree ("statefp" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE UNIQUE INDEX "state_stusps_idx" ON "state" USING btree ("stusps" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE UNIQUE INDEX "state_name_idx" ON "state" USING btree ("name" "pg_catalog"."text_ops" ASC NULLS LAST);

ALTER TABLE "state" OWNER TO "geog574";



CREATE TABLE "ebird" (

"global_unique_identifier" char(50) COLLATE "default" NOT NULL,

"category" varchar(20) COLLATE "default",

"common_name" varchar(70) COLLATE "default",

"scientific_name" varchar(70) COLLATE "default",

"observation_count" varchar(8) COLLATE "default",

"age_sex" text COLLATE "default",

"state_province" varchar(50) COLLATE "default",

"state_code" char(10) COLLATE "default",

"county" varchar(50) COLLATE "default",

"latitude" float8,

"longitude" float8,

"observation_date" date,

"approved" int4,

"reviewed" int4,

"geom" "public"."geometry",

"uid" int8 NOT NULL DEFAULT nextval('ebd.ebird_uid_seq'::regclass),

CONSTRAINT "ebird_pkey" PRIMARY KEY ("global_unique_identifier", "uid") 

)

WITHOUT OIDS;



CREATE TRIGGER "update_geom" BEFORE INSERT OR UPDATE OF "latitude", "longitude" ON "ebird" FOR EACH ROW EXECUTE PROCEDURE "ebd"."update_geom_column"();

CREATE INDEX "ebird_common_name_idx" ON "ebird" USING btree ("common_name" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE INDEX "ebird_srid_idx" ON "ebird" USING btree (st_srid(geom) "pg_catalog"."int4_ops" ASC NULLS LAST, st_srid(geom) "pg_catalog"."int4_ops" ASC NULLS LAST);

CREATE INDEX "ebird_geom_idx" ON "ebird" USING gist ("geom" "public"."gist_geometry_ops_2d");

CREATE INDEX "ebird_state_code_idx" ON "ebird" USING btree ("state_code" "pg_catalog"."bpchar_ops" ASC NULLS LAST);

CREATE INDEX "ebird_obsdate_idx" ON "ebird" USING btree ("observation_date" "pg_catalog"."date_ops" ASC NULLS LAST);

CREATE INDEX "ebird_month_idx" ON "ebird" USING btree (date_part('month'::text, observation_date) "pg_catalog"."float8_ops" ASC NULLS LAST);

CREATE INDEX "ebird_year_idx" ON "ebird" USING btree (date_part('year'::text, observation_date) "pg_catalog"."float8_ops" ASC NULLS LAST);

CREATE INDEX "ebird_state_province_idx" ON "ebird" USING btree ("state_province" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE INDEX "ebird_month_year_idx" ON "ebird" USING btree (date_part('month'::text, observation_date) "pg_catalog"."float8_ops" ASC NULLS LAST, date_part('year'::text, observation_date) "pg_catalog"."float8_ops" ASC NULLS LAST);

CREATE INDEX "ebird_county_idx" ON "ebird" USING btree ("county" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE UNIQUE INDEX "ebird_uid_idx" ON "ebird" USING btree ("uid" "pg_catalog"."int8_ops" ASC NULLS LAST);

CREATE INDEX "ebird_geohash_idx" ON "ebird" USING btree (st_geohash(geom) "pg_catalog"."text_ops" ASC NULLS LAST, st_geohash(geom) "pg_catalog"."text_ops" ASC NULLS LAST);

ALTER TABLE "ebird" CLUSTER ON "ebird_geohash_idx";

CREATE INDEX "ebd_sandhill_idx" ON "ebird" USING btree ("common_name" "pg_catalog"."text_ops" ASC NULLS LAST) WHERE common_name::text = 'Sandhill Crane'::text;

CREATE INDEX "ebd_whooper_idx" ON "ebird" USING btree ("common_name" "pg_catalog"."text_ops" ASC NULLS LAST) WHERE common_name::text = 'Whooping Crane'::text;

ALTER TABLE "ebird" OWNER TO "geog574";



CREATE TABLE "species" (

"common_name" varchar(70) COLLATE "default" NOT NULL,

"scientific_name" varchar(70) COLLATE "default" NOT NULL,

CONSTRAINT "species_pkey" PRIMARY KEY ("scientific_name") 

)

WITHOUT OIDS;



CREATE INDEX "species_scientific_name_idx1" ON "species" USING btree ("scientific_name" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE INDEX "species_common_name_idx1" ON "species" USING btree ("common_name" "pg_catalog"."text_ops" ASC NULLS LAST);

ALTER TABLE "species" OWNER TO "geog574";



CREATE TABLE "access" (

"access" varchar(20) COLLATE "default" NOT NULL,

"d_access" varchar(254) COLLATE "default",

CONSTRAINT "access_pkey" PRIMARY KEY ("access") 

)

WITHOUT OIDS;



ALTER TABLE "access" OWNER TO "geog574";



CREATE TABLE "area" (

"gid" int4 NOT NULL DEFAULT nextval('usgs_pad.area_gid_seq'::regclass),

"category" varchar(12) COLLATE "default",

"own_name" varchar(70) COLLATE "default",

"loc_own" varchar(250) COLLATE "default",

"mang_name" varchar(70) COLLATE "default",

"loc_mang" varchar(250) COLLATE "default",

"des_tp" varchar(75) COLLATE "default",

"loc_ds" varchar(250) COLLATE "default",

"unit_nm" varchar(250) COLLATE "default",

"loc_nm" varchar(250) COLLATE "default",

"state_nm" varchar(50) COLLATE "default",

"gis_acres" numeric(10),

"access" varchar(20) COLLATE "default",

"gap_sts" varchar(95) COLLATE "default",

"iucn_cat" varchar(70) COLLATE "default",

"date_est" varchar(4) COLLATE "default",

"geom" "public"."geometry",

CONSTRAINT "area_pkey" PRIMARY KEY ("gid") 

)

WITHOUT OIDS;



CREATE INDEX "area_geom_idx" ON "area" USING gist ("geom" "public"."gist_geometry_ops_2d");

CREATE INDEX "area_unit_nm_idx" ON "area" USING btree ("unit_nm" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE INDEX "area_loc_nm_idx" ON "area" USING btree ("loc_nm" "pg_catalog"."text_ops" ASC NULLS LAST);

CREATE INDEX "area_mang_nm_idx" ON "area" USING btree ("mang_name" "pg_catalog"."text_ops" ASC NULLS LAST);

ALTER TABLE "area" OWNER TO "geog574";



CREATE TABLE "category" (

"category" varchar(12) COLLATE "default" NOT NULL,

"d_category" varchar(254) COLLATE "default",

CONSTRAINT "category_pkey" PRIMARY KEY ("category") 

)

WITHOUT OIDS;



ALTER TABLE "category" OWNER TO "geog574";



CREATE TABLE "designation" (

"des_tp" varchar(75) COLLATE "default" NOT NULL,

"d_des_tp" varchar(254) COLLATE "default",

CONSTRAINT "designation_pkey" PRIMARY KEY ("des_tp") 

)

WITHOUT OIDS;



ALTER TABLE "designation" OWNER TO "geog574";



CREATE TABLE "gap_status" (

"gap_sts" varchar(95) COLLATE "default" NOT NULL,

"d_gap_sts" varchar(254) COLLATE "default",

CONSTRAINT "gap_status_pkey" PRIMARY KEY ("gap_sts") 

)

WITHOUT OIDS;



ALTER TABLE "gap_status" OWNER TO "geog574";



CREATE TABLE "iucn_category" (

"iucn_cat" varchar(70) COLLATE "default" NOT NULL,

"d_iucn_cat" varchar(254) COLLATE "default",

CONSTRAINT "iucn_category_pkey" PRIMARY KEY ("iucn_cat") 

)

WITHOUT OIDS;



ALTER TABLE "iucn_category" OWNER TO "geog574";



CREATE TABLE "manager_name" (

"mang_name" varchar(70) COLLATE "default" NOT NULL,

"d_mang_nam" varchar(254) COLLATE "default",

"mang_type" varchar(50) COLLATE "default",

CONSTRAINT "manager_name_pkey" PRIMARY KEY ("mang_name") 

)

WITHOUT OIDS;



ALTER TABLE "manager_name" OWNER TO "geog574";



CREATE TABLE "manager_type" (

"mang_type" varchar(50) COLLATE "default" NOT NULL,

"d_mang_typ" varchar(254) COLLATE "default",

CONSTRAINT "manager_type_pkey" PRIMARY KEY ("mang_type") 

)

WITHOUT OIDS;



ALTER TABLE "manager_type" OWNER TO "geog574";



CREATE TABLE "owner_name" (

"own_name" varchar(70) COLLATE "default" NOT NULL,

"d_own_name" varchar(254) COLLATE "default",

"own_type" varchar(50) COLLATE "default",

CONSTRAINT "owner_name_pkey" PRIMARY KEY ("own_name") 

)

WITHOUT OIDS;



ALTER TABLE "owner_name" OWNER TO "geog574";



CREATE TABLE "owner_type" (

"own_type" varchar(50) COLLATE "default" NOT NULL,

"d_own_type" varchar(254) COLLATE "default",

CONSTRAINT "owner_type_pkey" PRIMARY KEY ("own_type") 

)

WITHOUT OIDS;



ALTER TABLE "owner_type" OWNER TO "geog574";





ALTER TABLE "county" ADD CONSTRAINT "county_stusps_fkey" FOREIGN KEY ("state") REFERENCES "state" ("stusps") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "county" ADD CONSTRAINT "county_state_code_fkey" FOREIGN KEY ("state_code") REFERENCES "state" ("state_code") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "county" ADD CONSTRAINT "county_statefp_fkey" FOREIGN KEY ("statefp") REFERENCES "state" ("statefp") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ebird" ADD CONSTRAINT "ebird_scientific_name_fkey" FOREIGN KEY ("scientific_name") REFERENCES "species" ("scientific_name") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_access_fkey" FOREIGN KEY ("access") REFERENCES "access" ("access") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_category_fkey" FOREIGN KEY ("category") REFERENCES "category" ("category") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_des_tp_fkey" FOREIGN KEY ("des_tp") REFERENCES "designation" ("des_tp") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_gap_sts_fkey" FOREIGN KEY ("gap_sts") REFERENCES "gap_status" ("gap_sts") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_iucn_cat_fkey" FOREIGN KEY ("iucn_cat") REFERENCES "iucn_category" ("iucn_cat") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_own_name_fkey" FOREIGN KEY ("own_name") REFERENCES "owner_name" ("own_name") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "area_mang_name_fkey" FOREIGN KEY ("mang_name") REFERENCES "manager_name" ("mang_name") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "area" ADD CONSTRAINT "state_nm_fkey" FOREIGN KEY ("state_nm") REFERENCES "state" ("stusps") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "manager_name" ADD CONSTRAINT "manager_name_mang_type_fkey" FOREIGN KEY ("mang_type") REFERENCES "manager_type" ("mang_type") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "owner_name" ADD CONSTRAINT "owner_name_own_type_fkey" FOREIGN KEY ("own_type") REFERENCES "owner_type" ("own_type") ON DELETE RESTRICT ON UPDATE CASCADE;
