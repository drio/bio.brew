local version="0.1.16"
local URL="https://sourceforge.net/projects/samtools/files/samtools/0.1.16/samtools-${version}.tar.bz2"
local tb_file=`basename $URL`
local type="tar.bz2"
local seed_name="samtools-${version}"
local install_files=(samtools misc/samtools.pl bcftools/bcftools bcftools/vcfutils.pl)

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
  for_env "export SAMTOOLS_DIR='$LOCAL_DIR/$seed_name'"
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
