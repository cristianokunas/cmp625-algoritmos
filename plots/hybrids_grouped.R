library(ggplot2)
library(dplyr)
library(readr)
library(stringr)

df <- read_csv("all_results.csv")

df <- df %>%
  mutate(
    repetition = as.integer(repetition),
    size = as.integer(size),
    time = as.numeric(time),
    sortType = trimws(as.character(sortType)),
    partition = trimws(as.character(partition))
  )

agg_df <- df %>%
  group_by(partition, sortType, size) %>%
  summarise(mean_time = mean(time), .groups = "drop")

agg_df <- agg_df %>%
  mutate(
    theory = case_when(
      sortType == "BruteForce" ~ size^2,
      TRUE ~ size * log2(size)
    )
  )

# --- Separate Hybrid_* and non-Hybrid
agg_hybrid <- agg_df %>% filter(str_starts(sortType, "Hybrid_"))
agg_others <- agg_df %>% filter(!str_starts(sortType, "Hybrid_"))

# --- Scale theory for others
agg_others <- agg_others %>%
  group_by(partition, sortType) %>%
  mutate(
    theory_scaled = theory / max(theory) * max(mean_time)
  ) %>%
  ungroup()

# --- Generate plots for non-Hybrid types
plots_others <- agg_others %>%
  group_by(partition, sortType) %>%
  group_split() %>%
  lapply(function(group_data) {
    part <- unique(group_data$partition)
    sort <- unique(group_data$sortType)
    
    ggplot(group_data, aes(x = size)) +
      geom_line(aes(y = mean_time), color = "steelblue", size = 1.2) +
      geom_line(aes(y = theory_scaled), color = "darkred", linetype = "dashed", size = 1) +
      labs(
        title = paste("Partition:", part, "| Sort Type:", sort),
        x = "Input Size (n)",
        y = "Time (seconds)",
        subtitle = "Empirical (blue) vs Theoretical (red, scaled)"
      ) +
      theme_minimal(base_size = 14)
  })

plots_hybrid <- agg_hybrid %>%
  group_by(partition, sortType) %>%
  mutate(
    theory = size * log2(size),  # All Hybrid_* assumed O(n log n)
    theory_scaled = theory / max(theory) * max(mean_time)
  ) %>%
  group_by(partition) %>%
  group_split() %>%
  lapply(function(part_data) {
    part <- unique(part_data$partition)
    
    ggplot(part_data, aes(x = size, y = mean_time, color = sortType)) +
      geom_line(size = 1.2) +
      labs(
        title = paste("Partition:", part, "| Hybrid Sort Types"),
        x = "Input Size (n)",
        y = "Time (seconds)",
        subtitle = "Each line = one Hybrid_* sortType"
      ) +
      theme_minimal(base_size = 14) +
      theme(legend.title = element_blank())
  })

# --- Combine and save all plots
all_plots <- c(plots_others, plots_hybrid)

pdf("grouped_hybrids.pdf", width = 8, height = 6)
for (p in all_plots) print(p)
dev.off()

