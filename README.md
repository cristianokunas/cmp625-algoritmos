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
├── ordenacao.py               # Algoritmo híbrido de ordenação (QuickSort + InsertionSort)
├── experimentos.py            # Script para executar testes automáticos e salvar resultados em CSV
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
python3 experimentos.py $tamanho $repetições
```

4. Após a execução:
   - `resultados_node.csv` conterá os tempos de ordenação para vetores usando **QuickSort/InsertionSort** comparado com o `sorted()` do Python para cada node.

---

## 📈 Análise de Resultados

//TODO

---

## 📚 Complexidade dos Algoritmos

| Algoritmo                         | Complexidade  | Observações |
|:-----------------------------------|:--------------|:------------|
| Força bruta com InsertionSort      | O(checar)     | Eficiente para grandes pequenas |
| QuickSort/InsertionSort Híbrido    | O(n log n)    | Combina melhor tempo médio de QuickSort e eficiência de InsertionSort para pequenos subvetores |

---
