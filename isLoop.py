import sys
import common

### ここから本体 ###
#遷移前後の状態のファイル名をコマンドライン引数から読み取る。
file_name:str = sys.argv[1]
next_file_name:str = sys.argv[2]
#遷移後の状態・generation・stepを読み取る
next_states, gene, next_step = common.readStateFile(next_file_name)
if(next_step == 1): #遷移後がステップ1つまり初期化直後の場合は比較対象がないので、
    print("", end='') #ループしていない無を出力する。
    sys.exit() #そして終わる。

#遷移前後の状態・generation・stepを読み取る
states, gene, step = common.readStateFile(file_name)

#(1)完全に固まっている状態かを判定する。
#ここで、完全に固まっている状態=>今の状態と次の状態が等しいとする。
#完全に固まっている状態は一目瞭然なので、次の状態を見せずに次geneに移す。
if(next_states == states):
    print( 'gene\t' + str(gene))       #その数字を出力
    print( 'step\t' + str(step))       #その数字を出力
    print( 'loop_from\t' + str(step))  #その数字を出力
    #ここで、step = loop_fromとすることで、frozenであることがわかる。
    sys.exit() #frozenであれば、(2)は調べなくて良いので終わる。

#(2)過去の状態と比較してループしているかをチェックする。
#比較対象は現在(30分前にtweetした)状態を基準とする。
gene_folder = common.state_log_dir+ '{:08}/'.format(gene)#読み取るフォルダ
past_step:int = step - 1
#最近のファイルから読み取っていく。
while(past_step >= 0):
    past_file_path:str = gene_folder + '{:08}.txt'.format(past_step)
    #昔のファイルの状態・generation・stepを読み取る
    past_states, g, s = common.readStateFile(past_file_path)
    #状態が同じか確認する
    if(states == past_states):#状態が同じであれば、
        print( 'gene\t' + str(gene))            #その数字を出力
        print( 'step\t' + str(step))            #その数字を出力
        print( 'loop_from\t' + str(past_step))  #その数字を出力
        sys.exit() #そのstepで終わり。
    past_step -= 1 #同じ状態の昔のstepが無ければ-1を返す。

print("", end='') #状態が同じ昔のstepが無ければ、無を出力する。

