## Author: Swadesh Pal. ## Created on: 04-06-2016. ## Last edited: 04-06-2016.
# Getting and Cleaning Data by Johns Hopkins University on Coursera. 
# Quiz 2.

## Question 1
# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories 
# (hint: this is the url you want "https://api.github.com/users/jtleek/repos"). 
# Use this data to find the time that the datasharing repo was created. What time was it created? 
# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
# You may also need to run the code in the base R package and not R studio. 

library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "e035d1bf252a2c05ee12",
                   secret = "ca04a39f9c83ef069c67cac46b7d5fa618712b7a")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

# OR:
#req <- with_config(gtoken, GET("https://api.github.com/rate_limit"))
#stop_for_status(req)
#content(req)

# curl -u Access Token:x-oauth-basic "https://api.github.com/users/jtleek/repos"
#BROWSE("https://api.github.com/users/jtleek/repos",authenticate("Access Token","x-oauth-basic","basic"))

# Convert unstructured json to structured json
library(jsonlite)
jsonData <- fromJSON(toJSON(content(req)))

# Find the time that the "datasharing" repo was created
ans <- subset(jsonData, name == "datasharing", select = c(created_at))
row.names(ans) <- NULL
print(ans)

## Question 2
# Check for required packages
if(!require("sqldf")) {
  install.packages("sqldf")
}
library(sqldf)
# Read survey data
fileList <- list.files()
if(!"getdata-data-ss06pid.csv" %in% fileList)
{
  destFile = "./getdata-data-ss06pid.csv"
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", 
                destfile = destFile)
}
acs <- read.csv("getdata-data-ss06pid.csv", header=TRUE, sep=",")
head(acs)
sqldf("select pwgtp1 from acs where AGEP < 50")

## Question 3
unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

## Question 4
siteLink <- "http://biostat.jhsph.edu/~jleek/contact.html"
siteInfo <- url(siteLink)
siteData <- readLines(siteInfo)
close(siteInfo)
ans <- sapply(siteData[c(10, 20, 30, 100)], nchar)
print(ans)

## Question 5
fileList <- list.files()
if(!"getdata-wksst8110.for" %in% fileList)
{
  destFile = "./getdata-wksst8110.for"
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", 
                destfile = destFile)
}
data <- read.fwf("getdata-wksst8110.for", 
                 widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4), skip = 4)
head(data)
ans <- sum(data[,4])
print(ans)
