# Import libraries ----
#  -> Nothing to do

# Import data ----
# Where we see the "files" on the lower right, move to this folder and click More --> set as working directory
setwd("~/data-science-projects/udemy_machine_learning_az/1_data_preprocessing")
dataset = read.csv("Data.csv")

# Missing data ----
dataset$Age <- ifelse(is.na(dataset$Age),
                      mean(dataset$Age, na.rm = TRUE),
                      dataset$Age)

dataset$Salary <- ifelse(is.na(dataset$Salary),
                         mean(dataset$Salary, na.rm = TRUE),
                         dataset$Salary)
  
# Categorical data ----
dataset$Country <- factor(dataset$Country, 
                          levels = c("France", "Spain", "Germany"),
                          labels = c(1, 2, 3))

dataset$Purchased <- factor(dataset$Purchased, 
                            levels = c("Yes", "No"),
                            labels = c(1, 0))

# Split into train/test set ----
# install.packages("caTools")
library(caTools)
set.seed(123)
# here we split based on y and we need to put the ratio for the train set
split = sample.split(dataset$Purchased, SplitRatio = 0.8)
# it returns true if an observation goes to the train set and false if it goes to the test set
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Feature scaling ----
# This is sort of a naive way as it doesn't use the test set as it would use new data i.e. it's doing a fit_transform on the test set too, where it should be only doing a transform
training_set[, 2:3] = scale(training_set[, 2:3])
test_set[, 2:3] = scale(test_set[, 2:3])

# This is closer to the python implementation
# install.packages("caret")
# library(caret)
# scale_param <- preProcess(training_set, method=c("center", "scale"))
# training_set <- predict(scale_param, training_set)
# test_set <- predict(scale_param, test_set)

