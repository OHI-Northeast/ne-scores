# Livelihoods and Economies   
Jobs and revenue produced from marine-related industries are clearly of huge value to many people, even for those people who do not directly participate in marine-related industries. People value community identity, tax revenue, and indirect economic and social impacts of a stable coastal economy. The necessity of providing for oneself and those dependent on them, generally surpasses any other needs or objectives. Without the availability of jobs with livable wages, it is likely that people will prioritize ocean health less and feel less connected to it. This goal tracks the number and quality of jobs and the amount of revenue produced across as many marine-related industries/sectors as possible through two sub-goals, **Livelihoods** and **Economies**. A score of 100 reflects productive coastal economies that avoid the loss of ocean-dependent livelihoods while maximizing livelihood quality.

The two data layers for the Livelihoods sub-goal ($LIV$), **job growth** ($j$) and **wage growth** ($w$), were first scored according to their respective targets and then averaged to get the final Livelihoods sub-goal status. The Economies sub-goal ($ECO$) status is solely dependent on the **gross domestic product** ($gdp$) data layer. These two sub-goal statuses were averaged with equal weighting to get the final Livelihoods & Economies ($LE$) status. This goal is not assessed for the four offshore regions.

$$LIV_{i,t} = 100*\frac{j_{i,t} + w_{i,t}}{2} $$

$$ECO_{i,t} = 100*gdp_{i,t}$$

$$LE_{i,t} = \frac{LIV_{i,t} + ECO_{i,t}}{2} $$

## Goal Layers

----

### Economic growth

**Data description:** NOAA's Economics: National Ocean Watch (ENOW) data provides economic data relevant to ocean sectors at a county level for years 2005 - 2016. Ocean sectors include Living Resources, Marine Construction, Transportation, Ship & Boat Building, Tourism & Recreation, and Offshore Mineral Extraction. ENOW data on annual Gross Domestic Product (GDP) in 2012 US dollars was provided by the National Ocean Economics Program (NOEP) by county and ocean sector.

**Methods summary:** The data was provided by county and also as state-wide totals. From the data we selected GDP values across "All Ocean Sectors", rather than filtering for specific sectors. We also accounted for a data collection change between 2015 and 2016 (from the NOEP website):

> In the recent release of the ENOW series "An additional industry, Fish and Seafood Merchant Wholesalers (NAICS 424460) was added to the Living Resources sector's Seafood Market industry for data years 2016 and beyond. The industry was not applied to earlier years." The addition of this industry significantly distorts annual comparisons and timeline analysis of the Seafood Market sector and Living Resources totals.

To account for this change, we subtracted the 2016 value for Living Resources from All Ocean Sectors, and used the 2015 value for Living instead gapfilling with 2015 data.

After accounting for this, we compared aggregated county data to the state-wide totals and found differences between these two data series. This could be explained by suppressed data at the county level that is included in the state-wide totals. By comparing the absolute values and the temporal trends of the county-aggregated and state-wide totals we made decisions about what data series to use, either the county-level or state-wide totals. 

The state level information was used for Rhode Island, Maine, New York and Connecticut. Since Massachusetts is split into two regions in our region, and the state level trends were similar to the county-aggregated trends, just higher values, we used the county level information. The two data series for New Hampshire differed significantly beginning in 2011 due to data suppression up until that point, where the values across all economic indicators jumps for the state data series. We assumed that if data were not suppressed pre-2011 statewide, we would also see parallel trends in New Hampshire as well. Operating under that assumption, we opted to use the county level data for New Hampshire economic indicators.

Annual GDP growth rate was calculated for each region by comparing each year's GDP total to the average of the previous 3 years. 

**Economies sub-goal layer**  
Each region's GDP growth rate ($g$) is compared to the target of a 3% annual growth ($ref_{max} = 0.03$). This growth target was chosen as it aligns with a widely agreed upon national growth target of between 2-3 % annually (Jones 2016). All regions that achieved a 3% or greater growth rate compared to the average of the previous 3 years received a score of 1. Scores ($eco$) for each region ($i$) and year ($t$)  were scaled linearly so that a score of 0 would be equal to a 30% or greater annual loss in GDP ($ref_{min} = -0.3$), equal to levels seen during the Great Depression:

