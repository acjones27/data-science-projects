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