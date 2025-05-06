# 📦 Projeto de Algoritmos: Substrings Repetidas e Ordenação Combinada

Este projeto implementa e analisa algoritmos fundamentais para:
- **Identificação de substrings repetidas** em textos (usando métodos de força bruta e Suffix Array).
- **Ordenação híbrida** de vetores, combinando QuickSort com InsertionSort.

Os resultados dos experimentos são salvos em arquivos CSV, prontos para análise ou visualização gráfica.

---

## 📂 Estrutura do Projeto

```
projeto-algoritmos/
│
├── substring.py              # Algoritmos de substrings repetidas (força bruta e suffix array)
├── ordenacao.py               # Algoritmo híbrido de ordenação (QuickSort + InsertionSort)
├── experimentos.py            # Script para executar testes automáticos e salvar resultados em CSV
├── resultados_substrings.csv  # Resultados de identificação de substrings (gerado ao rodar)
└──  resultados_ordenacao.csv   # Resultados de ordenação (gerado ao rodar)
```

---

## ⚙️ Requisitos

- Python 3.8 ou superior
- Sem bibliotecas externas obrigatórias

> Opcionalmente, para análises gráficas futuras, você pode instalar:
> 
> ```bash
> pip install pandas matplotlib
> ```

---

## 🚀 Como Executar

1. Clone o projeto ou copie os arquivos para uma pasta local.

2. No terminal, acesse a pasta:

```bash
cd projeto-algoritmos
```

3. Para rodar todos os experimentos e gerar os arquivos CSV:

```bash
python3 experimentos.py
```

4. Após a execução:
   - `resultados_substrings.csv` conterá os tempos para diferentes tamanhos de texto usando **Suffix Array**.
   - `resultados_ordenacao.csv` conterá os tempos de ordenação para vetores usando **QuickSort/InsertionSort** comparado com o `sorted()` do Python.

---

## 📜 Executar Algoritmos Manualmente

Você também pode usar os algoritmos individualmente:

### 1. Força Bruta - Substrings Repetidas
```python
from substring import maior_substring_repetida_bruta

texto = "ABCDEFABCXYZABC"
print(maior_substring_repetida_bruta(texto))
```
> ⚠️ Força bruta é recomendada apenas para textos com até 2000 caracteres.

---

### 2. Suffix Array - Substrings Repetidas (mais eficiente)
```python
from substring import maior_substring_repetida_suffix_array

texto = "ABCDEFABCXYZABC"
print(maior_substring_repetida_suffix_array(texto))
```

---

### 3. Ordenação Híbrida (QuickSort + InsertionSort)
```python
from ordenacao import ordenar_hibrido
import random

vetor = [random.randint(0, 1000) for _ in range(20)]
print(ordenar_hibrido(vetor.copy()))
```

---

## 📈 Análise de Resultados

//TODO

---

## 📚 Complexidade dos Algoritmos

| Algoritmo                         | Complexidade  | Observações |
|:-----------------------------------|:--------------|:------------|
| Força Bruta Substring              | O(n³)         | Somente para textos pequenos |
| Suffix Array Substring             | O(n log n)    | Eficiente para grandes entradas |
| QuickSort/InsertionSort Híbrido    | O(n log n)    | Combina melhor tempo médio de QuickSort e eficiência de InsertionSort para pequenos subvetores |

---

## 🛠️ Melhorias Futuras

- Automatizar geração de gráficos diretamente após os testes.

---
