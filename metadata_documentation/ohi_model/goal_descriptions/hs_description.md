# Habitat Services

This goal aims to measure the extent of habitat services in the form of the amount of protection provided by marine and coastal habitats to coastal areas that people value, and the presence of areas serving as carbon sinks.

Healthy habitats contribute to coastal protection from storm surge, flooding and sea level rise and are a key aspect of carbon storage. In the Northeast, this includes salt marsh and eelgrass habitats. Both of these habitats are also included in the Biodiversity - Habitats subgoal. These habitats vary in their ability to protect against coastal storm surge so we apply a weighting scheme. Salt marsh is four times more protective than eelgrass in regards to coastal protection. 

## Data Layers

### Salt Marsh

For salt marsh habitats we used NOAA's Coastal Change Analysis Program data (C-CAP) to derive an estimate of salt marsh loss from 1996 through 2010 and a collection of historical loss estimates to estimate the overall loss of salt marsh habitat coverage since ~1880 (Table 1). The NOAA C-CAP data are land cover raster data (.img format) available for the years 1996, 2001, 2006 and 2010 for each state. To measure salt marsh habitats coverage in each of these years we included the following C-CAP land classifications: Estuarine Forested Wetland (16), Estuarine Scrub/Shrub Wetland (17), Estuarine Emergent Wetland (18), Estuarine Aquatic Bed (23). For each time step we remove all land cover cells that are not in the four categories. The total number of wetland cells is calculated for each time step, and then compared to the 1996 value to get a sense for percent gained or lost since 1996. These values ranged between a 2.5% loss (New York) and a roughly 3% gain (Maine). These values were added to the historical loss estimates (Table 1). Linear interpolation was used to gapfill missing data between 2001 and 2010, and the most recent value (2010) was carried forward to 2017.

|State|Historical loss (%)|Reference|
|----|----|----|
|Rhode Island| 53| Bromberg and Bertness (2005)|
|Massachusetts| 41| Bromberg and Bertness (2005)|
|New Hampshire| 18| Bromberg and Bertness (2005)|
|Maine|0| Bromberg and Bertness (2005)|
|Connecticut|27| Basso et al. 2015 |
|New York|48|Basso et al. 2015 |
Table 1: Estimates of historical salt marsh loss by state.

### Eelgrass

Data available to measure the extent and condition of eelgrass habitats in the Northeast through time is quite limited. As such we developed a model to assess the water quality condition in areas that are home to eelgrass habitats as a proxy for the condition of eelgrasses across the region. To gauge the extent of eelgrass across all Northeast States we first used the spatial Past Eelgrass Surveys data layer from the Northeast Data Portal to identify all locations where eelgrass has been in the past (1980 forwards). We then overlaid this location information with the EPA's National Coastal Condition Assessment Water Quality Index which measures Phosphorus, Nitrogen, Dissolved Oxygen, Water Clarity, and Chlorophyll a for each site monitored by the EPA across the region. The Water Quality Index provides data in categories of "Good", "Fair" and "Poor" for each monitoring site. We assign the following scores to each of these categories: Good = 100, Fair = 50 and Poor = 0. We then intersect the Water Quality Index monitoring sites with the current and past eelgrass beds as identified in the Northeast Data Portal using a 10km buffer to determine the water quality values where eelgrass are present. We only use sites where eelgrass presence data and water quality monitoring sites overlap within our 10km buffer and take the average score based on all overlapping points. Data is missing for 2005 and 2011-2017. With only two data points for 2006 and 2010, we gapfill 2005 data with the 2006 data and the 2010 data is carried forward through 2017.

## Carbon Storage

Since eelgrass and salt marsh have relatively similar carbon sequestration rates (Mcleod 2011) they are treated equally. The Carbon Storage sub-goal score for each region and year is calculated by taking the average eelgrass and salt marsh score.

## Coastal Protection

The presence of salt marsh has a near 4-times higher level of coastal protection against storm surge compared to eelgrass. To calculate the Coastal Protection sub-goal score, salt marsh scores are multiplied by 0.8, eelgrass scores multiplied by 0.2 and then summed for each region and year.

The **Habitat Services** goal score is the average of Carbon Storage and Coastal Protection.

## References

Basso, G., K. O'Brien, M. Albino, and V. O'Neill. "Status and trends of wetlands in the Long Island Sound Area: 130 year assessment." U.S. Department of the Interior, Fish and Wildlife Service. (2015): 37 pp.

Bromberg, Keryn D., and Mark D. Bertness. "Reconstructing New England salt marsh losses using historical maps." Estuaries 28.6 (2005): 823-832.

Mcleod, Elizabeth, et al. "A blueprint for blue carbon: toward an improved understanding of the role of vegetated coastal habitats in sequestering CO2." Frontiers in Ecology and the Environment 9.10 (2011): 552-560.
