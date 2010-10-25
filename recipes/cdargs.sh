
bb_install_cdargs()
{
  local URL="http://www.skamphausen.de/downloads/cdargs/cdargs-1.35.tar.gz"
  local tb_file=`basename $URL`
  local type="tar.gz"
  local seed_name=$(extract_tool_name $tb_file $type)
  local install_files=(bin/cdargs contrib/cdargs-bash.sh)

  before_install
  cd $TB_DIR
  download $URL
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name
  make_tool $seed_name
  install_tool $seed_name
  link_from_stage $seed_name ${install_files[@]}
  after_install $seed_name
}
