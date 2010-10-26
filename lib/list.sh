bb_list()
{
  n_recipes=`ls $RECIPE_DIR/ | wc -l`

  if [ $n_recipes != "0" ]
  then
    for r in `ls $RECIPE_DIR/*.sh`
    do
      local bb_action="list"
      source "${r}"

      if [ $(check_if_installed $seed_name) == "1" ];then 
        echo -ne "[I] " 
      else
        echo -ne "[U] "
      fi
      echo "$seed_name"
    done
  else
    echo "No recipes found." 
  fi 
}
