# Habitat Services

This goal aims to measure the extent of habitat services in the form of the amount of protection provided by marine and coastal habitats to coastal areas that people value, and the presence of areas serving as carbon sinks. This goal contains two sub-goals, **Carbon Storage** ($CS$) and **Coastal Protection** ($CP$). Both of these sub-goals rely on two data layers that measure the extent of **salt marsh** ($sm$) and health of **eelgrass** ($eel$). Habitat Services ($HS$) status is calculated by taking the average of the Carbon Storage and Coastal Protection goals.

$$HS_{i,t} = 100*\frac{CS_{i,t}+CP_{i,t}}{2}$$

## Carbon Storage 
Since eelgrass and salt marsh have relatively similar carbon sequestration rates (Mcleod 2011) they are treated equally. The Carbon Storage sub-goal status for each region ($i$) and year ($t$) is calculated by taking the average eelgrass and salt marsh score.

$$CS_{i,t} = \frac{sm_{i,t}+eel_{i,t}}{2}$$

## Coastal Protection 
The presence of salt marsh has a near 4-times higher level of coastal protection against storm surge compared to eelgrass (Sharp et al. 2018). To calculate the Coastal Protection sub-goal status, salt marsh scores are multiplied by 0.8, eelgrass scores multiplied by 0.2 and then summed for each region ($i$) and year ($t$).

$$CP_{i,t} = 0.8*sm_{i,t} + 0.2*eel_{i,t}$$

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

**Habitat Services: Carbon Storage sub-goal layer**  
The proportion (%) of each region that fell into the three different categories (Poor, Fair, Good) was multiplied by the categorical score (0, 50, 100 respectively), and then summed for the final score per region on a scale of 0 to 100.

**Habitat Services: Coastal Protection sub-goal layer**  
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

**Habitat Services: Carbon Storage sub-goal layer**   
The final score for each region and year was equal to the inverse of the amount of salt marsh lost per region. If a region lost 25% of their salt marsh habitat, they would score 75.

**Habitat Services: Coastal Protection sub-goal layer**   
The final score for each region and year was equal to the inverse of the amount of salt marsh lost per region. If a region lost 25% of their salt marsh habitat, they would score 75.

**Gapfilling**   
The C-CAP data was of high enough resolution that we were able to calculate salt marsh loss in both North and South Massachusetts separately since 1996. But there was no data on historical loss at this scale. Each of these regions were assigned the same amount of historical loss (41%), assuming they lost the same proportion. Linear interpolation was used to gapfill missing data between 2001 and 2010, and the most recent value (2010) was carried forward to 2017.

----

#### References    
Mcleod, E., Chmura, G. L., Bouillon, S., Salm, R., Björk, M., Duarte, C. M., et al. (2011). A blueprint for blue carbon: toward an improved understanding of the role of vegetated coastal habitats in sequestering CO 2. Frontiers in Ecology and the Environment 9, 552–560. doi:10.1890/110004.

Sharp, R., Tallis, H.T., Ricketts, T., Guerry, A.D., Wood, S.A., Chaplin-Kramer, R., et al. (2018). InVEST 3.6.0 User’s Guide. The Natural Capital Project, Stanford University, University of Minnesota, The Nature Conservancy, and World Wildlife Fund.

NROC (Northeast Regional Ocean Council). 2009. Past Eelgrass Surveys. Northeast Ocean Data Portal, https://www.northeastoceandata.org/eelgrass/past-eelgrass-surveys/. Accessed 9 May 2019.

U.S. Environmental Protection Agency. 2016. National Aquatic Resource Surveys. National Coastal Condition Assessment 2010 (data and metadata files). Available from U.S. EPA web page:https://www.epa.gov/national-aquatic-resource-surveys/data-national-aquatic-resource-surveys. Data from the National Aquatic Resource Surveys. Date accessed: 2018-07-31.

Neckles, H. A., A. R. Hanson, P. Colarusso, R. N. Buchsbaum, and F. T. Short (eds.). 2009. Status, Trends, and Conservation of Eelgrass in Atlantic Canada and the Northeastern United States. Report of a Workshop Held February 24-25, 2009, Portland, Maine.

Basso, G., K. O'Brien, M. Albino, and V. O'Neill. "Status and trends of wetlands in the Long Island Sound Area: 130 year assessment." U.S. Department of the Interior, Fish and Wildlife Service. (2015): 37 pp.

Bromberg, Keryn D., and Mark D. Bertness. (2005). "Reconstructing New England salt marsh losses using historical maps." Estuaries 28.6: 823-832.
