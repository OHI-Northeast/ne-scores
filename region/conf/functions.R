## functions.R.
## Each OHI goal model is a separate R function.
## The function name is the 2- or 3- letter code for each goal or subgoal;
## for example, FIS is the Fishing subgoal of Food Provision (FP).


FIS <- function(layers) {
  scen_year <- layers$data$scenario_year

  #catch data
  catch <-
    AlignDataYears(layer_nm = "fis_meancatch", layers_obj = layers) %>%
    select(
      region_id = rgn_id,
      year = scenario_year,
      species,
      catch = mean_catch
    )

  stockscores <-
    AlignDataYears(layer_nm = "fis_stockscores", layers_obj = layers) %>%
    select(
      region_id = rgn_id,
      year = scenario_year,
      species = nmfs_original_species,
      score
    )

  # To calculate the weight (i.e, the relative catch of each stock per region),
  # the mean catch of taxon i is divided by the sum of mean catch of all species in region/year

  #remove stocks without scores, calculate catch weight, get catch-weighted stock scores then calculate region scores

  state_status <- catch %>%
    left_join(stockscores) %>%
    filter(!is.na(score)) %>% #remove stocks with no stock scores **THIS MIGHT NEED TO CHANGE IF WE WANT TO KEEP THESE STOCKS AND GAPFILL INSTEAD**
    group_by(year, region_id) %>%
    mutate(SumCatch = sum(catch, na.rm=T)) %>% #calculate total catch per region per year
    ungroup() %>%
    rowwise() %>%
    mutate(wprop = catch / SumCatch,  #calculate proportional catch
           weighted_score = sum(score * wprop)) %>%
    group_by(region_id, year) %>%
    summarize(score = sum(weighted_score, na.rm=T)) %>%
    ungroup()


  # Get yearly status and trend
  ###

  fis_status <-  state_status %>%
    mutate(status     = round(score * 100, 1),
           dimension = 'status') %>%
    select(scenario_year = year, region_id, status, dimension)


  # calculate trend
  trend_years <- (scen_year - 4):(scen_year)

  trend <-
    CalculateTrend(status_data = fis_status, trend_years = trend_years)


  # assemble dimensions
  fis_score <- fis_status %>%
    filter(scenario_year == scen_year) %>% ## filter for scenario year after calculating trend
    rename(year = scenario_year) %>%
    select(region_id, score = status, dimension) %>%
    bind_rows(trend) %>%
    mutate(goal = 'FIS') %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  scores <- fis_score %>%
    select(region_id, goal, dimension, score)

  return(scores)
}


MAR <- function(layers) {
  scen_year <- layers$data$scenario_year

  #production data
  production <-
    AlignDataYears(layer_nm = "mar_production", layers_obj = layers) %>%
    mutate(species = as.character(Species),
           year = scenario_year) %>%
    select(-layer_name, -Species, -scenario_year) %>%
    filter(!is.na(production))

  #sustainability scores
  sustscores <-
    read_csv("~/github/ne-scores/region/layers/mar_sust_scores.csv") %>%
    select(-sustainabilityscore)

  #calculate status from sustainability weighted production
  mar_status <- production %>%
    filter(yr_num > 2) %>% #we want to start with the third year in the series since we use a 3 year rolling mean for production
    left_join(sustscores) %>%
    mutate(last_yrs_prod_sust = last_years_prod * rescaled, #scaling last years production data by sustainability score
           sust_times_prod    = production*rescaled)  %>% #current years production times sustainability score
    group_by(mar_production_year, rgn_id, year) %>%
    summarize(total_production   = sum(sust_times_prod, na.rm = T),
              last_yr_total_prod = sum(last_yrs_prod_sust, na.rm = T)) %>%
    ungroup() %>%
    mutate(growth_score = pmin(1, total_production/(1.04*last_yr_total_prod)),
           status = 100 * growth_score,
           dimension = "status") %>%
    rename(region_id = rgn_id)

  # calculate trend
  trend_data <- mar_status %>%
    filter(!is.na(status))

  trend_years <- (scen_year - 4):(scen_year)

  mar_trend <-
    CalculateTrend(status_data = trend_data, trend_years = trend_years)

  # bind status and trend by rows
  mar_score <- mar_status %>%
    filter(year == scen_year) %>% ## filter for scenario year after calculating trend
    select(region_id, score = status, dimension) %>%
    bind_rows(mar_trend) %>%
    mutate(goal = 'MAR') %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  scores <- mar_score %>%
    select(region_id, goal, dimension, score)

  return(scores)
}


