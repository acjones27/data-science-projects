df <- data.frame(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# Initialize output vector
output <- numeric(ncol(df))

# Fill in the body of the for loop
for (i in seq_along(df)) {            
  output[i] <- median(df[[i]])
}

# View the result
output

# Turn this code into col_median()

col_median <- function(df) {
  output <- numeric(ncol(df))
  for (i in seq_along(df)) {            
    output[[i]] <- median(df[[i]])      
  }
  output
}

# Change col_median() to a col_mean() function to find column means
col_mean <- function(df) {
  output <- numeric(ncol(df))
  for (i in seq_along(df)) {
    output[[i]] <- mean(df[[i]])
  }
  output
}

# Define col_sd() function
col_sd <- function(df) {
  output <- numeric(length(df))
  for (i in seq_along(df)) {
    output[[i]] <- sd(df[[i]])
  }
  output
}

# Add a second argument called power
f <- function(x, power) {
  # Edit the body to return absolute deviations raised to power
  abs(x - mean(x)) ^ power
}


# It may be kind of surprising that you can pass a function as an argument to another function, so let's verify first that it worked.
col_summary <- function(df, fun) {
  output <- numeric(ncol(df))
  for (i in seq_along(df)) {
    output[[i]] <- fun(df[[i]])
  }
  output
}

# Find the column medians using col_median() and col_summary()
col_median(df)
col_summary(df, median)

# Find the column means using col_mean() and col_summary()
col_mean(df)
col_summary(df, mean)

# Find the column IQRs using col_summary()
col_summary(df, IQR)


# All the map functions in purrr take a vector, .x, as the first argument, then return .f applied to each element of .x. The type of object that is returned is determined by function suffix (the part after _):
  
# map() returns a list or data frame
# map_lgl() returns a logical vector
# map_int() returns a integer vector
# map_dbl() returns a double vector
# map_chr() returns a character vector

# Load the purrr package
library(purrr)

# Use map_dbl() to find column means
map_dbl(df, mean)

# Use map_dbl() to column medians
map_dbl(df, median)

# Use map_dbl() to find column standard deviations
map_dbl(df, sd)

# The map functions use the ... ("dot dot dot") argument to pass along additional arguments to .f each time it’s called. For example, we can pass the trim argument to the mean() function:
  
map_dbl(df, mean, trim = 0.5)

# Multiple arguments can be passed along using commas to separate them. For example, we can also pass the na.rm argument to mean():
  
map_dbl(df, mean, trim = 0.5, na.rm = TRUE)

# Find the mean of each column
map_dbl(planes, mean)

# Find the mean of each column, excluding missing values
map_dbl(planes, mean, na.rm = TRUE)

# Find the 5th percentile of each column, excluding missing values
map_dbl(planes, quantile, probs = 0.05, na.rm = TRUE)

df3 <- data.frame( A = c(1,2,3), B = c("A", "B", "C"), C = c(0.5, -0.5, -3))

# Find the columns that are numeric
map_lgl(df3, is.numeric)

# Find the type of each column
map_chr(df3, typeof)

# Find a summary of each column
map(df3, summary)

cyl = split(mtcars, mtcars$cyl)

# Examine the structure of cyl
str(cyl)

# Extract the first element into four_cyls
four_cyls <- cyl[[1]]

# Fit a linear regression of mpg on wt using four_cyls
# Predict mpg using wt from the data set four_cyls
lm(mpg ~ wt, four_cyls)