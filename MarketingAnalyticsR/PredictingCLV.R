library(dplyr)
library(corrplot)
library(ggplot2)
# The dataset salesData is loaded in the workspace. It contains information on customers for the months one to three. Only the sales of month four are included.

salesData <- read.csv("https://assets.datacamp.com/production/repositories/1861/datasets/c18f1ab90ca134ecd8ab51ed34d285df9fc3059b/salesData.csv")

# Structure of dataset
str(salesData, give.attr = FALSE)

# Visualization of correlations
salesData %>% select_if(is.numeric) %>%
  select(-id) %>%
  cor() %>% 
  corrplot()

# Boxplots displaying the distribution of the salesThisMon dependent on the levels of the categorial variable FreqStore
ggplot(salesData) +
  geom_boxplot(aes(x = mostFreqStore, y = salesThisMon))

# Make boxplots displaying the distribution of the salesThisMon dependent on the levels of the categorial variable preferredBrand
ggplot(salesData) +
  geom_boxplot(aes(x = preferredBrand, y = salesThisMon))

# Which variables are probably well suited to explain the sales of this month? Got an idea? Let's move on to the simple linear regression.
# We saw that the sales in the last three months are strongly positively correlated with the sales in this month. Hence we will start off including that as an explanatory variable in a linear regression.

names(salesData)

# Model specification using lm
salesSimpleModel <- lm(salesThisMon ~ salesLast3Mon, 
                       data = salesData)

# Looking at model summary
summary(salesSimpleModel)

# Look at the regression coefficient. Is there a positive or negative relationship between the two variables?
# There's a positive relationship at 0.38 since > 0

# About how much of the variation in the sales in this month can be explained by the sales of the previous three months?
# Looking at R-sq, about 59% of the data can be explained by this model
