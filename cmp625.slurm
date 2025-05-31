#!/bin/bash
#SBATCH --job-name=cmp625
#SBATCH --partition=cei
#SBATCH --nodes=1
#SBATCH --time=02:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

python3 experimentos.py 5