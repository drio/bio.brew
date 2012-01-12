
local URL="http://www.lua.org/ftp/lua-5.2.0.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name="lua-5.2.0"
local deps=()
local install_files=(src/lua)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  log "Compiling: -j $make_j"
  make -j $make_j linux &> $LOG_DIR/${seed_name}.make.log.txt
  log "linking: $TB_DIR/$seed_name/src/lua -> $LOCAL_DIR/bin"
  ln -s $TB_DIR/$seed_name/src/lua $LOCAL_DIR/bin
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
