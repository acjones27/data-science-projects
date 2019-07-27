# class(data) --> class
# dim(data) --> rows, columns
# names(data) --> column names
# str(data) --> structure
# library(dplyr)
# glimpse(data) --> better than str 
# sumamry(data) --> summary of each column

bmi <- read.csv("bmi.csv")
# Check the class of bmi
class(bmi)

# Check the dimensions of bmi
dim(bmi)

# View the column names of bmi
names(bmi)

# Check the structure of bmi
str(bmi)

# Load dplyr
library(dplyr)

# Check the structure of bmi, the dplyr way
glimpse(bmi)

# View a summary of bmi
summary(bmi)

# Print bmi to the console
bmi

# View the first 6 rows
head(bmi)

# View the first 15 rows
head(bmi, n = 15)

# View the last 6 rows
tail(bmi)

# View the last 10 rows
tail(bmi, n = 10)

# Histogram of BMIs from 2008
hist(bmi$Y2008)

# Scatter plot comparing BMIs from 1980 to those from 2008
plot(bmi$Y1980, bmi$Y2008)

import(tidyr)
# The most important function in tidyr is gather(). It should be used when you have columns that are not variables and you want to collapse them into key-value pairs.

# The easiest way to visualize the effect of gather() is that it makes wide datasets long. Running the following command on wide_df will make it long:
#   gather(wide_df, my_key, my_val, -col)

# Apply gather() to bmi and save the result as bmi_long
bmi_long <- gather(bmi, "year", "bmi_val", -Country)

# View the first 20 rows of the result
head(bmi_long, n = 20)

# The opposite of gather() is spread(), which takes key-values pairs and spreads them across multiple columns. This is useful when values in a column should actually be column names (i.e. variables). It can also make data more compact and easier to read.

# The easiest way to visualize the effect of spread() is that it makes long datasets wide. Running the following command will make long_df wide:
#     spread(long_df, my_key, my_val)

# Apply spread() to bmi_long
# year is the single column that will be spread into multiple columns, and bmi_val is the value that goes with it
bmi_wide <- spread(bmi_long, year, bmi_val)

# View the head of bmi_wide
head(bmi_wide)

# The separate() function allows you to separate one column into multiple columns. Unless you tell it otherwise, it will attempt to separate on any character that is not a letter or number. You can also specify a specific separator using the sep argument.

# The opposite of separate() is unite(), which takes multiple columns and pastes them together. By default, the contents of the columns will be separated by underscores in the new column, but this behavior can be altered via the sep argument.

fake <- read.csv("fake_data_sep_unite.csv")

head(fake)

fake_sep <- separate(fake, year.mo, c("year", "month"))
fake_unite <- unite(fake_sep, "year/mo", year, month, sep = "/")

head(fake_unite)

census <- read.csv("census.csv")
# View the head of census
head(census)

# Gather the month columns
census2 <- gather(census, month, amount, -YEAR)

# Arrange rows by YEAR using dplyr's arrange
census2 <- arrange(census2, YEAR)

# View first 20 rows of census2
head(census2, n = 20)

# type conversions
# Not every combination exists

library(lubridate)
ymd("2015 August 25th")

ymd("2015-08-25")

mdy("august 25, 2015")

hms('12:05:40')

ymd_hms("2018 October, 24th 19.13.10")

# Make this evaluate to "character"
class(as.character(TRUE))

# Make this evaluate to "numeric"
class(as.numeric("8484.00"))

# Make this evaluate to "integer"
class(as.integer(99))

# Make this evaluate to "factor"
class(as.factor("factor"))

# Make this evaluate to "logical"
class(as.logical("FALSE"))

students <- read.csv("students.csv")
str(students)

# Coerce Grades to character
students$Grades <- as.character(students$Grades)

# Coerce Medu to factor (mother's education level)
students$Medu <- as.factor(students$Medu)

# Coerce Fedu to factor (father's education level)
students$Fedu <- as.factor(students$Fedu)

# Look at students once more with str()
str(students)

fake_dob <- read.csv("fake_dob_data.csv")
head(fake_dob)
str(fake_dob)
# Load the lubridate package
library(lubridate)

# Parse as date
dmy("17 Sep 2015")

# Parse as date and time (with no seconds!)
mdy_hm("July 15, 2012 12:56")

# Coerce dob to a date (with no time)
fake_dob$dob <- ymd(fake_dob$dob)

# Coerce nurse_visit to a date and time
fake_dob$last_login <- ymd_hms(fake_dob$last_login)
str(fake_dob)

library(stringr)
# trim  surrounding whitespace
str_trim("    Hi my name is Anna      ")

# add 00's to the beginning of string until it's 7 digits long
str_pad("24493", width = 7, side = "left", pad = "0")

