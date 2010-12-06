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
  mkdir -p $CONTRIB_DIR
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
    log "Setting permission"
    [ -f $LOCAL_DIR/$seed_name/$f ] && chmod 755 $LOCAL_DIR/$seed_name/$f
  done
  return 0
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

cpan_remove()
{
  local p_module=$1
  local log_file=$LOG_DIR/${seed_name}.cpan.uninstall.log.txt
  log "Removing CPAN module: ${p_module}"
  (echo "u $p_module") | cpan &> $log_file
}

cpan_install()
{
  local p_module=$1
  local log_file=$LOG_DIR/${seed_name}.cpan.install.log.txt
  log "Installing CPAN module: ${p_module}"
  (echo "force install $p_module") | cpan &> $log_file
}

setup_cpan_policy()
{
  log "Setting up CPAN policy to follow."
  local log_file=$LOG_DIR/cpan.policy.log.txt
  (echo y; echo o conf prerequisites_policy follow;echo o conf commit) | cpan &> $log_file
}

setup_cpan_config()
{
  cp_dir="$HOME/.cpan/CPAN"
  cp_config="$cp_dir/MyConfig.pm"

  setup_cpan_policy
  if [ -f $cp_config ] 
  then
    log "Cannot setup CPAN config. Already exists"  
  else
    log "Setting up CPAN config."
    mkdir -p $cp_dir
    ( 
    cat<<-EOF
\$CPAN::Config = {
  'auto_commit' => q[0],
  'build_cache' => q[100],
  'build_dir' => q[${HOME}/.cpan/build],
  'cache_metadata' => q[1],
  'commandnumber_in_prompt' => q[1],
  'connect_to_internet_ok' => q[1],
  'cpan_home' => q[${HOME}/.cpan],
  'ftp_passive' => q[1],
  'ftp_proxy' => q[],
  'http_proxy' => q[],
  'inactivity_timeout' => q[0],
  'index_expire' => q[1],
  'inhibit_startup_message' => q[0],
  'keep_source_where' => q[${HOME}/.cpan/sources],
  'load_module_verbosity' => undef,
  'make_arg' => q[],
  'make_install_arg' => q[],
  'make_install_make_command' => q[],
  'makepl_arg' => q[],
  'mbuild_arg' => q[],
  'mbuild_install_arg' => q[],
  'mbuild_install_build_command' => q[./Build],
  'mbuildpl_arg' => q[],
  'no_proxy' => q[],
  'prerequisites_policy' => q[follow],
  'scan_cache' => q[atstart],
  'show_upload_date' => q[0],
  'term_ornaments' => q[1],
  'urllist' => [q[ftp://cpan.pair.com/pub/CPAN/], q[ftp://cpan.netnitco.net/pub/mirrors/CPAN/], q[ftp://cpan.mirrors.tds.net/pub/CPAN], q[ftp://cpan.llarian.net/pub/CPAN/]],
  'use_sqlite' => q[0],
};
1;
__END__
EOF
    ) > $cp_config
  fi
}
