# Sense of Place

A connection with the ocean is an important indicator of ocean health. While quantifying a feeling is a difficult endeavor, we feel it is an important aspect of measuring ocean health since this type of connection fosters stewardship. To do so, we try to capture the aspects of the coastal and marine system that people value as part of their cultural identity. This definition includes people living near the ocean and those who live far from it but still derive a sense of identity or value from the ocean. This goal scores highest when marine species which are valued by the community have minimal threats to conservation, when there are areas identified as special and have long term protection, and when coastal communities show engagement with commerical and recreation fishing activities. 

We include three sub-goals for Sense of Place: Lasting Special Places ($LSP$), Iconic Species ($ICO$), and Fishing Engagement ($SPFIS$). These three subgoals are averaged to get the final Sense of Place ($SOP$) goal status:

$$SOP_{i,t} = \frac{LSP_{i,t}+ICO_{i,t}+SPFIS_{i,t}}{3}$$

## Lasting Special Places

The Lasting Special Places sub-goal aims to measure how well geographic locations that hold particular value for aesthetic, spiritual, cultural, recreational or existence reasons, are protected. Due to data limitations, these unique aspects can not be discretely measured. Instead, we measure how much of the coast (offshore 3 nautical miles) is protected through **marine protected areas** ($mpa$), and how much of the inland area (1 kilometer from the coast) is protected ($lpa$) and compare these to reference targets from Aichi Target 11 which states a goal of 10% coastal protection and 17% land protection.


$$LSP_{i,t} = 100* \frac{(\frac{mpa_{i,t}}{0.1} + \frac{lpa_{i,t}}{0.17})}{2}$$

## Iconic Species

Iconic species are relevant to local cultural identity through a species’ relationship to one or more of the following: 1) traditional activities such as fishing, hunting or commerce; 2) local ethnic or religious practices; 3) existence value; and 4) locally-recognized aesthetic value. The **species status** ($st$) layer scores each iconic species, $x$, on a scale from 0 to 1 based on their conservation status. The Iconic Species sub-goal status is equal to the sum of the rescale conservation status of iconic species within each region ($i$).

$$ICO_{i,t} =100* \sum_{x=1}^{n}st_{x,t}$$


## Fishing Engagement

The Fishing Engagement ($SPFIS$) subgoal aims to measure the level of **commercial fishing engagement** ($c$) and **recreational fishing reliance** ($r$) there is in a region. These two data layers are averaged to get the final status for this sub-goal.

$$SPFIS_{i,t} = 100*\frac{c_{i,t}+r_{i,t}}{2}$$

## Goal Layers

----

### Marine protected areas  

**Data description:**   
We use the United States Geological Survey (USGS) Protected Areas Database (PAD) for the US, Version 2.0. This spatial geodatabase contains terrestrial and marine protected areas for the United States. There are 5 layers included in the database, one of which is Marine (`PADUS2_0Marine`). All areas designated as fishery/shellfish management areas as well as the Special Area Management Plans were removed from the outset since these designations are not associated with protection or designation as a special place, but rather for resource management. The database also includes the year of establishment.

### Methods 

The USGS PAD Marine data layer was overlaid with the Northeast OHI regions. The total area protected within each region was calculated. The target for this layer is to have at least 10% of marine area protected. This target reflects the Aichi Target 11 since there is no regional target. All of the marine protected areas were established before 2005, and show no change over the study period.

**Lasting Special Places sub-goal layer**  
Each region is scored from 0 to 1 by comparing the amount of marine protected areas to their total area. If 10% or more is protected, the region receives a 1. Scores linearly decrease to 0 for no protected areas.

**Gapfilling**  
No gapfilling was necessary.

----

### Coastal land protected areas

**Data description:**   
We use the United States Geological Survey (USGS) Protected Areas Database (PAD) for the US, Version 2.0. This spatial geodatabase contains terrestrial and marine protected areas for the United States. There are 5 layers included in the database, three of which are relevant for terrestrial protected areas (`PADUS2_0Designation`, `PADUS2_0Fee`, `PADUS2_0Easement`). The database also includes the year of establishment.

### Methods 

The three PAD data layers were combined and then clipped to the 1km inland buffer so that only areas within 1km of the coast are measured. The total area protected within each OHI assessment region was calculated. The target for this layer is to have at least 17% of coastal area protected. This target reflects the Aichi Target 11 since there is no regional target.

**Lasting Special Places sub-goal layer**  
Each region is scored from 0 to 1 by comparing the amount of coastal protected areas to their total area. If 17% or more is protected within a given year, the region receives a 1. Scores linearly decrease to 0 for no protected areas.

**Gapfilling**  
No gapfilling was necessary.

----

### Iconic species list

**Data description(s):**    
There was no known regionally appropriate list of iconic species so the list was created for this assessment.

