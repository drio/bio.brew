
local URL="http://sourceforge.net/projects/tmux/files/tmux/tmux-1.3/tmux-1.3.tar.gz/download"
local tb_file="tmux-1.3.tar.gz"
local type="tar.gz"
local seed_name=$(extract_tool_name $tb_file $type)
#local install_files=(bin/dargs contrib/cdargs-bash.sh)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  mv "download" $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  export LIBRARY_PATH=$LOCAL_LIB/lib:$CPATH
  export CPATH=$LOCAL_LIB/include:$CPATH
  configure_tool $seed_name
  make_tool $seed_name
  ln -s $TB_DIR/$seed_name/tmux $LOCAL_DIR/bin
  after_install $seed_name
  #export LD_LIBRARY_PATH
}

do_remove()
{
  before_remove $seed_name
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
