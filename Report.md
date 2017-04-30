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
 - [ ] DM 
In the age of online collaboration, the scientific research community at large has gained the ability to more readily share their findings with the public. Likewise, so has the general population; thus, the concept of "citizen science" has thrived.  One of our primary sources, eBird, is a prime example of an organization that utilizes data from these self-titled “citizen scientists”. The Cornell Lab of Ornithology and National Audubon Society pooled their resources in 2002, resulting into what is now “…one of the largest and fastest growing biodiversity data resources in existence.” (eBird.org).
    
- [ ] **Research Questions**:
 - [X] KM
 - [ ] DM 
From the early planning stages, our primary objective has been: the creation of a platform that answers variations of these three questions: What bird species can I see nearby? Where can I see a certain species nearby? When can I see a certain species nearby? If you look back towards the first question you can see that at a minimum, a location must be provided. This requirement continues for the second and third questions; however, these two queries allow for bird species as an additional parameter. More detailed queries may include specifying a certain month, natural area, or any combination of the aforementioned variables. This project focuses on solutions to these concerns through the design, creation, and implementation of a spatial database, along with custom functions, joins, and relationships.
    
- [ ] **Data Description & Sources**:
 - [X] KM
 - [ ] DM 
Three main sources formed our database: the eBird Basic Dataset from Cornell, the Protected Areas Database of the United States from USGS, and TIGER/Line Shapefiles from the U.S. Census Bureau. The latter two sources were obtained as shapefiles and uploaded to our SQL database using PostGIS’ shp2pgsql and psql command line expressions. The download for the former source consists of a tab-delimited text file, imported as a table using the SQL copy command and assigned point geometry derived from longitude and latitude field values. 
    
- [ ] **Expectations & Transition to Section 2**:
 - [ ] KM
 - [ ] DM 
Although the raw data we obtained has the potential for extensive analytical research, our database will mainly cater to the average outdoor enthusiast and thus many of the original fields proved unnecessary. Our goal in combining these resources is developing a search tool that is both comprehensive and practical at a local scale. 
    

### Section 2: Database Design & Manipulation

- [ ] **Database Design**:
 - [ ] KM
 - [ ] DM 


- [ ] **Conceptual Model & Description**:
 - [ ] KM
 - [ ] DM 


- [ ] **Logical Model & Description**:
 - [ ] KM
 - [ ] DM 


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
