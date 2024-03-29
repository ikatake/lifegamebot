import sys
import common

### ここから本体 ###
#ループ情報を読み取るファイル
file_name:str = sys.argv[1]
step:int = 0
gene:int = 0
loop_from:int = 0
#print('[DBGmakeGifMaker.py]' + file_name)

#ループが確定したgeneration・step・ループ元stepを読み取る。
gene, step, loop_from = common.readLoopFile(file_name)

in_arg_pngs:str = './pngs/' + '{:08}/*.png'.format(gene)
out_arg_gif:str = '/home/ikatake/www/wetsteam/lifegamebot/gifs/'
out_arg_gif += '{:08}.gif'.format(gene)
#gene_folder = common.state_log_dir+ '{:08}/'.format(gene)
print('#!/bin/sh')
print('/usr/local/bin/convert -delay 10 ' + in_arg_pngs + ' ' + out_arg_gif)
