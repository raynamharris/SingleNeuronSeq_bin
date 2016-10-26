## this script picks up where 01_kallisto_gather.R left off. 
load("/Users/raynamharris/Github/SingleNeuronSeq/results/2016-02-25_results/2016-02-25_02-dplyrmutate.Rdata")

## read in the file with the concentration for each ERCC sample
setwd("/Users/raynamharris/Github/SingleNeuronSeq/data")
stds <- read.csv(file="ercc_stds.csv", header = TRUE, sep=",")
str(stds)

## use dplyr to combine the data file (couts or tpm), the log transform.
library(dplyr)
counts_stds <- dplyr::full_join(stds, counts_rename, by = "id")
counts_stds <- counts_stds[c(1:92),] ## keep only ERCC rows
str(counts_stds)
head(counts_stds)
#now, log transform only the columns with counts
counts_stds[, 3:35] <- log(counts_stds[3:35]+1) 

tpm_stds <- dplyr::full_join(stds, tpm, by = "id")
str(tpm_stds)
head(tpm_stds)
#now, log transform only the columns with counts
tpm_stds[, 3:35] <- log(tpm_stds[3:35]+1) 


library(ggplot2)
library(reshape)
melt_counts_std <- melt(counts_stds)
p <- ggplot(melt_counts_std, aes(factor(variable), value)) 
p + geom_boxplot() 


##look at which ones explained by mix concentrations
head(counts_stds)
library(lme4)
lm1 <- lm(mix1~X1.4.polyA_S1 + X12.cck.100p.2.polyA_S12 + X13.cck.10p.2.polyA_S13 + X14.cck.10n.3.polyA_S14 + X15.cck.1n.3.polyA_S15 + X16.cck.100p.3.polyA_S16 + X17.cck.10p.3.polyA_S17 + X2.5.polyA_S2 + X21.CCK8A.ribo_S21 +X23.CCK8C.ribo_S23 + X24.CCK9A.use10ul.ribo_S24 + X28.10pg.ribo_S28 + X29.1.none_S29 +
            X3.6.polyA_S3 + X32.CCK7A.none_S32 + X34.CCK7C.none_S34 + X35.100ng.none_S35 + X36.10pg.none_S36 + X39.1.nueron_S2 + X4.7.polyA_S4 + X41.1.nueron_S4 + X43.1.nueron_S6 + X44.A.pool_S7 + X44.B.pool_S16 + X45.B.pool_S18 + X49.negative_S12 + X5.8.polyA_S5 +  X50.human.100.ng_S13 + X52.negative_S15 + 
            X6.CCK10.10n.polyA_S6 + X8.CCK10.100p.polyA_S8 + X9.CCK10.10p.polyA_S9, data = counts_stds)
summary(lm1) 


lm2 <- lm(mix1~X9.CCK10.10p.polyA_S9, data = counts_stds)
summary(lm2) 

#plot expected vs observed
library(ggplot2)
library(plyr)

ggplot(counts_stds, aes(mix1, X9.CCK10.10p.polyA_S9)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Stock ERCC Concentration (attomoles/uL)") + labs(y="ERCC counts: 10 pg Tissue Sample")
ggplot(counts_stds, aes(mix1, X16.cck.100p.3.polyA_S16)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Stock ERCC Concentration (attomoles/uL)") + labs(y="ERCC counts: 100 pg Tissue Sample")
ggplot(counts_stds, aes(mix1, X28.10pg.ribo_S28)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Stock ERCC Concentration (attomoles/uL)") + labs(y="ERCC counts: Ribo-minus method")
ggplot(counts_stds, aes(mix1, X1.4.polyA_S1)) + geom_point() + geom_smooth(method = "lm", se = FALSE) + 
  labs(x = "Stock ERCC Concentration (attomoles/uL)") + labs(y="ERCC counts: polyA method") 


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
str(counts_stds_forcor)
dev.off()
library(corrplot)
corr_counts_stds_forcorr <- cor(counts_stds_forcor)
str(corr_counts_stds_forcorr)
quartz()
corrplot(corr_counts_stds_forcorr, method="ellipse")

#

cor(counts_stds_forcor$X16.cck.100p.3.polyA_S16, counts_stds_forcor$X9.CCK10.10p.polyA_S9)
# [1] 0.9811149
cor.test(counts_stds_forcor$mix1, counts_stds_forcor$X9.CCK10.10p.polyA_S9)

#	Pearson's product-moment correlation
#data:  counts_stds_forcor$mix1 and counts_stds_forcor$S2
#t = 48.12, df = 90, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
# 0.9715248 0.9874956
#sample estimates:
#      cor 
#0.9811149 
