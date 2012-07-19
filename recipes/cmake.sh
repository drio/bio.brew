local version=2.8.7
local type="tar.gz"
local URL="http://www.cmake.org/files/v2.8/cmake-${version}.${type}"
local tb_file=`basename $URL`
local seed_name="cmake-${version}"
local install_files=(bin/cmake bin/cpack bin/ctest)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  configure_tool $seed_name
  make_tool $seed_name $make_j
  install_tool $seed_name
  link_from_stage $seed_name ${install_files[@]}
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
