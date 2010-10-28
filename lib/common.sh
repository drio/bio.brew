
VERSION="0.0.1"
RECIPE_DIR="$MAIN_DIR/recipes"
LOCAL_DIR="$MAIN_DIR/local"
TB_DIR="$MAIN_DIR/tarballs"
LOG_DIR="$MAIN_DIR/logs"
BIN_DIR="$LOCAL_DIR/bin"
SHARE_DIR="$LOCAL_DIR/share"
CONTRIB_DIR="$LOCAL_DIR/contrib"

version()
{
  echo $VERSION
  bye 0
}

bye()
{
  exit $1
}

check_recipe()
{
  if [ ! -f $RECIPE_DIR/$1 ]  
  then
    usage 1 "recipe not found."
  fi
}

log()
{
  local log_msg=$1
  local log_and_go=$2
  echo "`date` >> $1"
  [ ".$log_and_go" != "." ] && exit $log_and_go
  return 0
}

extract_tool_name()
{
  local tb_file=$1
  local type=$2
  echo `echo $tb_file | sed "s/.$type//g"`
}

# Thanks: http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac 
find_dist_path()
{
  local target_file=$1
  cd `dirname $target_file`
  cd ..
  target_file=`basename $target_file`

  # Iterate down a (possible) chain of symlinks
  while [ -L "$target_file" ]
  do
      target_file=`readlink $target_file`
      cd `dirname $target_file`
      target_file=`basename $target_file`
  done

  result=`pwd -P`/$target_file
  echo $result
}
