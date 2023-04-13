#!/bin/sh
cd $(cd $(dirname $0);pwd) 
perl ./lg.pl ./state.txt > ./state.new
python3 isLoop.py ./state.txt ./state.new > ./loop.txt
if [ -s ./loop.txt ]; then #loop.txtに内容があれば(初期化する)、状況をつぶやく
  #echo "[DBGtest.sh] INITIALIZE Route. loop.txt:" 
  #cat  ./loop.txt
  python3 ./makeGifMaker.py ./loop.txt > ./makeGif.sh
  sh ./makeGif.sh
  python3 ./announce.py ./loop.txt > ./tweet.txt
  python3 ./makeLogDirNextGene.py ./loop.txt
  echo "init" > ./state.new
else #loop.txtが空であれば、状態をつぶやく
  #echo "[DBGtest.sh] NORMAL Route"
  perl ./makeSVG.pl ./state.new > ./state.svg
  perl ./makePNG.pl ./state.new
  perl ./saveLog.pl ./state.new ./state.svg
  perl ./trans.pl ./state.new ./trans.conf.pl > ./tweet.txt
fi
python3 ./tweet.py ./tweet.txt
mv  ./state.new ./state.txt

