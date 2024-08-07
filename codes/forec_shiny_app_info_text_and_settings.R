# create text blocks for Fore-C shiny app information buttons and hover text -------------------
landing_page_info_txt <- 'Use this tool to explore current and future coral disease risk.'

forecast_page_explainer_txt <- 'Nowcasts indicate disease risk predictions that use observed
(including satellite) data.\nForecasts indicate disease risk predictions that use modeled 
future conditions.'

forecasts_step_1_txt <- '1. Overview of current regional disease conditions.'

forecasts_step_1_txt_sub <- 'Hover mouse over bars to see percentage of pixels in each risk category.'

forecasts_step_2_txt <- '2. Spatial variation in current and future disease risk.' 

forecasts_step_2_txt_sub <- 'Toggle among map layers at different space and time scales (in map legend).'

forecasts_step_3_txt <- '3. Location-specific seasonal disease projections.'

forecasts_step_3_txt_sub <- 'Click on a polygon on the map to see disease projections through time.'
  
last_update_date <- ga_forecast[which(ga_forecast$Date == max(ga_forecast$Date[ga_forecast$type == "nowcast"]))[1], "Date"] + 1
last_update_date <- as.Date(last_update_date[[1]], "%Y-%m-%d")

last_update_txt <- paste0('Last update: ', last_update_date)

scenarios_page_info_txt <- 'Click on a pixel and adjust sliders to explore coral disease mitigation potential.'

scenarios_page_explainer_txt <- 'Use this tool to refine nowcast predictions based on 
local conditions and to assess intervention strategies.'

scenarios_step_1_txt <- 'Step 1: Select a region & disease.'

scenarios_step_2_txt <- 'Step 2: Select a location.'

scenarios_step_3_txt <- 'Step 3: Adjust local conditions.'

scenarios_step_4_txt <- 'Step 4: Assess changes in disease risk due to changes in local conditions.'

scenarios_page_explainer_txt_2 <- 'Location-specific condition values may not update on per-pixel (or management zone) basis because the spatial scale of the underlying data may be larger than a pixel (or management zone).'

historical_data_txt1 <- 'This map shows the locations, data collectors, and 
time range for the survey data that was used to build the coral disease models.'

historical_data_txt2 <- 'You can zoom in and out to explore different regions 
and click on survey points for pop-up information.' 

historical_data_txt3 <- 'There is less uncertainty in disease forecasts for 
locations with more surveys.'

turbidity_hover_txt <- 'Turbidity is represented by the diffuse attenuation coefficient at 490 nm (Kd490). Higher value indicate lower clarity of ocean water.'

# create text for about page ---------------------------------------------------------------
# about coral diseases
photo_credit <- "Photos courtesy of Courtney Couch."

