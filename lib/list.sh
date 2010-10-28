bb_list()
{
  n_recipes=`ls $RECIPE_DIR/ | wc -l`

  if [ $n_recipes != "0" ]
  then
    for r in `ls $RECIPE_DIR/*.sh`
    do
      local installed="-"
      local bb_action="list"
      local s_deps=""
      source "${r}"

      [ $(check_if_installed $seed_name) == "1" ] && installed="I" || installed="-"
      for d in "${deps[@]}"; do s_deps="$s_deps $d"; done
      # printf "%s %-24.24s %s\n" "$installed" "$seed_name" "$s_deps"
      s_deps=`echo $s_deps | sed 's/^\s//g'`
      printf "%s %s (%s)\n" "$installed" "$seed_name" "$s_deps"
      deps=""
    done
  else
    echo "No recipes found." 
  fi 
}
