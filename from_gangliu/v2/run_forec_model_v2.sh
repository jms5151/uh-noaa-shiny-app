#! /bin/csh

#=============================================================================================
# run_forec_model_v2.sh
#=============================================================================================
#
# Note that each run of this script will update products for one Monday update only and the
# updated Monday would be the Monday right after the latest processed Monday stated in the 
# date tracking file (track_date_auto/track_date_forec_model_run_auto.txt). If there is any 
# delay in processing for a few previous Mondays, a few backup runs of this script set up in 
# the cronjob should catch up all the needed processing for all the previosuly missed Monday 
# processing. If not, the processing should automatically catch up over the next Monday's 
# primary and backup runs. If there are too many missed processings, just simply manually 
# rerun this script at many times as needed.
#
#       ****
#
# -- This script is to be revised so that it can make the processing to process for all 
#    missed Mondays by an single execution. -- to be done
#
#       ****
#
#=============================================================================================
#
# Programming History:
#
# 2022/09/16 Gang Liu : Initial development.
#
#=============================================================================================

echo ' '
echo '  ======================================================================================'
echo '  =========================== Run weekly FORE-C update ================================='
echo '                             (in run_forec_model_v2.sh)'
echo '  ======================================================================================'
echo '  '
echo "  -- Starting time:"  `date`
set time_start = `date +%s`
#echo $time_start
echo "  "
echo "  User's home directory: "$HOME
echo "  Host name:             "$HOSTNAME
echo "  "
echo "  Running script: $0"
echo
echo '  There are '$#' arguments passed to '$0': '
echo '            '$*

#=============================================================================================
#=============================================================================================
# Section 1:
#
# Set up directories:
#
# --- You can use relevant environmental variables that you already set for any of these.
#
#=============================================================================================
#=============================================================================================

echo ' '
echo '  ====================================================================================='
echo '  Section 1. Set up directories:'
echo '  -------------------------------------------------------------------------------------'

#=============================================================================================
# 1-1)
# Set root directories:
#
#---------------------------------------------------------------------------------------------
# -- Hard code in the line below, if not using environment variable, ROOTDIR_HOST.
# -- Comment out the folloinwg line if using environment variable, ROOTDIR_HOST:

#set root_dir_host = "/data/data568"

if ( !($?root_dir_host) ) then
  if ( !($?ROOTDIR_HOST) ) then
    echo "-----QUIT! root_dir_host is not hard coded and environment variable ROOTDIR_HOST is not defined!"
    echo "     -- To run this script please either define the environment variable ROOTDIR_HOST or"
    echo "        hard code value for root_dir_host in Section 1-1 of $0"
    exit 2
  else
    set root_dir_host = $ROOTDIR_HOST
  endif
else
  echo "\n  root_dir_host is hard coded!"
endif

#---------------------------------------------------------------------------------------------
# -- Hard code in the line below, if not using environment variable, CRWDIR_CODE.
# -- Comment out the following line if using environment variable, CRWDIR_CODE:

#set root_dir_code = "/data/data568/crw/code"

if ( !($?root_dir_code) ) then
  if ( !($?CRWDIR_CODE) ) then
    echo "-----QUIT! root_dir_code is not hard coded and environment variable CRWDIR_CODE is not defined!"
    echo "     -- To run this script please either define the environment variable CRWDIR_CODE or"
    echo "        hard code value for root_dir_code in Section 1-1 of $0"
    exit 2
  else
    set root_dir_code = $root_dir_host$CRWDIR_CODE
  endif
else
  echo "\n  root_dir_code is hard coded!"
endif

#---------------------------------------------------------------------------------------------
# -- Hard code in the line below, if not using environment variable, CRWDIR_CODE.
# -- Comment out the following line if using environment variable, CRWDIR_CODE:

#set root_dir_data = "/data/data568/crwdir"

