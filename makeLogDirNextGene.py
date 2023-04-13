import sys
import common
import os

file_name:str = sys.argv[1]
step:int = 0
gene:int = 0
loop_from:int = 0

#ループが確定したgeneration・step・ループ元stepを読み取る。
gene, step, loop_from = common.readLoopFile(file_name)

dir = './stateLogs/{:08}'.format(gene+1)
try:
    os.makedirs(dir, exist_ok=True)
except FileExistsError:
    pass

dir = common.state_log_dir + '{:08}'.format(gene+1)
try:
    os.makedirs(dir, exist_ok=True)
except FileExistsError:
    pass
