import glob, json, re, sys, numpy as np 
from sklearn.metrics import precision_recall_fscore_support as score
from os.path import join 
indirPrefix = sys.argv[1]
fold2score = {} #ensemble score
for fold in range(10):
	foldIndir=join(indirPrefix, f"fold{fold}")
	pid_iter = glob.glob(f"{foldIndir}/final/p*-i*")[0]

	if fold not in fold2score:
		fold2score[fold] = {}
	preds = [json.loads(line) for line in open(join(pid_iter,"my_predictions.jsonl")).readlines()]
	precision, recall, f1, _ = score([int(p['label']) for p in preds], [int(p['pred_label']) for p in preds], average='macro')
	fold2score[fold]['avg'] = (precision, recall, f1)
	(posp, negp, neup), (posr, negr, neur), (posf, negf, neuf), _ = score([int(p['label']) for p in preds], [int(p['pred_label']) for p in preds], average=None)
	fold2score[fold]['breakdown'] = (posp, negp, neup), (posr, negr, neur), (posf, negf, neuf)
avgscores = [fold2score[fold]['avg'] for fold in range(10)]
posscores = [ [fold2score[fold]['breakdown'][i][0] for i in range(3)]  for fold in range(10)] 
negscores = [ [fold2score[fold]['breakdown'][i][1] for i in range(3)]  for fold in range(10)]
neuscores = [ [fold2score[fold]['breakdown'][i][2] for i in range(3)]  for fold in range(10)]

print("--AVG PRE, REC, F1")
print(np.mean(avgscores, 0))
print("--POS PRE, REC, F1")
print(np.mean(posscores, 0))

print("--NEG PRE, REC, F1")
print(np.mean(negscores, 0))


print("--NEU PRE, REC, F1")
print(np.mean(neuscores, 0))