if ( !($?root_dir_data) ) then
  if ( !($?CRWDIR_DATA) ) then
    echo "-----QUIT! root_dir_data is not hard coded and environment variable CRWDIR_DATA is not defined!"
    echo "     -- To run this script please either define the environment variable CRWDIR_DATA or"
    echo "        hard code value for root_dir_code in Section 1-1 of $0"
    echo "                          "
    exit 2
  else
    set root_dir_data = $root_dir_host$CRWDIR_DATA
  endif
else
  echo "\n  root_dir_data is hard coded!"
endif

#---------------------------------------------------------------------------------------------
# -- Hard code in the line below, if not using environment variable, CRWDIR_WEB.
# -- Comment out the following line if using environment variable, CRWDIR_WEB:

#set root_dir_web = "/data/www-socd/coralreefwatch"

if ( !($?root_dir_web) ) then
  if ( !($?CRWDIR_WEB) ) then
    echo "-----QUIT! root_dir_web is not hard coded and environment variable CRWDIR_WEB is not defined!"
    echo "     -- To run this script please either define the environment variable CRWDIR_WEB or"
    echo "        hard code value for root_dir_web in Section 1-1 of $0"
    echo "                          "
    exit 2
  else
    set root_dir_web = $CRWDIR_WEB
  endif
else
  echo "\n  root_dir_web is hard coded!"
endif

#---------------------------------------------------------------------------------------------
# -- Hard code in the line below, if not using environment variable, CRWDIR_FTP.
# -- Comment out the following line if using environment variable, CRWDIR_FTP:

#set root_dir_ftp = "/data/aftp/socd/mecb/crw"

if ( !($?root_dir_ftp) ) then
  if ( !($?CRWDIR_FTP) ) then
    echo "-----QUIT! root_dir_ftp is not hard coded and environment variable CRWDIR_FTP is not defined!"
    echo "     -- To run this script please either define the environment variable CRWDIR_FTP or"
    echo "        hard code value for root_dir_ftp in Section 1-1 of $0"
    echo "                          "
    exit 2
  else
    set root_dir_ftp = $CRWDIR_FTP
  endif
else
  echo "\n  root_dir_ftp is hard coded!"
endif

#=============================================================================================
# 1-2)
#
# Set path to code and date tracking file:
set dir_code = $root_dir_code"/proc_nrt/forec/model/v2"

# Set path to the source data folder:
set dir_root_source_data_to_examine = $root_dir_ftp"/data/for_forec/shiny_app"

# Set date tracking folder and error token folder
set pathfile_log_date = $dir_code"/track_date_auto/track_date_forec_model_run_auto.txt"
set dir_log_error     = $dir_code"/track_error_auto"

# Set path to output data files:
set dir_root_output_shinyapp = $root_dir_data"/product/forec/model/v2/uh-noaa-shiny-app/forec_shiny_app_data"
set dir_root_output_crw      = $root_dir_data"/product/forec/model/v2/crw_outputs"

echo "  "
echo "  dir_code: "$dir_code
echo "  dir_root_source_data_to_examine: "$dir_root_source_data_to_examine
echo "  "
echo "  pathfile_log_date: "$pathfile_log_date
echo "  dir_log_error:     "$dir_log_error
echo "  "
echo "  dir_root_output_shinyapp: "$dir_root_output_shinyapp
echo "  dir_root_output_crw:      "$dir_root_output_crw

#---------------------------------------------------------------------------------------------
# Throw a notice:
touch $dir_log_error"/no_show_stopping_error_if_no_other_file_here.txt"

