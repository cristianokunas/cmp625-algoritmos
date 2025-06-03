#!/bin/bash
#SBATCH --job-name=cmp625
#SBATCH --nodes=1
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --time=24:00:00

cp -r ~/cmp625-algoritmos $SCRATCH

cd $SCRATCH/cmp625-algoritmos

REPS=10
TAMANHOS=(1000 2000 5000 10000 50000 100000 500000 1000000)

#configuração dos resultados, execução número, tipo ordenação, tamanho do vetor, tempo, máquina
echo "app, exec, type, size, time, machine"

for rep in $(seq 1 $REPS); do
    for tam in "${TAMANHOS[@]}"; do
        echo "Executando repetição $rep com tamanho $tam"
        output=$(python3 experimentos.py $tam $rep | grep cmp625)
        echo "$output"
        echo "$output" >> results.csv
    done
done
