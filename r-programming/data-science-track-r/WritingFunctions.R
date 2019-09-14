install.packages("here")
library(here)
here::here()

library(ggplot2)
library(dplyr)

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

# Rewrite the map() call to use the anonymous function
# function(df) lm(mpg ~ wt, data = df).
# map(cyl, fit_reg)

# Rewrite to call an anonymous function
map(cyl, function(df) lm(mpg ~ wt, data = df))

# Rewrite to use the formula shortcut instead
map(cyl, ~lm(mpg ~ wt, data = .))

# Save the result from the previous exercise to the variable models
models <- map(cyl, ~ lm(mpg ~ wt, data = .))

# Use map and coef to get the coefficients for each model: coefs
coefs <- map(models, coef)

# Use string shortcut to extract the wt coefficient
map(coefs, "wt")

# use map_dbl with the numeric shortcut to pull out the second element
map_dbl(coefs, 2)

mtcars %>%
  split(mtcars$cyl) %>%
  map(~ lm(mpg ~ wt, data = .)) %>%
  map(coef) %>%
  map_dbl("wt")

# Define models (don't change)
models <- mtcars %>%
  split(mtcars$cyl) %>%
  map(~ lm(mpg ~ wt, data = .))

# Rewrite to be a single command using pipes
summaries <- map(models, summary)
map_dbl(summaries, "r.squared")

# Rewrite to be a single command using pipes
models %>%
  map(summary) %>%
  map_dbl("r.squared")

# safely() is an adverb; it takes a verb and modifies it. That is, it takes a function as an argument and it returns a function as its output. The function that is returned is modified so it never throws an error (and never stops the rest of your computation!).

# Instead, it always returns a list with two elements:

# - result is the original result. If there was an error, this will be NULL.
# - error is an error object. If the operation was successful this will be NULL.

# Create safe_readLines() by passing readLines() to safely()
safe_readLines <- safely(readLines)

# Call safe_readLines() on "http://example.org"
example_lines <- safe_readLines("http://example.org")
example_lines

# Call safe_readLines() on "http://asdfasdasdkfjlda"
nonsense_lines <- safe_readLines("http://asdfasdasdkfjlda")
nonsense_lines

urls <- list(
  example = "http://example.org",
  rproj = "http://www.r-project.org",
  asdf = "http://asdfasdasdkfjlda"
)

# Throws an error with no info
map(urls, readLines)

# Define safe_readLines()
safe_readLines <- safely(readLines)

# Use the safe_readLines() function with map(): html
html <- map(urls, safe_readLines)

# Call str() on html
str(html)

# Extract the result from one of the successful elements
html[[1]]

# Extract the error from the element that was unsuccessful
html[[3]]

# Define safe_readLines() and html
safe_readLines <- safely(readLines)
html <- map(urls, safe_readLines)

# Examine the structure of transpose(html)
str(transpose(html))

# Extract the results: res
res <- transpose(html)[["result"]]

# Extract the errors: errs
errs <- transpose(html)[["error"]]

# Initialize some objects
safe_readLines <- safely(readLines)
html <- map(urls, safe_readLines)
res <- transpose(html)[["result"]]
errs <- transpose(html)[["error"]]

# Create a logical vector is_ok
is_ok <- map_lgl(errs, is_null)

# Extract the successful results
res[is_ok == TRUE]

# Find the URLs that were unsuccessful
urls[!is_ok]

# We'll use random number generation as an example throughout the remaining exercises in this chapter. To get started, let's imagine simulating 5 random numbers from a Normal distribution. You can do this in R with the rnorm() function. For example, to generate 5 random numbers from a Normal distribution with mean zero, we can do:

rnorm(n = 5)

# Now, imagine you want to do this three times, but each time with a different sample size.

# Create a list n containing the values: 5, 10, and 20
n <- c(5, 10, 20)

# Call map() on n with rnorm() to simulate three samples
map(n, rnorm)

# k, but now imagine we don't just want to vary the sample size, we also want to vary the mean. The mean can be specified in rnorm() by the argument mean. Now there are two arguments to rnorm() we want to vary: n and mean.

# The map2() function is designed exactly for this purpose; it allows iteration over two objects. The first two arguments to map2() are the objects to iterate over and the third argument .f is the function to apply.

# Initialize n
n <- list(5, 10, 20)

# Create a list mu containing the values: 1, 5, and 10
mu <- list(1, 5, 10)

