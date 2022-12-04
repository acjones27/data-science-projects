# RECODING VARIABLES
#Assign the value of mtcars to the new variable mtcars2
mtcars2 <- mtcars

#Assign the label "high" to mpgcategory where mpg is greater than or equal to 20
mtcars2$mpgcategory[mtcars$mpg >= 20] <- "high"

#Assign the label "low" to mpgcategory where mpg is less than 20

mtcars2$mpgcategory[mtcars$mpg < 20] <- "low"

#Assign mpgcategory as factor to mpgfactor
mtcars2$mpgfactor <- as.factor(mtcars2$mpgcategory)

# FREQUENCY TABLES
# Frequency tables show you how often a given value occurs. To look at a frequency table of the data in R, use the function table(). The top row of the output is the value, and the bottom row is the frequency of the value.

# How many of the cars have a manual transmission?
table(mtcars$am)

# What percentage of cars have 3 or 5 gears?
table(mtcars$gear)

# BARPLOTS
# The first argument of barplot() is a vector containing the heights of each bar. These heights correspond to the proportional frequencies of a desired measure in your data. You can obtain this information using the table() function.

# Assign the frequency of the mtcars variable "am" to a variable called "height"
height <- table(mtcars$am)

# Create a barplot of "height"
barplot(height)

# vector of bar heights
height <- table(mtcars$am)

# Make a vector of the names of the bars called "barnames"
barnames <- c("automatic", "manual")

# Label the y axis "number of cars" and label the bars using barnames
barplot(height, ylab = "number of cars", names.arg = barnames)

# HISTOGRAMS
# It can be useful to plot frequencies as histograms to visualize the spread of our data

# Make a histogram of the carb variable from the mtcars data set. Set the title to "Carburetors"

hist(mtcars$carb, main = "Carburetors")

# arguments to change the y-axis scale to 0 - 20, label the x-axis and colour the bars red
hist(mtcars$carb, main = "Carburetors", ylim = c(0, 20), xlab = "Number of Carburetors", col = "red")

# Q: Why did we make a bar graph of transmission (mtcars$am), but a histogram of carburetors (mtcars$carb)
# A: Because transmission is categorical, and carb is continuous

# Calculate the mean miles per gallon
mean(mtcars$mpg)

# Calculate the median miles per gallon
median(mtcars$mpg)

# There's no mode function in R
# Produce a sorted frequency table of `carb` from `mtcars`
sort(table(mtcars$carb), decreasing = TRUE)

# Get the quantiles from a variable
quantile(mtcars$qsec)

# To better visualise your data's quartiles you can create a boxplot using the function boxplot() (in the same way as you used hist() and barplot()).

# Make a boxplot of qsec
boxplot(mtcars$qsec)

# Calculate the interquartile range of qsec
IQR(mtcars$qsec)

# In the boxplot you created you can see a circle above the boxplot. This indicates an outlier. We can calculate an outlier as a value 1.5 * IQR above the third quartile, or 1.5 * IQR below the first quartile.

# We can also measure the spread of data through the standard deviation. You can calculate these using the function sd(), which takes a vector of the variable in question as its first argument.

# Find the IQR of horsepower
IQR(mtcars$hp)

# Find the standard deviation of horsepower
sd(mtcars$hp)

# Find the IQR of miles per gallon
IQR(mtcars$mpg)

# Find the standard deviation of miles per gallon
sd(mtcars$mpg)

# Mean, median and mode are all measures of the average. In a perfect normal distribution the mean, median and mode values are identical, but when the data is skewed this changes. In the the graph on the right which of the following statements are most accurate?

# We can calculate the z-score for a given value (X) as (X - mean) / standard deviation. In R you can do this with a whole variable at once by putting the variable name in the place of X

# Calculate the z-scores of mpg
X <- mtcars$mpg
m <- mean(X)
s <- sd(X)

(X - m)/s