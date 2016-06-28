#Sleuth from https://rawgit.com/pachterlab/sleuth/master/inst/doc/intro.html

#source("http://bioconductor.org/biocLite.R")
#biocLite("rhdf5")
#biocLite("biomaRt")
#install.packages('devtools')
#devtools::install_github('pachterlab/sleuth')
library("sleuth")

setwd("~/Github/SingleNeuronSeq/data")
base_dir <- "~/Github/SingleNeuronSeq/data"
sample_id <- dir(file.path(base_dir,"2016-06-27-kallistoquant"))
sample_id
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "2016-06-27-kallistoquant", id))
kal_dirs

s2c <- read.csv('Cborealissampleinfo-JA16393.csv', header = TRUE, stringsAsFactors=FALSE)
s2c

s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)

# not all samples produced an output. 
# I used this filter to remove samples for which there was no output
s2c <- filter(s2c, sample != "GM-27-S_S34")
s2c <- filter(s2c, sample != "GM-30-S_S18")
s2c <- filter(s2c, sample != "GM-37-S_S22")
s2c <- filter(s2c, sample != "GM-38-S_S23")
s2c <- filter(s2c, sample != "GM-37-S_S22")
s2c <- filter(s2c, sample != "GM-39-S_S24")
s2c <- filter(s2c, sample != "LP-01-S_S1")
s2c <- filter(s2c, sample != "LP-02-S_S2")
s2c <- filter(s2c, sample != "LP-03-S_S3")
s2c <- filter(s2c, sample != "LP-04-S_S4")
s2c <- filter(s2c, sample != "LP-06-S_S5")
s2c <- filter(s2c, sample != "PD-14-S_S11")
s2c <- filter(s2c, sample != "PD-23-S_S15")
s2c <- filter(s2c, sample != "VD-58-S_S32")
s2c <- filter(s2c, sample != "GM-27-S_S34")
s2c <- filter(s2c, sample != "GM-29-S_S17")


## Now the “sleuth object” can be constructed. 
## This requires three commands that 
## (1) load the kallisto processed data into the object 
## (2) estimate parameters for the sleuth response error measurement model and 
## (3) perform differential analysis (testing). On a laptop the three steps should take about 2 minutes altogether.
so <- sleuth_prep(s2c, ~  type)
so <- sleuth_fit(so)
so <- sleuth_wt(so, 'typePD') 
models(so)
sleuth_live(so)
results_table <- sleuth_results(so, 'condition')


## plotting densities by group
plot_group_density(so, use_filtered = TRUE, units = "est_counts",
                   trans = "log", grouping = setdiff(colnames(so$conditionneuron.bio),
                                                     "sample"), offset = 1)


setwd("~/Github/SingleNeuronSeq/results")
library(dplyr)
ERCCs <- read.csv("processed_data_table_ERCC_2016-03-25.csv", sep = ",", header = TRUE)
mus <- read.csv("processed_data_table_Mus_tissue_neuron.csv", sep = ",", header = TRUE)
combo <- dplyr::full_join(mus, ERCCs, by = "sample")
combo <- combo[c(-1, -6, -7,-8,-9,-10,-11,-12,-13,-22)]
combo <- dplyr::mutate(combo, total_mapped = frac_mapped.x + frac_mapped.y)

library(plyr)
combo <- rename(combo, c("frac_mapped.x" = "frac_mapped_mus"))
combo <- rename(combo, c("frac_mapped.y" = "frac_mapped_ERCC"))
plot(combo$frac_mapped.mus, combo$frac_mapped.ERCC)

library(ggplot2)
ggplot(combo, aes(frac_mapped_ERCC, frac_mapped_mus), size = 3) + geom_point(size= 3) + geom_point(aes(colour = factor(RNAseqBatch.y, size = 3)))
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14))
#write.csv(combo, "combo.csv")


## now plot some ERCC stuff

library(dplyr)
library(ggplot2)
library(reshape2)
setwd("~/Github/SingleNeuronSeq/results")
ERCC <- read.csv("kallisto_table_ERCC.csv", sep=",", header=TRUE)
#plot tpm versus counts
a <- ggplot(ERCC, aes(x = target_id, y = est_counts))
a + geom_point(aes(color=factor(batch))) + theme(legend.position="none")

## make the data wide so I can look at correlations across samples
ERCC_counts <- select(ERCC,target_id, sample, est_counts)
ERCC_counts <- dcast(ERCC_counts, target_id ~ sample)
ERCC_counts <- data.frame(ERCC_counts[,-1], row.names=ERCC_counts[,1])
ERCC_tpm <- select(ERCC,target_id, sample, tpm)
ERCC_tpm <- dcast(ERCC_tpm, target_id ~ sample)
ERCC_tpm <- data.frame(ERCC_tpm[,-1], row.names=ERCC_tpm[,1])

## make correlation matrix
library(Hmisc)
ERCC_counts <- log(ERCC_counts + 1) 
ERCC_counts_corr <- cor(ERCC_counts, use="complete.obs", method="kendall") 
install.packages("corrgram")
library(corrgram)
corrgram(ERCC_counts, order=NULL, lower.panel=panel.shade,
         upper.panel=NULL, text.panel=panel.txt,
         main="Car Milage Data (unsorted)")


require(lattice)
levelplot(ERCC_counts_corr)


install.packages("qtlcharts")
library(qtlcharts)
iplotCorr(mat=ERCC_counts, group=ERCC_counts$batch, reorder=TRUE)

ERCC_counts_corr <- round(cor(ERCC_counts),2)
ERCC_counts_corr_melt <- melt(ERCC_counts_corr)
ggplot(data = ERCC_counts_corr_melt, aes(x=X1, y=X2, fill=value)) + 
  geom_tile()

col<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = ERCC_counts_corr, col = col, symm = TRUE)
