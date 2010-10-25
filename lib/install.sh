bb_install()
{
  recipe=$1
  log "Installing recipe: $recipe"
  check_recipe ${recipe}.sh
  log "recipe script found"
  method="bb_install_$recipe"
  source "$RECIPE_DIR/${recipe}.sh"
  $method
}
