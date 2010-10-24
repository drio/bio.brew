
VERSION="0.0.1"
RECIPE_DIR="$MAIN_DIR/recipes"

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
  if [ ! -f $RECIPE_DIR/*.sh ]  
  then
    usage 1 "recipe not found."
  fi
}
