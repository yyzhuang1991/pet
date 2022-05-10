next:
    figure out num_k

# generate data 
outdir=./affevents/twitter
indir=/uusoc/exports/scratch/yyzhuang/affevent-lm-aug/new-aug/twitter/10fold/scoremode_agree/use_rlogf0/freq3
unlabeledEvent=/uusoc/res/nlp/nlp/yuan/affevent-lm/twitter/new_data_aug/dest/data/processed_event2sentis.json
for fold in {0..9}
do
    curIndir="$indir"/fold"$fold"/conf1_gen1/gen0.850.850.85_conf0.850.850.85/cyc1
    curOutdir="$outdir"/fold"$fold"
    mkdir -p $curOutdir

    echo $curIndir
    python generate_data.py $curIndir $curOutdir $unlabeledEvent
done  
done 

for fold in 0 
do 

data_dir=./affevents/twitter/fold"$fold"
outdir=out/twitter/fold"$fold"
python3 cli.py \
--method pet \
--pet_num_train_epochs 1 \
--pattern_ids 0 \
--data_dir $data_dir \
--model_type bert \
--model_name_or_path bert-base-uncased \
--task_name affevent \
--output_dir $outdir \
--do_eval \
--do_train  