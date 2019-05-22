# This dataset is about bank customers and will be used to predict if customers will default on their loan payments.

library(dplyr)
library(corrplot)
library(ggplot2)
library(car)
library(MASS)

defaultData <- read.csv("https://assets.datacamp.com/production/repositories/1861/datasets/0b0772985a8676c3613e8ac2c6053f5e60a3aebd/defaultData.csv", sep = ';')

# Summary of data
summary(defaultData)

# Look at data structure
str(defaultData)

# Analyze the balancedness of dependent variable
ggplot(defaultData,aes(x = PaymentDefault)) +
  geom_histogram(stat = "count") 

# You have seen the glm() command for running a logistic regression. glm() stands for generalized linear model and offers a whole family of regression models.

# Build logistic regression model
logitModelFull <- glm(PaymentDefault ~ limitBal + sex + education + marriage +
                        age + pay1 + pay2 + pay3 + pay4 + pay5 + pay6 + billAmt1 + 
                        billAmt2 + billAmt3 + billAmt4 + billAmt5 + billAmt6 + payAmt1 + 
                        payAmt2 + payAmt3 + payAmt4 + payAmt5 + payAmt6, 
                      family = binomial, data = defaultData)

# Take a look at the model
summary(logitModelFull)

# Take a look at the odds
coefsexp <- coefficients(logitModelFull) %>% exp() %>% round(2)
coefsexp

# E.g. "Being married increases the odds of defaulting on a payment by 0.84 compared to not being married"

# What is the correct interpretation of a p value equal to 0.05 for a variable's coefficient, when we have the following null hypothesis:

# H0: The influence of this variable on the payment default of a customer is equal to zero.
# The probability of finding this coefficient's value is only 5%, given that our null hypothesis (the respective coefficient is equal to zero) is true.

# The stepAIC() function gives back a reduced model

#Build the new model
# Set trace = 0, as you do not want to get an output for the whole model selection process
logitModelNew <- stepAIC(logitModelFull, trace = 0) 

#Look at the model
summary(logitModelNew) 

# Save the formula of the new model (it will be needed for the out-of-sample part) 
formulaLogit <- as.formula(summary(logitModelNew)$call)
formulaLogit
