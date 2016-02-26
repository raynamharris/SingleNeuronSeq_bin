## Kallisto Gather was created by Dennis Wylie and edited by Rayna
## original kallisto gater script found here:
## location of script "/Volumes/HofmannLab/rmharris/singlecellseq/scripts.dennis"

## change to data directory
setwd("/Users/raynamharris/Github/SingleNeuronSeq/data/kallisto_combo_raw")
## this will create lists of all the samples
kallistoDirs = dir("/Users/raynamharris/Github/SingleNeuronSeq/data/kallisto_combo_raw")
kallistoDirs = kallistoDirs[!grepl("\\.(R|py|pl|sh|xlsx?|txt|tsv|csv|org|md|obo|png|jpg|pdf)$",
        kallistoDirs, ignore.case=TRUE)]
kallistoFiles = paste0(kallistoDirs, "/abundance.tsv")
names(kallistoFiles) = kallistoDirs

kallistoData = lapply(
    kallistoFiles,
    read.table,
    sep = "\t",
    row.names = 1,
    header = TRUE
)

## this for loop uses the reduce function to make two data frame with counts or tpm from all the samples
ids = Reduce(f=union, x=lapply(kallistoData, rownames))
if (all(sapply(kallistoData, function(x) {all(rownames(x)==ids)}))) {
    counts = data.frame(
        id = ids,
        sapply(kallistoData, function(x) {x$est_counts}),
        check.names = FALSE,
        stringsAsFactors = FALSE
    )
    tpm = data.frame(
        id = ids,
        sapply(kallistoData, function(x) {x$tpm}),
        check.names = FALSE,
        stringsAsFactors = FALSE
    )
}

## With four very long database names, the ids are very long
head(counts, "counts.csv")

## Let's use this perl string to extract only some of the information
## to do so, I'll save as an csv, run this command in unix, then read in new csv
setwd("/Users/raynamharris/Github/SingleNeuronSeq/results/2016-02-25_results")
## perl -pe 's/,\"(.*?)\|.*?\|.*?\|.*?\|.*?\|(.*?)\|(.*?)\|(.*?)\|/,\"\2_\1_\3_\4/g' counts.csv > counts_rename.csv

write.csv(counts, "counts.csv", row.names=FALSE)
counts_rename <- read.csv("counts_rename.csv", header=TRUE, sep=',')
counts_rename[1]=NULL
head(counts_rename)
tail(counts_rename)

## workspace saved as kallisto_gather.Rdata for easy import
save.image("/Users/raynamharris/Github/SingleNeuronSeq/results/2016-02-25_results/2016-02-25_01-kallisto-gather.Rdata")


