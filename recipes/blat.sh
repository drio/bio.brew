local version="34"
local URL="http://hgwdev.cse.ucsc.edu/~kent/src/blatSrc${version}.zip"
local tb_file=`basename $URL`
local type="zip"
local seed_name="blatSrc"
local install_files=(bin/blat bin/pslPretty bin/pslReps bin/pslSort)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  export MACHTYPE="x86_64"
  mkdir -p ~/bin/$MACHTYPE
  make &> $LOG_DIR/${seed_name}.make.log.txt
  cd ..
  mv $HOME/bin/$MACHTYPE ./$seed_name/bin
  mv $seed_name $LOCAL_DIR
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
