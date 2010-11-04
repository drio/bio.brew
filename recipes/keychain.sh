local URL="http://www.funtoo.org/archive/keychain/keychain-2.7.1.tar.bz2"
local tb_file=`basename $URL`
local type="tar.bz2"
local seed_name=$(extract_tool_name $tb_file $type)
local install_files=(keychain)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  log "Manually copying keychain script"
  cp ${install_files[0]} $LOCAL_DIR/bin
  after_install $seed_name
}

do_remove()
{
  before_remove $seed_name
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