FP <- function(layers, scores) {
  scen_year <- layers$data$scenario_year

  #fisheries harvest

  f <-
    AlignDataYears(layer_nm = "fis_meancatch", layers_obj = layers) %>%
    select(
      region_id = rgn_id,
      year = scenario_year,
      species,
      catch = mean_catch
    ) %>%
    group_by(region_id, year) %>%
    summarize(total_catch = sum(catch, na.rm = T))

  #mariculture production
  m <-
    AlignDataYears(layer_nm = "mar_production", layers_obj = layers) %>%
    mutate(species = as.character(Species),
           year = scenario_year) %>%
    group_by(rgn_id, year) %>%
    summarize(total_production = sum(production, na.rm = T))

  #combine
  w <- m %>%
    rename(region_id = rgn_id) %>%
    full_join(f) %>%
    rowwise() %>%
    mutate(w_fis = total_catch/sum(total_production, total_catch,na.rm = T),
           w_mar = 1-w_fis)

  write_csv(w, "layers/fp_wildcaught_weight.csv")


  # combine with FIS and MAR scores
  s <- scores %>%
    filter(goal %in% c('FIS', 'MAR')) %>%
    filter(!(dimension %in% c('pressures', 'resilience'))) %>%
    left_join(w, by = "region_id")  %>%
    mutate(weight = ifelse(goal == "FIS", w_fis, w_mar))


  #scores with weighted contributions
  s <- s  %>%
    group_by(region_id, dimension) %>%
    summarize(score = weighted.mean(score, weight, na.rm = TRUE)) %>%
    mutate(goal = "FP") %>%
    ungroup() %>%
    select(region_id, goal, dimension, score) %>%
    data.frame()

  # return all scores
  return(rbind(scores, s))
}


RAO <- function(layers) {
  scen_year <- layers$data$scenario_year

  ## Economic access (gas prices compared to mean wage)
  econ_access <- AlignManyDataYears("rao_econ_access") %>%
    rename(econ_score = score,
           region_id = rgn_id) %>%
    select(-layer_name, -data_year)

  ## Fish stock sustainability
  fish_access <- AlignManyDataYears("rao_fssi") %>%
    rename(fssi_score = score,
           region_id = rgn_id) %>%
    select(-layer_name, -data_year)

  #coastal access
  coast_access <- AlignDataYears(layer_nm = "tr_rao_coastal_access", layers_obj = layers)  %>%
    select(-layer_name) %>%
    rename(region_id = rgn_id,
           access_score = score)


  ## calculate status
  rao_status <- econ_access %>%
    left_join(fish_access) %>%
    left_join(coast_access) %>%
    rowwise() %>%
    mutate(status = mean(c(econ_score, fssi_score, access_score), na.rm = T)*100,
           dimension = 'status')

  ## calculate trend
  trend_data <- rao_status %>%
    filter(!is.na(status))

  trend_years <- (scen_year - 4):(scen_year)

  rao_trend <-
    CalculateTrend(status_data = trend_data, trend_years = trend_years)

  ## calculate scores
  rao_score <- rao_status %>%
    filter(scenario_year == scen_year) %>%
    select(region_id, score = status, dimension) %>%
    bind_rows(rao_trend) %>%
    mutate(goal = "RAO")

  ## return final scores
  scores <- rao_score %>%
    select(region_id, goal, dimension, score)

  return(scores)
}

