import glob, json, re, sys
from sklearn.metrics import precision_recall_fscore_support as score
from os.path import join 
indirPrefix = sys.argv[1]
fold2pid2iter2score = {} #ensemble score
for fold in range(10):
	foldIndir=join(indirPrefix, f"fold{fold}")
	pid_iters = glob.glob(f"{foldIndir}/final/p*-i*")
	for pid_iter in pid_iters:
		pid, itera = re.findall(rf"p(\d+)-i(\d+)", pid_iter)[0]

		if fold not in fold2pid2iter2score:
			fold2pid2iter2score[fold] = {}
		if pid not in fold2pid2iter2score[fold]:
			fold2pid2iter2score[fold][pid] = {}

		preds = [json.loads(line) for line in open(join(pid_iter,"my_predictions.jsonl")).readlines()]
		precision, recall, f1, _ = score([int(p['label']) for p in preds], [int(p['pred_label']) for p in preds], average='macro')
		fold2pid2iter2score[fold][pid][itera] = (precision, recall, f1)
print(fold2pid2iter2score)


