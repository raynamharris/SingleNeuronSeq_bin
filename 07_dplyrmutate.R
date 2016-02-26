#I want to make new columns with the max neg control count for each RNAseq batch
# samples 
# JA15597 S20 S37
# JA16033 S49 S52

load("/Users/raynamharris/Github/SingleNeuronSeq/results/2016-02-25_results/2016-02-25_01-kallisto-gather.Rdata")


#make rownames the id
rownames <- counts_rename[,1]
counts_rename_mutate <- counts_rename
row.names(counts_rename_mutate)=counts_rename_mutate[,1]
head(counts_rename_mutate)

library(dplyr)
counts_rename_mutate <- counts_rename_mutate %>% 
  rowwise() %>% 
  mutate(JA15597_neg = max(S20, S37))%>% 
  mutate(JA16033_neg = max(S49, S52))
str(counts_rename_mutate)
counts_rename_mutate <- as.data.frame(counts_rename_mutate)

## now, let's make new adjusted columsn 
counts_rename_mutate$S01_adj <- (counts_rename_mutate$S01 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S02_adj <- (counts_rename_mutate$S02 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S03_adj <- (counts_rename_mutate$S03 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S04_adj <- (counts_rename_mutate$S04 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S05_adj <- (counts_rename_mutate$S05 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S06_adj <- (counts_rename_mutate$S06 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S07_adj <- (counts_rename_mutate$S07 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S08_adj <- (counts_rename_mutate$S08 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S09_adj <- (counts_rename_mutate$S09 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S10_adj <- (counts_rename_mutate$S19 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S11_adj <- (counts_rename_mutate$S11 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S12_adj <- (counts_rename_mutate$S12 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S13_adj <- (counts_rename_mutate$S13 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S14_adj <- (counts_rename_mutate$S14 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S15_adj <- (counts_rename_mutate$S15 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S16_adj <- (counts_rename_mutate$S16 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S17_adj <- (counts_rename_mutate$S17 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S18_adj <- (counts_rename_mutate$S18 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S19_adj <- (counts_rename_mutate$S19 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S20_adj <- (counts_rename_mutate$S20 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S21_adj <- (counts_rename_mutate$S21 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S22_adj <- (counts_rename_mutate$S22 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S23_adj <- (counts_rename_mutate$S23 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S24_adj <- (counts_rename_mutate$S24 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S25_adj <- (counts_rename_mutate$S25 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S26_adj <- (counts_rename_mutate$S26 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S27_adj <- (counts_rename_mutate$S27 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S28_adj <- (counts_rename_mutate$S28 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S29_adj <- (counts_rename_mutate$S29 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S30_adj <- (counts_rename_mutate$S30 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S31_adj <- (counts_rename_mutate$S31 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S32_adj <- (counts_rename_mutate$S32 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S33_adj <- (counts_rename_mutate$S33 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S34_adj <- (counts_rename_mutate$S34 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S35_adj <- (counts_rename_mutate$S35 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S36_adj <- (counts_rename_mutate$S36 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S37_adj <- (counts_rename_mutate$S37 - counts_rename_mutate$JA15597_neg) 
counts_rename_mutate$S38_adj <- (counts_rename_mutate$S38 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S39_adj <- (counts_rename_mutate$S39 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S40_adj <- (counts_rename_mutate$S40 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S41_adj <- (counts_rename_mutate$S41 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S42_adj <- (counts_rename_mutate$S42 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S43_adj <- (counts_rename_mutate$S43 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S44.A_adj <- (counts_rename_mutate$S44.A - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S44.B_adj <- (counts_rename_mutate$S44.B - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S44.C_adj <- (counts_rename_mutate$S44.C - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S45.A_adj <- (counts_rename_mutate$S45.A - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S45.B_adj <- (counts_rename_mutate$S45.B - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S45.C_adj <- (counts_rename_mutate$S45.C - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S46_adj <- (counts_rename_mutate$S46 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S47_adj <- (counts_rename_mutate$S47 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S48_adj <- (counts_rename_mutate$S48 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S49_adj <- (counts_rename_mutate$S49 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S50_adj <- (counts_rename_mutate$S50 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S51_adj <- (counts_rename_mutate$S51 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S52_adj <- (counts_rename_mutate$S52 - counts_rename_mutate$JA16033_neg) 
counts_rename_mutate$S52_adj <- (counts_rename_mutate$S52 - counts_rename_mutate$JA16033_neg) 
str(counts_rename_mutate)

#remove original columsn and negative controls
counts_rename_mutate <- counts_rename_mutate[,-c(2:59)]
# JA15597 S20 S37
# JA16033 S49 S52
counts_rename_mutate$S20_adj=NULL
counts_rename_mutate$S37_adj=NULL
counts_rename_mutate$S49_adj=NULL
counts_rename_mutate$S52_adj=NULL

str(counts_rename_mutate) 

## make column 1 the row names
## replace negative numbers with zeros
rownames <- counts_rename_mutate[,1]
counts_rename_mutate[1] = NULL
counts_rename_mutate[counts_rename_mutate < 0] <- 0
counts_rename_mutate <- as.data.frame(counts_rename_mutate)
str(counts_rename_mutate) 
head(counts_rename_mutate)

colSums(counts_rename_mutate)


## this was giving ddseq a hard time, so let's remove samples where there are almost no ERCC counts
counts_rename_mutate$S06_adj=NULL
counts_rename_mutate$S07_adj=NULL
counts_rename_mutate$S11_adj=NULL
counts_rename_mutate$S12_adj=NULL
counts_rename_mutate$S14_adj=NULL
counts_rename_mutate$S15_adj=NULL
counts_rename_mutate$S16_adj=NULL
counts_rename_mutate$S18_adj=NULL
counts_rename_mutate$S27_adj=NULL
counts_rename_mutate$S35_adj=NULL
counts_rename_mutate$S44.B_adj=NULL
counts_rename_mutate$S44.C_adj=NULL
counts_rename_mutate$S45.B_adj=NULL
counts_rename_mutate$S46_adj=NULL
counts_rename_mutate$S47_adj=NULL
counts_rename_mutate$S48_adj=NULL
counts_rename_mutate$S50_adj=NULL


## attemping to get rownames for this slimmed dataset
row.names(counts_rename_mutate)=rownames
head(counts_rename_mutate)
#removing transcripts with all zeros
counts_rename_mutate <- counts_rename_mutate[!apply(counts_rename_mutate[, -c(1,2)], 1, function(row) all(row == 0)), ]
head(counts_rename_mutate)
rownames <- row.names(counts_rename_mutate)



save.image("/Users/raynamharris/Github/SingleNeuronSeq/results/2016-02-25_results/2016-02-25_02-dplyrmutate.Rdata")


