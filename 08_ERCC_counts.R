## this script picks up where 01_kallisto_gather.R left off. 
load("/Users/raynamharris/Github/SingleNeuronSeq/results/2016-02-25_results/2016-02-25_02-dplyrmutate.Rdata")

## read in the file with the concentration for each ERCC sample
setwd("/Users/raynamharris/Github/SingleNeuronSeq/data")
stds <- read.csv(file="ercc_stds.csv", header = TRUE, sep=",")
str(stds)

## use dplyr to combine the data file (couts or tpm), the log transform.
library(dplyr)
counts_stds <- dplyr::full_join(stds, counts, by = "id")
str(counts_stds)
head(counts_stds)
#now, log transform only the columns with counts
counts_stds[, 3:41] <- log(counts_stds[3:41]+1) 

tpm_stds <- dplyr::full_join(stds, tpm, by = "id")
str(tpm_stds)
head(tpm_stds)
#now, log transform only the columns with counts
tpm_stds[, 3:41] <- log(tpm_stds[3:41]+1) 


library(ggplot2)
library(reshape)
melt_counts_std <- melt(counts_stds)
p <- ggplot(melt_counts_std, aes(factor(variable), value)) 
p + geom_boxplot() 


##look at which ones explained by mix concentrations
#library(lm)
library(lme4)
lm1 <- lm(mix1~S01+S02+S03+S04+S05+S08+S09+S10+S13+S17+S19+S21+S22+S23+S24+S25+S26+S28+S29+S30+S31+S32+S33+S34+S36+S37+S38+S39+S40+S41+S42+S43+S50, data = counts_stds)
summary(lm1) 


lm2 <- lm(mix1~S02, data = counts_stds)
summary(lm2) 

#plot expected vs observed
library(ggplot2)
library(plyr)


ggplot(counts_stds, aes(mix1, S11)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Stock ERCC Concentration (attomoles/uL)") + labs(y="ERCC counts: 1 ng Tissue Sample")
ggplot(counts_stds, aes(mix1, S02)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Stock ERCC Concentration (attomoles/uL)") + labs(y="ERCC counts: 1 ng Tissue Sample")


require(cowplot)
quartz()
plot_grid(S11, S2, labels = c("A", "B"), ncol = 2)


##correlations
#install.packages("corrplot")
## counts_stds for corr plot
counts_stds_forcor <- counts_stds
rownames(counts_stds_forcor) <- counts_stds_forcor$id
counts_stds_forcor[1] <- NULL
counts_stds_forcor[1] <- NULL
counts_stds_forcor[2] <- NULL
dev.off()
library(corrplot)
corr_counts_stds_forcorr <- cor(counts_stds_forcor)
quartz()
corrplot(corr_counts_stds_forcorr, method="ellipse")

#

cor(counts_stds_forcor$mix1, counts_stds_forcor$S02)
# [1] 0.9811149
cor.test(counts_stds_forcor$mix1, counts_stds_forcor$S02)

#	Pearson's product-moment correlation
#data:  counts_stds_forcor$mix1 and counts_stds_forcor$S2
#t = 48.12, df = 90, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# 0.9715248 0.9874956
#sample estimates:
#      cor 
#0.9811149 
