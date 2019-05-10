
## VEP SNR (N125 peak vs baseline noise 200 ms before stimulus)

raw <- read.table(file = "data/vep_snr_uncorrected.csv",header = FALSE, dec = ".", col.names = "snr", sep=",")
raw$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
raw$subj      <- c(c(1:27), c(1:27)) 
raw$method    <- c(rep("uncorrected", 27*2))

asr <- read.table(file = "data/vep_snr_asr.csv",header = FALSE, dec = ".", col.names = "snr", sep=",")
asr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
asr$subj      <- c(c(1:27), c(1:27)) 
asr$method    <- c(rep("asr", 27*2))

rasr <- read.table(file = "data/vep_snr_rasr.csv",header = FALSE, dec = ".", col.names = "snr", sep=",")
rasr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
rasr$subj      <- c(c(1:27), c(1:27)) 
rasr$method    <- c(rep("rasr", 27*2))

### testing time
library(ez)
library(effsize)

# combine all for ANOVA
all <- rbind(raw, asr, rasr)
aov_group <- ezANOVA(data=all, dv = snr, within = .(condition, method), wid=subj)
print(aov_group)

# # outside
# ASR_out <- asr$snr[asr$condition == "outside"];
# rASR_out <- rasr$snr[rasr$condition == "outside"];
# raw_out <- raw$snr[raw$condition == "outside"];
# 
# x <- c(ASR_out, rASR_out, raw_out);
# grouping <- c(c(rep("asr out", 27)),c(rep("rasr out", 27)), c(rep("uncorrected out", 27)));
# source("pairwise.t.test.with.t.and.df.R")
# result <- pairwise.t.test.with.t.and.df(x,grouping, p.adjust.method = "holm", paired = TRUE);
# print(result)
# 
# # inside
# ASR_in <- asr$snr[asr$condition == "inside"];
# rASR_in <- rasr$snr[rasr$condition == "inside"];
# raw_in <- raw$snr[raw$condition == "inside"];
# x <- c(ASR_in, rASR_in, raw_in);
# grouping <- c(c(rep("asr in", 27)),c(rep("rasr in", 27)), c(rep("uncorrected in", 27)));
# result <- pairwise.t.test.with.t.and.df(x,grouping, p.adjust.method = "holm", paired = TRUE);
# print(result)
# 
# #cohen.d(all$snr, all$condition, pooled = FALSE, paired = TRUE)


a <- mean(all$snr[all$condition== "inside" & all$method == "rasr"])
b <- mean(all$snr[all$condition== "inside" & all$method == "asr"])
c <- mean(all$snr[all$condition== "outside" & all$method == "rasr"])
d <- mean(all$snr[all$condition== "outside" & all$method == "asr"])
e <- mean(all$snr[all$condition== "inside" & all$method == "uncorrected"])
f <- mean(all$snr[all$condition== "outside" & all$method == "uncorrected"])
plot(c(a,b,c,d,e,f), xlab = "methods", ylab = "mean vep snr", xaxt = "n")
# Changing x axis
axis(1, at=1:6, labels=c("in rASR","in ASR", "out rASR","out ASR","in uncorr", "out uncorr" ))
legend("topright", legend=c(a,b,c,d,e,f))