---
output:
  word_document: default
  html_document: default
---
# Livelihoods and Economies   
Jobs and revenue produced from marine-related industries are clearly of huge value to many people, even for those people who do not directly participate in marine-related industries. People value community identity, tax revenue, and indirect economic and social impacts of a stable coastal economy. The necessity of providing for oneself and those dependent on them, generally surpasses any other needs or objectives. Without the availability of jobs with livable wages, it is likely that people will prioritize ocean health less and feel less connected to it. This goal tracks the number and quality of jobs and the amount of revenue produced across as many marine-related industries/sectors as possible through two sub-goals, **Livelihoods** and **Economies**. A score of 100 reflects productive coastal economies that avoid the loss of ocean-dependent livelihoods while maximizing livelihood quality.

The two data layers for the Livelihoods sub-goal ($LIV$), **job growth** ($j$) and **wage growth** ($w$), were first scored according to their respective targets and then averaged to get the final Livelihoods sub-goal status. The Economies sub-goal ($ECO$) status is solely dependent on the **gross domestic product** ($gdp$) data layer. These two sub-goal statuses were averaged with equal weighting to get the final Livelihoods & Economies ($LE$) status. This goal is not assessed for the four offshore regions.

$$LIV_{i,t} = 100*\frac{j_{i,t} + w_{i,t}}{2} $$

$$ECO_{i,t} = 100*gdp_{i,t}$$

$$LE_{i,t} = \frac{LIV_{i,t} + ECO_{i,t}}{2} $$
