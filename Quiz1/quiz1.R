## Author: Swadesh Pal. ## Created on: 29-05-2016. ## Last edited: 29-05-2016.
# Getting and Cleaning Data by Johns Hopkins University on Coursera. 
# Quiz 1.

# Read survey data
fileList <- list.files()
if(!"getdata-data-ss06hid.csv" %in% fileList)
{
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
}
survey_data <- read.csv("getdata-data-ss06hid.csv")
m <- which(names(survey_data) == "VAL")
num <- length(na.omit(survey_data[survey_data[,m]>=24, m]))
print(num) # question 1

# Check for required packages
if(!require("xlsx")) {
  install.packages("xlsx")
}
# Read data from <*.xlsx> file
fileList <- list.files()
if(!"getdata-data-DATA.gov_NGAP.xlsx" %in% fileList)
{
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx")
}
dat <- read.xlsx("getdata-data-DATA.gov_NGAP.xlsx",
                        sheetIndex = 1, colIndex = (7:15),
                        rowIndex = (18:23))
print(sum(dat$Zip*dat$Ext,na.rm=T)) # question 3

# Read data from <*.xml> file
library(XML)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlInternalTreeParse(url)
rootNode <- xmlRoot(doc)
names(rootNode)
names(rootNode[[1]][[1]])
zipcode <- xpathSApply(rootNode, "//zipcode", xmlValue)
table(zipcode == 21231) # question 4

# question 5
# Check for required packages
if(!require("data.table")) {
  install.packages("data.table")
}
# Read Survey data
fileList <- list.files()
if(!"getdata-data-ss06pid.csv" %in% fileList)
{
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
}
DT <- fread("getdata-data-ss06pid.csv", sep=",")
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(DT[,mean(pwgtp15),by=SEX]) # correct answer
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(rowMeans(DT)[DT$SEX==1], rowMeans(DT)[DT$SEX==2])
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15))
