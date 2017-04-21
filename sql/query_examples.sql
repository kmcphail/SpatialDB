--Number of counties per state:
SELECT st.name, COUNT(*) FROM census.county AS cn
JOIN census.state AS st ON ST_Intersects(ST_Centroid(cn.geom), st.geom)
GROUP BY st.name
ORDER BY st.name ASC
;

--An adaptation of your first query example.
--Number of Whooping Crane observations in Wisconsin by county and year:
SELECT DISTINCT cn.name, COUNT(*), date_part('year', e.observation_date) FROM ebd.ebird AS e
JOIN census.county AS cn ON ST_Intersects(cn.geom, e.geom)
WHERE e.common_name = 'Whooping Crane' AND e.state_province = 'Wisconsin'
GROUP BY cn.name, date_part('year', e.observation_date) 
--Need to use date_part in the GROUP BY or you get count of obs by date within year.
ORDER BY cn.name ASC, date_part('year', e.observation_date) DESC
;

-- A query to find the nearest PA where a species can be seen (this month and using data since 2015)
-- 	We can trasnform this to a function to make it easier for data query
--	 e.g.
--	SELECT nearest_pa(common_name, month, your_longitude, your_latitude)
--	Returns the nearest PA, state - we could add the county, distance (and bearing) if we like.

SELECT
	up.unit_nm AS pa_name,
	up.state_nm AS "state"
FROM
	usgs_pad.padus1_4combined_4326 AS up
JOIN ebd.ebird e ON ST_INTERSECTS (e.geom, up.geom)
WHERE
	e.common_name = 'American Bittern'
AND e.observation_date >= '2015-01-01'
AND date_part('month', e.observation_date) = date_part('month', now())
ORDER BY
	up.geom <-> ST_SetSRID (
		ST_POINT (- 89.7485322, 43.4687975),
		4326
	)
LIMIT 1;
