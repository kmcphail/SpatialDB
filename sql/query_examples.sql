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
GROUP BY cn.name, e.observation_date
ORDER BY cn.name ASC, date_part('year', e.observation_date) DESC
;