HS <- function(layers) {
  scen_year <- layers$data$scenario_year

  ## coastal protection
  coastal_protection <- AlignManyDataYears("hs_coastal_protection") %>%
    filter(scenario_year == scen_year) %>%
    mutate(service = "cp") %>%
    select(year = scenario_year, region_id = rgn_id, rgn_name, score = cp_score, service)

  ## carbon storage
  carbon_storage <- AlignManyDataYears("hs_carbon_storage") %>%
    filter(scenario_year == scen_year) %>%
    mutate(service = "cs") %>%
    select(year = scenario_year, region_id = rgn_id, rgn_name, score = cs_score, service)


  ## calculate status. eventually rbind() the other habitats here
  hs_status <- coastal_protection %>%
    rbind(carbon_storage) %>%
    group_by(year, region_id, rgn_name) %>%
    summarize(status = mean(score, na.rm = T)) %>%
    mutate(dimension = 'status') %>%
    ungroup()


  ## calculate trend
  trend_data <- hs_status %>%
    filter(!is.na(status))

  trend_years <- (scen_year - 4):(scen_year)

  hs_trend <-
    CalculateTrend(status_data = trend_data, trend_years = trend_years)

  ## calculate scores
  hs_score <- hs_status %>%
    filter(year == scen_year) %>%
    select(region_id, score = status, dimension) %>%
    bind_rows(hs_trend) %>%
    mutate(goal = "HS")

  ## return final scores
  scores <- hs_score %>%
    select(region_id, goal, dimension, score)

  return(scores)
}

TR <- function(layers) {

  scen_year <- layers$data$scenario_year

  ## read in tourism jobs layer
  tourism_job_growth <-
    AlignDataYears(layer_nm = "tr_job_growth", layers_obj = layers) %>%
    select(-layer_name)

  ## read in beach closures layer
  beach <- AlignDataYears(layer_nm = "tr_beach_closures", layers_obj = layers) %>%
    select(-layer_name) %>%
    rename(region_id = rgn_id)

  #coastal access
  access <- AlignDataYears(layer_nm = "tr_rao_coastal_access", layers_obj = layers) %>%
    select(-layer_name) %>%
    rename(region_id = rgn_id,
           access_score = score)

  # we don't set a specific target of job growth in the T&R sector. As long as regions are not losing jobs
  # in the sector, they receive a score of 100. We do set a minimum, or lower limit, of 25% job loss, where
  # loss of 25% or more jobs in this sector are given a 0.

  ## parameters
  min_jobs = -0.25 #(a loss of 25% of all jobs gets a score of 0)

  tr_job_score <- tourism_job_growth %>%
    dplyr::mutate(job_score =
             case_when(
               tr_job_growth >= 0 ~ 1,
               tr_job_growth < 0 ~ (tr_job_growth - min_jobs)/(0 - min_jobs)
             ))

  # get status
  tr_status <- tr_job_score %>%
    select(region_id = rgn_id, job_score, scenario_year) %>%
    left_join(beach) %>%
    left_join(access) %>%
    rowwise() %>%
    mutate(status = mean(c(perc_open, job_score, access_score))*100,
           dimension = 'status')

  # calculate trend
  trend_data <- tr_status %>%
    filter(!is.na(status))

  trend_years <- (scen_year - 4):(scen_year)

  tr_trend <-
    CalculateTrend(status_data = trend_data, trend_years = trend_years)

  # bind status and trend by rows
  tr_score <- tr_status %>%
    filter(scenario_year == scen_year) %>% ## filter for scenario year after calculating trend
    rename(year = scenario_year) %>%
    select(region_id, score = status, dimension) %>%
    bind_rows(tr_trend) %>%
    mutate(goal = 'TR') %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  scores <- tr_score %>%
    select(region_id, goal, dimension, score)

  return(scores)
}

