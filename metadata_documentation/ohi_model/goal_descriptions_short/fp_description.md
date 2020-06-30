---
output:
  word_document: default
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


