usage()
{
  e_code=$1
  e_msg=$2

  if [ ".$e_msg" != "." ]; then
    echo "ERROR: $e_msg"
    echo ""
  fi

  cat << EOF
VERSION: $VERSION

bb (BioBrew) is a tiny and personal package manager that allows you 
to quickly setup your toolbox in a new (and perhaps hostile) environment.

bb also tries to focus on bio informatics tools (bfast, samtools, bwa, 
picard tools, ...)  as well as crucial UNIX tools (vim, cdargs, etc ...).

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

