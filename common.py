
def readStateFile(file_path:str)->tuple:
    with open(file_path, mode='r') as f:
        states:str = ''
        n_line:int = 0
        s:str = ''
        for s in f:
            if(n_line < 10):
                states += s.rstrip('\r\n')
            elif(s.split('\t')[0] == 'gene'):
                gene:int = int(s.split('\t')[1])
            elif(s.split('\t')[0] == 'step'):
                step:int = int(s.split('\t')[1])
            n_line += 1
    #print('states' + states + '\ngene' + str(gene) + '\nstep' +str(step))
    return states, gene, step

state_log_dir:str = "/home/ikatake/www/wetsteam/lifegamebot/stateLogs/"