**Methods summary**   
Regional experts were sought out through focus groups to provide input on what species should be included in the Iconic Species list. These species should be those that are relevant to local cultural identity through a species’ relationship to one or more of the following: 1) traditional activities such as fishing, hunting or commerce; 2) local ethnic or religious practices; 3) existence value; and 4) locally-recognized aesthetic value.

#### List of species:   

Common name|Scientific name|Conservation status available
-----------|---------------|--------------------
American oyster|Crossostrea virginia|No
Blue crab|Callinectes sapidus|No
Horseshoe crab|Limulus polyphemus|Yes
American lobster|Homarus americanus|Yes
Bay scallop|Argopecten irradians|No
Sea scallop|Placopecten magellanicus|Yes
Bald eagle|Haliaeetus leucocephalus|Yes
Humpback whale|Megaptera novaeangliae|Yes
North atlantic right whale|Eubalaena glacialis|Yes
Sperm whale|Physeter macrocephalus|Yes
Fin whale|Balaenoptera physalus|Yes
Bottlenose dolphin|Tursiops truncatus|Yes
Minke whale|Balaenoptera acutorostrata|Yes
Atlantic bluefin tuna|Thunnus thynnus|Yes
Arctic tern|Sterna paradisaea|Yes
Atlantic puffin|Fratercula arctica|Yes
Atlantic surfclam|Spissula solidissima|Yes
Soft shell clam|Mya arenaria|No
Northern quahog|Mecenaria mercenaria|No
Roseate tern|Sterna dougallii|Yes
Atlantic herring|Clupea harengus|Yes
Atlantic cod|Gadus morhua|Yes
Haddock|Melanogrammus aeglefinus|Yes
American shad|Alosa sapidissima|Yes
Alewife|Alosa pseudoharengus|Yes
Atlantic sturgeon|Acipenser oxyrhynchus oxyrhynchus|Yes
Striped bass|Morone saxatilis|Yes
Great white shark|Carcharodon carcharias|Yes
Sandbar shark|Carcharhinus plumbeus|Yes
Atlantic salmon|Salmo salar|Yes
Piping plover|Charadrius melodus|Yes
Common tern|Sterna hirundo|Yes
Least tern|Sternula antillarum|Yes
Osprey|Pandion haliaetus|Yes

**Iconic Species sub-goal layer**    
This layer is used in the Iconic Species sub-goal.

**Gapfilling**    
Not necessary

----

### Species conservation status

**Data description(s):**  
Species conservation status data were collected from two different sources: NatureServe and the International Union for Conservation of Nature’s (IUCN). NatureServe provides conservation information for terrestrial and marine species in Canada and the United States. Their database provides status information at the state level when possible, as well as the United States status and global status from IUCN. The database was queried using the `natserv` R package (Chamberlain 2020) and a total of 328 species and their conservation status were returned. For the remainder, the IUCN global database was queried using the `rredlist` R package (Chamberlain 2020), returning information for 363 species for a total of 691 species. Very few species had revised status during our study period, but whenever that data was available it was included.

**Methods summary**  

Species status' were translated into scores from 0 to 1 (table below) based on the IUCN threat categories status of each species following the weighting schemes developed by Butchart et al. (2007). For the purposes of this analysis, we included only data for extant species for which sufficient data were available to conduct an assessment. We did not include the Data Deficient classification as assessed species following previously published guidelines for a mid-point approach (Schipper et al. 2008).

Conservation status|	Score
-------------------|-------
Least Concern|	0
Near threatened|	0.2
Vulnerable|	0.4
Endangered|	0.6
Critically endangered|	0.8
Extinct|	1

Table: Conservation status scores translated into 0 (low threat) to 1 (highest threat/extinct) scale.


**Sense of Place: Iconic Species sub-goal layer**  
The final layer includes all species, their status score, and year. In the Sense of Place: Iconic Species, this layer is subset to just the 29 iconic species.

**Gapfilling:**   
Species conservation status are rarely updated due to limited time and resources for assessments. Therefore status scores are carried forward to 2017 or backfilled through 2005.

----

### Commercial fishing engagement

**Data description:**   
The commercial fishing engagement layer is derived from NOAA Fisheries Community Social Vulnerability Indicators dataset. 

> Social indicators are numerical measures that describe the well-being of individuals or communities. Indicators are comprised of one variable or several components combined into an index. They are used to describe and evaluate community well-being in terms of social, economic, and psychological welfare. In this study, a set of 13 indices have been developed to measure Social Vulnerability, Gentrification Pressure, Sea Level Rise Risk, and Fishing Dependence (both commercial and recreational) of coastal communities in the U.S.

This dataset contains indicator rankings (Low, Medium Low, Medium High and High) for coastal counties across many coastal US states for the years 2009 - 2016. This layer specifically used the Commercial Fishing Engagement indicator. Time series indicator data and the coastal communities shapefile was provided by NOAA via direct contact.

