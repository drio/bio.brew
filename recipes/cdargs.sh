
local URL="http://www.skamphausen.de/downloads/cdargs/cdargs-1.35.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name=$(extract_tool_name $tb_file $type)
local install_files=(bin/cdargs contrib/cdargs-bash.sh)

case $bb_action in
  "install") 
    if [ $(check_if_installed $seed_name) == "0" ]
    then
      before_install $seed_name
      cd $TB_DIR
      download $URL $tb_file
      decompress_tool $tb_file $type
      cd $seed_name
      configure_tool $seed_name
      make_tool $seed_name
      install_tool $seed_name
      link_from_stage $seed_name ${install_files[@]}
      after_install $seed_name
    else
      log "recipe already installed, skipping."
    fi
    ;;
  "remove")
    if [ $(check_if_installed $seed_name) == "1" ]
    then
      before_remove $seed_name
      remove_recipe $seed_name
      remove_from_stage $seed_name ${install_files[@]}
      after_remove $seed_name
    else
      log "recipe not installed."
    fi
    ;;
  "list")
    ;;
  *)
    log "Incorrect action. Bailing out."; exit 1
    ;;
esac
