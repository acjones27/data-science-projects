# Measures of Location

# Mean
mean(df[["Column 1"]])

# Median
median(df[["Column 1"]])

# Trimmed mean
mean(df[["Column 1"]], trim = 0.1)

# Weighted mean
weighted.mean(state[["Murder rate"]], w = state[["Population"]])

# Weighted median
# To calculate the weighted median, we first sort the data, then give a weight to each point
# The weighted median is he value such that the sum of weights is equal for lower and upper halves
library(matrixStats)
weightedMedian(state[["Murder rate"]], w = state[["Population"]])

# Measures of variability

# Mean absolute difference, MAD

# Variance and Standard deviation
# Standard deviation is more intuitive than variance as it's on the same scale
# It might seem weird that people prefer SD over MAD but mathematically working with squared values is much easier than absolute values

# 