#=============================================================================================
#=============================================================================================
# Section 2:
#
# Examine whether the weekly input source data files are made available for the Monday after
# the last updated Monday which coule be a Monday before the latest Monday, then determine 
# whether the weekly FORE-C model run should be executed.
#
#=============================================================================================
#=============================================================================================
#
# Every Monday late afternoon or evening, there should be a new data folder dated with the 
# Monday's date appearing in the shiny_app ftp folder. In the dated folder, there are 
# supposed to be two sets of data files, one set dated in the filename with the prior
# Sunday's date (one day before the Monday) and another set with the prior Saturday's date
# (two days before the Monday). See a whole set of data files below, as an example.
#
# Expect to have:  ***  54 file (= 9 regions x 6 variables) ***
#
# This section checks the availability of this dated Monday folder and all the data files
# supposed to be in the folder.
#
# For example,
#        /data/aftp/socd/mecb/crw/data/for_forec/shiny_app/20220912 
# contains
#        
#        cfsv2_hotsnap_gbr_reef-id_20220910.nc
#        cfsv2_hotsnap_guam_cnmi_reef-id_20220910.nc
#        cfsv2_hotsnap_hawaii_reef-id_20220910.nc
#        cfsv2_hotsnap_howland_baker_reef-id_20220910.nc
#        cfsv2_hotsnap_jarvis_reef-id_20220910.nc
#        cfsv2_hotsnap_johnston_reef-id_20220910.nc
#        cfsv2_hotsnap_palmyra_kingman_reef-id_20220910.nc
#        cfsv2_hotsnap_samoas_reef-id_20220910.nc
#        cfsv2_hotsnap_wake_reef-id_20220910.nc
#        cfsv2_mean-90d_gbr_reef-id_20220910.nc
#        cfsv2_mean-90d_guam_cnmi_reef-id_20220910.nc
#        cfsv2_mean-90d_hawaii_reef-id_20220910.nc
#        cfsv2_mean-90d_howland_baker_reef-id_20220910.nc
#        cfsv2_mean-90d_jarvis_reef-id_20220910.nc
#        cfsv2_mean-90d_johnston_reef-id_20220910.nc
#        cfsv2_mean-90d_palmyra_kingman_reef-id_20220910.nc
#        cfsv2_mean-90d_samoas_reef-id_20220910.nc
#        cfsv2_mean-90d_wake_reef-id_20220910.nc
#        cfsv2_wintcond_gbr_reef-id_20220910.nc
#        cfsv2_wintcond_guam_cnmi_reef-id_20220910.nc
#        cfsv2_wintcond_hawaii_reef-id_20220910.nc
#        cfsv2_wintcond_howland_baker_reef-id_20220910.nc
#        cfsv2_wintcond_jarvis_reef-id_20220910.nc
#        cfsv2_wintcond_johnston_reef-id_20220910.nc
#        cfsv2_wintcond_palmyra_kingman_reef-id_20220910.nc
#        cfsv2_wintcond_samoas_reef-id_20220910.nc
#        cfsv2_wintcond_wake_reef-id_20220910.nc
#        dz-v3.0_hdw_gbr_reef-id_20220911.nc
#        dz-v3.0_hdw_guam_cnmi_reef-id_20220911.nc
#        dz-v3.0_hdw_hawaii_reef-id_20220911.nc
#        dz-v3.0_hdw_howland_baker_reef-id_20220911.nc
#        dz-v3.0_hdw_jarvis_reef-id_20220911.nc
#        dz-v3.0_hdw_johnston_reef-id_20220911.nc
#        dz-v3.0_hdw_palmyra_kingman_reef-id_20220911.nc
#        dz-v3.0_hdw_samoas_reef-id_20220911.nc
#        dz-v3.0_hdw_wake_reef-id_20220911.nc
#        dz-v3.0_wdw_gbr_reef-id_20220911.nc
#        dz-v3.0_wdw_guam_cnmi_reef-id_20220911.nc
#        dz-v3.0_wdw_hawaii_reef-id_20220911.nc
#        dz-v3.0_wdw_howland_baker_reef-id_20220911.nc
#        dz-v3.0_wdw_jarvis_reef-id_20220911.nc
#        dz-v3.0_wdw_johnston_reef-id_20220911.nc
#        dz-v3.0_wdw_palmyra_kingman_reef-id_20220911.nc
#        dz-v3.0_wdw_samoas_reef-id_20220911.nc
#        dz-v3.0_wdw_wake_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_gbr_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_guam_cnmi_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_hawaii_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_howland_baker_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_jarvis_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_johnston_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_palmyra_kingman_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_samoas_reef-id_20220911.nc
#        forec5km_sst-mean-90d_v1.0_wake_reef-id_20220911.nc
#
# This processing check the availability of the this dated Monday folder and all the data 
# files dated as prior Sunday and Saturday's dates.

