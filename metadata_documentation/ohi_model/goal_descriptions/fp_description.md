---
output:
  pdf_document: default
  html_document: default
---

# Food Provision

The Food Provision goal contains two sub-goals, Aquaculture ($AQ$) and Wild-Caught Fisheries ($FIS$).

## Aquaculture

The aim of this sub-goal is to maximize the sustainable production of farmed seafood. Higher scores reflect significant growth of food provisioning of farmed species in a sustainable manner. With limited information about regional targets for aquaculture production in the Northeast, an annual production growth rate of 4% is used. Information on sustainability of farmed species is used to weight production in a manner where less sustainable species (i.e. Atlantic salmon) contribute less to the overall production score than more sustainable species (i.e. oysters).

The species **production** ($p$) layer was compiled by hand from many different sources and required conversion to a single unit, pounds. Requirements for reporting vary state by state, and confidentiality clauses can limit the amount of available data. Species **sustainability** ($s$) layer was used to weight the contribution of farmed seafood. Production in tons for each species ($x$) is multiplied by the species sustainability score ($s$) which is on a 0 (least sustainable) to 1 (most sustainable) scale. The weighted production data is aggregated by region and compared to last years production. If annual production has increased by at least 4% compared to last years, the region scores 100. 

$$ AQ_{i,t} = \sum_{x=1}^{n}s_{x}*p_{x,i,t} $$


## Wild-Caught Fisheries

The aim of this sub-goal is to maximize the sustainable harvest of seafood in regional waters from wild-caught fisheries. Wild caught fisheries harvests must remain below levels that would compromise the resource and its future harvest, but the amount of seafood harvested should be maximized within the bounds of sustainability, i.e., maximum sustainable yield (MSY). In short, regions are rewarded for maximizing the amount of sustainable food provided and penalized for unsustainable practices and/or underharvest. A region may deliberately underharvest resources for conservation or other purposes, in which case its score for food provision would decrease, but its score for other goals (e.g., biodiversity, sense of place) might increase. This sub-goal is calculated from two layers, **Fisheries landings** ($c$) and **Fisheries stock status** ($ss$).

The **landings** layer was derived from the NOAA Fisheries (NMFS) Commercial Landings data. This data was provided by statistical area for the years 1996-2017. The amount of Atlantic herring, mackerel and skate caught for bait were removed. Landings data is used to weight stock scores by their proportional contribution to regional catch.

$$w_{x} = \frac{c_{x}}{\sum_{x=1}^{n}{c}} $$

The **stock status** ($ss$) layer was derived from stock assessment information provided by the National Marine Fisheries Service or RAM Legacy Stock Assessment Database. The metrics B/Bmsy and F/Fmsy (when available) were used to score each stock between 0 (least sustainable) and 1 (most sustainable). For more details about how these layers were calculated see the Layers section.

The annual proportional catch ($w$) of each stock ($x$) within each of the 12 regions was used to weight the contribution of stock scores ($ss$) to the final Wild-Caught Fisheries status for each region ($i$) and year ($t$).

$$FIS_{i,t} = \sum_{x=1}^{n}w_{x,i,t} * ss_{x,t} $$

The Food Provision goal status is equal to the production-weighted average of the Fisheries and Aquaculture goal statuses. The total amount of seafood produced by aquaculture ($p_{aq}$) and fisheries ($p_{fis}$) in each region is calculated and the proportional amount of each is used to weight the contribution of these two sub-goal statuses to the Food Provision goal status.

$$FP_{i,t} = 100*(p_{fis}*FIS_{i,t}+p_{aq}*AQ_{i,t})$$


## Goal Layers

----

### Aquaculture production

**Data description(s):**    
Production data was gathered from available state reports (e.g. CRMC’s “Aquaculture in Rhode Island”, Massachusetts DF&G reports). Since this data often exists within PDF’s and various formats, all production data was entered by hand into a google sheet.

**Methods summary**  
The raw data was cleaned so that all units of production were in pounds according to the conversion table below:

Species |	Pounds|	Bushel	|Bag	|Individual
--------|-------|---------|-----|----------
Hard Clam |	1	|0.017|	0.048	|10.00
Quahog	|1	|0.017	|NA	|10.00
Soft Shell Clams	|1	|0.020	|NA|	NA
Bay Scallop	|1	|0.014|	NA|	NA
Oysters	|1	|0.017|	0.017|	2.36
Clams	|1	|0.017	|NA	|NA
Scallops	|1	|0.014	|NA|	NA

