bb_remove()
{
  local recipe=$1
  local bb_action="remove"
  check_recipe ${recipe}.sh
  log "recipe script found"
  source "$RECIPE_DIR/${recipe}.sh"
}

before_remove()
{
  local recipe_name=$1
  [ -f $LOG_DIR/$recipe_name.lock ] && usage 1 "Other instance is working on $recipe_name. Bailing out."
  touch $LOG_DIR/$recipe_name.lock
}

remove_recipe()
{
  local recipe_name=$1
  log "removing: $TB_DIR/$recipe_name"
  rm -rf $TB_DIR/$recipe_name
  log "removing: $LOCAL_DIR/$recipe_name"
  rm -rf $LOCAL_DIR/$recipe_name
}

remove_from_stage()
{
  local recipe_name=$1; shift
  local install_files=("$@")
  for f in ${install_files[@]} 
  do
    local bn=`basename $f`
    log "remove link from from staging area [$f]"
    rm -f $LOCAL_DIR/bin/$bn
  done
}

after_remove()
{
  local recipe_name=$1
  local lock_file="$LOG_DIR/$recipe_name.lock"
  log "recipe [$recipe_name] removed."
  log "removing lock. [$lock_file]"
  rm -f $lock_file
}