# look for value in vector
friends <- c("Anna", "Jaime", "Matz")
str_detect(friends, "Anna")

# find and replace
str_replace(friends, "Anna", "Emily")

tolower("ANNA JONES!!")
toupper("anna jones!!")

# Trim all leading and trailing whitespace
str_trim(c("   Filip ", "Nick  ", " Jonathan"))

# Pad these strings with leading zeros
str_pad(c("23485W", "8823453Q", "994Z"), width = 9, side = "left", pad = "0")

# missing values
df <- data.frame(A = c(1, NA, 8, NA),
                 B = c(3, NA, 88, 23),
                 C = c(2, 45, 3, 1))
is.na(df)

# are there any na's
any(is.na(df))

# how many na's
sum(is.na(df))

inds <- which(is.na(df$A))
df[inds,]

ind_B_88 <- which(df$B == 88)
df[ind_B_88, ]
# number of na's per variable
summary(df)

# rows without na's
complete.cases(df)
df[complete.cases(df),]

# both steps in one
na.omit(df)

social_df <- read.csv("social.csv")
head(social_df)

# Call is.na() on the full social_df to spot all NAs
is.na(social_df)

# Use the any() function to ask whether there are any NAs in the data
any(is.na(social_df))

# View a summary() of the dataset
summary(social_df)

# Call table() on the status column
table(social_df$status)

# Replace all empty strings in status with NA
social_df$status[social_df$status == ""] <- NA

# Print social_df to the console
social_df

# Use complete.cases() to see which rows have no missing values
complete.cases(social_df)

# Use na.omit() to remove all rows with any missing values
na.omit(social_df)

# outliers and incorrect data
df2 <- data.frame(A = rnorm(100, 50, 10),
                  B = c(rnorm(99, 50, 10), 500),
                  C = c(rnorm(99, 50, 10), -1))

summary(df2)

hist(df2$B, breaks = 20)
boxplot(df2)


# Import sales.csv: sales
url_sales <- 'http://s3.amazonaws.com/assets.datacamp.com/production/course_1294/datasets/sales.csv'
sales <- read.csv(url_sales, stringsAsFactors = FALSE)

# View dimensions of sales
dim(sales)

# Inspect first 6 rows of sales
head(sales)

# View column names of sales
names(sales)

# Look at structure of sales
str(sales)

# View a summary of sales
summary(sales)

# Load dplyr
library(dplyr)

# Get a glimpse of sales
glimpse(sales)

# my_df[1:5, ] # First 5 rows of my_df
# my_df[, 4]   # Fourth column of my_df
# my_df[-(1:5), ] # Omit first 5 rows of my_df
# my_df[, -4]     # Omit fourth column of my_df

# Remove the first column of sales: sales2
sales2 <- sales[,-1]

# Define a vector of column indices: keep
keep <- 5:(ncol(sales2)-15)

# Subset sales2 using keep: sales3
sales3 <- sales2[,keep]

head(sales3$event_date_time)
head(sales3$sales_ord_create_dttm)

# Load tidyr
library(tidyr)

# Split event_date_time: sales4
sales4 <- separate(sales3, event_date_time,
                   c("event_dt", "event_time"), sep = " ")

# Split sales_ord_create_dttm: sales5
sales5 <- separate(sales4, sales_ord_create_dttm,
                   c("ord_create_dt", "ord_create_time"), sep = " ")

# Load stringr
library(stringr)

# Find columns of sales5 containing "dt": date_cols
date_cols <- str_detect(names(sales5), "dt")

# Load lubridate
library(lubridate)

# Coerce date columns into Date objects
sales5[, date_cols] <- lapply(sales5[, date_cols], ymd)

# Find date columns (don't change)
date_cols <- str_detect(names(sales5), "dt")

# Create logical vectors indicating missing values (don't change)
missing <- lapply(sales5[, date_cols], is.na)

# Create a numerical vector that counts missing values: num_missing
num_missing <- sapply(missing, sum)

# Print num_missing
num_missing

# Combine the venue_city and venue_state columns
sales6 <- unite(sales5, venue_city_state, venue_city, venue_state, sep = ", ")

# View the head of sales6
head(sales6)

# Load readxl
library(readxl)

url_mbta <- 'http://s3.amazonaws.com/assets.datacamp.com/production/course_1294/datasets/mbta.xlsx'

download.file(url_mbta, 'mbta.xlsx')

mbta <- read_excel('mbta.xlsx', skip=1)

# View the structure of mbta
str(mbta)

# View the first 6 rows of mbta
head(mbta)

# View a summary of mbta
summary(mbta)

# Remove rows 1, 7, and 11 of mbta: mbta2
mbta2 <- mbta[c(-1,-7,-11),]

# Remove the first column of mbta2: mbta3
mbta3 <- mbta2[,-1]

# Load tidyr
library(tidyr)

