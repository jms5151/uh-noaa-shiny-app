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

==============================================================================================
#
#  Programming history 
#
#  (At the Coral Reef Watch implemention) 
#
#  2022/07/20 Gang Liu : Added print statements and some comments.
#                      : Commented out some processing stages that are not needed currently.
#
#=============================================================================================

"""

print("\n  Running model in core processing stage: ")

# Setup ---------------------------------------------------------------

# Load module
import runpy

# load functions 
from functions.fun_create_delete_directories import create_dir, delete_dir

# set filepaths
from filepaths import tmp_path, input_path, models_path

# Create directory for temporary files
print('\n  -- 1) Create tmp_path for temporary holding data, removed right after processing: ')
print('      ',tmp_path)
create_dir(tmp_path)

# Only need to run after cloning repository / pulling updated data fiels (unzip files)
print('\n  -- 2) Unzip files in repository: ')
print('       ---- Not needed for now. unpacked files will stay permanently without removal after each run.')
###runpy.run_path(path_name = 'Unzip_files.py')

# Co-variates data pre-processing for grid ---------------------------------------------------

# compile NRT & forecasted SST metrics
print('\n  -- 3) Compile NRT & forecasted SST metrics: Grid_covariates_sst_metrics.py')
runpy.run_path(path_name = 'Grid_covariates_sst_metrics.py')

# compile seasonal ocean color metrics
print('\n  -- 4) Compile seasonal ocean color metrics: Grid_covariates_ocean_color_dynamic.py')
runpy.run_path(path_name = 'Grid_covariates_ocean_color_dynamic.py')

# compile predictor data
print('\n  -- 5) compile predictor data: Grid_concat_dynamic_covariates.py')
runpy.run_path(path_name = 'Grid_concat_dynamic_covariates.py')

# Forecasting --------------------------------------------------------------------------------

# run model predictions
print('\n  -- 6) Run model predictions: Run_model_forecasts.py')
runpy.run_path(path_name = 'Run_model_forecasts.py')

# create model scenarios
print('\n  -- 7) Create model scenarios: Create_scenarios.py')
runpy.run_path(path_name = 'Create_scenarios.py')

# run scenarios
print('\n  -- 8) Run scenarios: Run_model_scenarios.py')
runpy.run_path(path_name = 'Run_model_scenarios.py')

# Create shiny outputs -----------------------------------------------------------------------
print('\n  -- 9) Create shiny outputs - predictions: Shiny_inputs_aggregate_predictions.py ')
runpy.run_path(path_name = 'Shiny_inputs_aggregate_predictions.py')

print('\n  -- 10) Create shiny outputs - scenarios: Shiny_inputs_aggregate_scenarios.py ')
runpy.run_path(path_name = 'Shiny_inputs_aggregate_scenarios.py')

print('\n  -- 11) Create shiny outputs - polygons: Shiny_inputs_update_polygons.py ')
runpy.run_path(path_name = 'Shiny_inputs_update_polygons.py')

# CRW outputs --------------------------------------------------------------------------------
print('\n  -- 12) CRW outputs: Output_forecasts_for_CRW.py')
runpy.run_path(path_name = 'Output_forecasts_for_CRW.py')

# Delete temporary files ---------------------------------------------------------------------
print('\n  -- 13) Remove temporary folder: ', tmp_path)
delete_dir(tmp_path + 'map_data/')
delete_dir(tmp_path)

## delete input data and model files if pushing to github
###delete_dir(input_path)
###delete_dir(models_path)

#=============================================================================================
#The end