LIV <- function(layers){

  scen_year <- layers$data$scenario_year

  # wages
  le_cst_wages <- AlignDataYears(layer_nm = "le_coast_wages", layers_obj = layers) %>%
    select(-layer_name)

  #jobs
  le_cst_jobs  <- AlignDataYears(layer_nm = "le_job_growth", layers_obj = layers) %>%
    select(-layer_name)

  ## Jobs scores

  #we don't set a specific target of job growth. If national job growth is positive, we want to be at or above that growth rate. If national job growth is negative, we want coastal job growth to be the same or better as the previous 3 yr avg

  ## parameters
  min_jobs = -0.25 #(a loss of 25% of all jobs gets a score of 0)

  jobs_score <- le_cst_jobs %>%
    mutate(job_score =
             case_when(
               coast_job_growth >= 0 & us_job_growth < 0 ~ 1,
               coast_job_growth >= 0 & us_job_growth >= 0 ~ coast_job_growth/us_job_growth,
               coast_job_growth < 0 & us_job_growth < 0 ~ (coast_job_growth - min_jobs)/(0 - min_jobs),
               coast_job_growth <0 & us_job_growth >= 0 ~ (coast_job_growth - min_jobs)/(us_job_growth - min_jobs)
             ),
           job_score = ifelse(job_score > 1, 1, job_score))

  write.csv(jobs_score, file = "~/github/ne-prep/prep/liv/data/job_scores.csv")


  ## Wage scores

  ## set parameters for min (what gets a 0) and reference point target (what gets 100)
  min_wage  = -0.4 #this represents a 40% decrease
  targ_wage = 0.035 #this represents our target growth rate

  wages_score <- le_cst_wages %>%
    mutate(wages_score =
             case_when(
               wage_growth_rate >= targ_wage ~ 1, #if the growth rate is about 3.5% it gets a perfect score
               wage_growth_rate <= targ_wage ~ (wage_growth_rate - min_wage)/(targ_wage-min_wage)))

  write.csv(wages_score, file = "~/github/ne-prep/prep/liv/data/wages_scores.csv")


  # LIV calculations ----

  # combine jobs and wages scores per region and divide by two

  ## status
  liv_status <- jobs_score %>%
    left_join(wages_score) %>%
    mutate(status = (job_score + wages_score)/2) %>%
    select(year = scenario_year, region_id = rgn_id, status) %>%
    filter(!is.na(status))

  ## trend

  trend_years <- (scen_year-4):(scen_year)

  liv_trend <- CalculateTrend(status_data = liv_status, trend_years = trend_years)

  liv_scores <- liv_status %>%
    mutate(score = 100 * status,
           dimension = "status") %>%
    filter(year == scen_year) %>%
    select(-year, -status) %>%
    rbind(liv_trend) %>%
    mutate(goal = 'LIV') %>%
    select(region_id, goal, dimension, score) %>%
    arrange(goal, dimension, region_id) %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  return(liv_scores)

}

ECO <- function(layers) {
  # ECO data layers

  scen_year <- layers$data$scenario_year

  #coastal gdp growth rate
  eco_cst_gdp <- AlignDataYears(layer_nm = "eco_coast_gdp", layers_obj = layers) %>%
    select(-layer_name)

  # ECO calculations ----

  # ECO status

  ## set parameters for min (what gets a 0) and reference point target (what gets 100)
  min_gdp  = -0.3 #this represents the worst case scenario (what gets a 0)
  targ_gdp = 0.03 #this represents our target gdp growth rate

   gdp_scores <- eco_cst_gdp %>%
    mutate(status =
             case_when(
               gdp_growth_rate >= targ_gdp ~ 1, #if the growth rate is about 3.5% it gets a perfect score
               gdp_growth_rate <= targ_gdp ~ (gdp_growth_rate - min_gdp)/(targ_gdp - min_gdp)))

    write.csv(gdp_scores, file = "~/github/ne-prep/prep/eco/data/gdp_scores.csv")

    eco_status <- gdp_scores %>%
    select(year = scenario_year, region_id = rgn_id, status) %>%
    filter(!is.na(status))

  # ECO trend

  trend_years <- (scen_year-4):(scen_year)

  eco_trend <- CalculateTrend(status_data = eco_status, trend_years = trend_years)

  # ECO scores

  eco_scores <- eco_status %>%
    filter(year == scen_year) %>%
    mutate(dimension = "status",
           score = 100 * status) %>%
    select(-year, -status) %>%
    rbind(eco_trend) %>%
    mutate(goal = 'ECO') %>%
    select(region_id, goal, dimension, score) %>%
    arrange(goal, dimension, region_id) %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  return(eco_scores)

}


