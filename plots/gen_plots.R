library(ggplot2)
library(dplyr)
library(readr)

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

agg_df <- agg_df %>%
  arrange(partition, sortType)

agg_df <- agg_df %>%
  group_by(partition, sortType) %>%
  mutate(
    theory_scaled = theory / max(theory) * max(mean_time)
  ) %>%
  ungroup()

plots <- agg_df %>%
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

# --- Save all plots into a single PDF
pdf("complexity_plots.pdf", width = 8, height = 6)
for (p in plots) print(p)
dev.off()
