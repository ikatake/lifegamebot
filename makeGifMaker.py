import sys
#import common

### ここから本体 ###
#ループ情報を読み取るファイル
file_name:str = sys.argv[1]
step:int = 0
gene:int = 0
loop_from:int = 0
#print('[DBGmakeGifMaker.py]' + file_name)

#ループが確定したgeneration・step・ループ元stepを読み取る。
with open(file_name, mode='r') as f:
    s:str = ''
    for s in f:
        #print('[DBGmakeGifMaker.py]' + s ,end='')
        if(s.split('\t')[0] == 'gene'):
            gene = int(s.split('\t')[1])
        elif(s.split('\t')[0] == 'step'):
            step = int(s.split('\t')[1])
        elif(s.split('\t')[0] == 'loop_from'):
            loop_from = int(s.split('\t')[1])

in_arg_pngs:str = './pngs/' + '{:08}/*.png'.format(gene)
out_arg_gif:str = '/home/ikatake/www/wetsteam/lifegamebot/gifs/'
out_arg_gif += '{:08}.gif'.format(gene)
#gene_folder = common.state_log_dir+ '{:08}/'.format(gene)
print('#!/bin/sh')
print('/usr/local/bin/convert -delay 10 ' + in_arg_pngs + ' ' + out_arg_gif)
