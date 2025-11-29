# Setup of SplatSuRe environment for training and basic metrics evaluation

git clone git@github.com:pranav-asthana/SplatSuRe.git --recursive
cd SplatSuRe
conda create -y --name splatsure python=3.11
conda activate splatsure
pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cu118
pip install --no-build-isolation submodules/*
pip install -r requirements.txt