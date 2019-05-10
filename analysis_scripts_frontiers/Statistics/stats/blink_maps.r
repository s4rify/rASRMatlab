
## Map dissimilarities
# Look at Z-transformed R^2 values for blink map correlations 

filt_asr <- read.table(file = "data/ztrans_blink_corr_FILT_ASR_.csv",header = FALSE, dec = ".", col.names = "corr", sep=",")
filt_asr$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
filt_asr$subj      <- c(1:27)
filt_asr$method    <- c(rep("filt_asr", 27*2))

filt_riem <- read.table(file = "data/ztrans_blink_corr_FILT_RIEM_.csv",header = FALSE, dec = ".", col.names = "corr", sep=",")
filt_riem$condition <- c(c(rep("inside",27)), c(rep("outside",27)))
filt_riem$subj      <- c(1:27)
filt_riem$method    <- c(rep("filt_riem", 27*2))

### testing time
library(ez)
library(effsize)

# combine all for ANOVA
all <- rbind(filt_asr,filt_riem)
aov_group <- ezANOVA(data=all, dv = corr, within = .(condition, method), wid=subj)
print(aov_group)

# plot
a <- mean(all$corr[all$condition== "inside" & all$method == "filt_asr"])
b <- mean(all$corr[all$condition== "inside" & all$method == "filt_riem"])
# this should be transformed back when reported
plot(c(a,b), xlab = "methods", ylab = "mean r^2 corr values (transformed!)", xaxt = "n")
# Changing x axis
axis(1, at=1:2, labels=c("uncorr ~ ASR","uncorr ~ rASR"))

# interaction effect
# outside
one <- filt_asr$corr[filt_asr$condition == "outside"];
two <- filt_riem$corr[filt_riem$condition == "outside"];
x <- c(one, two);
grouping <- c(c(rep("filt asr outside", 27)),c(rep("filt rasr outside", 27)));
source("pairwise.t.test.with.t.and.df.R")
result <- pairwise.t.test.with.t.and.df(x, grouping, adjust.method="bonf", paired=TRUE)
# print t-test result
print(result)
# Print t-values
print(c("t-value: ", result[[5]]))
# Print dfs
print(c("Df: ", result[[6]]))

print(c("mean of filt_asr outside: ", mean(one)))
print(c("mean of filt_riem outside: ", mean(two)))

cohen.d(x, as.factor(grouping))

# inside
one <- filt_asr$corr[filt_asr$condition == "inside"];
two <- filt_riem$corr[filt_riem$condition == "inside"];
x <- c(one, two);
grouping <- c(c(rep("filt asr inside", 27)),c(rep(" filt rasr inside", 27)));
source("pairwise.t.test.with.t.and.df.R")
result <- pairwise.t.test.with.t.and.df(x, grouping, adjust.method="bonf", paired=TRUE)
# print t-test result
print(result)
# Print t-values
print(c("t-value: ", result[[5]]))
# Print dfs
print(c("Df: ", result[[6]]))

print(c("mean of filt_asr inside: ", mean(one)))
print(c("mean of filt_riem inside: ", mean(two)))