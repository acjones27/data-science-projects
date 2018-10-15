install.packages("RMySQL")
library(DBI)

con <- dbConnect(RMySQL::MySQL(),
                 dbname = "company",
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com",
                 port = 3306,
                 user = "student",
                 password = "datacamp")

dbListTables(con)
dbReadTable(con, "employees")
#dbDisconnect(con)
con

table_names <- dbListTables(con)
tables <- lapply(table_names, dbReadTable, conn = con)

employees <- dbReadTable(con, "employees")
subset(employees,
       subset = started_at > "2012-09-01",
       select = name)

dbGetQuery(con, "SELECT name FROM employees 
                 where started_at > '2012-09-01'")

con <- dbConnect(RMySQL::MySQL(),
                 dbname = "tweater",
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com",
                 port = 3306,
                 user = "student",
                 password = "datacamp")

res <- dbSendQuery(con, "SELECT * FROM comments WHERE user_id > 4")
# Use dbFetch() twice
dbFetch(res, n = 2)
dbFetch(res)

# Clear res
dbClearResult(res)

read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/swimming_pools.csv")
read_tsv("http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/potatoes.txt")

library(readxl)
library(gdata)

# Specification of url: url_xls
url_xls <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/latitude.xls"

# Import the .xls file with gdata: excel_gdata
excel_gdata <- read.xls(url_xls)

# Download file behind URL, name it local_latitude.xls
download.file(url_xls, "local_latitude.xls")

# Import the local .xls file with readxl: excel_readxl
excel_readxl <- read_excel("local_latitude.xls")

# https URL to the wine RData file.
url_rdata <- "https://s3.amazonaws.com/assets.datacamp.com/production/course_1478/datasets/wine.RData"

# Download the wine file to your working directory
download.file(url_rdata, "wine_local.RData")

# Load the wine data into your workspace using load()
load("wine_local.RData")

# Print out the summary of the wine data
summary(wine)

library(httr)

# Get the url
url <- "http://www.omdbapi.com/?apikey=ff21610b&t=Annie+Hall&y=&plot=short&r=json"
resp <- GET(url)

# Print resp
resp

# Print content of resp as text
content(resp, as = "text")

# Print content of resp
content(resp)


install.packages("jsonlite")
library(jsonlite)
fromJSON("https://jsonplaceholder.typicode.com/posts")

# wine_json is a JSON
wine_json <- '{"name":"Chateau Migraine", "year":1997, "alcohol_pct":12.4, "color":"red", "awarded":false}'

# Convert wine_json into a list: wine
wine <- fromJSON(wine_json)

# Print structure of wine
str(wine)

# Definition of quandl_url
quandl_url <- "https://www.quandl.com/api/v3/datasets/WIKI/FB/data.json?auth_token=i83asDsiWUUyfoypkgMz"

# Import Quandl data: quandl_data
quandl_data <- fromJSON(quandl_url)

# Print structure of quandl_data
str(quandl_data)

# Definition of the URLs
url_sw4 <- "http://www.omdbapi.com/?apikey=ff21610b&i=tt0076759&r=json"
url_sw3 <- "http://www.omdbapi.com/?apikey=ff21610b&i=tt0121766&r=json"

# Import two URLs with fromJSON(): sw4 and sw3
sw4 <- fromJSON(url_sw4)
sw3 <- fromJSON(url_sw3)

# Print out the Title element of both lists
sw3$Title
sw4$Title


# Is the release year of sw4 later than sw3?
sw4$Year > sw3$Year