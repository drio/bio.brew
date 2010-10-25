
VERSION="0.0.1"
RECIPE_DIR="$MAIN_DIR/recipes"
LOCAL_DIR="$MAIN_DIR/local"
TB_DIR="$MAIN_DIR/tarballs"
LOG_DIR="$MAIN_DIR/logs"
BIN_DIR="$LOCAL_DIR/bin"
SHARE_DIR="$LOCAL_DIR/share"

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
  log_msg=$1
  log_and_go=$2
  echo "`date` >> $1"
  [ ".$log_and_go" != "." ] && exit $log_and_go
  return 0
}

before_install()
{
  mkdir -p $LOCAL_DIR
  mkdir -p $TB_DIR
  mkdir -p $LOG_DIR
  mkdir -p $BIN_DIR
  mkdir -p $SHARE_DIR
}

download()
{
  local url=$1
  log "downloading [$url]"
  curl --silent -O $url
}

decompress_tool()
{
  local tb_file=$1
  local tb_type=$2
  log "decompressing tarball: $tb_file ($tb_type)"
  case $tb_type in
    "tar.gz")
      tar zxf $tb_file
    ;;
    ?)
      log "Problems decompressing $tb_file" 1
    ;;
  esac
}

extract_tool_name()
{
  local tb_file=$1
  local type=$2
  echo `echo $tb_file | sed "s/.$type//g"`
}

configure_tool()
{
  local seed_name=$1
  local log_file="$LOG_DIR/${seed_name}.configure.log.txt"

  log "running configure [logging output: $log_file]"
  ./configure --prefix=$LOCAL_DIR/$seed_name &> $log_file
}

make_tool()
{
  local log_file=$LOG_DIR/${seed_name}.make.log.txt
  log "running make on tool [logging output: $log_file]"
  make &> $log_file
}

install_tool()
{
  local log_file=$LOG_DIR/${seed_name}.install.log.txt
  log "installing tool [logging output: $log_file]"
  make install &> log_file
}

link_from_stage()
{
  local seed_name=$1; shift
  local install_files=("$@")
  for f in ${install_files[@]} 
  do
    local bn=`basename $f`
    log "linking from staging area [$f]"
    rm -f $LOCAL_DIR/bin/$bn
    ln -s $LOCAL_DIR/$seed_name/$f $LOCAL_DIR/bin/$bn
  done
}

after_install()
{
  log "recipe [$1] installed."
}
