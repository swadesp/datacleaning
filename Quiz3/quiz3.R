## Author: Swadesh Pal. ## Created on: 12-06-2016. ## Last edited: 12-06-2016.
# Getting and Cleaning Data by Johns Hopkins University on Coursera. 
# Quiz 3.

## Question 1
# Read survey data
fileList <- list.files()
if(!"getdata-data-ss06hid.csv" %in% fileList)
{
  destFile = "./getdata-data-ss06hid.csv"
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", 
                destfile = destFile)
}
survey_data <- read.csv("getdata-data-ss06hid.csv", header=TRUE, sep=",")
agricultureLogical <- ((survey_data$ACR == 3) & (survey_data$AGS == 6))
print(which(agricultureLogical)[1:3])


## Question 2
# Check for required packages
if(!require("jpeg")) {
  install.packages("jpeg")
}
library(jpeg)
# Read image data
fileList <- list.files()
if(!"getdata-jeff.jpg" %in% fileList)
{
  destFile = "./getdata-jeff.jpg"
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", 
                destfile = destFile, mode = "wb")
}
img <- readJPEG(destFile, native = TRUE)
print(quantile(img, probs = c(0.3, 0.8)))



## Question 3
if(!require("data.table")) {
  install.packages("data.table")
}
library(data.table)
# Read Gross Domestic Product data
fileList <- list.files()
if(!"getdata-data-GDP.csv" %in% fileList)
{
  destFile = "./getdata-data-GDP.csv"
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                destfile = destFile)
}
# Read educational data
fileList <- list.files()
if(!"getdata-data-EDSTATS_Country.csv" %in% fileList)
{
  destFile = "./getdata-data-EDSTATS_Country.csv"
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", 
                destfile = destFile)
}
GDP_data <- read.csv("getdata-data-GDP.csv", skip = 4, nrows = 215, header=TRUE, sep=",")
GDP_data <- data.table(GDP_data)
GDP_data <- GDP_data[X != ""]
ED_data <- data.table(read.csv("getdata-data-EDSTATS_Country.csv", header=TRUE, sep=","))
# Extracting only necessary information
GDP_data <- GDP_data[, list(X, X.1, X.3, X.4)]
setnames(GDP_data, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "Rank", 
                                                  "CountryName", "GDP"))
data_set <- merge(GDP_data, ED_data, all = TRUE, by = ("CountryCode"))
print(sum(!is.na(unique(data_set$Rank))))
reqSet <- data_set[order(data_set$Rank, decreasing = TRUE), ]
print(reqSet$CountryName[13])

## Question 4
set1 <- data_set[data_set$Income.Group == "High income: OECD", ]
set2 <- data_set[data_set$Income.Group == "High income: nonOECD", ]
avgGDP_Cat1 <- mean(set1$Rank, na.rm = TRUE)
avgGDP_Cat2 <- mean(set2$Rank, na.rm = TRUE)


## Question 5
grp <- quantile(data_set$Rank, probs = seq(0, 1, 0.2), na.rm = TRUE)
data_set$perGDP <- cut(data_set$Rank, breaks = grp)
data_set[Income.Group == "Lower middle income", .N, by = c("Income.Group", "perGDP")]
