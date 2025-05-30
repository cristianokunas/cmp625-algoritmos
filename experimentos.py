# experimentos.py
import random
import string
import timeit
import csv
import sys
from substring import maior_substring_repetida_bruta, maior_substring_repetida_suffix_array
from ordenacao import ordenar_hibrido, insertion_sort

def gerar_texto(tamanho):
    return ''.join(random.choices(string.ascii_uppercase, k=tamanho))

def experimento_substring(tamanho):
    texto = gerar_texto(tamanho)
    if tamanho <= 2000:
        tempo_bruta = timeit.timeit(lambda: maior_substring_repetida_bruta(texto), number=1)
        print(f"Força Bruta ({tamanho} chars): {tempo_bruta:.4f}s")
    else:
        print(f"Força Bruta pulado para {tamanho} caracteres devido ao tempo alto")
    tempo_suffix = timeit.timeit(lambda: maior_substring_repetida_suffix_array(texto), number=1)
    print(f"Suffix Array ({tamanho} chars): {tempo_suffix:.4f}s")

def experimento_ordenacao(tamanho):

    vetor = [random.randint(0, 1_000_000) for _ in range(tamanho)]
    tempo_bruto = timeit.timeit(lambda: insertion_sort(vetor.copy(), 0, tamanho-1), number=1)
    tempo_hibrido = timeit.timeit(lambda: ordenar_hibrido(vetor.copy()), number=1)
    tempo_sorted = timeit.timeit(lambda: sorted(vetor.copy()), number=1)
    print(f"Força Bruta ({tamanho} elementos): {tempo_bruto:.4f}s")
    print(f"QuickSort/InsertionSort ({tamanho} elementos): {tempo_hibrido:.4f}s")
    print(f"Sorted nativo Python ({tamanho} elementos): {tempo_sorted:.4f}s")

    resultados.append({'Tipo': 'InsertionSort', 'Tamanho': tamanho, 'Tempo': tempo_bruto})
    resultados.append({'Tipo': 'QuickSort/Insertion', 'Tamanho': tamanho, 'Tempo': tempo_hibrido})
    resultados.append({'Tipo': 'Sorted Nativo', 'Tamanho': tamanho, 'Tempo': tempo_sorted})

resultados = []

if __name__ == "__main__":
#     print("\n--- Experimentos com Substrings Repetidas (Suffix Array) ---")
#     for tam in [10, 100, 1000, 2000, 5000, 10000, 50000, 100000, 500000, 1000000]:
#         experimento_substring(tam)
    iter = int(sys.argv[1])
    print("\n--- Experimentos com Ordenação Combinada ---")
    for i in range(iter):
        for tam in [1000, 2000, 5000, 10000, 50000]:
        # for tam in [1000, 2000, 5000, 10000, 50000, 100000, 500000, 1000000, 5000000, 10000000]:
            experimento_ordenacao(tam)

    with open("resultados_ordenacao.csv", mode="w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["Tipo", "Tamanho", "Tempo"])
        writer.writeheader()
        writer.writerows(resultados)