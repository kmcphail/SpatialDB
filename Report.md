Guidelines:
- No more than 15 pages at 1.5 line spacing
- Format and style should conform to standards suitable for publication. 
- Details your thought process, approach, and results.
- Add maps/figures/tables/etc as needed.


## Avian GeoSearch
### Utilizing data-driven research to spatially locate bird species & accessible lands
#### Kirk McPhail, Dorn Moore




### Section 1: Introduction & Objectives

- [ ] **Introduction**:
 - [X] KM
 - [X] DM

In the age of online collaboration, the scientific research community at large has gained the ability to more readily share their findings with the public. Likewise, so has the general population; thus, the concept of "citizen science" has thrived.  One of our primary sources, eBird, is a prime example of an organization that utilizes data from these self-titled “citizen scientists”. The Cornell Lab of Ornithology and National Audubon Society pooled their resources in 2002, resulting into what is now “…one of the largest and fastest growing biodiversity data resources in existence.” (eBird.org).

There is a considerable community of dedicated birders who use technology tools and networks of other birders to help them find opportunities to see more birds in their area or places they are visiting. However, for non-birders or novices, it can be difficult to know where to go to see a particular species or find a list of common species seen a particular area. For example, at the International Crane Foundation, where one of the authors works, it is a common question from visitors to our site or our website to ask "Where can I see Sandhill cranes near me?" Our goal with this project was to help bring together the over 274 million eBird species sightings in the United States to help people find birds.
    
- [ ] **Research Questions**:
 - [X] KM
 - [X] DM

From the early planning stages, our primary objective has been: the creation of a platform that answers variations of these three questions: 

- What bird species can I see nearby? 
- Where can I see a certain species nearby? 
- When can I see a certain species nearby? 

If you look back towards the first question you can see that at a minimum, a location must be provided. This requirement continues for the second and third questions; however, these two queries allow for bird species as an additional parameter. More detailed queries may include specifying a certain month, natural area, or any combination of the aforementioned variables. This project focuses on solutions to these concerns through the design, creation, and implementation of a spatial database, along with custom functions, joins, and relationships.
    
- [ ] **Data Description & Sources**:
 - [X] KM
 - [X] DM

Three main sources formed our database: the eBird Basic Dataset from Cornell, the Protected Areas Database of the United States from USGS, and TIGER/Line Shapefiles from the U.S. Census Bureau. The download for the former source consists of a tab-delimited text file, imported as a table using the SQL copy command and assigned point geometry derived from longitude and latitude field values. The latter two sources were obtained as shapefiles and uploaded to our SQL database using PostGIS’ shp2pgsql and psql command line expressions. 
    
- [ ] **Expectations & Transition to Section 2**:
 - [ ] KM
 - [ ] DM

Although the raw data we obtained has the potential for extensive analytical research, our database will primarily cater to the average outdoor enthusiast and thus many of the original fields proved unnecessary. Our goal in combining these resources is to develop a bird species search tool that is both comprehensive and practical at a local scale. 

We encountered several challenges working with such a vast dataset of species sightings. We ere able to resolve several of these through query experimentation and will discuss those challenges and solutions in the sections below.
    

### Section 2: Database Design & Manipulation

- [ ] **Conceptual Model & Description**:
 - [ ] KM
 - [ ] DM

We translated our source data into four spatial entities (see "ebird", "area", "state", "county" in figure 1) placed in three categories, which are expressed as schemas during the database implementation phase. The first category consists of species observations depicted as points, another contains protected lands with polygon geometry, and the last category holds both states and counties represented as polygons. Given the amount of overlap in field values within each entity, minimizing redundancy via normalization became the next priority. 

_Figure 1. Entity-Relationship diagram_

- [ ] **Logical Model & Description**:
 - [ ] KM
 - [ ] DM


- [ ] **Database Implementation**:
 - [ ] KM
 - [X] DM 

The database sections were pulled from existing (third-party) databases, namely eBird, the USGS Protected Area Database (USGS PAD), and the US Census Tiger data. In each case, we created separate schema to hold these databases. Our research questions do not require that we keep all of the attributes in each table. We eliminated attribute fields that were not useful for our question. Further, the database providers often included duplicative fields to make it easier for outside users to query by easy to read fields. For example, the USGS PAD includes both a coded value and descriptive value for a 8 fields (16 in total). In the case of the USGS PAD, we created list tables that are foreign keys and reduce the number of fields stored in the core table. We created a similar table in eBird schema to hold common and scientific names.

