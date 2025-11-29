#!/bin/bash

set -e

scene='Train'
upscale=4
ratio_threshold=1.1
weight_maps_dirname=weight_maps
output_dir=outputs_${upscale}x
sr_images_dir=images_SR

if [[ $scene = @(Auditorium|Ignatius|Palace|Ballroom|Courthouse|Panther|Barn|Lighthouse|Playground|Courtroom|M60|Temple|Caterpillar|Family|Meetingroom|Train|Francis|Truck|Church|Horse|Museum) ]]; then
  data_dir=data/tandt/${scene}
  r=8
fi
if [[ $scene = @(bicycle|bonsai|counter|flowers|garden|kitchen|room|stump|treehill) ]]; then
  data_dir=data/mipnerf_data/${scene}
  r=8
fi
if [[ $scene = @(drjohnson|playroom) ]]; then
  data_dir=data/deep_blending/${scene}/colmap
  r=4
fi

# Train LR model
python train_lr.py -s ${data_dir} -m ${output_dir}/lr/${scene} -r ${r} --eval

# Get weight maps
python weight_maps.py -s ${data_dir} -m ${output_dir}/lr/${scene} -r ${r} --eval --weight_maps_dirname ${weight_maps_dirname} --ratio_threshold ${ratio_threshold}

# Train SR model
python train.py -s ${data_dir} -m ${output_dir}/${scene} -r 1 --eval --images ${sr_images_dir} --img_ext png --upscale ${upscale} --weight_maps_path ${output_dir}/lr/${scene}/${weight_maps_dirname}

python render.py --model_path ${output_dir}/${scene} --skip_train --images images -r ${r} --img_ext jpg --upscale ${upscale}

# Metrics
python metrics.py -m ${output_dir}/${scene}