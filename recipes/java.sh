
# This recipe is special, please read: https://jdk-distros.dev.java.net/developer.html
local URL="http://download.oracle.com/otn-pub/java/jdk/6u25-b06/jdk-6u25-linux-x64.bin"
#local URL="http://download.java.net/dlj/binaries/jdk-6u24-dlj-linux-i586.bin"
local construct='https://jdk-distros.dev.java.net/source/browse/*checkout*/jdk-distros/trunk/utils/construct.sh?content-type=text%2Fplain'
local tb_file=`basename $URL`
local seed_name="java"
local install_files=(bin/java bin/javac bin/jar)

do_install()
{
  before_install $seed_name
  # pwd: tarball
  cd $TB_DIR
  download $URL $tb_file
  mkdir $recipe
  mv $tb_file $recipe
  # pwd: tarball/java
  cd $recipe
  log "Untaring jdk"
  echo | sh $tb_file &> $LOG_DIR/$recipe.unpack.txt
  cd ..
  # pwd: tarball
  log "Moving to local"
  mv java/jdk1* ../local/java
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
