#!/bin/bash
#

start=`date`
bb_dir=`../bin/bb | grep MAIN | awk '{print $2}'`
bb=$bb_dir/bin/bb
cd $bb_dir
#rm -rf *
#curl -LsSf http://github.com/drio/bio.brew/tarball/master | tar xvz -C. --strip 1 

for i in java bfast ant picard libevent
do
  $bb -j8 install $i
done

$bb install svn

for i in samtools bwa cdargs dnaa gatk git perl r ruby tmux vim #srma
do
  $bb -j8 install $i
done

finish=`date`

echo " "
echo "start: $start"
echo "end  : $finish"
echo "size : `du -hs .`"
echo "# recipes installed : $($bb list | grep "^I" | wc -l)"
echo "# recipes           : $(ls recipes/*.sh | wc -l)"