Species names were harmonized, e.g. "Quahog" and "Clams" were assigned the shared name "Hard Clams". A three year rolling mean was applied to production to account for year to year variability.

**Aquaculture sub-goal layer**    
The final layer includes total production in pounds of each species farmed in each region over time.

**Gapfilling:**   
Some regions had missing data for years and required gapfilling.

Maine's Department of Marine Resources (DMR) does not report Atlantic salmon production data after 2010 due to confidentiality statutes. Based on communication with experts in the region, we know that Atlantic salmon production does not stop after 2010. Without any other information, we gapfilled 2011 - 2017 with the same 2010 production data reported by Maine's DMR.

Massachusetts was missing 2012 and 2013 for Hard Clam and Oysters, and Rhode Island was missing 2010 for Oysters and Hard Clam. We didn’t know if these were true 0’s, indicating no production, or missing data. Since we calculate a rolling average of production, NAs will remain as NA’s and the average will rely on just one or two years of catch. This is done to account for any wild fluctuations in catch year to year.

**Data Sources:**
*Rhode Island*  
Aquaculture Situation and Outlook Report 2009: Rhode Island  
Coastal Resources Management Council, Aquaculture in Rhode Island - Annual Status Reports (1999 - 2015)

*Maine*  
Maine Department of Marine Resources Aquaculture Harvest Data. https://www.maine.gov/dmr/aquaculture/harvestdata/index.html.  
Aquaculture Situation and Outlook Report 2009: Maine

*Massachusetts*   
Department of Fish and Game Massachusetts Marine Fisheries Annual Report (2011-2017).  
Aquaculture Situation and Outlook Report 2009: Massachusetts  

*New York*  
Aquaculture Situation and Outlook Report 2009: New York  
Shellfish Harvested in Long Island Sound. https://longislandsoundstudy.net/ecosystem-target-indicators/shellfish-harvested/

*Connecticut*  
Aquaculture Situation and Outlook Report 2009: Connecticut  
Shellfish Harvested in Long Island Sound. https://longislandsoundstudy.net/ecosystem-target-indicators/shellfish-harvested/

*New Hampshire*  
New Hampshire Fish and Game Biennial Reports (2015, 2017, 2019)  
Aquaculture Situation and Outlook Report 2010: New Hampshire

----

### Aquaculture species sustainability

**Data description(s):**    
Monterey Bay Aquarium's Seafood Watch aquaculture standards were used as sustainability factors for all farmed aquaculture species in the Northeast. Seafood Watch (SW) data measures species sustainability based on multiple factors, including gear type, location, species, and more. Through direct communication with SW, we were provided with a database of farmed species for the United States specifically.

**Methods summary:** 
The Seafood Watch data provided a sustainability score for each species on a scale from 0 to 10. It was not possible to perfectly match each reported farmed species with their counterpart in the Seafood Watch data but in these cases, the nearest species was used. Below, sustainability scores for each species is discussed.

*Oysters*   
The data had *Eastern oyster* but not *American oyster* although both were reported in production. All oyster species in the database had the same score of 7.98, so this score was used for all oyster species.

*Atlantic salmon*   
Atlantic salmon farmed in marine net pens had a score of 4.82.

*Scallops*  
Both *Bay scallops* and *scallops* were reported in the production data. Seafood Watch data scores Bay scallops at 8.86. In fact, all scallops in the database had a score of 8.86, and so this score was used for all scallops in the production data.

*Mussels*  
Both *Blue mussels* and *mussels* were reported in the production data. All mussels in the Seafood Watch dataset had a score of 8.11.

*Clams*  
Both *Hard Clams/Quahogs* and *soft shell Clams* were reported in the production data. Hard Clams had a score of 8.39. Seafood Watch doesn’t have Quahog or “Clams", so those two species received the same value as Hard Clam.


**Aquaculture sub-goal layer**  
These were simply converted to 0 to 1 for use in the Aquaculture sub-goal.

**Gapfilling:**  
There was no gapfilling necessary.

**References:**  
Monterey Bay Aquarium Seafood Watch program. 2019. Seafood Watch Aquaculture Standards for the United States. Data provided via direct communication, 23 August 2019. 

----

### Fisheries stock status

**Data description:**   

