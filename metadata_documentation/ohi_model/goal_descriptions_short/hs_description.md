---
output:
  html_document: default
  word_document: default
---
# Habitat Services

This goal aims to measure the extent of habitat services in the form of the amount of protection provided by marine and coastal habitats to coastal areas that people value, and the presence of areas serving as carbon sinks. This goal contains two sub-goals, **Carbon Storage** ($CS$) and **Coastal Protection** ($CP$). Both of these sub-goals rely on two data layers that measure the extent of **salt marsh** ($sm$) and health of **eelgrass** ($eel$). Habitat Services ($HS$) status is calculated by taking the average of the Carbon Storage and Coastal Protection goals.

$$HS_{i,t} = 100*\frac{CS_{i,t}+CP_{i,t}}{2}$$

## Carbon Storage 
Since eelgrass and salt marsh have relatively similar carbon sequestration rates (Mcleod 2011) they are treated equally. The Carbon Storage sub-goal status for each region ($i$) and year ($t$) is calculated by taking the average eelgrass and salt marsh score.

$$CS_{i,t} = \frac{sm_{i,t}+eel_{i,t}}{2}$$

## Coastal Protection 
The presence of salt marsh has a near 4-times higher level of coastal protection against storm surge compared to eelgrass (Sharp et al. 2018). To calculate the Coastal Protection sub-goal status, salt marsh scores are multiplied by 0.8, eelgrass scores multiplied by 0.2 and then summed for each region ($i$) and year ($t$).

$$CP_{i,t} = 0.8*sm_{i,t} + 0.2*eel_{i,t}$$

### References    
Mcleod, E., Chmura, G. L., Bouillon, S., Salm, R., Björk, M., Duarte, C. M., et al. (2011). A blueprint for blue carbon: toward an improved understanding of the role of vegetated coastal habitats in sequestering CO 2. Frontiers in Ecology and the Environment 9, 552–560. doi:10.1890/110004.

Sharp, R., Tallis, H.T., Ricketts, T., Guerry, A.D., Wood, S.A., Chaplin-Kramer, R., et al. (2018). InVEST 3.6.0 User’s Guide. The Natural Capital Project, Stanford University, University of Minnesota, The Nature Conservancy, and World Wildlife Fund.
