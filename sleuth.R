#Sleuth from https://rawgit.com/pachterlab/sleuth/master/inst/doc/intro.html

source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
biocLite("biomaRt")
install.packages('devtools')
devtools::install_github('pachterlab/sleuth')
library("sleuth")


base_dir <- "~/Github/SingleNeuronSeq/data/"
sample_id <- dir(file.path(base_dir,"05_kallistoquant_2016-03-02"))
sample_id
kal_dirs <- sapply(sample_id, function(id) file.path(base_dir, "05_kallistoquant_2016-03-02", id, "kallisto"))
kal_dirs

s2c <- read.csv(file.path(base_dir, "2016-02-25-sample_annotation.csv"), header = TRUE, stringsAsFactors=FALSE)
s2c <- dplyr::select(s2c, sample = run_accession, condition)
s2c

s2c <- dplyr::mutate(s2c, path = kal_dirs)
print(s2c)

## Now the “sleuth object” can be constructed. 
## This requires three commands that 
## (1) load the kallisto processed data into the object 
## (2) estimate parameters for the sleuth response error measurement model and 
## (3) perform differential analysis (testing). On a laptop the three steps should take about 2 minutes altogether.
so <- sleuth_prep(s2c, ~ condition)
so <- sleuth_fit(so)
so <- sleuth_wt(so, 'conditionscramble')
models(so)


## Since the example was constructed with the ENSEMBL human transcriptome, we will add gene names from ENSEMBL using biomaRt (there are other ways to do this as well):
mart <- biomaRt::useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")
## Creating a generic function for 'nchar' from package 'base' in package 'S4Vectors'
t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
                                     "external_gene_name"), mart = mart)
t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,
                     ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
so <- sleuth_prep(s2c, ~ condition, target_mapping = t2g)
so <- sleuth_fit(so)
so <- sleuth_wt(so, which_beta = 'conditionscramble')
sleuth_live(so)
results_table <- sleuth_results(so, 'conditionscramble')
