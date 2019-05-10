# computation times ttest
asr_total <- read.table(file = "data/asr_total.csv",header = FALSE, dec = ".", col.names = "s", sep=",")
asr_total$method    <- c(rep("asr_total", 158)) # blocks: ca 6 per subject: 27*6

asr_minimal <- read.table(file = "data/asr_min.csv",header = FALSE, dec = ".", col.names = "s", sep=",")
asr_minimal$method    <- c(rep("asr_min", 158))

rasr_total <- read.table(file = "data/rasr_total.csv",header = FALSE, dec = ".", col.names = "s", sep=",")
rasr_total$method    <- c(rep("rasr_total", 158))

rasr_minimal <- read.table(file = "data/rasr_min.csv",header = FALSE, dec = ".", col.names = "s", sep=",")
rasr_minimal$method    <- c(rep("rasr_min", 158))

library(ez)
library(effsize)
source("pairwise.t.test.with.t.and.df.R")
# minimal times
all <- rbind(asr_minimal, rasr_minimal)
result <- pairwise.t.test.with.t.and.df(all$s, all$method, adjust.method="bonf", paired=TRUE)
# p-value
print(result)
# Print t-values
print(c("t-value: ", result[[5]]))
# Print dfs
print(c("Df: ", result[[6]]))
# Cohen's D for t-test
cohen.d(all$s, as.factor(all$method), paired = TRUE)

# total times
all <- rbind(asr_total, rasr_total)
result <- pairwise.t.test.with.t.and.df(all$s, all$method, adjust.method="bonf", paired=TRUE)
# p-value
print(result)
# Print t-values
print(c("t-value: ", result[[5]]))
# Print dfs
print(c("Df: ", result[[6]]))
# Cohen's D for t-test
cohen.d(all$s, as.factor(all$method), paired = TRUE)

wilcox.test(rasr_minimal$s, asr_minimal$s, paired=TRUE)