echo '  \n'
echo '  ======================================================================================'
echo '  Section 2. Examine weekly input source data files and determine whether to run model:'
echo '  --------------------------------------------------------------------------------------'

set s_reef_id = 'reef-id'
set s_file_extension = 'nc'

set list_regions = ('gbr' 'guam_cnmi' 'hawaii' 'howland_baker' 'jarvis' 'johnston' 'palmyra_kingman' 'samoas' 'wake')

set list_variables_prediction = ('cfsv2_hotsnap' 'cfsv2_mean-90d' 'cfsv2_wintcond') 
set list_variables_satellite  = ('dz-v3.0_hdw' 'dz-v3.0_wdw' 'forec5km_sst-mean-90d_v1.0')

#=============================================================================================
set today_date = `date +"%Y%m%d"`

echo "\n  ----- Today's system date: "$today_date
echo '\n  ----------------------------------------------------------------'

#---------------------------------------------------------------------------------------------
# Read the date of last successful processing:

set date_last_processed_monday = `fgrep '' $pathfile_log_date | cut -c1-8`
echo '  '
echo "  ----- Date of the last successfully processed Monday:           "$date_last_processed_monday

#---------------------------------------------------------------------------------------------
set date_to_be_processed_monday         = `date -d "$date_last_processed_monday +7 days" +%Y%m%d`
set date_to_be_read_sunday_satellite    = `date -d "$date_last_processed_monday +6 days" +%Y%m%d`
set date_to_be_read_saturday_prediction = `date -d "$date_last_processed_monday +5 days" +%Y%m%d`

echo '  '
echo "  ----- Date to be processed processed Monday:  "$date_to_be_processed_monday
echo "  ----- Date to be read Sunday   (satellite):   "$date_to_be_read_sunday_satellite
echo "  ----- Date to be read Saturday (prediction):  "$date_to_be_read_saturday_prediction

#---------------------------------------------------------------------------------------------
if($date_to_be_processed_monday > $today_date) then
  echo '\n  ----- Already_updated! Exit without processing!'
  goto abort_processing
else
  echo '\n  ----- Proceed to processing:'
endif

#---------------------------------------------------------------------------------------------
set dir_source_data_to_examine = $dir_root_source_data_to_examine'/'$date_to_be_processed_monday

set list_dates_prediction = ($date_to_be_read_saturday_prediction $date_to_be_read_saturday_prediction $date_to_be_read_saturday_prediction)
set list_dates_satellite  = ($date_to_be_read_sunday_satellite    $date_to_be_read_sunday_satellite    $date_to_be_read_sunday_satellite)

set list_variables = ($list_variables_prediction $list_variables_satellite)
set list_dates     = ($list_dates_prediction     $list_dates_satellite)

#=============================================================================================
#Loop through the lists of regions and variables:

set counter_files = 0  

