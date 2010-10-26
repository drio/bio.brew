
local URL="http://monkey.org/~provos/libevent-1.4.14b-stable.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name=$(extract_tool_name $tb_file $type)

case $bb_action in
  "install") 
    if [ $(check_if_installed $seed_name) == "0" ]
    then
      before_install $seed_name
      cd $TB_DIR
      download $URL $tb_file
      decompress_tool $tb_file $type
      cd $seed_name
      configure_tool $seed_name $LOCAL_DIR
      make_tool $seed_name
      install_tool $seed_name
      #link_from_stage $seed_name ${install_files[@]}
      after_install $seed_name
    else
      log "recipe already installed, skipping."
    fi
    ;;
  "remove")
      before_remove $seed_name
      remove_recipe_using_make $seed_name
      #remove_from_stage $seed_name ${install_files[@]}
      after_remove $seed_name
    ;;
  *)
    log "Incorrect action. Bailing out."; exit 1
    ;;
esac
