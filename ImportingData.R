# check files in current path
dir()

# get path of file
path <- file.path("~", "DataCamp", "states.csv")

# use factors for categorical variables with a finite number of levels e.g. Male/Female, Low/Mid/High, Race
states <- read.csv(path, stringsAsFactors = FALSE)

# get structure
str(states)

# get some summary stats about the variables in the data fram
summary(states)

# when the delimiter is not a comma, we need to use read.table instead
states2 <- read.table("states2.txt", header = TRUE, sep = "/", stringsAsFactors = FALSE)
str(states2)

states3 <- read.table("states3.csv", 
                      sep = ",", 
                      col.names = c("state", "capital", "pop_mil", "area_sqm"), 
                      header = FALSE, 
                      stringsAsFactors = FALSE)
str(states3)

# select state with min population
states2[which.min(states2$pop_mil),]

# if we set the class of a variable as NULL then it will be excluded from the import
# factor, numeric, character, logical, numeric, integer, Date
states4 <- read.csv("states.csv", 
                      sep = ",", 
                      stringsAsFactors = FALSE,
                      colClasses = c("factor", "character", "numeric", "NULL")
                      )
str(states4)

# read.csv2 is used when using numbers like 3,5 instead of 3.5. it uses delim = ";" and dec = ","

install.packages("readr")
library(readr)
better_states <- read_csv("states.csv")
better_states3 <- read_tsv("states3.txt")
better_states4 <- read_delim("states4.txt", delim = "/", 
                             col_names = c("state", "capital", "pop_mil", "area_sqm"))
# c = character, 
# d = double, 
# i = integer, 
# l = logical, 
# _ = skip
# skip = 1 means to skip 1st row of file (note: if the file has a header, this will be skipped)
# n_max = 3 means only import 3 rows
better_states5 <- read_delim("states4.txt", delim = "/", 
                             col_names = c("state", "capital", "pop_mil", "area_sqm"),
                             col_types = "ccdd",
                             skip = 1, n_max = 3)
better_states5


install.packages("data.table")
library(data.table)

fread("states.csv")
fread("states1.csv")

# all equivalent ways to import variables 2 and 3
fread("states.csv", drop = 2:3)
fread("states.csv", select = c(1, 4))
fread("states.csv", drop = c("capital", "pop_mil"))
fread("states.csv", select = c("state", "area_sqm"))

install.packages("readxl")
library(readxl)
dir()
excel_sheets("cities.xlsx")
read_excel("cities.xlsx", sheet = 2)
read_excel("cities.xlsx", sheet = "year_2000")

excel_sheets("urbanpop.xlsx")

# Read the sheets, one by one
pop_1 <- read_excel("urbanpop.xlsx", sheet = 1)
pop_2 <- read_excel("urbanpop.xlsx", sheet = 2)
pop_3 <- read_excel("urbanpop.xlsx", sheet = 3)

# Put pop_1, pop_2 and pop_3 in a list: pop_list
pop_list <- list(pop_1, pop_2, pop_3)

str(pop_list)

# Read all Excel sheets with lapply(): pop_list
pop_list <- lapply(excel_sheets("urbanpop.xlsx"),
                   read_excel,
                   path = "urbanpop.xlsx")

# Display the structure of pop_list
str(pop_list)

install.packages("XLConnect")
install.packages("rJava")
library(rJava)
library(XLConnect)

book <- loadWorkbook("cities.xlsx")
getSheets(book)
readWorksheet(book, sheet = "year_2000")
readWorksheet(book, sheet = "year_2000",
              startRow = 3, endRow = 4,
              startCol = 2, header = FALSE)

pop_2010 <- data.frame(
  Capital = c("New York", "Berlin", "Madrid", "Stockholm",
  Population = c(10000000, 20000000, 30000000, 40000000))
)
createSheet(book, name = "year_2010")
writeWorksheet(book, pop_2010, sheet = "year_2010")
saveWorkbook(book, file = "cities2.xlsx")
book <- loadWorkbook("cities2.xlsx")
renameSheet(book, "year_1990", "Y1990")
renameSheet(book, "year_2000", "Y2000")
renameSheet(book, "year_2010", "Y2010")
saveWorkbook(book, file = "cities3.xlsx")
removeSheet(book, sheet = "Y2010")
saveWorkbook(book, file = "cities4.xlsx")
# style, formulae, etc