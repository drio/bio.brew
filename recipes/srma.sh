
local version="0.1.13"
local URL="git://srma.git.sourceforge.net/gitroot/srma/srma"
local tb_file=`basename $URL`
local seed_name="srma"
local deps=("samtools" "ant" "picard" "java")
local install_files=(c-code/srma java/build/jar/srma-${version}.jar)

do_install()
{
  check_deps ${deps[@]}
  before_install $seed_name
  cd $LOCAL_DIR
  log "cloning project"
  git clone $URL $seed_name &> $LOG_DIR/${seed_name}.git_clone.log.txt
  cd $seed_name
  log "Building c version"
  cd c-code
  ln -s ./../../../local/samtools
  log "autogen"
  sh ./autogen.sh &> $LOG_DIR/${seed_name}.autogen.log.txt
  configure_tool $seed_name 
  make_tool $seed_name $make_j

  log "Building jar"
  cd ../java
  mkdir lib; cd lib
  ln -s ../../../../local/picard/sam*.jar
  ln -s ../../../../local/picard/picard*.jar
  cd ..
  ant jar &> $LOG_DIR/${seed_name}.jar.log.txt

  cd $LOCAL_DIR/$seed_name
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