foreach region ($list_regions)

  # Set minimum file size: first three for predictions and last three for satellite:
  switch ($region)
  case 'gbr':  
    set list_file_size_expected_min  = ('900000' '7000000' '9000000' '10000' '10000' '10000')
    breaksw
  case 'guam_cnmi':
    set list_file_size_expected_min  = ( '20000'  '100000'  '100000' '10000' '10000' '10000')
    breaksw
  case 'hawaii':
    set list_file_size_expected_min  = ( '10000'  '800000'  '800000' '10000' '10000' '10000')
    breaksw
  case 'howland_baker':
    set list_file_size_expected_min  = ( '10000'   '20000'   '30000' '10000' '10000' '10000')
    breaksw
  case 'jarvis':
    set list_file_size_expected_min  = ( '10000'   '10000'   '10000' '10000' '10000' '10000')
    breaksw
  case 'johnston':
    set list_file_size_expected_min  = ( '10000'   '40000'   '10000' '10000' '10000' '10000')
    breaksw
  case 'palmyra_kingman':
    set list_file_size_expected_min  = ( '10000'   '30000'   '50000' '10000' '10000' '10000')
    breaksw
  case 'samoas':
    set list_file_size_expected_min  = ( '10000'   '90000'  '140000' '10000' '10000' '10000')
    breaksw
  case 'wake':
    set list_file_size_expected_min  = ( '10000'   '10000'   '10000' '10000' '10000' '10000')
    breaksw
  default:
    echo ' '
    echo '-----QUIT! Requested an un-predefined region: '$region
    exit 3
    breaksw
  endsw

  echo '  '
  echo '  Regions to check:            '$region
  echo '  '
  echo '  # of variables to check (should be 6):     '$#list_variables
  echo '  Variables to check:          '$list_variables
  echo '  Dates of variables:          '$list_dates
  echo '  Expected minimum file sizes: '$list_file_size_expected_min

  #===========================================================================================
  echo '  '

  foreach i_variable (`seq 1 1 $#list_variables`)

    set variable         = $list_variables[$i_variable]
    set date_of_variable = $list_dates[$i_variable]
    set file_size_expected_min = $list_file_size_expected_min[$i_variable]

    set file_search = $dir_source_data_to_examine'/'$variable'_'$region'_'$s_reef_id'_'$date_of_variable'.'$s_file_extension

    echo '  Search and examine file: '$file_search

    if ( !(-f $file_search) ) then
      echo "----QUIT! ERROR: File not found: "
      goto abort_processing
    else
      echo '  --- Found file!'

      set file_size = `ls -l $file_search | awk '{print $5}'`
      if($file_size > $file_size_expected_min) then
        echo '      --- Good file size: '$file_size' - larger than minimum expected ('$file_size_expected_min').'
      else
        echo '      --- BAD File size: '$file_size' - smaller than minimum expected ('$file_size_expected_min').'
        echo "----QUIT! Error: File is too small: "
        goto proceed_to_abort
      endif
    endif

    @ counter_files++
    
  #===========================================================================================

  end # foreach i_variable
end # foreach region

echo '  '
echo '  Total number of files counted (54 files = 9 regions x 6 variable are expected):   '$counter_files
echo '  '
echo '  ************************************************************************************'
echo '  GOOD! All files passed inspection! '
echo '  -----> processing to start:'

#=============================================================================================
#=============================================================================================
# Section 3:
#
# Run FORE-C model v2.0.
#
#=============================================================================================
#=============================================================================================

echo '  \n'
echo '  ======================================================================================'
echo '  Section 3. Run FORE-C model v2.0.:'
echo '  --------------------------------------------------------------------------------------'

#Run model:
python ForeC_master_code.py

#=============================================================================================
#=============================================================================================
# Section 4:
#
# Check if all the output files are all updated in the following three output data folders:
# /data/data568/crwdir/product/forec/model/v2/uh-noaa-shiny-app/forec_shiny_app_data/Forecasts
# /data/data568/crwdir/product/forec/model/v2/uh-noaa-shiny-app/forec_shiny_app_data/Scenarios
# /data/data568/crwdir/product/forec/model/v2/crw_outputs
# 
# If all updated, update date tracking file and proceed to send the data to Github.
# If not, throw out a token warning file to halt all future processing until manually 
#         examine what happened and bug/issue is fixed. 
#         -- Note: The error token file, once created by this cutomated script, can only be 
#                  removed manually for the furture automated process to resume.
#
#=============================================================================================
#=============================================================================================

