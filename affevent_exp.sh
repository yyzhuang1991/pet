next:
    figure out num_k

# generate data 
outdir=./affevents/twitter
indir=/uusoc/exports/scratch/yyzhuang/affevent-lm-aug/new-aug/twitter/10fold/scoremode_agree/use_rlogf0/freq3
for fold in {0..9}
do
    curIndir="$indir"/fold"$fold"/conf1_gen1/gen0.850.850.85_conf0.850.850.85/cyc1
    curOutdir="$outdir"/fold"$fold"
    mkdir -p $curOutdir

    echo $curIndir
    python generate_data.py $curIndir $curOutdir
done  
done 


num_k=5
epoch=5
num_sample=0
data_dir=affevents/twitter
for fold in 0
do
    cur_data_dir="$data_dir"/fold"$fold"
    output_dir="$cur_data_dir"/out
    $cur_data_dir
python run.py \
    --task_name SST-2 \
    --data_dir $cur_data_dir \
    --overwrite_output_dir \
    --do_train \
    --do_eval \
    --do_predict \
    --evaluate_during_training \
    --model_name_or_path bert-base-uncased \
    --few_shot_type prompt \
    --num_k $num_k \
    --max_steps 1000 \
    --eval_steps 100 \
    --per_device_train_batch_size 2 \
    --learning_rate 1e-5 \
    --num_train_epochs $epoch \
    --output_dir $output_dir \
    --seed 100 \
    --template "*cls**sent_0*_It_was*mask*.*sep+*" \
    --mapping "{'0':'great', '1':'terrible','2':'okay'}" \
    --num_sample $num_sample
done