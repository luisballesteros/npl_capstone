library(tm)
library(readr)
# library(tidyverse)
library(stringi)
library(RWeka)
library(ggplot2)
library(wordcloud)
library(SnowballC)
library(gridExtra)
getwd()
###https://medium.com/text-mining-in-data-science-a-tutorial-of-text/text-mining-in-data-science-51299e4e594

inputFileName <- './data/en_US.blogs.txt'
badWordsFileURL <- 'http://www.bannedwordlist.com/lists/swearWords.txt'
badWordsFileName <- './data/swearWords.txt'

datafolder <- "data"
url  <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
fname <- "Coursera-SwiftKey.zip"
fpath <- paste(datafolder, fname, sep="/")
fpath_badwords <- paste(datafolder, badWordsFileName, sep="/")
if (!file.exists(fpath)){
    download.file(url, destfile=fpath, method="curl")
    download.file(badWordsFileURL, destfile=fpath_badwords, method="curl")
}
unzip(zipfile=fpath, exdir=datafolder)

file_l <- list.files(path=datafolder, recursive=T, pattern=".*en_.*.txt")

file_info <- lapply(paste(datafolder, file_l, sep="/"),
                    function(file_) {
            file_Size_origin <- round(file.info(file_)$size/1024^2, 1)
            fileConnection <- file(file_, open='r')
            linesInFile <- readLines(fileConnection)
            file_Size_origin <- round(file.info(paste0(file_))$size/1024^2, 1)
            fileSize <- format(object.size(linesInFile), units ='Mb')
            fileNoOfLines <- length(linesInFile)
            fileWords <- sum(stri_count_words(linesInFile))
            nchars <- lapply(linesInFile, nchar)
            maxchars <- which.max(nchars)
            name <- stri_extract_last_regex(file_, '([a-zA-Z]+)[^\\.txt]')
            close(fileConnection)
            return(c(name, file_Size_origin, fileSize, 
                     fileNoOfLines, fileWords, maxchars))

})

df <- data.frame(matrix(unlist(file_info), nrow=length(l), byrow=T))
colnames(df) <- c("file", "size_original_(MB)", "size_in_R_(MB)",
                  "lines", "words", "longest_line" )
df


import_files <- function(file_){
    fileConnection <- file(paste0('./data/final/en_US/',file_))
    linesInFile <- readLines(fileConnection)
    close(fileConnection)
    return(linesInFile)    
}

blogs <- import_files('en_US.blogs.txt')
news <- import_files('en_US.news.txt')
twitter <- import_files('en_US.twitter.txt')
corpusFeeds <- VCorpus(VectorSource(blogs))