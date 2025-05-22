# ordenacao.py
import random

def insertion_sort(arr, inicio, fim):
    for i in range(inicio + 1, fim + 1):
        chave = arr[i]
        j = i - 1
        while j >= inicio and arr[j] > chave:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = chave

def particiona(arr, inicio, fim):
    pivo = arr[fim]
    i = inicio - 1
    for j in range(inicio, fim):
        if arr[j] <= pivo:
            i += 1
            arr[i], arr[j] = arr[j], arr[i]
    arr[i + 1], arr[fim] = arr[fim], arr[i + 1]
    return i + 1

# Ordenação por Força Bruta (Bubble Sort)
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
    return arr

def quicksort_hibrido(arr, inicio, fim, limiar=20):
    if inicio < fim:
        if (fim - inicio + 1) <= limiar:
            insertion_sort(arr, inicio, fim)
        else:
            pivo = particiona(arr, inicio, fim)
            quicksort_hibrido(arr, inicio, pivo - 1, limiar)
            quicksort_hibrido(arr, pivo + 1, fim, limiar)

def ordenar_hibrido(arr, limiar=20):
    quicksort_hibrido(arr, 0, len(arr) - 1, limiar)
    return arr
