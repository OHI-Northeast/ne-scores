---
output:
  pdf_document: default
  html_document: default
---

# Biodiversity

People value biodiversity in particular for its existence value. The risk of species extinction generates great emotional and moral concern for many people. As such, this goal assesses the conservation status of species based on the best available global data through two sub-goals: species and habitats. Species were assessed because they are what one typically thinks of in relation to biodiversity. Because only a small proportion of marine species worldwide have been mapped and assessed, we also assessed habitats as part of this goal, and considered them a proxy for condition of the broad suite of species that depend on them. For the species sub-goal, we used species risk assessments from both NatureServe and the International Union for Conservation of Nature (IUCN 2016) for a wide range of taxa to provide a geographic snapshot of how total marine biodiversity is faring, even though it is a very small sub-sample of overall species diversity (Mora et al. 2011). For the habitats sub-goal we look to measure the status of key foundational habitats in the region: Salt Marsh, eelgrass, and Seabed Habitats (full list of habitats included below). We calculate each of these subgoals separately and weight them equally when calculating the overall goal score.

The **Biodiversity goal** score is equal to the average of the Habitats and Species sub-goal scores for each region and year.

$$ BIO_{i,t} = 100*\frac{SPP_{i,t} + HAB_{i,t}}{2}$$

### Habitats sub-goal

The habitat subgoal measures the average condition of marine habitats present in each region that provide critical habitat for a broad range of species (salt marsh, eelgrass, and seabed habitats). This subgoal is considered a proxy for the condition of the broad suite of marine species that rely on these habitats.