# Edit to call map2() on n and mu with rnorm() to simulate three samples
map2(n, mu, rnorm)

# But wait, there's another argument to rnorm() we might want to vary: sd, the standard deviation of the Normal distribution. You might think there is a map3() function, but there isn't. Instead purrr provides a pmap() function that iterates over 2 or more arguments.

# pmap() takes a list of arguments as its input. For example, we could replicate our previous example, iterating over both n and mu with the following:

n <- list(5, 10, 20)
mu <- list(1, 5, 10)

pmap(list(n, mu), rnorm)

# Create a sd list with the values: 0.1, 1 and 0.1
sd <- list(0.1, 1, 0.1)

# Edit this call to pmap() to iterate over the sd list as well
pmap(list(n, mu, sd), rnorm)

# Name the elements of the argument list
# pmap(list(mu, n, sd), rnorm)
pmap(list(mean = mu, n = n, sd = sd), rnorm)

# Sometimes it's not the arguments to a function you want to iterate over, but a set of functions themselves. Imagine that instead of varying the parameters to rnorm() we want to simulate from different distributions, say, using rnorm(), runif(), and rexp(). How do we iterate over calling these functions?

# In purrr, this is handled by the invoke_map() function.

# In more complicated cases, the functions may take different arguments, or we may want to pass different values to each function. In this case, we need to supply invoke_map() with a list, where each element specifies the arguments to the corresponding function.

# Define list of functions
funs <- list("rnorm", "runif", "rexp")

# Parameter list for rnorm()
rnorm_params <- list(mean = 10)

# Add a min element with value 0 and max element with value 5
runif_params <- list(min= 0, max = 5)

# Add a rate element with value 5
rexp_params <- list(rate = 5)

# Define params for each function
params <- list(
  rnorm_params,
  runif_params,
  rexp_params
)

# Call invoke_map() on funs supplying params and setting n to 5
invoke_map(funs, params, n = 5)


# walk() operates just like map() except it's designed for functions that don't return anything. You use walk() for functions with side effects like printing, plotting or saving.
# Let's check that our simulated samples are in fact what we think they are by plotting a histogram for each one.

# Define list of functions
funs <- list(Normal = "rnorm", Uniform = "runif", Exp = "rexp")

# Define params
params <- list(
  Normal = list(mean = 10),
  Uniform = list(min = 0, max = 5),
  Exp = list(rate = 5)
)

# Assign the simulated samples to sims
sims <- invoke_map(funs, params, n = 50)

# Use walk() to make a histogram of each element in sims
walk(sims, hist)

# Replace "Sturges" with reasonable breaks for each sample
breaks_list <- list(
  Normal = seq(6, 16, 0.5),
  Uniform = seq(0, 5, 0.25),
  Exp = seq(0, 1.5, 0.1)
)

# Use walk2() to make histograms with the right breaks
walk2(sims, breaks_list, hist)

# Turn this snippet into find_breaks()
find_breaks <- function(x) {
  rng <- range(x, na.rm = TRUE)
  seq(rng[1], rng[2], length.out = 30)
}

# Call find_breaks() on sims[[1]]
find_breaks(sims[[1]])

# Use map() to iterate find_breaks() over sims: nice_breaks
nice_breaks <- map(sims, find_breaks)

# Use nice_breaks as the second argument to walk2()
walk2(sims, nice_breaks, hist)

# Increase sample size to 1000
sims <- invoke_map(funs, params, n = 1000)

# Compute nice_breaks (don't change this)
nice_breaks <- map(sims, find_breaks)

# Create a vector nice_titles
nice_titles <- c("Normal(10, 1)", "Uniform(0, 5)", "Exp(5)")

# Use pwalk() instead of walk2()
pwalk(list(x = sims, breaks = nice_breaks, main = nice_titles), hist, xlab = "")

# Pipe this along to map(), using summary() as .f
sims %>%
  walk(hist) %>%
  map(summary)

# Using stopifnot() is a quick way to have your function stop, if a condition isn't met. stopifnot() takes logical expressions as arguments and if any are FALSE an error will occur.

# Define troublesome x and y
x <- c(NA, NA, NA)
y <- c( 1, NA, NA, NA)

both_na <- function(x, y) {
  # Add stopifnot() to check length of x and y
  stopifnot(length(x) == length(y) )

  sum(is.na(x) & is.na(y))
}

# Call both_na() on x and y
both_na(x, y)

