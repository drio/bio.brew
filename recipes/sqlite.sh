
local URL="http://www.sqlite.org/sqlite-3.7.3.tar.gz"
lCPATHocal tb_file=`basename $URL`
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
  rm -f $LOCAL_DIR/lib/libsqlite3*
  rm -f $LOCAL_DIR/lib/pkgconfig
  rm -f $LOCAL_DIR/bin/sqlite3
  rm -f $LOCAL_DIR/include/sqlite3ext.h
  rm -f $LOCAL_DIR/include/sqlite3.h
  rm -f $LOCAL_DIR/lib/pkgconfig/sqlite3.pc
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
