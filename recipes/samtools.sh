
local URL="https://samtools.svn.sourceforge.net/svnroot/samtools"
local tb_file=`basename $URL`
local seed_name="samtools"
local install_files=(samtools)
local deps=("subversion-1.6.13")

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cd $LOCAL_DIR
  log "svn: checking out $URL"
  svn co $URL $seed_name &> $LOG_DIR/${seed_name}.svn_co.log.txt
  mv $seed_name/trunk/$seed_name ./s
  rm -rf $seed_name
  mv ./s $seed_name
  cd $seed_name
  make_tool $seed_name $make_j
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
