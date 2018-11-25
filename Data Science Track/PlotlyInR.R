# load the dplyr package
library(dplyr)

# Load sample student data
StudentData<-read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_1959/datasets/SampleClassData.csv")

# Dump the student data
StudentData

#Load the tidyr library
library(tidyr)

#Gather the data
GatheredStudentData <- StudentData %>% 
  gather(Indicator,Score, -SID,-First,-Last)

# Remove NA's
GatheredStudentData <- GatheredStudentData %>% 
  na.omit()

# Dump the student data
glimpse(GatheredStudentData)

# load the `plotly` package
library(plotly)

# This will create your very first plotly visualization
plot_ly(z = ~volcano)

# The diamonds dataset
str(diamonds)

# A firs scatterplot has been made for you
plot_ly(diamonds, x = ~carat, y = ~price)

# Replace ___ with the correct vector
plot_ly(diamonds, x = ~carat, y = ~price, color = ~carat)

# Replace ___ with the correct vector
plot_ly(diamonds, x = ~carat, y = ~price, color = ~carat, size = ~carat)


# Calculate the numbers of diamonds for each cut<->clarity combination
diamonds_bucket <- diamonds %>% count(cut, clarity)

# Replace ___ with the correct vector
plot_ly(diamonds_bucket, x = ~cut, y = ~n, type = "bar", color = ~clarity) 


# The Non Fancy Box Plot
plot_ly(y = ~rnorm(50), type = "box")

# The Fancy Box Plot
plot_ly(diamonds, y = ~price, color = ~cut, type = "box")

# The Super Fancy Box Plot
plot_ly(diamonds, x = ~cut, y = ~price, color = ~clarity, type = "box") %>%
  layout(boxmode = "group")
