
local URL="http://apache.securedservers.com/apr/apr-1.4.2.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name=$(extract_tool_name $tb_file $type)

do_install()
{
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
}

do_remove()
{
  before_remove $seed_name
  #remove_from_stage $seed_name ${install_files[@]}
  rm -f $LOCAL_DIR/bin/apr*
  rm -f $LOCAL_DIR/lib/libapr*
  rm -f $LOCAL_DIR/lib/apr.exp
  rm -f $LOCAL_DIR/lib/pkgconfig/apr-1.pc
}

source "$MAIN_DIR/lib/case.sh"