Stock assessment information was provided for 46 individual stocks via data request from the National Marine Fisheries Service for all stocks in the greater Northeast region from 2004 - 2018. Specifically, the metrics B/Bmsy and F/Fmsy (when available) were provided for the years in which they were assessed. Additional stock assessment information for species not in the NMFS stock assessment database were available in the RAM Legacy Stock Assessment database, this resulted in four additional stocks. Stock assessments for American lobster were collected from the Atlantic States Marine Fisheries Commission documents.

Assessment source | Stock | Metrics
------|---------------------|-------
ASMFC | American lobster, Gulf of Maine | B/Bmsy, F/Fmsy
ASMFC | American lobster, Southern New England | B/Bmsy, F/Fmsy
NMFS  | Acadian redfish | B/Bmsy, F/Fmsy
NMFS  | American plaice | B/Bmsy, F/Fmsy
NMFS  | Atlantic cod, George's Bank | B/Bmsy, F/Fmsy     
NMFS  | Atlantic cod, Gulf of Maine | B/Bmsy, F/Fmsy     
NMFS  | Atlanic halibut | B/Bmsy, F/Fmsy
NMFS  | Atlantic herring | B/Bmsy, F/Fmsy
NMFS  | Atlantic mackerel | B/Bmsy, F/Fmsy
NMFS  | Surf clam | B/Bmsy, F/Fmsy
NMFS  | Atlantic wolffish | B/Bmsy, F/Fmsy
NMFS  | Barndoor skate | B/Bmsy
NMFS  | Black sea bass | B/Bmsy, F/Fmsy
NMFS  | Bluefish | B/Bmsy, F/Fmsy
NMFS  | Butterfish | B/Bmsy, F/Fmsy
NMFS  | Clearnose skate | B/Bmsy
NMFS  | Monkfish/anglerfish/goosefish, Gulf of Maine/Northern Georges Bank | B/Bmsy, F/Fmsy
NMFS  | Monkfish/anglerfish/goosefish, Southern Georges Bank/Mid-Atlantic | B/Bmsy, F/Fmsy
NMFS  | Haddock, George's Bank | B/Bmsy, F/Fmsy
NMFS  | Haddock, Gulf of Maine | B/Bmsy, F/Fmsy
NMFS  | Little (Summer) skate | B/Bmsy
NMFS  | Squid/Loligo
NMFS  | Ocean pout | B/Bmsy, F/Fmsy
NMFS  | Ocean quahog | B/Bmsy, F/Fmsy
NMFS  | Pollock | B/Bmsy, F/Fmsy
NMFS  | Red hake, Gulf of Maine/Northern Georges Bank | B/Bmsy, F/Fmsy
NMFS  | Red hake, Southern Georges Bank/Mid-Atlantic | B/Bmsy, F/Fmsy
NMFS  | Scup/Porgy | B/Bmsy, F/Fmsy
NMFS  | Sea scallop | B/Bmsy, F/Fmsy
NMFS  | Silver hake/Whiting, Gulf of Maine/Northern Georges Bank | B/Bmsy, F/Fmsy
NMFS  | Silver hake/Whiting, Southern Georges Bank/Mid-Atlantic | B/Bmsy, F/Fmsy
NMFS  | Smooth skate | B/Bmsy
NMFS  | Spiny dogfish | B/Bmsy, F/Fmsy
NMFS  | Summer flounder | B/Bmsy, F/Fmsy
NMFS  | Thorny skate | B/Bmsy
NMFS  | Tilefish | B/Bmsy, F/Fmsy
NMFS  | Blueline tilefish | B/Bmsy, F/Fmsy
NMFS  | Golden tilefish | B/Bmsy, F/Fmsy
NMFS  | White hake | B/Bmsy, F/Fmsy
NMFS  | Sand-dab flounder/Windowpane/Brill, Gulf of Maine/Georges Bank | B/Bmsy, F/Fmsy
NMFS  | Sand-dab flounder/Windowpane/Brill, Southern New England/Mid-Atlantic | B/Bmsy, F/Fmsy
NMFS  | Winter flounder, Georges Bank | B/Bmsy, F/Fmsy
NMFS  | Winter flounder, Southern New England/Mid-Atlantic | B/Bmsy, F/Fmsy
NMFS  | Winter flounder, Gulf of Maine | B/Bmsy, F/Fmsy
NMFS  | Winter skate | B/Bmsy
NMFS  | Witch flounder | B/Bmsy, F/Fmsy
NMFS  | Yellowtail flounder, Cape Cod/Gulf of Maine | B/Bmsy, F/Fmsy
NMFS  | Yellowtail flounder, Georges Bank | B/Bmsy, F/Fmsy
NMFS  | Yellowtail flounder, Southern New England/Mid-Atlantic | B/Bmsy, F/Fmsy
RAM   | Menhaden | B/Bmsy, F/Fmsy
RAM   | Skipjack tuna | B/Bmsy, F/Fmsy
RAM   | Striped bass | B/Bmsy, F/Fmsy
RAM   | Weakfish | B/Bmsy


