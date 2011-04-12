
local version="1.5.64"
local URL="http://www.broadinstitute.org/igvdata/downloads/IGV_1.5.64.zip"
local tb_file=`basename $URL`
local seed_name="igv"
local unzip_dir="IGV_${version}"
local deps=(java)
local install_files=(igv.jar batik-codec.jar igv_linux-64.sh)

do_install()
{
  before_install $seed_name
  cd $LOCAL_DIR
  log "Downloading"
  curl -sL $URL > ${unzip_dir}.zip
  log "Unzipping"
  unzip ${unzip_dir}.zip &> $LOG_DIR/${seed_name}.unzip.log.txt
  rm -f *.zip
  mv $unzip_dir $seed_name
  link_from_stage $seed_name ${install_files[@]}
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
