custdata <- read.table("custdata.tsv", header = T, sep = '\t')

summary(custdata)
summary(custdata$income)
summary(custdata$age)

Income <- custdata$income / 1000
summary(Income)

library(ggplot2)

ggplot(custdata) +
  geom_histogram(aes(x = age), binwidth = 5, fill = "grey")

library(scales)

ggplot(custdata) + 
  geom_density(aes(x = income)) + 
  scale_x_continuous(labels = dollar)

ggplot(custdata) + 
  geom_density(aes(x = income)) + 
  scale_x_log10(breaks = c(100, 1000, 10000, 100000), labels = dollar) + 
  annotation_logticks(sides = "bt")

ggplot(custdata) + 
  geom_bar(aes(x = marital.stat), fill = "grey")

ggplot(custdata) +
  geom_bar(aes(x = state.of.res), fill = "grey") +
  coord_flip() +
  theme(axis.text.y = element_text(size = rel(0.8))) 
# reduce size of y-axis tick labels to 80% of default size for legibility

# better to order the categories by count
# to do this, we need to manually specify the order of the categories in the factor variable, not ggplot

statesums <- table(custdata$state.of.res) # frequency table for states. same data in bar chart
statef <- as.data.frame(statesums)
colnames(statef) <- c("state.of.res", "count")
levels(statef$state.of.res)

# reorders the factors
statef <- transform(statef, state.of.res = reorder(state.of.res, count))
levels(statef$state.of.res)

ggplot(statef) + 
  geom_bar(aes(x = state.of.res, y = count), 
               stat = "identity",
               fill = "grey") +
  coord_flip() +
  theme(axis.text.y = element_text(size = rel(0.8)))

# Line plots work best when relationship between two vars is relatively clean i.e. each x value has a unique y value
x <- runif(100)
y <- x^2 + 0.2*x
ggplot(data.frame(x = x, y = y), aes(x = x, y = y)) + 
  geom_line()

# are age and income related? if they track each other perfectly, you might not want to use both variables in a model for health insurance. The appropriate summary statistic is correlation
custdata2 <- subset(custdata, (custdata$age > 0 & custdata$age < 100 & custdata$income > 0))
cor(custdata2$age, custdata2$income)

ggplot(custdata2, aes(x = age, y = income)) + 
  geom_point() + 
  ylim(0, 200000)

ggplot(custdata2, aes(x = age, y = income)) + 
  geom_point() + 
  stat_smooth(method = "lm") +
  ylim(0, 200000)

ggplot(custdata2, aes(x = age, y = income)) + 
  geom_point() + 
  stat_smooth() +
  ylim(0, 200000)

ggplot(custdata2, aes(x = age, y = as.numeric(health.ins))) + 
  geom_point(position = position_jitter(w = 0.05, h = 0.05)) +
  geom_smooth()

install.packages("hexbin")
library(hexbin)

ggplot(custdata2, aes(x = age, y = income)) + 
  geom_hex(binwidth = c(5, 10000)) +
  geom_smooth(color = "white", se = F) +
  ylim(0, 200000)

# bar charts for 2 categorical variables

# stacked
ggplot(custdata) + 
  geom_bar(aes(x = marital.stat, fill = health.ins))

# side-by-side
ggplot(custdata) + 
  geom_bar(aes(x = marital.stat, fill = health.ins), position = "dodge")

# filled
ggplot(custdata) + 
  geom_bar(aes(x = marital.stat, fill = health.ins), position = "fill")

# to get a simulateous sense of both the population in each category and the ratio of insured to uninsured, you can add what's called a rug to the filled bar chart

ggplot(custdata, aes(x = marital.stat)) + 
  geom_bar(aes(fill = health.ins), position = "fill") +
  geom_point(aes(y = -0.05), size = 0.75, alpha = 0.3, position = position_jitter(h = 0.01))

custdata3 <- subset(custdata2, !is.na(housing.type))

ggplot(custdata3) + 
  geom_bar(aes(x = housing.type, fill = marital.stat), position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # could also use coord flip instead

ggplot(custdata3) + 
  geom_bar(aes(x = marital.stat), position = "dodge", fill = "darkgray") +
  facet_wrap(~housing.type, scales = "free_y") + # each graph has its own y-axis scale
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # NOTE: facet_wrap is incompatible with coord_flip, so we have to use element text here


# Histogram or density plot:
# - Examines data range
# - Checks number of modes
# - Checks if distribution is normal/lognormal
# - Checks for abnormalities/outliers
 
# Bar chart
# - Compares relative or absolute frequencies of the values of a categorical variable
 
# Line plot
# - Relationship between two continuous variables. Best when relationship is functional
 
# Scatter plot
# - Shows the relationship between two continuous variables. Best when relationship is too loose to be seen on a line plot

# Smoothing curve
# - Shows underlying average relationship, or trend, between two continuous variables.
# - Can also be used to show the relationship between a continuous and a boolean bariavle: the fraction of true values of the discrete variable as a function of the continuous
 
# Hexbin plot
# - Relationship between two continuous variables
 
# Stacked bar chart
# - Shows the relationship between two categorical variables. Highlights the frequencies of each value
 
# Side-by-side bar chart
# - Shows the relationship between two categorical variables. Good for comparing frequencies of each value of var2 across the values of var1
 
# Filled bar chart
# - Shows relationship between two categorical variables. Good for comparing relative frequencies of each value of var2 within each value of var1. Best when var2 is binary.

# Bar chart with faceting
# - Relationship between two categorical variables. Best for comparing relative frequencies of each value of var2 within each value of var1 when var2 takes on more than two values.