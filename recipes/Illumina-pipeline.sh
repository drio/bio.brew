
local version="1.40"
local URL="git@github.com:drio/Illumina-pipeline.git"
local seed_name="Illumina-pipeline"
local deps=(java ruby-1.9.2-p180)

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cd $LOCAL_DIR
  log "git clone: $URL"
  git clone $URL &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name/java
  log "Building java tools"
  ./BuildAllProjects.rb &> $LOG_DIR/${seed_name}.build_java_tools.log.txt
  cd ../..
  log "Preparing env: (I_PIPE)"
  for_env "export I_PIPE='$LOCAL_DIR/$seed_name'"
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  rm -rf $LOCAL_DIR/$seed_name
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