**Methods summary**   
The commercial fishing engagement indicator measures the presence of commercial fishing through fishing activity as shown through permits and vessel landings. We only wanted to include communities that touch the coast. Many of the counties included in the full dataset are not truly coastal (no boundary along the ocean or waterway). The first step was to use our inland 1km buffer on the coastal county shapefile provided by NOAA to select the coastal counties we were interested in by region.

We then subset the commercial fishing engagement indicator data and divide the Index score for each community (1-4) by 4, then take the mean across all communities in the region per year. 
 
**Fishing Engagement sub-goal layer**   
The target for this layer was set to be 10% higher than the highest observed value across all regions and years. For this layer that target was 0.474. The score for each region and year was equal to their coastal community mean aggregated score divided by this reference point.

**Gapfilling**    
Temporal gapfilling was necessary since this dataset only has data for 2009-2016. All years 2005-2008 were backfilled with the 2009 data, and 2017 was gapfilled with the 2016 data.

----

### Recreational fishing reliance

**Data description:**   
The recreational fishing reliance layer is derived from NOAA Fisheries Community Social Vulnerability Indicators dataset. 

> Social indicators are numerical measures that describe the well-being of individuals or communities. Indicators are comprised of one variable or several components combined into an index. They are used to describe and evaluate community well-being in terms of social, economic, and psychological welfare. In this study, a set of 13 indices have been developed to measure Social Vulnerability, Gentrification Pressure, Sea Level Rise Risk, and Fishing Dependence (both commercial and recreational) of coastal communities in the U.S.

This dataset contains indicator rankings (Low, Medium Low, Medium High and High) for coastal counties across many coastal US states for the years 2009 - 2016. This layer specifically used the Recreational Fishing Reliance indicator. Time series indicator data and the coastal communities shapefile was provided by NOAA via direct contact.

**Methods summary**   
The recreational fishing reliance indicator measures the presence of recreational fishing in relation to the population of a community. We only wanted to include communities that touch the coast. Many of the counties included in the full dataset are not truly coastal (no boundary along the ocean or waterway). The first step was to use our inland 1km buffer on the coastal county shapefile provided by NOAA to select the coastal counties we were interested in by region.

We then subset the recreational fishing reliance indicator data and divide the Index score for each community (1-4) by 4, then take the mean across all communities in the region per year. 
 
**Fishing Engagement sub-goal layer**   
The target for this layer was set to be 10% higher than the highest observed value across all regions and years. For this layer that target was 0.429. The score for each region and year was equal to their coastal community mean aggregated score divided by this reference point.

**Gapfilling**    
Temporal gapfilling was necessary since this dataset only has data for 2009-2016. All years 2005-2008 were backfilled with the 2009 data, and 2017 was gapfilled with the 2016 data.

----

#### References:  

NatureServe. (2019). NatureServe Explorer [web application]. NatureServe, Arlington, Virginia. https://explorer.natureserve.org/. [Accessed: July 22, 2019].

IUCN. (2018). The IUCN Red List of Threatened Species. Version 2018-1. http://www.iucnredlist.org. [Accessed 2018].

Butchart, Stuart HM, et al. "Improvements to the red list index." PloS one 2.1 (2007): e140.

Schipper, Jan, et al. "The status of the world's land and marine mammals: diversity, threat, and knowledge." Science 322.5899 (2008): 225-230.

Chamberlain, S. (2020). natserv: 'NatureServe' Interface. R package version 0.4.0. https://CRAN.R-project.org/package=natserv

Chamberlain, S. (2020). rredlist: 'IUCN' Red List Client. R package version 0.6.0. https://CRAN.R-project.org/package=rredlist

Schipper, J., Chanson, J. S., Chiozza, F., Cox, N. A., Hoffmann, M., Katariya, V., et al. (2008). The Status of the World’s Land and Marine Mammals: Diversity, Threat, and Knowledge. Science 322, 225–230. doi:10.1126/science.1165115.

U.S. Geological Survey (USGS) Gap Analysis Project (GAP), 2018, Protected Areas Database of the United States (PAD-US): U.S. Geological Survey data release, https://doi.org/10.5066/P955KPLE. [Downloaded June 5, 2019]

NOAA Fisheries Office of Science and Technology. (2019). NOAA Fisheries Community Social Vulnerability Indicators (CSVIs). Version 3.  https://www.fisheries.noaa.gov/national/socioeconomics/social-indicators-fishing-communities

Jepson, M., Colburn, L, L. (2013). Development of Social Indicators of Fishing Community Vulnerability and Resilience in the U.S. Southeast and Northeast Regions. U.S. Dept. of Commerce., NOAA Technical Memorandum NMFS-F/SPO-129, 64 p

