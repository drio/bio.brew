
local version="1.60"
# Can anyone tell me how to programmatically download tarballs from sourceforge ?
local URL="http://downloads.sourceforge.net/project/picard/picard-tools/${version}/picard-tools-${version}.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpicard%2Ffiles%2Fpicard-tools%2F${version}%2Fpicard-tools-${version}.zip%2Fdownload&ts=1320169333&use_mirror=cdnetworks-us-2"
local tb_file=`basename $URL`
local seed_name="picard"
local unzip_dir="picard-tools-${version}"
local deps=(java)

do_install()
{
  before_install $seed_name
  cd $LOCAL_DIR
  log "Downloading: ${URL}"
  curl -sL $URL > ${unzip_dir}.zip
  log "Unzipping: ${unzip_dir}.zip"
  unzip ${unzip_dir}.zip &> $LOG_DIR/${seed_name}.unzip.log.txt
  rm -f *.zip
  mv $unzip_dir $seed_name
  for_env "export PICARD='$LOCAL_DIR/picard'"
  after_install $recipe
}

do_remove()
{
  before_remove $seed_name
  rm -rf $LOCAL_DIR/$seed_name
  after_remove $seed_name
}

source "$MAIN_DIR/lib/case.sh"
