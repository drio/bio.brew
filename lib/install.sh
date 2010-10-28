bb_install()
{
  local recipe=$1
  local bb_action="install"
  log "Installing recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

clear_env()
{
  rm -f $LOG_DIR/$recipe.env.sh
}

for_env()
{
  echo $1 >> $LOG_DIR/$recipe.env.sh
}

check_deps()
{
  local list_deps=("$@")
  local not_installed=""
  for f in ${list_deps[@]} 
  do
    local install_flag="$LOG_DIR/$f.installed"
    [ ! -f $install_flag ] && not_installed="$not_installed $f"
  done
  [ ".$not_installed" != "." ] && log "Install deps first:$not_installed" && exit 1
  return 0 
}

check_if_installed()
{
  local recipe_name=$1
  #[ -d $TB_DIR/$recipe_name ] && echo 1 || echo 0
  [ -f $LOG_DIR/$recipe_name.installed ] && echo 1 || echo 0
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
  local install_flag="$LOG_DIR/$recipe_name.installed"
  log "recipe [$recipe_name] installed."
  log "removing lock. [$lock_file]"
  rm -f $lock_file
  log "touching install flag [$install_flag]"
  touch $install_flag
}

configure_tool()
{
  local seed_name=$1
  local options=$2
  local prefix=$3
  local log_file="$LOG_DIR/${seed_name}.configure.log.txt"

  [ ".$prefix" ==  "." ] && prefix=$LOCAL_DIR/$seed_name
  log "running configure [logging output: $log_file]"
  ./configure --prefix=$prefix $options &> $log_file
}

make_tool()
{
  local seed_name=$1
  local make_j=$2
  [ ".$make_j" == "." ] && make_j=1
  local log_file=$LOG_DIR/${seed_name}.make.log.txt
  log "running make on tool [logging output: $log_file] [j: $make_j]"
  (
  export LIBRARY_PATH=$LOCAL_DIR/lib
  export CPATH=$LOCAL_DIR/include
  make -j $make_j &> $log_file
  )
}

install_tool()
{
  local log_file=$LOG_DIR/${seed_name}.install.log.txt
  log "installing tool [logging output: $log_file]"
  make install &> $log_file
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
    chmod 755 $LOCAL_DIR/$seed_name/$f
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
    curl --silent -L -O $url
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
    "tar.bz2")
      tar jxf $tb_file
    ;;
    ?)
      log "Problems decompressing $tb_file" 1
    ;;
  esac
}
