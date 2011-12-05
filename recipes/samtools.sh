local URL="http://github.com/lh3/samtools.git"
local seed_name="samtools"
local deps=()
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cd $LOCAL_DIR
  log "git cloning: $URL"
  git clone $URL &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
  log "make"
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
