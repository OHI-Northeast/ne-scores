---
output:
  word_document: default
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
