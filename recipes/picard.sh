
local version="1.33"
local URL="http://sourceforge.net/projects/picard/files/picard-tools/${version}/picard-tools-${version}.zip/download"
local tb_file=`basename $URL`
local seed_name="picard"
local unzip_dir="picard-tools-${version}"
local deps=(java)

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
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  rm -rf $LOCAL_DIR/$seed_name
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
