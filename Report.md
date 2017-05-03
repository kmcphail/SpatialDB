Guidelines:
- No more than 15 pages at 1.5 line spacing
- Format and style should conform to standards suitable for publication. 
- Details your thought process, approach, and results.
- Add maps/figures/tables/etc as needed.


## Avian GeoSearch
### Utilizing data-driven research to spatially locate bird species & accessible lands
#### Kirk McPhail, Dorn Moore




### Section 1: Introduction & Objectives

- [X] **Introduction**:
 - [X] KM
 - [X] DM

In the age of online collaboration, the scientific research community at large has gained the ability to more readily share their findings with the public. Likewise, so has the general population; thus, the concept of "citizen science" has thrived.  One of our primary sources, eBird, is a prime example of an organization that utilizes data from these self-titled “citizen scientists”. The Cornell Lab of Ornithology and National Audubon Society pooled their resources in 2002, resulting into what is now “…one of the largest and fastest growing biodiversity data resources in existence.” (eBird.org).

There is a considerable community of dedicated birders who use technology tools and networks of other birders to help them find opportunities to see more birds in their area or places they are visiting. However, for non-birders or novices, it can be difficult to know where to go to see a particular species or find a list of common species seen a particular area. For example, at the International Crane Foundation, where one of the authors works, it is a common question from visitors to our site or our website to ask "Where can I see Sandhill cranes near me?" Our goal with this project was to help bring together the over 274 million eBird species sightings in the United States to help people find birds.
    
- [X] **Research Questions**:
 - [X] KM
 - [X] DM

From the early planning stages, our primary objective has been the creation of a platform that answers variations of three questions: 

- What bird species can I see nearby? 
- Where can I see a certain species nearby? 
- When can I see a certain species nearby? 

The first question demonstrates the minimum requirement when writing a proper query statement for use in our database; a user must designate a search location. Building on this stipulation, the second and third questions allow for bird species as an additional parameter. More detailed queries may include specifying a certain month, natural area, or any combination of the aforementioned variables. This project focuses on solutions to these concerns through the design, creation, and implementation of a spatial database, along with custom functions, joins, and relationships.
    
- [ ] **Data Description & Sources**:
 - [X] KM
 - [X] DM

Three main sources form our database: the eBird Basic Dataset from Cornell, the Protected Areas Database of the United States from USGS, and TIGER/Line Shapefiles from the U.S. Census Bureau. The download for the former source consists of a tab-delimited text file, imported as a table using the SQL copy command and assigned point geometry derived from longitude and latitude field values. The latter two sources were obtained as shapefiles and uploaded to our SQL database using PostGIS’ shp2pgsql and psql command line expressions. 
    
- [ ] **Expectations & Transition to Section 2**:
 - [ ] KM
 - [ ] DM

Although the raw data we obtained has the potential for extensive analytical research, our database will primarily cater to the average outdoor enthusiast and thus many of the original fields proved unnecessary. Our goal in combining these resources is to develop a bird species search tool that is both comprehensive and practical at a local scale. 

We encountered several challenges working with such a vast dataset of species sightings. We were able to resolve several of these through query experimentation and will discuss those challenges and solutions in the sections below.
    

### Section 2: Database Design & Manipulation

- [ ] **Conceptual Model & Description**:
 - [ ] KM
 - [ ] DM

We translated our source data into four spatial entities (see "ebird", "area", "state", "county" in figure 1) placed in three categories, which are expressed as schemas during the database implementation phase. The first category consists of species observations depicted as points, another contains protected lands with polygon geometry, and the last category holds both states and counties represented as polygons. Given the amount of overlap in field values within each entity, minimizing redundancy via normalization became the next priority. 

_Figure 1. Entity-Relationship diagram_

- [ ] **Logical Model & Description**:
 - [ ] KM
 - [ ] DM


_Figure 2. Logical diagram_

- [ ] **Database Implementation**:
 - [ ] KM
 - [ ] DM 


- [ ] **Database Manipulations**:
 - [ ] KM
 - [ ] DM



### Section 3: Results & Conclusion

- [ ] **Results**:
 - [ ] KM
 - [ ] DM


- [ ] **Wrap-up/Discussion/Conclusion**:
 - [ ] KM
 - [ ] DM



### Section 4: References

eBird Basic Dataset, Version: EBD_US_relFeb-2017. Cornell Lab of Ornithology, Ithaca, New York. Feb 2017. 
    <https://ebird.org/ebird/data/download> Accessed Mar 2017.
Protected Areas Database of the United States (PAD-US), Version: PADUS1_4Shapefile. U.S. Geological Survey, 
    Gap Analysis Program (GAP). May 2016. <https://gapanalysis.usgs.gov/padus/data/download/> Accessed Mar 2017.
TIGER/Line Shapefiles, Versions: tl_2016_us_state, tl_2016_us_county. U.S. Census Bureau. 2016. 
    <https://www.census.gov/geo/maps-data/data/tiger-line.html> Accessed Apr 2017.