LE <- function(scores, layers){

  # calculate LE scores
  scores.LE = scores %>%
    filter(goal %in% c('LIV','ECO') & dimension %in% c('status','trend','score','future')) %>%
    spread(key = goal, value = score) %>%
    mutate(score = rowMeans(cbind(ECO, LIV), na.rm=TRUE)) %>%
    select(region_id, dimension, score) %>%
    mutate(goal  = 'LE')

  # rbind to all scores
  scores = scores %>%
    rbind(scores.LE)

  # return scores
  return(scores)
}


ICO <- function(layers){

  scen_year <- layers$data$scenario_year

  # load iconic species scores per region
  ico_species_scores <- AlignDataYears(layer_nm = "ico_scores", layers_obj = layers)


  # get percent of total area that is protected for inland1km (cp) and offshore3nm (cmpa) per year
  # and calculate status score
  ico_status <- ico_species_scores %>%
    group_by(scenario_year, rgn_id) %>%
    summarize(status = mean(score)*100) %>%
    ungroup()

  # calculate trend

  trend_years <- (scen_year-4):(scen_year)

  ico_trend <- CalculateTrend(status_data = ico_status, trend_years = trend_years)


  #combine trend and status
  ico_scores <- ico_status %>%
    filter(scenario_year == scen_year) %>%
    mutate(dimension = "status",
           score = status) %>%
    select(region_id = rgn_id, score, dimension) %>%
    rbind(ico_trend) %>%
    mutate(goal = 'ICO') %>%
    arrange(goal, dimension, region_id) %>%
    distinct() %>%
    complete(region_id = 1:12, #this adds in all regions with NA values for trend and status
             goal,
             dimension)

  # return final scores
  return(ico_scores)

}

LSP <- function(layers) {

  scen_year <- layers$data$scenario_year

  # marine
  lsp_marine <- AlignDataYears(layer_nm = "lsp_protected_marine", layers_obj = layers) %>%
    select(-layer_name, -lsp_protected_marine_year) %>%
    mutate(layer = "marine")

  # land
  lsp_land  <- AlignDataYears(layer_nm = "lsp_protected_land", layers_obj = layers) %>%
    select(-layer_name, -lsp_protected_land_year) %>%
    mutate(layer = "land")

  ref_pct_marine <- 0.10 #our reference point for marine protection is 10% based on Aichi
  ref_pct_land   <- 0.17 #our reference point for land protection is 17% based on Aichi


  # get percent of total area that is protected for inland1km (cp) and offshore3nm (cmpa) per year
  # and calculate status score
  lsp_status <- lsp_marine %>%
    bind_rows(lsp_land) %>%
    rowwise() %>%
    mutate(ref = case_when(
      layer == "land" ~ ref_pct_land,
      layer == "marine" ~ ref_pct_marine),
    layer_status = min(1, prop_area/ref)) %>% #don't let this go above 1 when there is more protected area than our reference
    group_by(scenario_year, rgn_id) %>%
    mutate(status = mean(layer_status)*100) %>%
    ungroup()

  # calculate trend

  trend_years <- (scen_year-4):(scen_year)

  lsp_trend <- CalculateTrend(status_data = lsp_status, trend_years = trend_years)


  #combine trend and status
  lsp_scores <- lsp_status %>%
    filter(scenario_year == scen_year) %>%
    mutate(dimension = "status",
           score = status) %>%
    select(region_id = rgn_id, score, dimension) %>%
    rbind(lsp_trend) %>%
    mutate(goal = 'LSP') %>%
    arrange(goal, dimension, region_id) %>%
    distinct() %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  return(lsp_scores)
}

