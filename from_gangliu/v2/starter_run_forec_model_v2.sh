#=============================================================================================
#=============================================================================================
# starter_run_forec_model_v2.sh
#=============================================================================================
#
# Note: The following statements can't be simply put in a csh script to run. It will throw a 
#       syntax error message.:
#                   source $HOME/.bash_profile
#                   source $HOME/.bashrc
#       As a result this separate script (starter_run_forec_model_v2.sh) is used to launch
#                   ./run_forec_model_v2.sh       
#
# Note: 
# Currently each run of the processing (./run_forec_model_v2.sh) called by this script will 
# update products for one Monday update only and the updated Monday would be the Monday right 
# after the latest processed Monday stated in the date tracking file 
# (track_date_auto/track_date_forec_model_run_auto.txt). If there is any delay in processing 
# for a few previous Mondays, a few backup runs of this script set up in the cronjob should 
# catch up all the needed processing for all the previosuly missed Monday processing. If not, 
# the processing should automatically catch up over the next Monday's primary and backup runs. 
# If there are too many missed processings, just simply manually rerun this script at many 
# times as needed.
#
#       ****
#
# -- The script, ./run_forec_model_v2.sh is to be revised so that it can make the processing 
#    to process for all missed Mondays by one single execution. Currently, one execution
#    runs for one update only -- to be done
#
#       ****
#
#
#
#=============================================================================================
#
# Program History:
#
# 2022/09/27 Gang Liu : Initial development.
#
#=============================================================================================

echo '  '
echo '                   Executing:   starter_run_forec_model_v2.sh'
echo '  '
echo '  ======================================================================================'
echo '                        Activate Python environment first:'
echo '  ======================================================================================'
echo '  '
echo '  $HOME = '$HOME

#---------------------------------------------------------------------------------------------
# Get up Linux server environement variables:
#---------------------------------------------------------------------------------------------
#The following two lines are needed for cronjob:
source $HOME/.bash_profile
source $HOME/.bashrc

#---------------------------------------------------------------------------------------------
# Activate specific conda environemnt for processing:
#---------------------------------------------------------------------------------------------
##echo ' Python version of the conda 5km_v3.1:'
##conda activate 5km_v3.1_op_v20210108
##python --version

echo '  Python version of the forec_model_v20220624 environment:'
conda activate forec_model_v20220624
conda info --envs
python --version

#=============================================================================================
echo '  '
echo '  ====================================================================================='
echo '                        Execute model run:'
echo '  ====================================================================================='
echo '  '

cd /data/data568/crw/code/proc_nrt/forec/model/v2
./run_forec_model_v2.sh

#=============================================================================================
# Deactivate specific conda environment:

conda deactivate

#=============================================================================================
# The end
