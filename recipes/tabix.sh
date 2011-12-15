
local version="0.2.3"
local URL="http://sourceforge.net/projects/samtools/files/tabix/tabix-{$version}.tar.bz2/download"
local tb_type="tar.bz2"
local seed_name="tabix"
local root_seed=${seed_name}"-${version}"
local tb_file=${root_seed}.${tb_type}
local install_files=(tabix bgzip)

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cd $LOCAL_DIR
  log "Downloading ${root_seed}"
  curl -sL $URL > $tb_file
  decompress_tool $tb_file $tb_type
  rm -f $tb_file
  cd $root_seed
  link_from_stage $root_seed ${install_files[@]} 
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  rm -rf $LOCAL_DIR/$root_seed*
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
