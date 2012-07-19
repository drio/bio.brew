local URL="http://go.googlecode.com/files/go1.0.2.linux-amd64.tar.gz"
local tb_file=`basename $URL`
local type="tar.gz"
local seed_name=go

do_install()
{
  before_install $seed_name
  cd $TB_DIR
  download $URL $tb_file
  decompress_tool $tb_file $type
  cd $seed_name
  for_env "export GOROOT=`pwd`;export PATH=\$PATH:`pwd`/bin"
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
