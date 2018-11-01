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
