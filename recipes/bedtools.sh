local version="2.12.0"
local URL="http://bedtools.googlecode.com/files/BEDTools.v${version}.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name="BEDTools-Version-${version}"
local install_files=(bin/annotateBed bin/cuffToTrans         bin/genomeCoverageBed   
bin/mergeBed            bin/shuffleBed          bin/unionBedGraphs
bin/bamToBed            bin/closestBed          bin/fastaFromBed        
bin/intersectBed        bin/overlap             bin/slopBed             
bin/windowBed           bin/bed12ToBed6         bin/complementBed       
bin/fjoin               bin/linksBed            bin/pairToBed           
bin/sortBed             bin/bedToBam            bin/coverageBed         
bin/flankBed            bin/maskFastaFromBed    bin/pairToPair          
bin/subtractBed         bin/bedToIgv)

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
