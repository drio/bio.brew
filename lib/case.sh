case $bb_action in
  "install") 
    if [ $(check_if_installed $seed_name) == "0" ]
    then
      do_install
    else
      log "recipe already installed, skipping."
    fi
    ;;
  "remove")
    if [ $(check_if_installed $seed_name) == "1" ]
    then
      do_remove
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
