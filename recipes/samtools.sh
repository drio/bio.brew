local version="0.1.16"
local URL="http://downloads.sourceforge.net/project/samtools/samtools/${version}/samtools-${version}.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsamtools%2Ffiles%2Fsamtools%2F${version}%2F&ts=1320169674&use_mirror=voxel"
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