SPFIS <- function(layers){

  scen_year <- layers$data$scenario_year

  # commercial
  comm <- AlignDataYears(layer_nm = "sop_comm_engagement", layers_obj = layers) %>%
    select(-layer_name, -sop_comm_engagement_year, -ref, -mean_score) %>%
    mutate(layer = "commercial")

  # recreational
  rec  <- AlignDataYears(layer_nm = "sop_rec_reliance", layers_obj = layers) %>%
    select(-layer_name, -sop_rec_reliance_year, -ref, -mean_score) %>%
    mutate(layer = "recreational")

  # take the average score across both layers
  spfis_status <- comm %>%
    bind_rows(rec) %>%
    group_by(scenario_year, rgn_id, rgn_name) %>%
    summarize(status = mean(score)*100) %>%
    ungroup()

  # calculate trend

  trend_years <- (scen_year-4):(scen_year)

  spfis_trend <- CalculateTrend(status_data = spfis_status, trend_years = trend_years)


  #combine trend and status
  spfis_scores <- spfis_status %>%
    filter(scenario_year == scen_year) %>%
    mutate(dimension = "status",
           score = status) %>%
    select(region_id = rgn_id, score, dimension) %>%
    rbind(spfis_trend) %>%
    mutate(goal = 'SPFIS') %>%
    arrange(goal, dimension, region_id) %>%
    distinct() %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  # return final scores
  return(spfis_scores)
}

SP <- function(scores) {
  ## to calculate the four SP dimesions, average those dimensions for ICO and LSP
  s <- scores %>%
    filter(goal %in% c('ICO', 'LSP', 'SPFIS'),
           dimension %in% c('status', 'trend', 'future', 'score')) %>%
    group_by(region_id, dimension) %>%
    summarize(score = mean(score, na.rm = TRUE)) %>%
    ungroup() %>%
    arrange(region_id) %>%
    mutate(goal = "SP") %>%
    select(region_id, goal, dimension, score) %>%
    data.frame()

  # return all scores
  return(rbind(scores, s))
}

CW <- function(layers) {
  scen_year <- layers$data$scenario_year

  ### function to calculate geometric mean:
  geometric.mean2 <- function (x, na.rm = TRUE) {
    if (is.null(nrow(x))) {
      exp(mean(log(x), na.rm = TRUE))
    }
    else {
      exp(apply(log(x), 2, mean, na.rm = na.rm))
    }
  }

  # get data together:

  ## Water quality index. The higher the better
  wqi <- AlignDataYears(layer_nm = "cw_wqi", layers_obj = layers) %>%
    mutate(wqi_score = score/100) %>%
    select(region_id = rgn_id,
           year = scenario_year,
           wqi_score)

  ## Sediment quality index. The higher the better
  sqi <- AlignDataYears(layer_nm = "cw_sqi", layers_obj = layers) %>%
    mutate(sqi_score = score/100) %>%
    select(region_id = rgn_id,
           year = scenario_year,
           sqi_score)

  ## trash calculated from pounds per person. The lower the better so here I inverse the values.
  trash <- AlignDataYears(layer_nm = "cw_trash", layers_obj = layers) %>%
    select(region_id = rgn_id,
           year = scenario_year,
           trash_score = score)

  path <- AlignDataYears(layer_nm = "cw_pathogens", layers_obj = layers) %>%
    select(region_id = rgn_id,
           year = scenario_year,
           perc_open)

  ## combine layers
  cw_data <- wqi %>%
    full_join(sqi) %>%
    full_join(trash) %>%
    full_join(path) %>%
    gather(key = layer, value = value, -region_id, -year)

 ## apply the geometric mean
  cw_status <- cw_data %>%
    group_by(region_id, year) %>%
    summarize(status = geometric.mean2(value, na.rm = TRUE)) %>% # take geometric mean
    mutate(status = status * 100) %>%
    mutate(dimension = "status") %>%
    ungroup()

  ## calculate trend
    trend_data <- cw_status %>%
    filter(!is.na(status))

  trend_years <- (scen_year - 4):(scen_year)

  cw_trend <-
    CalculateTrend(status_data = trend_data, trend_years = trend_years)

  ## calculate scores
  cw_score <- cw_status %>%
    filter(year == scen_year) %>%
    select(region_id, score = status, dimension) %>%
    bind_rows(cw_trend) %>%
    mutate(goal = "CW") %>%
    complete(region_id = 1:12, #this adds in regions 1-4 with NA values for trend and status
             goal,
             dimension)

  ## return final scores
  scores <- cw_score %>%
    select(region_id, goal, dimension, score)

  return(scores)
}


