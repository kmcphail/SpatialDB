--	Create geohash index and cluster the ebird items according to their location.

CREATE INDEX ebird_geohash_idx ON ebd.ebird (ST_GeoHash(geom));
CLUSTER ebd.ebird USING ebird_geohash_idx;