# Gather columns of mbta3: mbta4
mbta4 <- gather(mbta3, key = "month", value = "thou_riders", -mode)

# View the head of mbta4
head(mbta4) 

# Coerce thou_riders to numeric
mbta4$thou_riders <- as.numeric(mbta4$thou_riders)

# Spread the contents of mbta4: mbta5
mbta5 <- spread(mbta4, mode, thou_riders)

# View the head of mbta5
head(mbta5)

# View the head of mbta5
head(mbta5)

# Split month column into month and year: mbta6
mbta6 <- separate(mbta5, month, c("year", "month"))

# View the head of mbta6
head(mbta6)

# View a summary of mbta6
summary(mbta6)

# Generate a histogram of Boat column
hist(mbta6$Boat)

# instead of using read.csv, you can use fread if the dataset is large.
# Set data.table = FALSE to return a dataframe instead of a data table
# library(data.table)
# fread("my_csv_file.csv", data.table = FALSE)

# View summary of food
summary(food)

# View head of food
head(food)

# View structure of food
str(food)

# can be info overload with large datasets. glimpse can be better

# Load dplyr
library(dplyr)

# View a glimpse of food
glimpse(food)

# View column names of food
names(food)

# some columns are contain duplicate info and can be removed. here's a list
duplicates <- c(4, 6, 11, 13, 15, 17, 18, 20, 22, 
                24, 25, 28, 32, 34, 36, 38, 40, 
                44, 46, 48, 51, 54, 65, 158)

# Remove duplicates from food: food2
food2 <- food[, -duplicates]

# the same can be done for useless columns
useless <- c(1, 2, 3, 32:41)

# Remove useless columns from food2: food3
food3 <- food2[, -useless]

# select only columns whose name contains the string "100g"
# Create vector of column indices: nutrition
nutrition <- str_detect(names(food3), "100g")

# View a summary of nutrition columns
summary(food3[,nutrition])

# Find indices of sugar NA values: missing
missing <- is.na(food3[,"sugars_100g"])

# Replace NA values with 0
food3$sugars_100g[missing] <- 0

# Create first histogram
hist(food3$sugars_100g, breaks = 100)

# Create food4
food4 <- food3[food3$sugars_100g > 0, ]

# Create second histogram
hist(food4$sugars_100g, breaks = 100)

# Find entries containing "plasti": plastic
plastic <- str_detect(food3$packaging, "plasti")

# Print the sum of plastic
sum(plastic)

# Load the gdata package
library(gdata)

# Import the spreadsheet: att
att = read.xls("attendance.xls")

# Print the column names 
names(att)

# Print the first 6 rows
head(att, nrows = 6)

# Print the last 6 rows
tail(att, nrows = 6)

# Print the structure
str(att)

# read.xls() function skips empty rows such as the 11th and 17th
# read.xls() function actually imported the first row of the original data frame as the variable name for the first column. Did you notice that the first 6 rows of att aren't the same as the first six rows you saw in the original spreadsheet? What about the 11th and 17th rows?

# compare with the spreadsheet
# http://s3.amazonaws.com/assets.datacamp.com/production/course_1294/datasets/attendance_screenshot.png

# remove unnecessary rows

# Create remove
remove <- c(3,56,57,58,59)

# Create att2
att2 <- att[-remove, ]

# remove unnecessary columns

# Create remove
remove <- c(3, 5, 7, 9, 11, 13, 15, 17)

# Create att3
att3 <- att2[, -remove]

# In this data frame, columns 1, 6, and 7 represent attendance data for US elementary schools, columns 1, 8, and 9 represent data for secondary schools, and columns 1 through 5 represent data for all schools in the US.
# 
# Each of these should be stored as its own separate data frame, so you'll split them up here.

# Subset just elementary schools: att_elem
att_elem <- att3[, c(1,6,7)]

# Subset just secondary schools: att_sec
att_sec <- att3[, c(1,8,9)]

# Subset all schools: att4
att4 <- att3[, 1:5]

# Define cnames vector (don't change)
cnames <- c("state", "avg_attend_pct", "avg_hr_per_day", 
            "avg_day_per_yr", "avg_hr_per_yr")

# Assign column names of att4
colnames(att4) <- cnames

# Remove first two rows of att4: att5
att5 <- att4[-c(1,2),]

# View the names of att5
names(att5)

# Remove all periods in state column
att5$state <- str_replace_all(att5$state, "\\.", "")

# Remove white space around state names
att5$state <- str_trim(att5$state)

# View the head of att5
head(att5)

library(dplyr)
example <- mutate_at(att5, vars(-state), funs(as.numeric))

# Define vector containing numerical columns: cols
cols <- -1

# Use sapply to coerce cols to numeric
att5[, cols] <- sapply(att5[, cols], as.numeric)