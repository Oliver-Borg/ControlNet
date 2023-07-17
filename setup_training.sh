#!/bin/bash
#SBATCH --job-name=ControlNetSetup
#SBATCH --account=compsci
#SBATCH --partition=ada
#SBATCH --nodes=1
#SBATCH --ntasks=4  # Number of cores to allocate
#SBATCH --cpus-per-task=1  # Number of threads per core
#SBATCH --time=02:00:00  # Time limit (HH:MM:SS)
#SBATCH --output=slurm/control.out  # Output file
#SBATCH --error=slurm/control.out  # Error file
#SBATCH --mail-type=END,FAIL  # Email you when the job finishes or fails
#SBATCH --mail-user=BRGOLI005@myuct.ac.za # Email address to send to

# Run from the root directory

module load python/miniconda3-py310
conda env create -f environment.yaml
source activate control
mkdir training
cd training
wget https://huggingface.co/lllyasviel/ControlNet/resolve/main/training/fill50k.zip &
cd ../models
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.ckpt &

wait

cd training
unzip fill50k.zip
cd ..

python tool_add_control.py ./models/v1-5-pruned.ckpt ./models/control_sd15_ini.ckpt

conda deactivate