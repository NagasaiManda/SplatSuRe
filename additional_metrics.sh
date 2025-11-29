#!/bin/bash

set -e

scene='Train'
output_dir=outputs_${upscale}x

# Additional metrics
python cmmd-pytorch/main.py ${output_dir}/${scene}/test/ours_30000/renders ${output_dir}/${scene}/test/ours_30000/gt > ${output_dir}/${scene}/cmmd.txt
python eval_dreamsim.py -m ${output_dir}/${scene} > ${output_dir}/${scene}/dreamsim.txt
pyiqa niqe musiq -t ${output_dir}/${scene}/test/ours_30000/renders > ${output_dir}/${scene}/niqe_musiq.txt
