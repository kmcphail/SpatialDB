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

-- A query to find the 10 nearest Protected Areas where a species can be seen (this month and using data since 2014)
-- 	We can trasnform this to a function to make it easier for data query
--	 e.g.
--	SELECT nearest_pa(common_name, month, your_longitude, your_latitude)
--	Returns the nearest PA, state - we could add the county, distance (and bearing) if we like.
SELECT
	up.unit_nm AS pa_name,
	up.state_nm AS "state",
	ST_Distance (up.geom :: geography, ST_SetSRID(ST_POINT(- 89.7485322, 43.4687975),4326)) / 1000 AS distance_km
FROM
	usgs_pad.area AS up
JOIN ebd.ebird e ON ST_INTERSECTS (e.geom, up.geom)
WHERE
	e.common_name = 'American Bittern'
AND up."access" NOT IN ('XA', 'UK')
AND e.observation_date >= '2014-01-01'
AND date_part('month', e.observation_date) = date_part('month', now())
GROUP BY up.unit_nm, up.state_nm, up.geom
ORDER BY
	up.geom <-> ST_SetSRID (
		ST_POINT (- 89.7485322, 43.4687975),
		4326
	)
LIMIT 10;

-- Simple query that lists all 'Open Access' protected areas within the specified county.
-- For extra results replace "ST_WITHIN" with "ST_INTERSECTS".
SELECT up.unit_nm FROM usgs_pad.area AS up
JOIN census.county AS cn ON ST_WITHIN(up.geom, cn.geom)
WHERE cn.name = 'Dane' AND cn.state = 'WI' AND up.access = 'OA'
GROUP BY up.unit_nm
ORDER BY up.unit_nm;

-- A query to find protected areas with certain species. 
WITH local_sp AS (
	SELECT eb.geom FROM ebd.ebird AS eb
	JOIN census.county AS cn ON ST_INTERSECTS(eb.geom, cn.geom)
	WHERE
		cn.name = 'Dane' AND 
		cn.state = 'WI' AND 
		eb.common_name = 'Sandhill Crane'		
	)
SELECT up.unit_nm as protected_area, ac.d_access as access_type 
FROM usgs_pad.area AS up
JOIN local_sp ON ST_INTERSECTS(local_sp.geom, up.geom)
JOIN usgs_pad."access" as ac on up."access"=ac."access"
WHERE up."access"NOT IN ('UK','XA')
GROUP BY up.unit_nm, ac.d_access
ORDER BY ac.d_access, up.unit_nm;



-- A query to create a bird list for a protected area in a particular month
--	In this example, since Devil's Lake State Park has several polygons and not just one, 
--	I used LIKE in the WHERE clause to caputer them all
SELECT
	e.common_name,
	e.scientific_name
FROM
	ebird AS e
JOIN usgs_pad.area AS pa ON ST_Intersects (pa.geom, e.geom)
WHERE
	LOWER (pa.unit_nm) LIKE 'devils lake%'
	AND pa.state_nm = 'WI'
	AND date_part('month', e.observation_date) = '5'
GROUP BY
	common_name,
	scientific_name
ORDER BY
	e.common_name;