To import the eBird data, we used an example found on the web (https://github.com/weecology/retriever/issues/90) to create properly formated table. Once completed, we uploaded the US eBird data downloaded from their website to the database. The details of this process are described in SQL in _APPENDIX 1_.

Data for the census and usgs schemas were uploaded using the SHP2PGSQL command. Once imported the USGS PAD tabe ("area") was used to create several additional list tables to eliminate 'duplicate' attributes, as described above. Please see the ER Model and Logical Diagram for details. We used the state name (census.state.name) as a foreign key in the USGS PAD table (usgs_pad.area.state_nm). There are no onter direct linkages between the tables in different schaa's - all of the other conenctions are spatial in nature.

For each table, indexes were created on fields pertinet to our core queries. The list indludes:

**ebd.ebird**
- CREATE INDEX ebird_geom_idx ON ebd.ebird USING GIST (geom);
- CREATE INDEX ebird_common_name_idx ON ebd.ebird (common_name);
- CREATE INDEX ebird_scientific_name_idx ON ebd.ebird (scientific_name);
- CREATE INDEX ebird_month_idx ON ebd.ebird (date_part('month',observation_date);
- CREATE INDEX ebird_year_idx ON ebd.ebird (date_part('year',observation_date);
- CREATE INDEX ebird_obsdate_idx ON ebd.ebird (observation_date);

**usgs_pad.area**
- CREATE INDEX area_geom_idx ON usgs_pad.area USING GIST (geom);
- CREATE INDEX area_loc_nm_idx ON usgs_pad.area (loc_nm);
- CREATE INDEX area_mang_nm_idx ON usgs_pad.area (mang_nm);
- CREATE INDEX area_unit_nm_idx ON usgs_pad.area (unit_nm);

**census.state**
- CREATE INDEX state_geom_idx ON census.state USING GIST (geom);
- CREATE INDEX county_name_idx ON census.state (name);
- CREATE INDEX county_statefp_idx ON census.state (statefp);
- CREATE INDEX county_stusps_idx ON census.state (stusps);

**census.county**
- CREATE INDEX county_geom_idx ON census.county USING GIST (geom);
- CREATE INDEX county_name_idx ON census.county (name);



- [ ] **Database Manipulations**:
 - [ ] KM
 - [ ] DM

To answer our core questions, we created several example queries. Below are examples of the queries and results.

		**QUERY**
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

		**RESULTS**
		protected_area		|	access_type
		--------------------------------------------------------------
		Black Earth Creek Fishery Area		|	Open Access
		Capitol Springs Centennial State Park	|	Open Access
		Cherokee Marsh Fishery Area		|	Open Access
		Cross Plains State Park		|	Open Access
		Dane County Waterfowl Production Area	|	Open Access
		Door Creek		|	Open Access
		Dorn Creek Fishery Area		|	Open Access
		...
		Bad Fish Creek Wildlife Area 	|	Restricted Access
		Brooklyn Wildlife Area		|	Restricted Access
		Deansville Wildlife Area	|	Restricted Access
		Extensive Wl Habitat		|	Restricted Access
		Goose Lake Wildlife Area	|	Restricted Access
		...


		**QUERY**
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


		**RESULTS**
		common_name 	|	scientific_name
		------------------------------------------------
		Acadian Flycatcher	|	Empidonax virescens
		Accipiter sp.		|	Accipiter sp.
		Alder Flycatcher	|	Empidonax alnorum
		American Coot		|	Fulica americana
		American Crow		|	Corvus brachyrhynchos
		American Goldfinch	|	Spinus tristis
		American Kestrel	|	Falco sparverius
		American Redstart	|	Setophaga ruticilla
		...
		Yellow-rumped Warbler	|	Setophaga coronata
		Yellow-throated Vireo	|	Vireo flavifrons
		Yellow Warbler		|	Setophaga petechia

### Section 3: Results & Conclusion

- [ ] **Results**:
 - [ ] KM
 - [ ] DM

    
- [ ] **Discussion**:
 - [ ] KM
 - [ ] DM

    
- [ ] **Conclusion**:
 - [ ] KM
 - [ ] DM



### Section 4: References

eBird Basic Dataset, Version: EBD_US_relFeb-2017. Cornell Lab of Ornithology, Ithaca, New York. Feb 2017. 
    <https://ebird.org/ebird/data/download> Accessed Mar 2017.
Protected Areas Database of the United States (PAD-US), Version: PADUS1_4Shapefile. U.S. Geological Survey, 
    Gap Analysis Program (GAP). May 2016. <https://gapanalysis.usgs.gov/padus/data/download/> Accessed Mar 2017.
TIGER/Line Shapefiles, Versions: tl_2016_us_state, tl_2016_us_county. U.S. Census Bureau. 2016. 
    <https://www.census.gov/geo/maps-data/data/tiger-line.html> Accessed Apr 2017.
