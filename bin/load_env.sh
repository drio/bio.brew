
BB_PATH="/data/rogers/drio_scratch/bb"
export PATH="$BB_PATH/bin:$PATH"
export PATH="$BB_PATH/local/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$BB_PATH/local/lib"

BB_LOGS_DIR="`bb | grep MAIN | awk -F: '{print $2}'`/logs"
for s in $BB_LOGS_DIR/*.sh
do
  source $s
done