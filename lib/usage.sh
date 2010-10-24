usage()
{
  e_code=$1
  e_msg=$2

  if [ ".$_msg" == "." ]; then
    echo "UPS!: $e_msg"
    echo ""
  fi

  cat << EOF
Usage: bb [-v] [-h] COMMAND [recipe]

COMMANDS:
  list   : list all the available recipes.
  install: install recipe.
  remove : remove recipe. 

OPTIONS:
  -v: print version.
  -h: print help.
EOF

  bye $e_code
}

