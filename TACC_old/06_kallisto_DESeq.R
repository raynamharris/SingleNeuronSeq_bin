## This script is based off of three sources
# 1. http://www.bioconductor.org/help/workflows/rnaseqGene/
# 2. Colleagues scripts https://github.com/rachelwright8/Ahya-White-Syndromes
# 3. CCBB RNAseq short course https://wikis.utexas.edu/display/bioiteam/Testing+for+Differential+Expression

## load DESeq and other R packages
library(DESeq2)
library(ggplot2)
library(pheatmap)
library(RColorBrewer)
library(ggplot2)
source("https://bioconductor.org/biocLite.R")
biocLite("genefilter")
library(genefilter)
library(reshape2)
library(dplyr)


################## Data Wrangling ################

### load data for samples and counts
countData <- counts #from 06_kallistogather.R
row.names(countData)=countData[,1] ## make col 1 row names
countData$id = NULL
str(countData)

## calculate sums
colSums <- as.data.frame(colSums(countData))
rowSums <- as.data.frame(rowSums(countData))
names(rowSums)[1]<-"sum"
rownames <- row.names(rowSums)  
colnames <- row.names(colSums)

# import sample info
colData <- read.csv("/Users/raynamharris/Github/SingleNeuronSeq/data/Cborealissampleinfo-JA16393.csv", header=TRUE, sep=",")

################## DESeq2 ################## 

## all results will go here 
setwd("~/Github/SingleNeuronSeq/results/2016-06-27-kallistoquant-cds")

## create deseq data set suing the DESeqDataSetFromMatrix function
## I will compare two factors (RNAseqBatch and condition) that each have multiple levels
dds <- DESeqDataSetFromMatrix(countData, colData, design= ~ type) 

## Run stats test for normalization, dispersion/variance, and test for differential expression
## took about 1 hour for this massive dataset
dds <- DESeq(dds)
save.image("2016-06-27-kallistoquant-cds-DESeq.Rdata")


## Prefilter the dataset, remove genes with 0 counts
nrow(dds)
#[1] 90
row.names(dds) <- rownames 
names(dds) <- colnames
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
#[1] 85

dds$type <- factor(dds$type, levels=c("PD","GM", "VP", "LP"))
dds
res <- results(dds)
res
res05 <- results(dds, alpha=0.05)
summary(res05)


rld <- rlog(dds, blind=FALSE)
colnames(rld) <- colnames
head(assay(rld), 3)

par( mfrow = c( 1, 2 ) )
dds <- estimateSizeFactors(dds)
plot(log2(counts(dds, normalized=TRUE)[,1:2] + 1),
     pch=16, cex=0.3)
plot(assay(rld)[,1:2],
     pch=16, cex=0.3)


sampleDists <- dist( t( assay(rld) ) )
sampleDists


sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$dex, rld$cell, sep="-" )
#colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)





## Histogram of pvalues
hist(res$pvalue)
hist(res2$pvalue)
hist(res3$pvalue)

## Table NAs
table(is.na(res$padj))
#FALSE  TRUE 
#24285 19443
table(is.na(res2$padj))
#29562 14166
table(is.na(res3$padj))
#29562 14166


## Tables FDR < 0.05 <0.01)
table(res$pvalue<0.05)
# 23228 13311 
table(res$pvalue<0.01)
#30217  6322
table(res$pvalue<0.001)
#34377  2162


table(res2$pvalue<0.05)
# 35631   908  
table(res2$pvalue<0.01)
#36364   175
table(res2$pvalue<0.001)
#36519    20 



sum(res$padj < 0.1, na.rm=TRUE)
# [1] 13663
sum(res2$padj < 0.1, na.rm=TRUE)
# [1] 0
sum(res3$padj < 0.1, na.rm=TRUE)
# [1] 0


## Hence, if we consider a fraction of 10% false positives acceptable, we can consider all genes with an adjusted p value below 10% = 0.1 as significant. How many such genes are there?
resSig <- subset(res, padj < 0.1)
head(resSig[ order(resSig$log2FoldChange), ])
head(resSig[ order(resSig$log2FoldChange, decreasing=TRUE), ])


