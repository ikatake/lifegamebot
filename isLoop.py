import sys
import common

### ここから本体 ###
#遷移後の状態のファイル名をコマンドライン引数から読み取る。
next_file_name:str = sys.argv[1]
#遷移後の状態・generation・stepを読み取る
next_states, gene, step = common.readStateFile(next_file_name)
    
#読み取るフォルダ
gene_folder = common.state_log_dir+ '{:08}/'.format(gene)
past_step:int = step - 1
#最近のファイルから読み取っていく。
while(past_step >= 0):
    past_file_path:str = gene_folder + '{:08}.txt'.format(past_step)
    #昔のファイルの状態・generation・stepを読み取る
    past_states, g, s = common.readStateFile(past_file_path)
    #状態が同じか確認する
    if(next_states == past_states):#状態が同じであれば、
        print( 'gene\t' + str(gene))            #その数字を出力
        print( 'step\t' + str(step))            #その数字を出力
        print( 'loop_from\t' + str(past_step))  #その数字を出力
        sys.exit() #そのstepで終わり。
    past_step -= 1 #同じ状態の昔のstepが無ければ-1を返す。

print("", end='') #状態が同じ昔のstepが無ければ、無を出力する。

