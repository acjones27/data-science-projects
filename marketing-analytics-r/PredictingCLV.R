library(dplyr)
library(corrplot)
library(ggplot2)
library(car)
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

# Estimating the full model except id
salesModel1 <- lm(salesThisMon ~ . - id, 
                  data = salesData)

# Checking variance inflation factors
vif(salesModel1)

# Estimating new model by removing information on brand
salesModel2 <- lm(salesThisMon ~ . -id -preferredBrand -nBrands, 
                  data = salesData)

# Checking variance inflation factors
vif(salesModel2)

# Good job! Since none of the variance inflation factors is greater than 10 we can certainly accept the second model.

# Model validation, Model fit, and Prediction
# Coefficient of determination R-squared tells you how much of the variation in your response variable is explained by the model
# F-test tells you if this amount is significant or not

# Overfitting happens when the model we create models not only the regression line but also the residuals
# Methods to avoid overfitting
# AIC() from stats package --> Used to compare two models, pick the one with the lowest AIC
# stepAIC() from MASS package
# out-of-sample model validation
# cross-validation

salesData2_4 <- read.csv("https://assets.datacamp.com/production/repositories/1861/datasets/cd1d99b917950fe8598a55fec5f884f04765a3aa/salesDataMon2To4.csv")


# getting an overview of new data
summary(salesData2_4)

# predicting sales
predSales5 <- predict(salesModel2, newdata = salesData2_4)

# calculating mean of future sales
mean(predSales5)
