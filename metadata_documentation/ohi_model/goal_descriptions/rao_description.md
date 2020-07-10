# Resource Access Opportunities

People value the ability to access coastal and ocean resources. Isolating what allows for this type of access is difficult, but a necessary component of humans relationship with the ocean. We isolated three key components; are people able to access the coast, are people able to go out on the water, and if they can, are the resources they seek available. This goal scores well when people are able to access the coastline, can afford to go boating, and fish stocks are thriving and available for accessing through fishing. The status for this goal ($RAO$)combines the three layers of this goal, **economic** ($e$), **coastal** ($c$) and **fisheries** ($f$) access, through a *geometric mean* to score each region ($i$) and goal for the years ($t = 2005 - 2017$).


$$ RAO_{i,t} =100*\sqrt[3]{e_{i,t}+c_{i,t}+f_{i,t}}$$

This goal was only assessed for coastal regions since that is where the people access coastal resources.

## Goal Layers

----

### Coastal access

**Data description(s):**   
This layer is derived from NOAA's Office of Response and Restoration's Environmental Sensitivity Index data. These maps were created to identify coastal resources that could be at risk if an oil spill were to occur. These include biological resources, sensitive habitats and human-use areas, which is the category we used to measure coastal access. Tee data was manually downloaded from the ESI site (https://response.restoration.noaa.gov/esi_download) for each state in the Northeast in August of 2019. The geospatial files provide point data. The data availability varied from different time periods between 2001 and 2016, but we combine all datasets as a single representative layer, therefore the time does not play a role in the final coastal access layer.  

**Methods summary:** 

The spatial information for each state was filtered to only those points that were of human use/interest. The reported point types varied from state to state, but overall encompassed the following which we included as coastal access points:

*Historical Site, Beach, Campground, Access Point, Boat Ramp, Marina, Ferry, Port, Access Point, Park, National Landmark, Surfing*

After removing all points not within these categories, a 1 mile buffer was applied to all points, since we were interested in measuring access points every mile of the coast. The total land area covered by this buffered point layer was calculated and compared to the total area of the 1 mile inland coastal shapefile. This allowed for comparison of how much of the 1 mile coastal strip was covered by an access point.

**Resource Access Opportunities goal layer**  
The score for each region was equal to the total area covered by coastal access points divided by the total area of the 1 mile inland buffer. A score of 1 indicates that there is a coastal access point every mile of the coast.

**Gapfilling:**  
Since there was not updated temporal data, this static layer was used for all years 2005 - 2016. There was no spatial gapfilling. 

----

### Economic access

**Data description(s)**  
1.  US Energy Information Administration (EIA) data on gasoline prices by county (Price data from the State Energy Data System (SEDS): 1960-2017 (complete)).

2.  Bureau of Labor Statistics (BLS) data on wages. Specifically, "Statewide Average Annual Pay All establishment sizes Total Covered Total". BLS dataseries IDS: ENU0900050010, ENU2300050010, ENU2500050010, ENU3300050010, ENU3600050010, ENU4400050010. This data was accessed from R using the R package `blscrapeR` for years 2001 to 2017.

**Methods summary**  
We calculated the ratio of gas prices to median wages for each state in the region. The target for this layer is to maintain a constant ratio each year. When no change, or a negative change indicating increased economic access occurs, this results in a perfect score. If the ratio doubles, the region scores 0.

*Median wages*  
Median annual wages were provided at the state level by the Bureau of Labor Statistics. No additional processing was needed.

*Gas Prices*  
Data on gas prices was converted from $/MMBtu (Millions of British thermal units), to approximate dollars per gallon using the heat contents provided by the EIA to get prices in US Dollars per gallon for each state. 

*Calculate ratio*  
Mean dollars per gallon was divided by mean wages for each region and year, and the change in that ratio year over year was calculated.

**Resource Access Opportunities layer**  
The target for this layer is to keep the ratio constant year over year. If the change remains the same (no change) or becomes negative, indicating a drop in the ratio, a region receives a score of 100. A score of 0 is assigned to a region if they experience a doubling in the ratio, as this would quickly and dramatically reduce economic access by half.

**Gapfilling**  
There was no gapfilling

----

### Fisheries resource access

**Data description(s)**    
The fish resource access layer was derived from NOAA’s Fish Stock Sustainability Index (FSSI). This data combines information from stock assessments to measure stock sustainability on a 0-4 scale for 47 stocks in the Northeast for all years 2005 - 2018.

**Methods summary**  
The raw data included stock name and location. Using this information, each stock was matched to an OHI region where it is found using the fisheries landings data used in the Wild-Caught Fisheries goal. Once the stocks were matched with OHI regions, each stock FSSI score was divided by 4 to convert scores into a 0 to 1 scale.

**Resource Access Opportunities layer**    
Each region's score is equal to the mean score of all stocks in the region and year.

**Gapfilling**   
There was no gapfilling

----

#### References

NOAA Fisheries Stock Sustainability Index. 2019. Emailed 29 July 2019. https://www.fisheries.noaa.gov/national/population-assessments/status-us-fisheries#fish-stock-sustainability-index.

U.S. Energy Information Administration (Oct 2008). Gasoline and Diesel Fuel Update. https://www.eia.gov/petroleum/gasdiesel/

Bureau of Labor Statistics, U.S. Department of Labor, Statewide Average Annual Pay All establishment sizes Total Covered Total.

National Oceanic Atmospheric Administration/Office of Response and Restoration. (2017).  Download ESI Maps and GIS Data.  NOAA/NOS Office of Response and Restoration, Seattle, WA. https://response.restoration.noaa.gov/esi_download
