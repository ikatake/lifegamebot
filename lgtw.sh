#!/bin/sh
cd $(cd $(dirname $0);pwd) 
perl ./lg.pl ./state.txt > ./state.new
perl ./checkMention.pl > initMention.txt
perl ./checkFrozen.pl ./state.txt ./state.new > ./initFrozen.txt
perl ./decideInit.pl  ./state.new ./initMention.txt ./initFrozen.txt > ./status.txt
#decideInit.plでstate.txtとstatus.txtに書き込む。
if [ -s ./status.txt ]; then #status.txtに内容があれば(初期化)、状況をつぶやく
  perl ./makeGifMaker.pl ./status.txt > ./makeGif.sh
  sh ./makeGif.sh
  perl ./announce.pl ./status.txt > ./tweet.txt
  perl ./makeLogDirNextGene.pl ./status.txt
  cp -p initMention.txt initMention`date '+%s'`.txt
  cp -p status.txt status`date '+%s'`.txt
else #status.txtが空であれば、状態をつぶやく
  perl ./makeSVG.pl ./state.new > ./state.svg
  perl ./saveLog.pl ./state.new ./state.svg
  perl ./trans.pl ./state.new trans.conf.pl > ./tweet.txt
fi
mv  ./state.new ./state.txt
perl ./tweet.pl ./tweet.txt
