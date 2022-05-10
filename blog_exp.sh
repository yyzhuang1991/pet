outdir=./affevents/blog
indir=/uusoc/exports/scratch/yyzhuang/affevent-lm-aug/new-aug/blog/10fold/scoremode_agree/freq3
unlabeledEvent=/uusoc/res/nlp/nlp/yuan/affevent-lm/twitter/new_data_aug/self-train/data/blog/transformed_events.list
for fold in {0..9}
do
    curIndir="$indir"/fold"$fold"/maxevent-1_conf1_gen1_userlogf0/gen0.90.90.9_conf0.90.90.9/cyc1
    curOutdir="$outdir"/fold"$fold"
    mkdir -p $curOutdir
    echo $curIndir
    python generate_data.py $curIndir $curOutdir $unlabeledEvent
done  


for fold in {0..4}
do 
data_dir=./affevents/blog/fold"$fold"
outdir=out/blog/fold"$fold"
python3 cli.py \
--method pet \
--pet_num_train_epochs 3 \
--sc_num_train_epochs 5 \
--pattern_ids 0 1 2 \
--data_dir $data_dir \
--model_type bert \
--model_name_or_path bert-base-uncased \
--task_name affevent \
--output_dir $outdir \
--do_eval \
--do_train  \
--eval_set test 
done
