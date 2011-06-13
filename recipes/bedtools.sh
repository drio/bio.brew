local version="2.12.0"
local URL="http://bedtools.googlecode.com/files/BEDTools.v${version}.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name="BEDTools-Version-${version}"
local install_files=(bin/coverageBed bin/slopBed bin/linksBed 
bin/mergeBed bin/bed12ToBed6 bin/closestBed bin/complementBed 
bin/overlap bin/annotateBed bin/subtractBed bin/maskFastaFromBed 
bin/windowBed bin/sortBed bin/unionBedGraphs bin/genomeCoverageBed 
bin/pairToPair bin/fastaFromBed bin/bedToBam bin/pairToBed 
bin/flankBed bin/bedToIgv bin/intersectBed bin/shuffleBed 
bin/fjoin bin/cuffToTrans bin/bamToBed)

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  cd ..
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
