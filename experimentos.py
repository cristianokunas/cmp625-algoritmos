# experimentos.py
import random
import timeit
import sys
import socket
from ordenacao import ordenar_hibrido, insertion_sort

def experimento_ordenacao(tamanho, repeticao):
    hostname = socket.gethostname()
    vetor = [random.randint(0, 1_000_000) for _ in range(tamanho)]
    
    tempo_bruto = timeit.timeit(lambda: insertion_sort(vetor.copy(), 0, tamanho-1), number=1)
    print(f"cmp625, {repeticao}, BruteForce, {tamanho}, {tempo_bruto:.4f}, {hostname}")
    
    for limiar in [5, 10, 20, 30, 50, 100, 500, 1000, 5000]:
        tempo_hibrido = timeit.timeit(lambda: ordenar_hibrido(vetor.copy(), limiar), number=1)
        print(f"cmp625, {repeticao}, Hybrid_{limiar}, {tamanho}, {tempo_hibrido:.4f}, {hostname}")
    
    tempo_sorted = timeit.timeit(lambda: sorted(vetor.copy()), number=1)
    print(f"cmp625, {repeticao}, NativeSorted, {tamanho}, {tempo_sorted:.4f}, {hostname}")

if __name__ == "__main__":
    tam = int(sys.argv[1])
    rep = int(sys.argv[2])
    print("\n--- Experimentos com Ordenação  ---")
    experimento_ordenacao(tam, rep)