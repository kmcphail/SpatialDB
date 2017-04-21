--usage
--	SELECT nearest_pa(common_name as TEXT, month as INT, my_longitude as float, my_latitude as float)


CREATE
OR REPLACE FUNCTION nearest_pa (
	VARCHAR,
	INT,
	FLOAT,
	FLOAT
) RETURNS SETOF record AS 
'SELECT
	up.unit_nm AS pa_name,
	up.state_nm AS "state",
	ST_DISTANCE(up.geom, ST_Point($3,$4)::geography)/1000 as distance_km
FROM
	usgs_pad.padus1_4combined_4326 AS up
JOIN ebd.ebird e ON ST_INTERSECTS (e.geom, up.geom)
WHERE
	e.common_name = $1
AND e.observation_date >= ''2015-01-01''
AND date_part(''month'', e.observation_date)::INT = $2
ORDER BY
	up.geom <-> ST_SetSRID (
		ST_POINT ($3, $4),
		4326
	)
LIMIT 1;
' LANGUAGE SQL;