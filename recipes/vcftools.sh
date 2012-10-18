local version="0.1.9"
local URL="http://sourceforge.net/projects/vcftools/files/vcftools_${version}.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name="vcftools_$version"
local install_files=(bin/vcf-annotate bin/vcf-compare bin/vcf-concat bin/vcf-convert bin/vcf-isec bin/vcf-merge bin/vcf-query bin/vcf-sort bin/vcf-stats bin/vcf-subset bin/vcftools bin/vcf-to-tab bin/vcf-validator)
local deps=()

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cd $LOCAL_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  make_tool $seed_name $make_j
  link_from_stage $seed_name ${install_files[@]}
  for_env "export PERL5LIB=\$PERL5LIB:$LOCAL_DIR/$seed_name/perl"
  after_install $seed_name
}

do_remove()
{
  before_remove $seed_name
  remove_recipe $seed_name
  remove_from_stage $seed_name ${install_files[@]}
  after_remove $seed_name
  echo "rm -f $LOCAL_DIR/$tb_file"
}

source "$MAIN_DIR/lib/case.sh"
