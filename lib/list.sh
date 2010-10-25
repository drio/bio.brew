
bb_list()
{
  n_recipes=`ls $RECIPE_DIR/ | wc -l`
  if [ $n_recipes != "0" ]
  then
    for r in `ls $RECIPE_DIR/*.sh`
    do
      f_name="`basename $r`" 
      r_name=${f_name%.*}
      echo $r_name
    done
  else
    echo "No recipes found." 
  fi 
}
