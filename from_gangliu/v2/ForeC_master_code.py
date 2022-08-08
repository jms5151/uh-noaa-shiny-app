# -*- coding: utf-8 -*-
"""
Master code for University of Hawaii - NOAA Coral Reef Watch Fore-C project
Created by Jamie M. Caldwell. Contact: jamie.sziklay@gmail.com
# platform       x86_64-w64-mingw32
# arch           x86_64
# os             mingw32
# system         x86_64, mingw32
# language       Python
# version.string Python version 3.8.8 (2021-12-02)


Gang Liu



"""



print('  Hello, I am in!')






# Setup ---------------------------------------------------------------

# Load module
import runpy

# load functions 
from functions.fun_create_delete_directories import create_dir, delete_dir

# set filepaths
from filepaths import tmp_path, input_path, models_path

# Create directory for temporary files
print('\n  tmp_path: ',tmp_path)
create_dir(tmp_path)

# Only need to run after cloning repository / pulling updated data fiels (unzip files)
print('\n  unzip files in repository: ')
print('             ---- This is not needed for now. unpacked files will stay permanently without removal after each run.')
#runpy.run_path(path_name = 'Unzip_files.py')

# Co-variates data pre-processing for grid --------------------------- 

# compile NRT & forecasted SST metrics
print('\n  compile NRT & forecasted SST metrics: ')
runpy.run_path(path_name = 'Grid_covariates_sst_metrics.py')

# compile seasonal ocean color metrics
print('\n  compile seasonal ocean color metrics: ')
runpy.run_path(path_name = 'Grid_covariates_ocean_color_dynamic.py')

# compile predictor data
print('\n  compile predictor data: ')
runpy.run_path(path_name = 'Grid_concat_dynamic_covariates.py')

# Forecasting --------------------------------------------------------

# run model predictions
print('\n  run model predictions: ')
runpy.run_path(path_name = 'Run_model_forecasts.py')

# create model scenarios
print('\n  run model predictions: ')
runpy.run_path(path_name = 'Create_scenarios.py')

# run scenarios
print('\n  run scenarios: ')
runpy.run_path(path_name = 'Run_model_scenarios.py')

# Create shiny outputs -----------------------------------------------
print('\n  Create shiny outputs: predictions ')
runpy.run_path(path_name = 'Shiny_inputs_aggregate_predictions.py')

print('\n  Create shiny outputs: scenarios ')
runpy.run_path(path_name = 'Shiny_inputs_aggregate_scenarios.py')

print('\n  Create shiny outputs: polygons ')
runpy.run_path(path_name = 'Shiny_inputs_update_polygons.py')

# CRW outputs --------------------------------------------------------
print('\n  CRW outputs: ')
runpy.run_path(path_name = 'Output_forecasts_for_CRW.py')

# Delete temporary files ---------------------------------------------
delete_dir(tmp_path + 'map_data/')
delete_dir(tmp_path)

# delete input data and model files if pushing to github
#delete_dir(input_path)
#delete_dir(models_path)
