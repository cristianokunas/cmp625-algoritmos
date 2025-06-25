# Pacotes necessários
if (!require("ggplot2")) install.packages("ggplot2", dependencies=TRUE)
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("scales")) install.packages("scales")
library(scales)
library(ggplot2)
library(dplyr)
library(tidyr)

# Lê o CSV
df <- read.csv("/home/kunas/Documents/gits/github/cmp625-algoritmos/plots/all_results.csv", stringsAsFactors = FALSE)

# Limpa espaços em branco
df$sortType <- trimws(df$sortType)

# Calcula média e desvio padrão
summary_df <- df %>%
  group_by(sortType, size, partition) %>%
  summarise(media = mean(time), desvio = sd(time), .groups = "drop")

# Identifica melhor Hybrid_* (menor tempo médio total)
best_hybrid <- summary_df %>%
  filter(grepl("^Hybrid_", sortType)) %>%
  group_by(sortType) %>%
  summarise(avg_time = mean(media)) %>%
  arrange(avg_time) %>%
  slice(1) %>%
  pull(sortType)

best_hybrid

# Conjuntos de dados
brute_df  <- summary_df %>% filter(sortType == "BruteForce")
hybrid_df <- summary_df %>% filter(sortType == best_hybrid)
nativo_df <- summary_df %>% filter(sortType == "NativeSorted")

# Tamanhos únicos
sizes <- sort(unique(df$size))

# Calcula os valores máximos antes de criar o data.frame teorico
brute_max <- brute_df %>% filter(size == max(sizes)) %>% summarise(m = mean(media)) %>% pull(m)
hybrid_max <- hybrid_df %>% filter(size == max(sizes)) %>% summarise(m = mean(media)) %>% pull(m)
native_max <- nativo_df %>% filter(size == max(sizes)) %>% summarise(m = mean(media)) %>% pull(m)
teorico <- data.frame(
  size = sizes,
  n2 = (sizes^2) * (brute_max / max(sizes^2)),
  nlogn_hybrid = (sizes * log2(sizes)) * (hybrid_max / max(sizes * log2(sizes))),
  nlogn_native = (sizes * log2(sizes)) * (native_max / max(sizes * log2(sizes)))
)

######################################################################### 
# Função para gerar gráfico
plot_curva <- function(df_empirico, tipo, teoria_df, teoria_col, label_teoria) {
  ggplot(df_empirico, aes(x = size, y = media, color = partition, fill = partition)) +
    geom_ribbon(aes(ymin = media - desvio, ymax = media + desvio), alpha = 0.15, color = NA) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    geom_line(data = teoria_df, aes(x = size, y = .data[[teoria_col]]),
              inherit.aes = FALSE, color = "black", linetype = "dashed", size = 1.2) +
    scale_x_continuous(
      # breaks = unique(df_empirico$size),
      labels = scales::comma_format(big.mark = ".", decimal.mark = ",")
    ) +
    scale_y_continuous(
      labels = comma_format(big.mark = ".", decimal.mark = ",")
    ) +
    labs(
      title = paste("Curva prática + teórica para", tipo),
      x = "Tamanho da entrada (n)",
      y = "Tempo médio (s)",
      color = "Partição", fill = "Partição"
    ) +
    annotate("text", x = min(df_empirico$size), y = max(df_empirico$media),
             label = paste("Curva teórica ~", label_teoria),
             hjust = 0, vjust = 1.5, color = "black", size = 4) +
    theme_minimal(base_size = 14)
}

# Geração dos gráficos
plot_curva(brute_df, "BruteForce", teorico, "n2", "n²")
plot_curva(hybrid_df, best_hybrid, teorico, "nlogn_hybrid", "n log n")
plot_curva(nativo_df, "NativeSorted", teorico, "nlogn_native", "n log n")

