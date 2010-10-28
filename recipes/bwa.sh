
local URL="https://bio-bwa.svn.sourceforge.net/svnroot/bio-bwa"
local tb_file=`basename $URL`
local seed_name="bwa"
local install_files=(bwa solid2fastq.pl)

do_install()
{
  before_install $seed_name
  cd $LOCAL_DIR
  svn co $URL $seed_name
  cd $seed_name
  svn $URL $seed_name 
  mv $seed_name/trunk/bwa ./b
  rm -rf bwa
  mv ./b ./bwa
  link_from_stage $recipe ${install_files[@]}
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