$$ eco_{i,t} = \begin{cases} 1,& g >= ref_{max},\\
\frac{g-ref_{min}}{ref_{max} - ref_{min}},& g < ref_{max}
\end{cases}$$

**Gapfilling:**  
The first three years of the time series, 2005-2007, were gapfilled with data from 2008 since growth rate was calculated by comparing to the previous three year mean. Since the dataset ends in 2016, these values are carried forward to 2017. There was no spatial gapfilling.

----

### Job growth

**Data description(s):**   
1. NOAA's Economics: National Ocean Watch (ENOW) data provides economic data relevant to ocean sectors at a county level for years 2005 - 2016. Ocean sectors include Living Resources, Marine Construction, Transportation, Ship & Boat Building, Tourism & Recreation, and Offshore Mineral Extraction. ENOW data on annual employment was provided by the National Ocean Economics Program (NOEP) by county and ocean sector.

2. Bureau of Labor Statistics (BLS) data on national employment. Specifically, the data series with ID: ENUUS00010010, "All Employees in Total Covered Total, all industries for All establishment sizes in U.S. TOTAL." This data was accessed from R using the R package `blscrapeR`.

**Methods summary:** The data was provided by county and also as state-wide totals. From the data we selected employment across "All Ocean Sectors", rather than filtering for specific sectors. We also accounted for a data collection change between 2015 and 2016 (from the NOEP website):

> In the recent release of the ENOW series "An additional industry, Fish and Seafood Merchant Wholesalers (NAICS 424460) was added to the Living Resources sector's Seafood Market industry for data years 2016 and beyond. The industry was not applied to earlier years." The addition of this industry significantly distorts annual comparisons and timeline analysis of the Seafood Market sector and Living Resources totals.

To account for this change, we subtracted the 2016 value for Living Resources from All Ocean Sectors, and used the 2015 value for Living instead gapfilling with 2015 data.

After accounting for this, we compared aggregated county data to the state-wide totals and found differences between these two data series. This could be explained by suppressed data at the county level that is included in the state-wide totals. By comparing the absolute values and the temporal trends of the county-aggregated and state-wide totals we made decisions about what data series to use, either the county-level or state-wide totals. 

The state level information was used for Rhode Island, Maine, New York and Connecticut. Since Massachusetts is split into two regions in our region, and the state level trends were similar to the county-aggregated trends, just higher values, we used the county level information. The two data series for New Hampshire differed significantly beginning in 2011 due to data suppression up until that point, where the values across all economic indicators jumps for the state data series. We assumed that if data were not suppressed pre-2011 statewide, we would also see parallel trends in New Hampshire as well. Operating under that assumption, we opted to use the county level data for New Hampshire economic indicators.

We calculated annual job growth rates and compared total employment that year to the average number of jobs over the previous 3 years. Because there is no absolute reference point for employment (i.e., a target number would be completely arbitrary), this layer uses a moving baseline as the reference point. The reference for regions job growth is set to be equal to or greater than the national average that year, calculated using data from the Bureau of Labor Statistics. This reflects an implicit goal of maintaining coastal employment on short time scales, allowing for decadal or generational shifts in what people want and expect.

Annual job growth rates for each region was calculated by comparing each year's total employment numbers to the national job growth rate, calculated using the United States Bureau of Labor Statistics data on national employment (series ENUUS00010010).

**Livelihoods sub-goal layer**  
Each region's mean employment growth rate ($g_{i}$) is compared to the national average over the same time period ($g_{n}$). If national job growth is positive, a region will score a 1 if it is greater than or equal to the national job growth rate. If national job growth is negative, we want coastal job growth to be the same or better than the region's job growth over the previous 3 years. A loss of 25% of jobs compared to the previous 3 years results in a score of 0. This reference point ($ref_{min}$ = 0.25) is equal to what was experienced during the Great Depression.


$$ j_{i,t} = \begin{cases} \frac{ref_{min} + g_{i}}{ref_{min} + g_{n}},& g_{n} >= 0,\\
\frac{ref_{min} + g_{i}}{ref_{min}},& g_{n} < 0
\end{cases}$$


**Gapfilling:**  
The first three years of the time series, 2005-2007, were gapfilled with data from 2008 since growth rate was calculated by comparing to the previous three year mean. Since the dataset ends in 2016, these values are carried forward to 2017. There was no spatial gapfilling.

