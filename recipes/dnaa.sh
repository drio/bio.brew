
local URL="git://dnaa.git.sourceforge.net/gitroot/dnaa/dnaa"
local tb_file=`basename $URL`
local seed_name="bfast"
local install_files=(bfast/bfast scripts/solid2fastq scripts/ill2fastq.pl)
local deps=(dwgsim/dwgsim dwgsim/dwgsim_eval dwgsim/dwgsim_pileup_eval.pl)

do_install()
{
  before_install $seed_name
  cd $LOCAL_DIR
  log "git cloning: $URL"
  git clone $URL &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
  log "autogen"
  sh ./autogen.sh &> $LOG_DIR/${seed_name}.autogen.log.txt
  configure_tool $seed_name 
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
