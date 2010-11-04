local URL="http://www.nicemice.net/par/Par152.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name="Par152"
local install_files=(par)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  cp protoMakefile Makefile
  make_tool $seed_name $make_j
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
