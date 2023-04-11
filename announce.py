import sys
import common

file_name:str = sys.argv[1]
step:int = 0
gene:int = 0
loop_from:int = 0

#ループが確定したgeneration・step・ループ元stepを読み取る。
gene, step, loop_from = common.readLoopFile(file_name)
print ('LifeGameBot generation:{} is gone.'.format(gene, step))
print ('Loop between step:{} and step:{}.'.format(loop_from, step))
print ('Gif: http://www.wetsteam.org/lifegamebot/gifs\{:08}\.gif'.format(gene))