disease_info_text <- "Growth anomalies are chronic, protuberant 
masses of coral skeletons (i.e., tumors) 
that reduce growth, fecundity, and survival. Tissue loss diseases, 
or white syndromes, are characterized by progressive tissue loss 
across the coral colony with lesions progressing slowly (chronic 
to subacute or rapidly (acute)."

warning_levels_txt <- "Disease on the Great Barrier Reef (GBR) is measured as
a density (total number of diseased colonies per 75m<sup>2</sup>), while 
disease in the U.S. Pacific is measured as prevalence (total number of 
diseased colonies divided by total number of colonies observed). Abundance 
pertains to specificmorphologies where applicable. Prevalence pertains to 
specific families."
  
about_models_text <- "Quantile regresson forest models are used to estimate 
disease risk in this product. Quantile regression forests use tree-based 
ensemble methods to estimate conditional quantiles. Quantile regression forest 
models were built using a subset of data shown in the Historical data page of 
this application, the remaining data was used for validation. There are 
separate models used for each disease-region group (i.e., growth anomalies in 
Australia, growth anomalies in the U.S. Pacific, white syndromes in Australia, 
and white syndromes in the U.S. Pacific."

# funding
himb_url <- a("Hawaii Institute of Marine Biology, University of Hawaii",
              href = 'http://www.himb.hawaii.edu/'              
)

nasa_url <- a("NASA Ecological Forecasting program",
              href = 'https://appliedsciences.nasa.gov/what-we-do/ecological-forecasting'
)

crw_url <- a("NOAA Coral Reef Watch",
             href = 'https://coralreefwatch.noaa.gov/')


funding_statement_txt <- tagList('Funding for this product is from the',
                                 nasa_url, 
                                 ' grant NNX17AI21G. The work was led by researchers at the',
                                 himb_url,
                                 'and ',
                                 crw_url,
                                 '.'
)

# publications
Geigeretal2021 <- a('Optimal Spatiotemporal Scales to Aggregate Satellite Ocean Color Data for Nearshore Reefs and Tropical Coastal Waters: Two Case Studies.',
                    href = 'https://www.frontiersin.org/articles/10.3389/fmars.2021.643302/full')

Geigeretal2021_citation <- tagList('1. Geiger EF, Heron SF, Hernandez WJ, Caldwell JM, Falinski K, Callender T, Greene AL, Liu G, De La Cour JL, Armstrong RA, Donahue MJ, Eakin CM. (2021)', 
                                   Geigeretal2021,
                                   'Frontiers in Marine Science.'
)

Greeneetal2020a <- a('Coral Disease Time Series Highlight Size-Dependent Risk and Other Drivers of White Syndrome in a Multi-Species Model.',
                     href = 'https://www.frontiersin.org/articles/10.3389/fmars.2020.601469/full'
)

Greeneetal2020a_citation <- tagList('2. Greene A, Donahue MJ, Caldwell JM, Heron SF, Geiger E, Raymundo LJ. (2020)',
                                    Greeneetal2020a,
                                    'Frontiers in Marine Science 7, 1022.'
)

Greeneetal2020b <- a('Complementary sampling methods for coral histology, metabolomics, and microbiome.',
                     href = 'https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/2041-210X.13431')

Greeneetal2020b_citation <- tagList('3. Greene A, Leggat W, Donahue MJ, Raymundo LJ, Caldwell JM, Moriarty T, Heron SF, Ainsworth TD. (2020)',
                                    Greeneetal2020b,
                                    'Methods in Ecology and Evolution, 11(9), 1012-1020.')

Caldwelletal2020 <- a('Case-control design identified ecological drivers of endemic coral diseases.',
                      href = 'https://www.nature.com/articles/s41598-020-59688-8'
)

Caldwelletal2020_citation <- tagList('4. Caldwell JM, Aeby G, Heron SF, and Donahue MJ. (2020)', 
                                     Caldwelletal2020,  
                                     'Scientific Reports, 10(1), 1-11.')

# related but not directly included
# Shore-Maggio A and Caldwell JM. Modes of coral disease transmission: how do diseases spread between individuals and among populations? (2019) Marine Biology 166:45.
# Greene A, Forsman Z, Toonen RJ, and Donahue MJ. CoralCam: A flexible, low-cost ecological monitoring platform. HardwareX 7 (2020): e00089. 
# Tracy AM, Pielmeier ML, Yoshioka RM, Heron SF, Harvell CD. 2019. Increases and decreases in marine disease reports in an era of global change. Proceedings of the Royal Society B. 2019 Oct 9; 286:20191718.
# Brodnicke OB, Bourne DG, Heron SF, Pears RJ, Stella JS, Smith HA, Willis BL. Unravelling the links between heat stress, bleaching and disease: fate of tabular corals following a combined disease and bleaching event. Coral Reefs. 2019 Aug 15;38(4):591-603. 
# NOAA Coral Reef Watch, CoralTemp: A Daily Global 5km Sea Surface Temperature Dataset. CoralTemp: A Daily Global 5km Sea Surface Temperature Dataset (2018) available at https://coralreefwatch.noaa.gov/satellite/coraltemp.php.

# settings
spinColor <- "#D3D3D3"