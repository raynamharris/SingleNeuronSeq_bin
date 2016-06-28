#need to transpose the dataframen and make row 1 the row names
library(reshape2)

#make rownames the id
countData <- counts
row.names(countData)=countData[,1]
countData$id = NULL
str(countData)

countData <- t(countData)
countData <- as.data.frame(countData)
