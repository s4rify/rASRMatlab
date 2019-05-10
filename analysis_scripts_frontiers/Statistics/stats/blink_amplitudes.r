## Blink Amplitudes
# We only compare the correction methods in the ANOVA because we are not interested whether rASR or ASR correct significantly
# in comparison to uncorrected data but only amongst themselves. 
raw <- read.table(file = "data/blink_uncorrected.csv",header = FALSE, dec = ".", col.names = "amplitude", sep=",")
raw$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
raw$subj      <- c(c(1:27), c(1:27)) 
raw$method    <- c(rep("uncorrected", 27*2))

asr <- read.table(file = "data/blink_asr.csv",header = FALSE, dec = ".", col.names = "amplitude", sep=",")
asr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
asr$subj      <- c(c(1:27), c(1:27)) 
asr$method    <- c(rep("asr", 27*2))

rasr <- read.table(file = "data/blink_rasr.csv",header = FALSE, dec = ".", col.names = "amplitude", sep=",")
rasr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
rasr$subj      <- c(c(1:27), c(1:27)) 
rasr$method    <- c(rep("rasr", 27*2))

library(ez)
library(effsize)

# combine correction methods for ANOVA, leave uncorected data out
all <- rbind(asr, rasr)
aov_group <- ezANOVA(data=all, dv = amplitude, within = .(condition, method), wid=subj)
print(aov_group)

source("pairwise.t.test.with.t.and.df.R")
result <- pairwise.t.test.with.t.and.df(all$amplitude, all$condition, adjust.method="bonf", paired=TRUE)
# print t-test result
print(result)
# Print t-values
print(c("t-value: ", result[[5]]))

# Print dfs
print(c("Df: ", result[[6]]))

# Cohen's D for t-test
cohen.d(all$amplitude, all$condition, paired = TRUE)
a <- mean(all$amplitude[all$condition== "inside" & all$method == "rasr"])
b <- mean(all$amplitude[all$condition== "inside" & all$method == "asr"])
c <- mean(all$amplitude[all$condition== "outside" & all$method == "rasr"])
d <- mean(all$amplitude[all$condition== "outside" & all$method == "asr"])
plot(c(a,b,c,d), xlab = "methods", ylab = "mean blink amplitude", xaxt = "n")
# Changing x axis
axis(1, at=1:4, labels=c("in rASR","in ASR", "out rASR","out ASR"))
legend("topright", legend=c(a,b,c,d))

print(c(mean(c(a,b)), "inside"))
print(c(mean(c(c,d)), "outside"))

un_in <- mean(raw$amplitude[raw$condition== "inside" & raw$method == "uncorrected"])
print(c(un_in, "uncorrected inside"))
un_out <- mean(raw$amplitude[raw$condition== "outside" & raw$method == "uncorrected"])
print(c(un_out, "uncorrected outside"))