# Using stop() instead of stopifnot() allows you to specify a more informative error message. Recall the general pattern for using stop() is:
#
#   if (condition) {
#     stop("Error", call. = FALSE)
#   }
# We recommend your error tells the user what should be true, not what is false.
# For example, here a good error would be "x and y must have the same length", rather than the bad error "x and y don't have the same length"

# Define troublesome x and y
x <- c(NA, NA, NA)
y <- c( 1, NA, NA, NA)

both_na <- function(x, y) {
  # Replace condition with logical
  if (length(x) != length(y)) {
    # Replace "Error" with better message
    stop("x and y must have the same length", call. = FALSE)
  }

  sum(is.na(x) & is.na(y))
}

# Call both_na()
both_na(x, y)

# Side effects describe the things that happen when you run a function that alters the state of your R session. If foo() is a function with no side effects (a.k.a. pure), then when we run x <- foo(), the only change we expect is that the variable x now has a new value. No other variables in the global environment should be changed or created, no output should be printed, no plots displayed, no files saved, no options changed. We know exactly the changes to the state of the session just by reading the call to the function.

# sapply calls
A <- sapply(df[1:4], class)
B <- sapply(df[3:4], class)
C <- sapply(df[1:2], class)

# Demonstrate type inconsistency
str(A)
str(B)
str(C)

# Use map() to define X, Y and Z
X <- map(df[1:4], class)
Y <- map(df[3:4], class)
Z <- map(df[1:2], class)

# Use str() to check type consistency
str(X)
str(Y)
str(Z)

col_classes <- function(df) {
  # Assign list output to class_list
  class_list <- map(df, class)

  # Use map_chr() to extract first element in class_list
  map_chr(class_list, 1)
}

# Check that our new function is type consistent
df %>% col_classes() %>% str()
df[3:4] %>% col_classes() %>% str()
df[1:2] %>% col_classes() %>% str()

# As you write more functions, you'll find you often come across this tension between implementing a function that does something sensible when something surprising happens, or simply fails when something surprising happens. Our recommendation is to fail when you are writing functions that you'll use behind the scenes for programming and to do something sensible when writing functions for users to use interactively.

# (And by the way, flatten_chr() is yet another useful function in purrr. It takes a list and removes its hierarchy. The suffix _chr indicates that this is another type consistent function, and will either return a character string or an error message.)

col_classes <- function(df) {
  class_list <- map(df, class)

  # Add a check that no element of class_list has length > 1
  if (any(map_dbl(class_list, length) > 1)) {
    stop("Some columns have more than one class", call. = FALSE)
  }

  # Use flatten_chr() to return a character vector
  flatten_chr(class_list)
}

# Check that our new function is type consistent
df %>% col_classes() %>% str()
df[3:4] %>% col_classes() %>% str()
df[1:2] %>% col_classes() %>% str()


diamonds_sub <- diamonds[1:20,]

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, 7)

# There are two instances in which the non-standard evaluation of filter() could cause surprising results:

# The x column doesn't exist in df.
# There is a threshold column in df.

# Create a threshold column with value 100
diamonds_sub$threshold <- 100

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, 7)

diamonds_sub <- diamonds[1:20,]

# Remove the x column from diamonds
diamonds_sub$x <- NULL

# Create variable x with value 1
x <- 1

# Use big_x() to find rows in diamonds_sub where x > 7
big_x(diamonds_sub, 7)

big_x <- function(df, threshold) {
  # Write a check for x not being in df
  if (!"x" %in% colnames(df)) {
    stop("df must contain variable called x", call. = FALSE)
  }

  # Write a check for threshold being in df
  if ("threshold" %in% colnames(df)) {
    stop("df must not contain variable called threshold", call. = FALSE)
  }

  dplyr::filter(df, x > threshold)
}

# This is the default behavior
options(stringsAsFactors = TRUE)

# Read in the swimming_pools.csv to pools
pools <- read.csv("swimming_pools.csv")

# Examine the structure of pools
str(pools)

# Change the global stringsAsFactors option to FALSE
options(stringsAsFactors = FALSE)

# Read in the swimming_pools.csv to pools2
pools2 <- read.csv("swimming_pools.csv")

# Examine the structure of pools2
str(pools2)

# Start with this
options(digits = 8)

# Fit a regression model
fit <- lm(mpg ~ wt, data = mtcars)

# Look at the summary of the model
summary(fit)

# Set the global digits option to 2
options(digits = 2)

# Take another look at the summary. notice no change
summary(fit)