########################################################################################
# Une os dados e aplica curva teórica escalada a cada tipo
df_facet <- bind_rows(
  brute_df  %>% mutate(sortType = "BruteForce",   teoria = (size^2) * (brute_max / max(sizes^2)), label = "n²"),
  hybrid_df %>% mutate(sortType = best_hybrid,     teoria = (size * log2(size)) * (hybrid_max / max(sizes * log2(sizes))), label = "n log n"),
  nativo_df %>% mutate(sortType = "NativeSorted", teoria = (size * log2(size)) * (native_max / max(sizes * log2(sizes))), label = "n log n")
)
# Normaliza tempos práticos e teóricos entre 0 e 1 por algoritmo (sortType)
df_facet_norm <- df_facet %>%
  group_by(sortType) %>%
  mutate(
    media_norm = media / max(media),
    desvio_norm = desvio / max(media),
    teoria_norm = teoria / max(teoria)
  ) %>%
  ungroup()
# Define intervalos de tamanho
tamanhos_pequenos <- sizes[sizes <= 10000]
tamanhos_grandes  <- sizes[sizes >= 50000]

# Filtro por tamanho pequeno
df_facet_pequenos <- df_facet_norm %>%
  filter(size %in% tamanhos_pequenos)
df_facet_grandes <- df_facet_norm %>%
  filter(size %in% tamanhos_grandes)

# --- Gráfico com TAMANHOS PEQUENOS ---
g_pequenos <- ggplot(df_facet_pequenos, aes(x = size, y = media_norm, color = partition, fill = partition)) +
  geom_ribbon(aes(ymin = media_norm - desvio_norm, ymax = media_norm + desvio_norm), alpha = 0.15, color = NA) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_line(aes(y = teoria_norm), color = "black", linetype = "dashed", size = 1.1) +
  facet_wrap(~ sortType, scales = "free_y") +
  scale_x_log10(
    breaks = unique(df_facet_pequenos$size),
    labels = comma_format(big.mark = ".", decimal.mark = ",")
  ) +
  scale_y_continuous(
    labels = comma_format(big.mark = ".", decimal.mark = ",")
  ) +
  labs(
    title = "Curvas práticas com teoria (tamanhos pequenos)",
    x = "Tamanho da entrada (n)",
    y = "Tempo médio normalizado (0-1)",
    color = "Partição", fill = "Partição"
  ) +
  theme_minimal(base_size = 12)

# Salva em PNG
ggsave("curvas_teoricas_pequenos.png", g_pequenos, width = 12, height = 3, dpi = 300)

# --- Gráfico com TAMANHOS GRANDES ---
g_grandes <- ggplot(df_facet_grandes, aes(x = size, y = media_norm, color = partition, fill = partition)) +
  geom_ribbon(aes(ymin = media_norm - desvio_norm, ymax = media_norm + desvio_norm), alpha = 0.15, color = NA) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_line(aes(y = teoria_norm), color = "black", linetype = "dashed", size = 1.1) +
  facet_wrap(~ sortType, scales = "free_y") +
  scale_x_log10(
    breaks = unique(df_facet_grandes$size),
    labels = comma_format(big.mark = ".", decimal.mark = ",")
  ) +
  scale_y_continuous(
    labels = comma_format(big.mark = ".", decimal.mark = ",")
  ) +
  labs(
    title = "Curvas práticas com teoria (tamanhos grandes)",
    x = "Tamanho da entrada (n)",
    y = "Tempo médio normalizado (0-1)",
    color = "Partição", fill = "Partição"
  ) +
  theme_minimal(base_size = 12)

# Salva em PNG
ggsave("curvas_teoricas_grandes.png", g_grandes, width = 12, height = 3, dpi = 300)



ggplot(df_facet_norm, aes(x = size, y = media_norm, color = partition, fill = partition)) +
  geom_ribbon(aes(ymin = media_norm - desvio_norm, ymax = media_norm + desvio_norm), alpha = 0.15, color = NA) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  geom_line(aes(y = teoria_norm), color = "black", linetype = "dashed", size = 1.1) +
  facet_wrap(~ sortType, scales = "fixed") +  # agora a escala pode ser fixa
  scale_x_log10(
    breaks = unique(df_facet_norm$size),
    labels = comma_format(big.mark = ".", decimal.mark = ",")
  ) +
  scale_y_continuous(
    labels = comma_format(big.mark = ".", decimal.mark = ",")
  ) +
  labs(
    title = "Curvas normalizadas (prática + teoria)",
    x = "Tamanho da entrada (n)",
    y = "Tempo normalizado (0–1)",
    color = "Partição", fill = "Partição"
  ) +
  theme_minimal(base_size = 12)


