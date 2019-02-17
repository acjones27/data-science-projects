### FUNCTIONS
# The function template is a useful way to start writing a function:

my_fun <- function(arg1, arg2) {
  # body
}


# Define ratio() function
ratio <- function(x, y) {
  x / y
}

# Call ratio() with arguments 3 and 4
ratio(3, 4)

# You probably either did ratio(3, 4), which relies on matching by position, or ratio(x = 3, y = 4), which relies on matching by name.
 
# However, beyond the first couple of arguments you should always use matching by name. It makes your code much easier for you and others to read. This is particularly important if the argument is optional, because it has a default. When overriding a default value, it's good practice to use the name.

# Rewrite the call to follow best practices
# mean(0.1,x=c(1:9, NA),TRUE)

mean(c(1:9, NA), trim = 0.1, na.rm = TRUE)

### SCOPE

# Consider the following:
  
y <- 10
f <- function(x) {
  x + y
}

# Q: What will f(10) return?
# A: It will return 20. Since y is not defined locally (inside the function) it will look one level up, i.e. globally. There it will find y = 10 so f(10) = 20

# Consider the following:

y <- 10
f <- function(x) {
  y <- 5
  x + y
}

# Q: What will f(10) return?
# A: It will return 15. First the function will look locally for y, so it will find y = 5.

# This one's a little different. Instead of predicting what the function will return, you need to predict the value of a variable. We run the following in a fresh session in the console:

f <- function(x) {
  y <- 5
  x + y
}
f(5)

# Q: Now, what will typing y return?
# A: It will return an error since y is only defined locally inside the function and it's cleared at the end of the function call

### TYPES and SUBSETTING
# 2nd element in tricky_list
typeof(tricky_list[[2]])

# Element called x in tricky_list
typeof(tricky_list[["x"]])

# 2nd element inside the element called x in tricky_list
typeof(tricky_list[["x"]][[2]])

# Now, tricky_list has a regression model stored in it. Let's see if we can drill down and pull out the slope estimate corresponding to the wt variable.

# Guess where the regression model is stored
names(tricky_list)

# Use names() and str() on the model element
names(tricky_list[["model"]])
str(tricky_list[["model"]])

# Subset the coefficients element
tricky_list[["model"]][["coefficients"]]

# Subset the wt element
tricky_list[["model"]][["coefficients"]][["wt"]]

### FOR LOOPS
# Original for loop

for (i in 1:ncol(df)) {
  print(median(df[[i]]))
}

# Replace the 1:ncol(df) sequence
for (i in seq_along(df)) {
  print(median(df[[i]]))
}

# Create an empty data frame
empty_df <- data.frame()

# Repeat for loop to verify there is no error
for (i in seq_along(empty_df)) {
  print(median(empty_df[[i]]))
}

# Our for loop does a good job displaying the column medians, but we might want to store these medians in a vector for future use.

# Before you start the loop, you must always allocate sufficient space for the output, let's say an object called output. This is very important for efficiency: if you grow the for loop at each iteration (e.g. using c()), your for loop will be very slow.

# A general way of creating an empty vector of given length is the vector() function. It has two arguments: the type of the vector ("logical", "integer", "double", "character", etc.) and the length of the vector.

# Create new double vector: output
output <- vector("double", ncol(df))

# Alter the loop
for (i in seq_along(df)) {
  # Change code to store result in output
  output[[i]] <- median(df[[i]])
}

# Print output
print(output)

### WRITING FUNCTIONS

# Define example vector x
x <- c(1:10,NA)

# Rewrite this snippet to refer to x
# (df$a - min(df$a, na.rm = TRUE)) /
#   (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
(x - min(x, na.rm = TRUE)) /
  (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
 
# We still have repetition with min call
# Define rng (The minimum is the first value of rng and the maximum is the second value of rng.)
rng = range(x, na.rm = TRUE)

# Rewrite this snippet to refer to the elements of rng
(x - rng[[1]]) / (rng[[2]] - rng[[1]])

# Use the function template to create the rescale01 function
rescale01 <- function(x) {
  rng = range(x, na.rm = TRUE)
  
  (x - rng[[1]]) / (rng[[2]] - rng[[1]])
}

# Test your function, call rescale01 using the vector x as the argument
rescale01(x)

# Define example vectors x and y
x <- c( 1, 2, NA, 3, NA)
y <- c(NA, 3, NA, 3,  4)

# Count how many elements are missing in both x and y
sum(is.na(x) & is.na(y))

# Turn this snippet into a function: both_na()

both_na <- function(x, y) {
  sum(is.na(x) & is.na(y))
}

# Let's test it on more complex examples

# Define x, y1 and y2
x <-  c(NA, NA, NA)
y1 <- c( 1, NA, NA)
y2 <- c( 1, NA, NA, NA)

# Call both_na on x, y1
both_na(x, y1)
# Returns 2 as expected

# Call both_na on x, y2
both_na(x, y2)
# Returns 3 and a warning. Not exactly as expected. Should probably return an error

### FUNCTION CODE STYLE

# Function names should be verbs, like remove_last (not removed, or my_function_name)
# Similarly, arguments should be clear. Use df for data frames; x, y, z for vectors; n for rows and p for columns; and stick to a consistent style e.g. snake case or camel case
# For the order of arguments, it goes data first e.g. x or df, followed by optional detail arguments. Detail arguments should also be given default values

# Rewrite mean_ci to take arguments named level and x
mean_ci <- function(level, x) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, level / 2))
}

# Alter the arguments to mean_ci
mean_ci <- function(x, level = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - level
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

# Alter the mean_ci function to return an error if the vector is empty = numeric(0)
mean_ci <- function(x, level = 0.95) {
  if (length(x) == 0) { 
    warning("`x` was empty", call. = FALSE)
    return(c(-Inf, Inf))
  } else {
    se <- sd(x) / sqrt(length(x))
    alpha <- 1 - level
    mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
  }
}

# Here's a poorly written function, which is also available in your workspace:

f <- function(x, y) {
  x[is.na(x)] <- y
  cat(sum(is.na(x)), y, "\n")
  x
}

# Your job is to turn it in to a nicely written function.

# What does this function do? Let's try to figure it out by passing in some arguments.

# Define a numeric vector x with the values 1, 2, NA, 4 and 5
x <- c(1, 2, NA, 4, 5)

# Call f() with the arguments x = x and y = 3
f(x = x, y = 3)
# Returns: 0 3
# [1] 1 2 3 4 5

# Call f() with the arguments x = x and y = 10
f(x = x, y = 10)
# Returns: 0 10
# [1]  1  2 10  4  5

# Rename the function f() to replace_missings()
replace_missings <- function(x, replacement) {
  # Change the name of the y argument to replacement
  x[is.na(x)] <- replacement
  cat(sum(is.na(x)), replacement, "\n")
  x
}

# Rewrite the call on df$z to match our new names
# df$z <- replace_missings(df$z, replacement = 0)

replace_missings <- function(x, replacement) {
  # Define is_miss
  is_miss <- is.na(x)
  
  # Rewrite rest of function to refer to is_miss
  x[is_miss] <- replacement
  cat(sum(is_miss), replacement, "\n")
  x
}

# Give a more informative message
replace_missings <- function(x, replacement) {
  is_miss <- is.na(x)
  x[is_miss] <- replacement
  
  # Rewrite to use message()
  message(sum(is_miss), " missings replaced by the value ", replacement, "\n")
  x
}

# Check your new function by running on df$z
replace_missings(df$z, replacement = 0)