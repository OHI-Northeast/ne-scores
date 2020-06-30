---
output:
  html_document: default
  word_document: default
---
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