echo '  \n'
echo '  ======================================================================================'
echo '  Section 4. Check if all the output files are all updated:'
echo '  --------------------------------------------------------------------------------------'

echo '\n  Check dates of the data file in the Forecasts folder:'
cd $dir_root_output_shinyapp"/Forecasts"
foreach file (`ls -1 *.*`)
  set date_files = `date -r $file +%Y%m%d`
  if($date_files < $date_to_be_processed_monday) then
     echo '-----QUIT! Data files in the Forecasts folder are not updated!'
     touch $dir_log_error/token_error_1__at_least_Forecasts_not_updated.txt
     goto abort_processing
  else
     echo "  The Forecasts file are updated: "$file
  endif
end

echo '\n  Check dates of the data file in the Scenarios folder:'
cd $dir_root_output_shinyapp"/Scenarios"
foreach file (`ls -1 *.*`)
  set date_files = `date -r $file +%Y%m%d`
  if($date_files < $date_to_be_processed_monday) then
     echo '-----QUIT! Data files in the Scenarios folder are not updated!'
     touch $dir_log_error/token_error_2__at_least_Scenarios_not_updated.txt
     goto abort_processing
  else
     echo "  The Scenarios file are updated: "$file
  endif
end

echo '\n  Check dates of the data file in the crw_outputs folder:'
cd $dir_root_output_crw
foreach file (`ls -1 *.*`)
  set date_files = `date -r $file +%Y%m%d`
  if($date_files < $date_to_be_processed_monday) then
     echo '-----QUIT! Data files in the crw_outputs folder are not updated!'
     touch $dir_log_error/token_error_3__crw_outputs_not_updated.txt
     goto abort_processing
  else
     echo "  The crw_outputs file are updated: "$file
  endif
end

#=============================================================================================
#=============================================================================================
# Section 5:
#
# Update date tracking file, now that all the output files passed date check
#
#=============================================================================================
#=============================================================================================

echo '  \n'
echo '  ======================================================================================'
echo '  Section 5. Update date tracking file:'
echo '  --------------------------------------------------------------------------------------'

# Update date tracking file:
echo $date_to_be_processed_monday" -- most recent processed Monday date" > $pathfile_log_date

# Check if the data tracking file is updated: ---- if not, abort and throw a wrech token!
set date_new_processed_monday = `fgrep '' $pathfile_log_date | cut -c1-8`
echo ' '
echo "  ----- Date of the 'new' successfully processed Monday:    "$date_new_processed_monday
if($date_new_processed_monday < $date_to_be_processed_monday) then
  echo '-----QUIT! Date tracking file is not updated for some strange reason!'
  touch $dir_log_error/token_error_4__date_tracking_file_not_updated.txt
  goto abort_processing
else if($date_new_processed_monday > $date_to_be_processed_monday) then
  echo '-----QUIT! There is a jump in the updated date tracking file!'
  touch $dir_log_error/token_error_5__a_jump_in_the_updated_date_tracking_file.txt
  goto abort_processing
else
  echo '  Model run is successful!'
endif

#=============================================================================================
#=============================================================================================
# Section 6:
#
# Push the weekly update into GitHub, if the processing has successfully completed.
#
#=============================================================================================
#=============================================================================================

echo '  \n'
echo '  ====================================================================================='
echo '  Section 6. Push the weekly update into GitHub:'
echo '  -------------------------------------------------------------------------------------'

# Update Github:  
cd $dir_code
./run_forec_github_update_auto.sh

#=============================================================================================
abort_processing:

echo "  \n"
echo "  ======================== Done: Run weekly FORE-C update ============================="
echo "  ====================================================================================="
echo "  "

#=============================================================================================
#The end