----

### Wage growth

**Data description:** NOAA's Economics: National Ocean Watch (ENOW) data provides economic data relevant to ocean sectors at a county level for years 2005 - 2016. Ocean sectors include Living Resources, Marine Construction, Transportation, Ship & Boat Building, Tourism & Recreation, and Offshore Mineral Extraction. ENOW data on annual wages in 2012 US dollars, and annual employment, was provided by the National Ocean Economics Program (NOEP) by county and ocean sector.

**Methods summary:** The data was provided by county and also as state-wide totals. From the data we selected wages across "All Ocean Sectors", rather than filtering for specific sectors. We also accounted for a data collection change between 2015 and 2016 (from the NOEP website):

> In the recent release of the ENOW series "An additional industry, Fish and Seafood Merchant Wholesalers (NAICS 424460) was added to the Living Resources sector's Seafood Market industry for data years 2016 and beyond. The industry was not applied to earlier years." The addition of this industry significantly distorts annual comparisons and timeline analysis of the Seafood Market sector and Living Resources totals.

To account for this change, we subtracted the 2016 value for Living Resources from All Ocean Sectors, and used the 2015 value for Living instead gapfilling with 2015 data.

After accounting for this, we compared aggregated county data to the state-wide totals and found differences between these two data series. This could be explained by suppressed data at the county level that is included in the state-wide totals. By comparing the absolute values and the temporal trends of the county-aggregated and state-wide totals we made decisions about what data series to use, either the county-level or state-wide totals. 

The state level information was used for Rhode Island, Maine, New York and Connecticut. Since Massachusetts is split into two regions in our region, and the state level trends were similar to the county-aggregated trends, just higher values, we used the county level information. The two data series for New Hampshire differed significantly beginning in 2011 due to data suppression up until that point, where the values across all economic indicators jumps for the state data series. We assumed that if data were not suppressed pre-2011 statewide, we would also see parallel trends in New Hampshire as well. Operating under that assumption, we opted to use the county level data for New Hampshire economic indicators.

Annual mean wages per job was calculated by dividing total wages by total employment for each year and region. Annual wage growth rate was then calculated by comparing each year's mean wages to the average of the previous 3 years. 

**Livelihoods sub-goal layer**  
Each region's mean wage growth rate ($g$) is compared to the target of a 3.5% annual growth ($ref_{max} = 0.035$), equal to the United States Federal Reserve Nominal wage growth target. All regions that achieved a 3.5% or greater growth rate compared to the average of the previous 3 years received a score of 1. Scores ($w$) for each region ($i$) and year ($t$) were scaled linearly so that a score of 0 would be equal to a  40% or greater annual loss in mean wages ($ref_{min} = -0.4$), equal to what was seen during the Great Depression:

$$ w_{i,t} = \begin{cases} 1,& g >= ref_{max},\\
\frac{g-ref_{min}}{ref_{max} - ref_{min}},& g < ref_{max}
\end{cases}$$

**Gapfilling:**  
The first three years of the time series, 2005-2007, were gapfilled with data from 2008 since growth rate was calculated by comparing to the previous three year mean. Since the dataset ends in 2016, these values are carried forward to 2017. There was no spatial gapfilling.

----

#### References:  

National Ocean Economics Program. Ocean Economic Data by Sector & Industry., ONLINE. 2012. Available: http://www.OceanEconomics.org/Market/oceanEcon.asp [9 May 2019]

National Oceanic and Atmospheric Administration (NOAA). Economics: National Ocean Watch (ENOW) Data. Based on data from the Bureau of Labor Statistics and the Bureau of Economic Analysis. Charleston, SC: NOAA Office for Coastal Management.

Kris Eberwein (2019). blscrapeR: An API Wrapper for the Bureau of Labor Statistics (BLS). R package version 3.2.0. https://CRAN.R-project.org/package=blscrapeR

Jones, C. I. (2016). Chapter 1—The Facts of Economic Growth. In J. B. Taylor & H. Uhlig (Eds.), Handbook of Macroeconomics (Vol. 2, pp. 3–69). Elsevier. https://doi.org/10.1016/bs.hesmac.2016.03.002
