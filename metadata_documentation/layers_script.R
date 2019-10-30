
#####################################
## This code takes some of the
## information in this file and
## creates a layers.csv file in the
## format used by the toolbox
## This is sourced by the region/calculate_scores.Rmd file
#####################################


targets <- read.csv('~/github/ne-scores/metadata_documentation/layers_targets.csv', stringsAsFactors=FALSE) %>%
  dplyr::mutate(dimension = ifelse(dimension %in% c("status", "trend"), NA, dimension)) %>%
  dplyr::filter(!is.na(dimension) | !is.na(goal)) %>%
  dplyr::mutate(goal = ifelse(is.na(goal), dimension, goal)) %>%
  dplyr::mutate(target = paste(goal, dimension, sep=' ')) %>%
  dplyr::mutate(target = gsub(" NA", "", target)) %>%
  unique() %>%
  dplyr::group_by(layer) %>%
  dplyr::summarize(targets = paste(target, collapse= "")) %>%
  data.frame()


# add the meta data
meta <- read.csv("~/github/ne-scores/metadata_documentation/layers_base.csv")
layers <- meta %>%
  dplyr::left_join(targets, by="layer") %>%
  dplyr::select(layer, filename, fld_value, targets, name, units, description)


write.csv(layers, here("region/layers.csv"), row.names=FALSE)
