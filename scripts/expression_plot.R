library(ggplot2)

expression_data <- read.csv(snakemake@input[[1]])

plot <- ggplot(expression_data, aes(x = Condition, y = Expression, fill = Condition)) +
  geom_boxplot() +
  labs(title = "NKX2-1 Expression in Tumor vs. Normal Tissue",
       x = "Sample Type",
       y = "Log2(TPM + 1)") +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", color = "white"),
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank()
  )

ggsave(snakemake@output[[1]], plot)