topGene <- rownames(res2)[which.min(res$padj)]
head(topGene)
plotCounts(dds, gene=topGene, intgroup=c("RNAseqBatch"))
plotCounts(dds, gene=topGene, intgroup=c("condition"))
data <- plotCounts(dds, gene=topGene, intgroup=c("RNAseqBatch","condition"), returnData=TRUE)
ggplot(data, aes(x=RNAseqBatch, y=count, color=condition)) +
  scale_y_log10() + 
  geom_point(position=position_jitter(width=.1,height=0), size=3) +
  ggtitle("Gm5835")
ggsave("topGene.jpg")

#------Independent filtering
attr(res, "filterThreshold")
#------Pvalues by normalized counts

plot(res$baseMean+1, -log2(res$pvalue),
     log="x", xlab="mean of normalized counts",
     ylab=expression(-log[2](pvalue)),
     ylim=c(0,15),
     cex=.4, col=rgb(0,0,0,.3))
    abline(h=-log2(0.05), col="red")
    
plot(res3$baseMean+1, -log2(res3$pvalue),
    log="x", xlab="mean of normalized counts",
    ylab=expression(-log[2](pvalue)),
    ylim=c(0,15),
    cex=.4, col=rgb(0,0,0,.3))
    abline(h=-log2(0.05), col="red")

        


## MA plot
hmcol <- colorRampPalette(brewer.pal(9, "GnBu"))(100);
plotMA(dds,ylim=c(-2,2),main="DESeq2");
#An MA-plot of changes induced by treatment. The log2 fold change for a particular comparison is plotted on the y-axis and the average of the counts normalized by size factor is shown on the x-axis (“M” for minus, because a log ratio is equal to log minus log, and “A” for average). Each gene is represented with a dot. Genes with an adjusted p value below a threshold (here 0.1, the default) are shown in red.

plotMA(res, ylim=c(-5,5))
topGene <- rownames(res2)[which.min(res2$padj)]
with(res[topGene, ], {
  points(baseMean, log2FoldChange, col="dodgerblue", cex=2, lwd=2)
  text(baseMean, log2FoldChange, topGene, pos=2, col="dodgerblue")
})



#------Dispersion estimates
plotDispEsts(dds);


#######-----------get VSD
vsd=getVarianceStabilizedData(dds) 
head(vsd)

######-------------make vsd and pvals table
vsdpvals=cbind(vsd,results)
tail(vsdpvals)

write.csv(vsdpvals, "vsdpvals.csv", quote=F)


######----------log GO
head(res)
logs=data.frame(cbind("gene"=row.names(res),"logP"=round(-log(res$pvalue+1e-10,10),1)))
logs$logP=as.numeric(as.character(logs$logP))
sign=rep(1,nrow(logs))
sign[res$log2FoldChange<0]=-1  ##change to correct model
table(sign)
logs$logP=logs$logP*sign
write.table(logs,quote=F,row.names=F,file="GO_2_logP.csv",sep=",")



#-------------write results tables; includes log2fc and pvals
write.table(results(dds), file="DESeq.results.txt", quote=FALSE, sep="\t");  
write.table(res, file="DESeq.results.res.txt", quote=F, sep="\t")



## The rlog transformation
## This is for things like PCA and such, which we can do later
rld <- rlog(dds, blind=FALSE)
plotSparsity(dds)
head(assay(rld), 3)

## Sample distance: which samples are most similar?
sampleDists <- dist( t( assay(rld) ) )
sampleDists

## Now let's make a pretty heat map
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$RNAseqBatch, rld$condition, sep="-" )
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
quartz()
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

