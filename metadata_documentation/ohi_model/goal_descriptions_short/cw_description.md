---
output:
  word_document: default
  html_document: default
---
# Clean Waters  
People value marine waters that are free of pollution and debris for aesthetic and health reasons. Contamination of waters comes from oil spills, chemicals, eutrophication, algal blooms, disease pathogens (e.g., fecal coliform, viruses, and parasites from sewage outflow), floating trash, and mass kills of organisms due to pollution. People are sensitive to these phenomena occurring in areas they access for recreation or other purposes as well as for simply knowing that clean waters exist. This goal scores highest when contamination from all potential sources is zero.

We include four components of pollution in the clean waters goal: **pathogens** ($p$), **trash** ($t$), **water quality** ($w$), and **sediment quality** ($s$). This decision was meant to represent a comprehensive list of the contamination categories that are commonly considered in assessments of coastal clean waters (Borja et al. 2008) and for which we could obtain data. The status of this goal is calculated as the geometric mean of the four data layers included.

$$ CW_{i,t} =100*\sqrt[4]{p_{i,t}+t_{i,t}+s_{i,t}+w_{i,t}}$$

We used a geometric mean, as is commonly done for water quality indices (Liou et al. 2004), because a very bad score for any one subcomponent would pollute the waters sufficiently to make people feel the waters were ‘too dirty’ to enjoy for recreational or aesthetic purposes (e.g., a large oil spill trumps any other measure of pollution). However, in cases where a subcomponent was zero, we added a value of 0.01 (on a scale of 0 to 1) to prevent the overall score from going to zero. Given that there is uncertainty around our pollution estimates, a zero score resulting from one subcomponent seemed too extreme.

Although clean waters are relevant and important anywhere in the ocean, coastal waters drive this goal both because the problems of pollution are concentrated there and because people predominantly access and care about clean waters in coastal areas. The nearshore area is what people can see and where beach-going, shoreline fishing, and other activities occur. Furthermore, the data for high seas areas is limited and there is little meaningful regulation or governance over the input of pollution into these areas. We therefore calculate this goal only for the first 3 nm of ocean for each country’s EEZ. We chose 3 nautical miles for several reasons, but found the status results to be relatively insensitive to different distances. 

## References   
Borja, A., Bricker, S. B., Dauer, D. M., Demetriades, N. T., Ferreira, J. G., Forbes, A. T., et al. (2008). Overview of integrative tools and methods in assessing ecological integrity in estuarine and coastal systems worldwide. Marine Pollution Bulletin 56, 1519–1537. doi:10.1016/j.marpolbul.2008.07.005.

Liou, S.-M., Lo, S.-L., and Wang, S.-H. (2004). A Generalized Water Quality Index for Taiwan. Environ Monit Assess 96, 35–52. doi:10.1023/B:EMAS.0000031715.83752.a1.



