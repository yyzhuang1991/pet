import json, sys 
from os.path import join 

indir, outdir, unlabeledFile = sys.argv[1], sys.argv[2], sys.argv[3]
if unlabeledFile.endswith('.json'):
	event2sentis = json.load(open(unlabeledFile))
	unlabeledEvents = sorted(event2sentis.keys())
with open(join(outdir, "unlabeled.csv"), 'w') as f:
	f.write("\n".join(unlabeledEvents))

labelMap = {'pos':0, 'neg':1, 'neu':2}

for name in ['train', 'dev', 'test']:
	event2info = json.load(open(join(indir, name, 'event2info.json')))
	gold_events = sorted([e for e in event2info if event2info[e].get("is_labeled", 0)])
	gold_labels = [ event2info[e]['label'] for e in gold_events]
	toWrite = [f"{e}\t{labelMap[l]}" for e, l in zip(gold_events, gold_labels)]
	with open(join(outdir, f"{name}.csv"), 'w') as f:
		f.write("\n".join(toWrite))
	print(f"Saving to {join(outdir, f'{name}.csv')}")