HAB <- function(layers) {

  scen_year <- layers$data$scenario_year

  ## salt marsh
  saltmarsh <- AlignManyDataYears("hab_salt_marsh") %>%
    filter(scenario_year == scen_year) %>%
    mutate(status = ifelse(perc_loss <= 0, 100, 100-perc_loss)) %>% #this keeps the perc_loss from going negative from going above 100 for Maine
    select(year = scenario_year, region_id = rgn_id, status, habitat)

  ## eelgrass
  eelgrass <- AlignManyDataYears("hab_eelgrass") %>%
    filter(scenario_year == scen_year) %>%
    select(year = scenario_year, region_id = rgn_id, status = score, habitat)

  ## Offshore
  offshore <- AlignManyDataYears("hab_fishing_effects") %>%
    filter(scenario_year == scen_year) %>%
    mutate(status = score*100) %>%
    select(year = scenario_year, region_id = rgn_id, status, habitat)

  ## calculate status. eventually rbind() the other habitats here
  hab_status <- saltmarsh %>%
    rbind(eelgrass) %>%
    rbind(offshore) %>%
    group_by(year, region_id) %>%
    summarize(status = mean(status, na.rm = T)) %>%
    mutate(dimension = 'status') %>%
    ungroup()


  ## calculate trend
  trend_data <- hab_status %>%
    filter(!is.na(status))

  trend_years <- (scen_year - 4):(scen_year)

  hab_trend <-
    CalculateTrend(status_data = trend_data, trend_years = trend_years)

  ## calculate scores
  hab_score <- hab_status %>%
    filter(year == scen_year) %>%
    select(region_id, score = status, dimension) %>%
    bind_rows(hab_trend) %>%
    mutate(goal = "HAB")

  ## return final scores
  scores <- hab_score %>%
    select(region_id, goal, dimension, score)

  ## create weights file for pressures/resilience calculations. This identifies
  ## what regions contain what habitats

  weights <- saltmarsh %>%
    rbind(eelgrass) %>%
    rbind(offshore)  %>%
    filter(!is.na(status)) %>%
    select(-status) %>%
    dplyr::mutate(boolean = 1) %>%
    dplyr::mutate(layer = "element_wts_hab_pres_abs") %>%
    dplyr::select(rgn_id = region_id, habitat, boolean, layer)

  write.csv(weights,
            sprintf(here("region/temp/element_wts_hab_pres_abs_%s.csv"), scen_year),
            row.names = FALSE)

  layers$data$element_wts_hab_pres_abs <- weights

  return(scores)
}