The **Habitats sub-goal** score for each region and year is equal to the average score across the three habitat classes assessed: salt marsh ($sm$), eelgrass ($e$), and seabed habitats ($sb$.

$$ HAB_{i,t} = \frac{sm_{i,t} + e_{i,t} + sb_{i,t}}{3}$$

### Species sub-goal

The Species sub-goal ($SPP$) measures how well marine species are faring in a given region using information about **species presence** ($p$) and their **conservation status** ($st$). The Species sub-goal status for each region and year is calculated by taking the average threat status for all  $x$ species ($sp$) found in the region and subtracting from 1. The upper reference point for the Species sub-goal is to have all species at a risk status of Least Concern. As in OHI global assessments, we scale the lower end of the goal to be 0 when 75% of species are extinct, a level comparable to the five documented mass extinctions that would constitute a catastrophic loss of biodiversity.  

mutate(score = 100*(0.75-status)/0.75,


$$SPP_{i,t} = \frac{0.75-\sum_{x=1}^{n}sp_{x,i,t} * st_{x,t}}{0.75} $$


## Goal Layers

----

### Eelgrass health

**Data description:**  
1. Locations of current and historic eelgrass beds in the Northeast. Geospatial data was downloaded from the Northeast Ocean Data Portal Past Eelgrass Survey's database https://www.northeastoceandata.org/eelgrass/past-eelgrass-surveys/.

2. Water Quality Index from the US Environmental Protection Agency National Coastal Condition Assessment (NCCA). This data was available for 2010, 2005/2006 and 2001. The NCCA reports include information across four indices for randomly sampled sites to represent the condition of all coastal waters: Biological Benthic Index, Water Quality Index (Phosphorus, Nitrogen, Dissolved Oxygen, Water Clarity, Chlorophyll a), Sediment Quality Index (contaminants & toxicity), Fish Quality Index. For this layer, we use only the Water Quality Index component of the report which measures Phosphorus, Nitrogen, Dissolved Oxygen, Water Clarity, and Chlorophyll a for each monitoring site. The Water Quality Index (WQI) provides data per site in categories of "Good", "Fair" and "Poor" according to thresholds established by the EPA. Some sites were assigned the category "Missing", these were removed before analysis. 

**Methods summary:** 

Data available to measure the extent and condition of eelgrass habitats in the Northeast through time was limited. We developed a model to assess the water quality condition in areas that are known to have eelgrass beds as a proxy for the condition of eelgrass beds across the region. A report by Neckles et al. (2009) states that:

> The most pervasive threat to eelgrass in the northeastern U.S. and Atlantic Canada is water quality degradation. Phil Colarusso summarized the components of water quality most relevant to eelgrass survival: nitrogen and phosphorus concentrations, chlorophyll a, suspended solids, and water clarity.

Since these are all measured in the Water Quality Index by the EPA, we chose to use the full WQI status rather than individual indicators from the index.

The Water Quality Index provides data in categories of "Good", "Fair" and "Poor" for each monitoring site. We assigned the following scores to each of these categories: Good = 100, Fair = 50 and Poor = 0. 

*Eelgrass bed locations*  
To gauge the extent of eelgrass across all Northeast States we first used the spatial Past Eelgrass Surveys data layer from the Northeast Data Portal to identify all locations where eelgrass has been in the past (1980 forwards).

*Intersect with water quality sampling sites*  
We then overlaid eelgrass bed location information with data from the EPA's National Coastal Condition Assessment (NCCA) Water Quality Index which measures Phosphorus, Nitrogen, Dissolved Oxygen, Water Clarity, and Chlorophyll a for each site monitored by the EPA across the region. We then intersected the Water Quality Index monitoring sites with the current and past eelgrass beds as identified in the Northeast Data Portal using a 10km buffer to determine the water quality values where eelgrass are present. We only use sites where eelgrass presence data and water quality monitoring sites overlap within our 10km buffer.

*Identify Long Island Sound sites*  
We also want to include the water quality monitoring sites in Long Island Sound (LIS). Our buffer approach still misses these sites since there are no eelgrass beds mapped from this region. But we know that historically eelgrass beds were present in LIS so we felt it important to include this region in the layer.

*Get scores using spsurvey*  
Each sampling site had an assigned weight indicating how representative of the area it is. These weights were incorporated into the scoring of each region by using the `spsurvey` R package and running a "Categorical Data Analysis for Probability Survey Data", which produced a sub-population estimate of the percent of area (e.g. 98%) for the coastal waters of a subpopulation (e.g. Maine) in a particular category of condition (e.g. Good).

**Biodiversity: Habitats sub-goal layer**   
The proportion (%) of each region that fell into the three different categories (Poor, Fair, Good) was multiplied by the categorical score (0, 50, 100 respectively), and then summed for the final score per region on a scale of 0 to 100.

**Gapfilling**   
Spatial gapfilling was done for Long Island Sound by including all available water quality sampling sites in that area, even though we did not have any spatial data on historical eelgrass beds in LIS. We do know that they were present there and thus should be included in the analysis. Long Island Sound is shared by Connecticut and New York, so these two regions were affected by this gapfilling.

Significant temporal gapfilling was needed. With only two data points for 2006 and 2010, we gapfill 2005 data with the 2006 data and the 2010 data is carried forward through 2017.

----

### Salt Marsh extent

**Data description:**  

This layer used NOAA's Coastal Change Analysis Program data (C-CAP) to derive an estimate of salt marsh loss from 1996 through 2010 and a collection of historical loss estimates to estimate the overall loss of salt marsh habitat coverage since ~1850s (Table below). 

1. NOAA's Coastal Change Analysis Program (C-CAP) land cover raster data (.img format) available for the years 1996, 2001, 2006 and 2010 for each state in the United States. To measure salt marsh habitats coverage in each of these years we included the following C-CAP land classifications: Estuarine Forested Wetland (16), Estuarine Scrub/Shrub Wetland (17), Estuarine Emergent Wetland (18), Estuarine Aquatic Bed (23).  
 
2. Historical loss references came from two studies

State |	Historical loss (%)	| Reference
------|---------------------|----------
Rhode Island|	53|	Bromberg and Bertness (2005)
Massachusetts|	41|	Bromberg and Bertness (2005)
New Hampshire|	18|	Bromberg and Bertness (2005)
Maine|	0|	Bromberg and Bertness (2005)
Connecticut|	27|	Basso et al. 2015
New York|	48	|Basso et al. 2015


**Methods summary:**  

*Estimating recent salt marsh loss*  
For each time step (1996, 2001, 2006 and 2010) we remove all land cover cells that are not in the four salt marsh categories. The total number of remaining cells is calculated for each time step, and then compared to the 1996 value to get a sense for percent gained or lost since 1996. These values ranged between a 2.5% loss (New York) and a roughly 3% gain (Maine). 

*Incorporating historic loss*  
There has been significant salt marsh lost in the Northeast United States since pre-industrial times. Unfortuantely, the landcover high resolution data only goes back to 1996. To account for historical loss, we looked to the literature for estimates of loss leading up to the 1990's. Both Bromberg and Bertness (2005) and Basso et al. (2015) provide state-level estimates of salt marsh loss since the 1850's. These figures were then added to the calculated habitat loss from the C-CAP data to get more accurate estimates of salt marsh habitat loss.

**Biodiversity: Habitats sub-goal layer**    
The final score for each region and year was equal to the inverse of the amount of salt marsh lost per region. If a region lost 25% of their salt marsh habitat, they would score 75.

**Gapfilling**   
The C-CAP data was of high enough resolution that we were able to calculate salt marsh loss in both North and South Massachusetts separately since 1996. But there was no data on historical loss at this scale. Each of these regions were assigned the same amount of historical loss (41%), assuming they lost the same proportion. Linear interpolation was used to gapfill missing data between 2001 and 2010, and the most recent value (2010) was carried forward to 2017.

----

### Seabed habitats

**Data description:**  
Data comes from the New England Fishery Management Council's model on Fishing Effects. From the Northeast Ocean Data Portal: 

> Fishing Effects represents the second generation of a framework that enables fishery managers to better understand the nature of fishing gear impacts on seabed habitats, the spatial distribution of seabed habitat vulnerability to particular fishing gears, and the spatial and temporal distribution of realized adverse effects from fishing activities on seabed habitats. Fishing Effects builds on the methods and results of the Swept-Area-Seabed-Impact (SASI) model developed in 2011 by the NEFMC Habitat Plan Development Team. Fishing Effects combines seafloor data (sediment type, energy regime) with parameters related to the interactions between fishing gear and seafloor habitats to generate habitat disturbance estimates in space and time.

Three types of data and maps are created by the model: Sediment, Percent Seabed Habitat Disturbance, and Intrinsic Seabed Habitat Vulnerability. For the OHI assessment, we used the Percent Seabed Habitat Disturbance layer. Data came in a 5x5km^2^ gridded format and contained monthly estimates of percent seabed habitat disturbance (0 - 1, 1 being completely disturbed) for all years 1996 to 2018.

Seabed habitats included in the Fishing Effects Model: Amphipods, anemones, ascidians, brachiopods, bryozoans, corals & sea pens, hydroids, macroalgae, scallops, mussels, polychaetes, sponges, sediment, biogenic burrows, biogenic depressions, bedforms, gravel, shell deposits

**Methods summary:**  
The raw data was first cropped to the OHI Northeast region. Mean annual rasters were calculated from the monthly Percent Seabed Habitat Disturbance rasters, and then overlaid with OHI regions to get the mean annual disturbance per OHI region per year.

**Biodiversity: Habitats sub-goal layer**   
The final score for each region and year was calculated as the inverse of the mean regional habitat disturbance, so that a region received a higher score for lower rates of disturbance.

**Gapfilling**   
No gapfilling was necessary.

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

*Table: Conservation status scores translated into 0 (low threat) to 1 (highest threat/extinct) scale.*

**Biodiversity: Species sub-goal layer**     
The final layer includes all species, their status score, and year. It is used in the Biodiversity: Species goal model.

**Gapfilling:**   
Species conservation status are rarely updated due to limited time and resources for assessments. Therefore status scores are carried forward to 2017 or backfilled through 2005.

----

### Species locations

**Data description(s):**  
Species range maps were collected from two different sources:    
1. Species maps provided by the Marine-life Data Analysis Team (MDAT) for the Northeast Ocean Data Portal (https://www.northeastoceandata.org/). A total of 156 species range maps including marine mammals, seabirds, and fish. Data was provided in raster format with cell values of either 1 (present) or 0 (absent).  

2. The International Union for Conservation of Nature’s (IUCN)    
Range maps from the IUCN database version 2018-1 were used to supplement the data portal maps. The IUCN data was provided via personal contact and relied on the same database used in O'Hara et al. (2020). The geospatial database contained individual shapefiles for all IUCN assessed species.

When species range maps were available for the same species from both data sources we prioritized the Northeast Ocean Data Portal maps as they were developed specifically for the region.

**Methods summary**  

*IUCN species range maps*   
The IUCN species shapefiles were clipped to the study region and rasterized to 1km2 grid cells with cell values of 1 (present) or NA (absent). 

*Northeast Ocean Data Portal species range maps*    
Since the species range maps provided by MDAT were already rasterized, we first clipped them to our study region and then resampled to 1km2 gride cells. Some of the fish maps were seasonal in nature (e.g. "Fall" and "Spring") and these were aggregated to give a representative picture of where the species could be found at any time of the year.

In total, we had 763 species with range maps for our region. There were 92 species that have range maps in both databases.

A final list of what regions each species was found in was compiled by overlaying the OHI regions on each species map and if at least one grid cell where a species is marked as present (value = 1), the species was listed to be found in that region.

**Biodiversity: Species sub-goal layer**     
The final layer includes all species and the regions where they are found.

**Gapfilling:**   
Gapfilling was not relevant to this layer.

----

#### References   

NROC (Northeast Regional Ocean Council). 2009. Past Eelgrass Surveys. Northeast Ocean Data Portal, https://www.northeastoceandata.org/eelgrass/past-eelgrass-surveys/. Accessed 9 May 2019.

U.S. Environmental Protection Agency. 2016. National Aquatic Resource Surveys. National Coastal Condition Assessment 2010 (data and metadata files). Available from U.S. EPA web page:https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys. Data from the National Aquatic Resource Surveys. Date accessed: 2018-07-31.

Neckles, H. A., A. R. Hanson, P. Colarusso, R. N. Buchsbaum, and F. T. Short (eds.). 2009. Status, Trends, and Conservation of Eelgrass in Atlantic Canada and the Northeastern United States. Report of a Workshop Held February 24-25, 2009, Portland, Maine.

Basso, G., K. O'Brien, M. Albino, and V. O'Neill. "Status and trends of wetlands in the Long Island Sound Area: 130 year assessment." U.S. Department of the Interior, Fish and Wildlife Service. (2015): 37 pp.

Bromberg, Keryn D., and Mark D. Bertness. (2005). "Reconstructing New England salt marsh losses using historical maps." Estuaries 28.6: 823-832.

New England Fishery Management Council. (2019). Fishing Effects Model Northeast Region. https://www.nefmc.org/library/fishing-effects-model. Data was emailed to the authors for approved use on April 12, 2019

NatureServe. (2019). NatureServe Explorer [web application]. NatureServe, Arlington, Virginia. https://explorer.natureserve.org/. [Accessed: July 22, 2019].

IUCN. (2018). The IUCN Red List of Threatened Species. Version 2018-1. http://www.iucnredlist.org. [Accessed 2018].

Butchart, Stuart HM, et al. "Improvements to the red list index." PloS one 2.1 (2007): e140.

Schipper, Jan, et al. "The status of the world's land and marine mammals: diversity, threat, and knowledge." Science 322.5899 (2008): 225-230.

Chamberlain, S. (2020). natserv: 'NatureServe' Interface. R package version 0.4.0. https://CRAN.R-project.org/package=natserv

Chamberlain, S. (2020). rredlist: 'IUCN' Red List Client. R package version 0.6.0. https://CRAN.R-project.org/package=rredlist

Schipper, J., Chanson, J. S., Chiozza, F., Cox, N. A., Hoffmann, M., Katariya, V., et al. (2008). The Status of the World’s Land and Marine Mammals: Diversity, Threat, and Knowledge. Science 322, 225–230. doi:10.1126/science.1165115.

Marine-life Data Analysis Team (MDAT; Patrick Halpin, Earvin Balderama, Jesse Cleary, Corrie Curtice, Michael Fogarty, Brian Kinlan, Charles Perretti, Jason Roberts, Emily Shumchenia, Arliss Winship). Marine life summary data products for Northeast ocean planning. Version 2.0. Northeast Ocean Data. http://northeastoceandata.org. Received 01/06/2019.
