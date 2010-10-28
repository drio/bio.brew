#!/bin/bash
#

start=`date`
cd /tmp/tmp
rm -rf * 
curl -LsSf http://github.com/drio/bio.brew/tarball/master | tar xvz -C. --strip 1 

for i in java samtools bfast ant picard libevent svn
do
  bb -j8 install $i
done

for i in bwa cdargs dnaa gatk git perl r ruby srma tmux vim
do
  bb -j8 install $i
done

finish=`date`

echo " "
echo "start: $start"
echo "end  : $finish"
echo "size : `du -hs .`"
echo "# recipes installed : bb list | grep "^I" | wc -l"
echo "# recipes           : ls recipes/*.sh | wc -l"