### Methods

Each stock is rescaled to be between 0 (least sustainable) and 1 (most sustainable) using stock assessment metrics $B/B_{MSY}$ and, when available, $F/F_{MSY}$. 

#### Rescaling $B/B_{MSY}$

The amount of biomass in the water ($B$) compared to the amount of biomass that can be harvested at maximum sustainable yield ($B_{MSY}$) provides a metric for knowing whether a single stock is fully exploited (0.8 < $B/B_{MSY}$ < 1.2), overfished ($B/B_{MSY}$ < 0.8) or underfished ($B/B_{MSY}$ > 1.2). The stock biomass score ($B'$) for each stock is calculated based on $B/B_{MSY}$, where

$$ B' = \begin{cases} B/B_{MSY},& B/B_{MSY} < 0.8,\\
1,& 0.8 < B/B_{MSY} < 1.2, \\
\frac{thresh - B/B_{MSY}}{thresh-pen} , & 1.2 < B/B_{MSY} < 3.0,\\
0.25, & B/B_{MSY} >= 3.0
\end{cases}$$


underexploitation penalty, $pen$ = 0.25 (a stock can not receive lower than 0.25 if underexploited)  
underxploitation threshold, $thresh$ = 3 (once a stock has a $B/B_{MSY}$ of 3 or greater, it will receive a score of 0.25)  


#### Rescaling $F/F_{MSY}$

Rescaled fishing mortality F' for each stock is calculated for stocks that have an assessed fishing mortality rate ($F/F_{MSY}$). This allows scores to reflect whether management actions have been taken to reduce fishing pressure, in particular for stocks that are overfished. As such, if a stock is overfished (B/BMSY < 0.8) but F/FMSY is reduced to account for rebuilding, F’ is set to 1 and the stock can receive the highest score of 1. A three year rolling-mean is also applied to $F'$ since fishing mortality fluctuate significantly in a short amount of time in response to a management decision. . This is not done for $B`$ as it is a less sensitive metric since it relies on biological processes.


When $B/B_{MSY}$ >= 0.8, a perfect score of 1 is assigned if $F/F_{MSY}$ is between 0.66 and 1.2. If $F/F_{MSY}$ is greater than 1.2, $F`$ decreases linearly towards 0, and once $F/F_{MSY}$ is greater than 2.0, indicating overfishing, $F`$ goes to 0. If $F/F_{MSY}$ is less than 0.66, indicating underfishing, $F`$ decreases linearly to a minimum score of 0.25.

$$ F' = \begin{cases} 0,& F/F_{MSY} >= 2.0,\\
\frac{2 - F/F_{MSY}}{0.8},& 1.2 < F/F_{MSY} < 2.0, \\
1 , & 0.66 < F/F_{MSY} < 1.2, \\
0.25 + \frac{0.75F/F_{MSY}}{0.66},& F/F_{MSY} < 0.66
\end{cases}$$

When $B/B_{MSY}$ < 0.8 & $F/F_{MSY}$ < 2.0, the model is altered to allow for low levels of fishing ($F/F_{MSY}$) for overfished stocks as a management measure. In these cases, $F/F_{MSY}$ is first translated into a new parameter, $F$ based on the slope of the line from from $B/B_{MSY} = 0.8$ to $0$:

$$F = F/F_{MSY} + \frac{1.2 - B/B_{MSY}}{0.7}$$
then,

$$ F' = \begin{cases} 0,& F >= 2.0,\\
\frac{2 - F}{0.8},& 1.2 < F < 2.0, \\
1 , & 0.66 < F < 1.2, \\
0.25 + \frac{0.75F}{0.66},& F < 0.66
\end{cases}$$

#### Calculating stock scores

The final stock score ($SS$) is the product of $B`$ and $F`$. If only $B/B_{MSY}$ is available, $SS = B`$. 


$$ SS = F'*B'$$


Here is an example of how $B/B_{MSY}$ and $F/F_{MSY}$ values are turned into stock scores between 0 and 1 for Pollock in the Gulf of Maine/Georges Bank:

![](../layers_info/pollock_kobe.png)

**Wild-Caught Fisheries goal layer**  
The final stock status layer lists each stock and it's stock score between 0 and 1. This is then combined with the fisheries landings data in the Wild-Caught Fisheries model to match stocks with the regions in which they are caught, and their stock scores are catch-weighted according to the proportional catch each stock makes up for each region.

**Gapfilling**  
Stock assessments are not performed every year for every managed stock in a region. This necessitates some gapfilling for years where information is not provided. All missing values for $B/B_{MSY}$ and $F/F_{MSY}$ were gapfilled with the most recent known value.

----

### Fisheries landings

**Data description:**   
Landings by statistical area for the US Northeast were provided by the National Marine Fisheries Service (NMFS) via email request in July of 2019. Data included pounds of species caught per statistical area (as designated by NOAA/NMFS) for the years 1996 - 2017. A total of 154 species are reported to be caught within the Northeast region between 1996 and 2017. This includes names such as "CONFIDENTIAL SPECIES", "OTHER INVERTEBRATES", and "CLAM, SPECIES NOT SPECIFIED". This data came from the Vessel Trip Reporting (VTR) database. Additional landings data from the Data Matching and Imputation System (DMIS) database was provided in January of 2020 to specifically fix inaccurate catch of American lobster in the VTR database. 

Note that while NOAA does maintain an online database for landings, it is presented as an aggregated landings database - to the state level. We used disaggregated landings data that is more spatially explicit to allow for higher resolution accounting of fisheries catch.

**Methods summary:** 

*1. Assigned landings to OHI regions*   
In order to aggregate species landings to the 12 Ocean Health Index Northeast regions, statistical areas were intersected with the OHI regions, and the amount of catch in each statistical area was assigned to the OHI region according to the proportional area of overlap. We assumed that catch was evenly distributed across each statistical area.

For example, statistical area 522 is 55% in the George's Bank region, and 45% in the Gulf of Maine. All catch reported in area 522 is split according to the 55%/45% proportion between the George's Bank and Gulf of Maine regions.

*2. Calculate mean landings*  
After aggregating landings to OHI regions, a three-year rolling mean of species landings was calculated to account for any significant year-to-year variability that may not be indicative of the average annual catch.

*3. Replace lobster catch*  
The catch figures for American lobster in this spatial NMFS dataset were significantly lower than reported landings in scientific stock assessments. Given the importance of this species both culturally and commercially, the landings figures were replaced using Lobster data from another NMFS dataset called the Data Matching and Imputation System (DMIS) database. These come with statistical areas so they can matchup with the VTR data. The VTR database is inaccurate when it comes to lobster because vessels with only a lobster permit are not required to submit a vessel trip report. The DMIS database builds off the VTR data to estimate landings by area.

*4. Removing catch from bait fisheries*
Bait fisheries are an important industry in the Northeast and make up a significant portion of total catch in the region, especially Atlantic herring. Since the Wild-Caught Fisheries sub-goal is meant to measure how well sustainable seafood is being provided for human consumption, all catch meant for non-human consumption (e.g. bait, pet food) is removed. Catch data by market was again provided via data request from the National Marine Fisheries Service.

**Wild-Caught Fisheries goal layer**  
The final goal layer includes total landings per year, species and region. This is used within the Wild-Caught Fisheries goal model to calculate the proportion that each species contributes to the region's total catch and is then used as to weight stock scores.

**Gapfilling**  
Some species had missing data and it was not clear whether they were true zeroes or missing data. We left these as missing (NA) and when a rolling mean was taken, it was dependent on those years where catch was reported.

----


#### References  
National Marine Fisheries Service. (2018). Stock assessment data for the Northeast and Mid-Atlantic stocks managed by NOAA. Provided via email from Jefferey Vieser. 14 December 2018.

RAM Legacy Stock Assessment Database. (2020). RAM Legacy Stock Assessment Database v4.491 (Version v4.491) [Data set]. Zenodo. http://doi.org/10.5281/zenodo.3676088

National Marine Fisheries Service. (2019). Landings by statistical area from the Vessel Trip Reporting database. Emailed July 5, 2019 by Alison Ferguson.

National Marine Fisheries Service. (2020). Landgins by statistical area from the Data Matching and Imputation System. Emailed January, 2019 by Alison Ferguson.

