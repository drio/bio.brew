bb_install()
{
  local recipe=$1
  local bb_action="install"
  log "Installing recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

check_if_installed()
{
  local recipe_name=$1
  [ -d $TB_DIR/$recipe_name ] && echo 1 || echo 0
}

before_install()
{
  local recipe_name=$1
  mkdir -p $LOCAL_DIR
  mkdir -p $TB_DIR
  mkdir -p $LOG_DIR
  mkdir -p $BIN_DIR
  mkdir -p $SHARE_DIR
  [ -f $LOG_DIR/$recipe_name.lock ] && usage 1 "Other instance is working on $recipe_name. Bailing out."
  touch $LOG_DIR/$recipe_name.lock
}

after_install()
{
  local recipe_name=$1
  local lock_file="$LOG_DIR/$recipe_name.lock"
  log "recipe [$recipe_name] installed."
  log "removing lock. [$lock_file]"
  rm -f $lock_file
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

download()
{
  local url=$1
  local tb_file=$2
  if [ -f $TB_DIR/$tb_file ]
  then
    log "$tb_file already downloaded, skipping"
  else
    log "downloading [$url]"
    curl --silent -O $url
  fi 
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
