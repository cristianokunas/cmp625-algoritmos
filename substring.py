# substring.py

def maior_substring_repetida_bruta(texto):
    n = len(texto)
    maior = ""
    for i in range(n):
        for j in range(i + 1, n):
            tamanho = 0
            while (j + tamanho < n) and (texto[i + tamanho] == texto[j + tamanho]):
                tamanho += 1
                if tamanho > len(maior):
                    maior = texto[i:i + tamanho]
    return maior

def construir_suffix_array(texto):
    return sorted(range(len(texto)), key=lambda i: texto[i:])

def maior_substring_repetida_suffix_array(texto):
    suffix_array = construir_suffix_array(texto)
    maior_substring = ""
    for i in range(len(suffix_array) - 1):
        s1 = texto[suffix_array[i]:]
        s2 = texto[suffix_array[i + 1]:]
        tamanho = 0
        while tamanho < len(s1) and tamanho < len(s2) and s1[tamanho] == s2[tamanho]:
            tamanho += 1
        if tamanho > len(maior_substring):
            maior_substring = s1[:tamanho]
    return maior_substring