## PCA
## simple PCA plot
plotPCA(rld, intgroup = c("RNAseqBatch", "condition"))
## slightly fancier ggplot
data <- plotPCA(rld, intgroup = c( "RNAseqBatch", "condition"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
quartz()
ggplot(data, aes(PC1, PC2, color=condition, shape=RNAseqBatch)) + geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance"))

library("genefilter")
topVarGenes <- head(order(rowVars(assay(rld)),decreasing=TRUE),20)
mat <- assay(rld)[ topVarGenes, ]
mat <- mat - rowMeans(mat)
df <- as.data.frame(colData(rld)[,c("RNAseqBatch","condition")])
quartz()
pheatmap(mat, annotation_col=df)




###################Analyzing Single Neurons Only
## slimming the data: samples to single neuron and counts to things with more than zero counts

library(tidyr)
library(dplyr)
library(reshape)
samples_single_neuron <- samples %>%
  filter(tissue == "neuron")
rownames <- samples_single_neuron[,1]

## In order to subset the count data I need to transform the dateframe. 
## To do so, I will melt then spread to preserve column and row names
## then I will subset using only the rownames from samples
counts_melt <- melt(counts)
counts_melt <- rename(counts_melt, c("id" = "transcript",  "variable" = "id", "value" = "counts"))
counts_melt_spread <- spread(counts_melt, transcript, counts)
counts_melt_spread_singleneuron <- counts_melt_spread[c(rownames),]

counts_melt_spread_singleneuron <- data.frame(counts_melt_spread_singleneuron[,-1], row.names=counts_melt_spread_singleneuron[,1])
counts_melt_spread_singleneuron_transp <- as.data.frame(t(counts_melt_spread_singleneuron[,-1]))
counts_melt_spread_singleneuron_transp[,-1] <-round(counts_melt_spread_singleneuron_transp[,-1],0) #the "-1" excludes column 
head(counts_melt_spread_singleneuron_transp)

## we need to make these integers not numbers
counts_melt_spread_singleneuron_transp_int <- counts_melt_spread_singleneuron_transp
counts_melt_spread_singleneuron_transp_int <- sapply(counts_melt_spread_singleneuron_transp_int, as.integer)
counts_melt_spread_singleneuron_transp_int <- as.data.frame(counts_melt_spread_singleneuron_transp_int)

str(counts_int)
str(counts_melt_spread_singleneuron_transp_int)
row.names(counts_melt_spread_singleneuron_transp_int) <- rownames

##let's work with single neuron dataframe
countData <- counts_melt_spread_singleneuron_transp_int

totalCounts=colSums(countData)
# full     #single neuron
min(totalCounts) #454387      1218068
max(totalCounts) #23325407    23325407
mean(totalCounts) #8551580    9905073

## indicated relevant variables for analysis
colData <- samples_single_neuron
head(colData)

## Table NAs
table(is.na(res$padj))
#FALSE  TRUE 
#24973 86824

## Tables FDR < 0.05 <0.01)
table(res$pvalue<0.05)
# FALSE  TRUE 
# 34136   714 
table(res$pvalue<0.01)
#FALSE  TRUE
#34709   141

## create deseq data set suing the DESeqDataSetFromMatrix function
## I will compare two factors (RNAseqBatch and condition) that each have multiple levels
dds_single <- DESeqDataSetFromMatrix(countData, colData, design= ~ RNAseqBatch + condition) 

## Run stats test for normalization, dispersion/variance, and test for differential expression
## took about 1 hour for this massive dataset
dds_single <- DESeq(dds_single)

## Prefilter the dataset, remove gens with 0 counts
nrow(dds_single)
#[1] 111798
row.names(dds_single) <- rownames
dds_single <- dds_single[ rowSums(counts(dds_single)) > 1, ]
nrow(dds_single)
#[1] 30586

## Differential expression. 
## using contrsts to compare tissue versus single neuron samples
#res_RNAseqBatch <- results(dds, contrast = c('RNASeqBatch', 'JA15597', 'JA16033'))
#res_condition <- results(dds, contrast = c("neuron.bio", "tissue.dillution", "pos.control", "neg.control", "neuron.tech"))
head(dds_single)
row.names(dds_single) <- rownames
res_dds_single <- results(dds_single)
res_dds_single <- res[order(res$padj),]
head(res_dds_single)
mcols(res_dds_single,use.names=TRUE)
summary(res_dds_single)

write.csv(as.data.frame(res),file="res_dds_single.csv")



#write.csv(as.data.frame(res2),file="res2.csv")

## Histogram of pvalues
hist(res_dds_single$pvalue)


## Table NAs
table(is.na(res_dds_single$padj))
#FALSE  TRUE 
#53938 13425
table(is.na(res_dds_single$padj))
#FALSE  TRUE 
#53938 13425

## Tables FDR < 0.05 <0.01)
table(res_dds_single$pvalue<0.05)
# FALSE  TRUE 
# 26967 39492 
table(res_dds_single$pvalue<0.01)
#FALSE  TRUE
#32570 33889
table(res_dds_single$pvalue<0.001)
#FALSE  TRUE
#35850 27325 
sum(res_dds_single$padj < 0.1, na.rm=TRUE)
# [1] 41415


## Hence, if we consider a fraction of 10% false positives acceptable, we can consider all genes with an adjusted p value below 10% = 0.1 as significant. How many such genes are there?
resSigres_dds_single <- subset(res_dds_single, padj < 0.1)
head(resSigres_dds_single[ order(resSigres_dds_single$log2FoldChange), ])
head(resSigres_dds_single[ order(resSigres_dds_single$log2FoldChange, decreasing=TRUE), ])


topGene <- rownames(res_dds_single)[which.min(res_dds_single$padj)]
head(topGene)
plotCounts(dds_single, gene=topGene, intgroup=c("RNAseqBatch"))
plotCounts(dds_single, gene=topGene, intgroup=c("condition"))
data <- plotCounts(dds_single, gene=topGene, intgroup=c("RNAseqBatch","condition"), returnData=TRUE)
quartz()
ggplot(data, aes(x=RNAseqBatch, y=count, color=condition)) +
  scale_y_log10() + 
  geom_point(position=position_jitter(width=.1,height=0), size=3)
ggsave("topGene.jpg")

#------Independent filtering
attr(res, "filterThreshold")
#------Pvalues by normalized counts

plot(res_dds_single$baseMean+1, -log2(res_dds_single$pvalue),
     log="x", xlab="mean of normalized counts",
     ylab=expression(-log[2](pvalue)),
     ylim=c(0,15),
     cex=.4, col=rgb(0,0,0,.3))
abline(h=-log2(0.05), col="red")


## MA plot
hmcol <- colorRampPalette(brewer.pal(9, "GnBu"))(100);
quart()
plotMA(dds_single,ylim=c(-2,2),main="DESeq2");
#An MA-plot of changes induced by treatment. The log2 fold change for a particular comparison is plotted on the y-axis and the average of the counts normalized by size factor is shown on the x-axis (“M” for minus, because a log ratio is equal to log minus log, and “A” for average). Each gene is represented with a dot. Genes with an adjusted p value below a threshold (here 0.1, the default) are shown in red.

plotMA(res_dds_single, ylim=c(-5,5))
topGene <- rownames(res_dds_single)[which.min(res2$padj)]
with(res2[topGene, ], {
  points(baseMean, log2FoldChange, col="dodgerblue", cex=2, lwd=2)
  text(baseMean, log2FoldChange, topGene, pos=2, col="dodgerblue")
})



#------Dispersion estimates
plotDispEsts(res_dds_single);

library(arrayQualityMetrics)
library(Biobase)

#######-----------get VSD
vsd=getVarianceStabilizedData(dds) 
head(vsd)
######-------------make vsd and pvals table
vsdpvals=cbind(vsd,results)
tail(vsdpvals)

#write.csv(vsdpvals, "vsdpvals.csv", quote=F)


######----------log GO
head(res)
logs=data.frame(cbind("gene"=row.names(res),"logP"=round(-log(res$pvalue+1e-10,10),1)))
logs$logP=as.numeric(as.character(logs$logP))
sign=rep(1,nrow(logs))
sign[res$log2FoldChange<0]=-1  ##change to correct model
table(sign)
logs$logP=logs$logP*sign
write.table(logs,quote=F,row.names=F,file="GO_2_logP.csv",sep=",")





## The rlog transformation
## This is for things like PCA and such, which we can do later
rlds-single <- rlog(res_dds_single, blind=FALSE)
head(assay(rld), 3)

## Sample distance: which samples are most similar?
sampleDists <- dist( t( assay(rld) ) )
sampleDists

## Now let's make a pretty heat map
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$RNAseqBatch, rld$condition, sep="-" )
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
quartz()
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

## PCA
## simple PCA plot
plotPCA(rld, intgroup = c("RNAseqBatch", "condition"))
## slightly fancier ggplot
data <- plotPCA(rld, intgroup = c( "RNAseqBatch", "condition"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
quartz()
ggplot(data, aes(PC1, PC2, color=condition, shape=RNAseqBatch)) + geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance"))

library("genefilter")
topVarGenes <- head(order(rowVars(assay(rld)),decreasing=TRUE),20)
mat <- assay(rld)[ topVarGenes, ]
mat <- mat - rowMeans(mat)
df <- as.data.frame(colData(rld)[,c("RNAseqBatch","condition")])
quartz()
pheatmap(mat, annotation_col=df)