#separando todos como individuais
plot_por_sortType <- function(df, teorico_df, output_prefix) {
  tipos <- unique(df$sortType)
  
  for (tipo in tipos) {
    df_tipo <- df %>% filter(sortType == tipo)
    teorico_tipo <- teorico_df %>% filter(sortType == tipo)
    
    g <- ggplot(df_tipo, aes(x = size, y = media_norm, color = partition, fill = partition)) +
      geom_ribbon(aes(ymin = media_norm - desvio_norm, ymax = media_norm + desvio_norm), alpha = 0.15, color = NA) +
      geom_line(size = 1) +
      geom_point(size = 2) +
      geom_line(data = teorico_tipo, aes(x = size, y = teoria_norm), color = "black", linetype = "dashed", size = 1.2) +
      scale_x_log10(
        breaks = unique(df_tipo$size),
        labels = comma_format(big.mark = ".", decimal.mark = ",")
      ) +
      scale_y_continuous(
        labels = comma_format(big.mark = ".", decimal.mark = ",")
      ) +
      labs(
        title = paste("Curva prática + teórica para", tipo),
        x = "Tamanho da entrada (n)",
        y = "Tempo médio normalizado (0–1)",
        color = "Partição", fill = "Partição"
      ) +
      theme_minimal(base_size = 12)
    
    ggsave(paste0(output_prefix, "_", tipo, ".png"), plot = g, width = 10, height = 3, dpi = 300)
  }
}



# Cria data frame com curvas teóricas para cada sortType e partição
teorico_lines_sep1 <- df_facet_pequenos %>%
  select(partition, sortType, size, teoria_norm, label) %>%
  distinct()
teorico_lines_sep2 <- df_facet_grandes %>%
  select(partition, sortType, size, teoria_norm, label) %>%
  distinct()
# Gerar os gráficos
plot_por_sortType(df_facet_pequenos, teorico_lines_sep1, "grafico_small_tipo")
plot_por_sortType(df_facet_grandes, teorico_lines_sep2, "grafico_big_tipo")




#para partition facets
plot_por_partition <- function(df, teorico_df, output_prefix) {
  parts <- unique(df$partition)
  
  for (p in parts) {
    df_part <- df %>% filter(partition == p)
    teorico_part <- teorico_df %>% filter(partition == p)
    
    g <- ggplot() +
      geom_ribbon(data = df_part, aes(x = size, ymin = media_norm - desvio_norm,
                                      ymax = media_norm + desvio_norm,
                                      fill = sortType), alpha = 0.15, color = NA) +
      geom_line(data = df_part, aes(x = size, y = media_norm, color = sortType), size = 1) +
      geom_point(data = df_part, aes(x = size, y = media_norm, color = sortType), size = 2) +
      geom_line(data = teorico_part, aes(x = size, y = teoria_norm, color = sortType), 
                linetype = "dashed", size = 1.2) +
      scale_x_log10(
        breaks = unique(df_part$size),
        labels = comma_format(big.mark = ".", decimal.mark = ",")
      ) +
      scale_y_continuous(
        labels = comma_format(big.mark = ".", decimal.mark = ",")
      ) +
      labs(
        title = paste("Curvas por algoritmo na partição", p),
        x = "Tamanho da entrada (n)",
        y = "Tempo médio normalizado (0–1)",
        color = "Algoritmo", fill = "Algoritmo"
      ) +
      theme_minimal(base_size = 12)
    
    ggsave(paste0(output_prefix, "_", p, ".png"), plot = g, width = 10, height = 3, dpi = 300)
  }
}

teorico_lines_sep <- df_facet_norm %>%
  select(partition, sortType, size, teoria_norm, label) %>%
  distinct()
plot_por_partition(df_facet_norm, teorico_lines_sep, "grafico_particao")