SPP <- function(layers) {

  scen_year <- layers$data$scenario_year

  #load data of each species and associated area per OHI Northeast region
  spp_rgns <-
    AlignDataYears(layer_nm = "spp_rgns", layers_obj = layers) %>%
    filter(scenario_year == scen_year) %>%
    mutate(common = as.character(common),
           sciname = as.character(sciname))

  #load conservation status scores (between 0 and 1) for each species/region combo
  spp_scores <-
    AlignDataYears(layer_nm = "spp_status_scores", layers_obj = layers) %>%
    filter(scenario_year == scen_year) %>%
    mutate(common = as.character(common),
           sciname = tolower(as.character(sciname)))

  #load the trend data
  spp_trend <-
    AlignDataYears(layer_nm = "spp_trend", layers_obj = layers) %>%
    filter(scenario_year == scen_year)

  #calculate status
  spp_status <- spp_rgns %>%
    left_join(spp_scores, by = c("common", "sciname", "rgn_id")) %>%
    select(rgn_id, common, sciname, score) %>%
    filter(!is.na(score)) %>%
    group_by(rgn_id) %>%
    mutate(status = mean(score)) %>%
    select(region_id = rgn_id, status) %>%
    distinct()

  #get trend by region
  rgn_trend <- spp_rgns %>%
    select(sciname, rgn_id) %>%
    left_join(spp_trend) %>%
    group_by(rgn_id) %>%
    summarize(trend = mean(score, na.rm=T)) %>% #take the mean trend for each region
    mutate(dimension = "trend",
           goal = "SPP") %>%
    rename(score = trend,
           region_id = rgn_id)


  #adjust the calculated status to score by incorporating the threshold at which rgns would get a 0
  scores <- spp_status %>%
    mutate(score = 100*(0.75-status)/0.75, #this assigns a region score of 0 if 80% of all species were critically endangered
           dimension = "status",
           goal = "SPP") %>%
    select(-status) %>%
    bind_rows(rgn_trend)


  return(scores)
}

BD <- function(scores) {
  d <- scores %>%
    filter(goal %in% c('HAB', 'SPP')) %>%
    filter(!(dimension %in% c('pressures', 'resilience'))) %>%
    group_by(region_id, dimension) %>%
    summarize(score = mean(score, na.rm = TRUE)) %>%
    mutate(goal = 'BD') %>%
    data.frame()

  # return all scores
  return(rbind(scores, d[, c('region_id', 'goal', 'dimension', 'score')]))
}

PreGlobalScores <- function(layers, conf, scores) {
  # get regions
  name_region_labels <- conf$config$layer_region_labels
  rgns <- layers$data[[name_region_labels]] %>%
    select(id_num = rgn_id, val_chr = label)

  # limit to just desired regions and global (region_id==0)
  scores <- subset(scores, region_id %in% c(rgns[, 'id_num'], 0))

  # apply NA to Antarctica
  id_ant <- subset(rgns, val_chr == 'Antarctica', id_num, drop = TRUE)
  scores[scores$region_id == id_ant, 'score'] = NA

  return(scores)
}

FinalizeScores <- function(layers, conf, scores) {
  # get regions
  name_region_labels <- conf$config$layer_region_labels
  rgns <- layers$data[[name_region_labels]] %>%
    select(id_num = rgn_id, val_chr = label)


  # add NAs to missing combos (region_id, goal, dimension)
  d <- expand.grid(list(
    score_NA  = NA,
    region_id = c(rgns[, 'id_num'], 0),
    dimension = c(
      'pressures',
      'resilience',
      'status',
      'trend',
      'future',
      'score'
    ),
    goal      = c(conf$goals$goal, 'Index')
  ),
  stringsAsFactors = FALSE)
  head(d)
  d <- subset(d,!(
    dimension %in% c('pressures', 'resilience', 'trend') &
      region_id == 0
  ) &
    !(
      dimension %in% c('pressures', 'resilience', 'trend', 'status') &
        goal == 'Index'
    ))
  scores <-
    merge(scores, d, all = TRUE)[, c('goal', 'dimension', 'region_id', 'score')]

  # order
  scores <- arrange(scores, goal, dimension, region_id)

  # round scores
  scores$score <- round(scores$score, 2)

  return(scores)
}
