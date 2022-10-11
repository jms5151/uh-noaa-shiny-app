#! /bin/csh

#=============================================================================================
# run_forec_github_update_auto.sh
#=============================================================================================
#
# Note: In the automated processing, this script will be called and executed when the caller
#       determined the processing is successfully completed and file are ready to be pushed 
#       to Github.
#
#---------------------------------------------------------------------------------------------
#
# Programming History:
#
# 2022/09/22 Gang Liu : Initial development.
#
#=============================================================================================
#
#
#=============================================================================================

echo ' '
echo ' ==============================================================================='
echo ' ---------  Run FORE-C Github update :                                               '
echo ' ==============================================================================='
echo ' -- Starting time for Run FORE-C Github update:'  `date`
set time_start = `date +%s`
#echo $time_start
echo ' '

#=============================================================================================
set dir_proc = '/data/data568/crw/code/proc_nrt/forec/model/v2'
set dir_github_local = '/data/home004/gang.liu/crw_github_jms5151/uh-noaa-shiny-app'
set dir_agent = '/data/data568/crw/code/proc_nrt/agent_for_auto_remote_access'

set dir_root_source = "/data/data568/crwdir/product/forec/model/v2/uh-noaa-shiny-app/forec_shiny_app_data"

#---------------------------------------------------------------------------------------------
set log_file = $dir_proc'/log/log_run_forec_github_update_auto.txt'

#=============================================================================================

set pathfile_log_date = $dir_proc"/track_date_auto/track_date_forec_model_run_auto.txt"
set date_last_processed_monday = `fgrep '' $pathfile_log_date | cut -c1-8`
set year_last_processed_monday = `fgrep '' $pathfile_log_date | cut -c1-4`
set month_last_processed_monday = `fgrep '' $pathfile_log_date | cut -c5-6`
set day_last_processed_monday = `fgrep '' $pathfile_log_date | cut -c7-8`
echo ' '
echo " ----- Date of the latest successfully processed Monday:           "$date_last_processed_monday

#=============================================================================================
echo " Github local location:  "$dir_github_local
echo ' '

#---------------------------------------------------------------------------------------------
#Check existence of local Github folder:

if ( !(-d $dir_github_local) ) then
  echo "QUIT! Error: Github local folder was not found:  "$dir_github_local
  echo " "
  exit
else
  echo " ** Exist: Github local folder exists:  "$dir_github_local
endif

#=============================================================================================
# Load the agent:

echo " "
echo " Load agent for password-less access:"
source $dir_agent/setup_agent_for_rhw1321.sh

#=============================================================================================
#=============================================================================================
cd $dir_github_local
echo "\n in folder: "$dir_github_local

echo "\n Run: git pull:"
git pull

#---------------------------------------------------------------------------------------------
cd forec_shiny_app_data
echo "  "
echo "  ===================================================================================="
echo "  Now in this Github local folder to pull updated Shiny App data files over: "
pwd

rsync -a $dir_root_source/Forecasts .
rsync -a $dir_root_source/Scenarios .

#---------------------------------------------------------------------------------------------
# Check file dates to make sure all the files have been pulled over successfully:

echo "  "
echo "  ===================================================================================="
echo "  Now check file dates: "

cd Forecasts
echo "\n  Now in this folding checking file dates:"
pwd
foreach file (`ls -1 *.*`)
  set date_files = `date -r $file +%Y%m%d`
  if($date_files < $date_last_processed_monday) then 
     echo "-----QUIT! File are not updated with old date:  "$date_files
     goto exit_for_error
  else
     echo " This file in Forecasts is updated: "$file
  endif
end

cd ../Scenarios
echo "\n  Now in this folding checking file dates:"
pwd
foreach file (`ls -1 *.*`)
  set date_files = `date -r $file +%Y%m%d`
  if($date_files < $date_last_processed_monday ) then
     echo "-----QUIT! File are not updated with old date:  "$date_files
     goto exit_for_error
  else
     echo " This file in Scenarios is updated: "$file
  endif
end

#---------------------------------------------------------------------------------------------
cd $dir_github_local
echo "\n in folder: "$dir_github_local

echo " Run: git add .:"
git add .

set s_comment = "Weekly data update of Monday "$year_last_processed_monday"/"$month_last_processed_monday"/"$day_last_processed_monday"."
echo " Run: commit -m "$s_comment
git commit -m "$s_comment"

echo " Run: git status:"
git status

echo " Run: git push:"
git push

#=============================================================================================
exit_for_error:

echo ' '
echo ' '
echo ' ==============================================================================='
echo " -- Ending time for Run FORE-C Github update:  "  `date`
set time_end = `date +%s`
#echo $time_end
#echo " "
#@ time_delta = ($time_end - $time_start)
#echo " -- Time used: "$time_delta"    seconds"
#set min = 60
#@ time_delta = ($time_end - $time_start) / $min
#echo " -- Time used: "$time_delta"    minutes"
echo ' '
echo ' ==============================================================================='
echo ' Done:  Run FORE-C Github update! '
echo ' ==============================================================================='

#=============================================================================================
#=============================================================================================
#The End
