
## VEP amplitudes (N125 peak)

raw <- read.table(file = "data/vep_amp_uncorrected.csv",header = FALSE, dec = ".", col.names = "amp", sep=",")
raw$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
raw$subj      <- c(c(1:27), c(1:27)) 
raw$method    <- c(rep("uncorrected", 27*2))

asr <- read.table(file = "data/vep_amp_asr.csv",header = FALSE, dec = ".", col.names = "amp", sep=",")
asr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
asr$subj      <- c(c(1:27), c(1:27)) 
asr$method    <- c(rep("asr", 27*2))

rasr <- read.table(file = "data/vep_amp_rasr.csv",header = FALSE, dec = ".", col.names = "amp", sep=",")
rasr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
rasr$subj      <- c(c(1:27), c(1:27)) 
rasr$method    <- c(rep("rasr", 27*2))

### testing time
library(ez)
library(effsize)

# combine all for ANOVA
all <- rbind( raw, asr, rasr)
aov_group <- ezANOVA(data=all, dv = amp, within = .(condition, method), wid=subj)
print(aov_group)

source("pairwise.t.test.with.t.and.df.R")
result <- pairwise.t.test.with.t.and.df(all$amp, all$condition, adjust.method="bonf", paired=TRUE)
# Print t-values
print(c("t-value: ", result[[5]]))

# Print dfs
print(c("Df: ", result[[6]]))

# Cohen's D for t-test
cohen.d(all$amp, as.factor(all$condition), paired = TRUE)
a <- mean(all$amp[all$condition== "inside" & all$method == "rasr"])
b <- mean(all$amp[all$condition== "inside" & all$method == "asr"])
c <- mean(all$amp[all$condition== "outside" & all$method == "rasr"])
d <- mean(all$amp[all$condition== "outside" & all$method == "asr"])
e <- mean(all$amp[all$condition== "inside" & all$method == "uncorrected"])
f <- mean(all$amp[all$condition== "outside" & all$method == "uncorrected"])
plot(c(a,b,c,d,e,f), xlab = "methods", ylab = "mean vep amplitudes", xaxt = "n")
# Changing x axis
axis(1, at=1:6, labels=c("in rASR","in ASR", "out rASR","out ASR", "in raw", "out raw"))
legend("topright", legend=c(mean(c(a,b,e)),mean(c(c,d,f))))

print(c(a, "rasr in"))
print(c(b, "asr in"))
print(c(c, "rasr out"))
print(c(d, "asr out"))
print(c(e, "uncorr in"))
print(c(f, "uncorr out"))
