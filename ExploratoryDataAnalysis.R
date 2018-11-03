comics <- read.csv("https://assets.datacamp.com/production/course_1796/datasets/comics.csv")

# Print the first rows of the data
head(comics)

# Check levels of align
levels(comics$align)

# Check the levels of gender
levels(comics$gender)

# Create a 2-way contingency table
tab <- table(comics$align, comics$gender)

# Load dplyr
library(dplyr)

# Print tab
print(tab)

# Remove align level
comics_filtered <- comics %>%
  filter(align != "Reformed Criminals") %>%
  droplevels()

# See the result
comics_filtered

# Load ggplot2
library(ggplot2)

# Create side-by-side barchart of gender by alignment
# Passing the argument position = "dodge" to geom_bar() says that you want a side-by-side (i.e. not stacked) barchart.
ggplot(comics, aes(x = align, fill = gender)) + 
  geom_bar(position = "dodge")

# Create side-by-side barchart of alignment by gender
ggplot(comics, aes(x = gender, fill = align)) + 
  geom_bar(position = "dodge") +
  theme(axis.text.x = element_text(angle = 90))

tab <- table(comics$align, comics$gender)
options(scipen = 999, digits = 3) # Print fewer digits
prop.table(tab)     # Joint proportions
prop.table(tab, 1)  # Conditional on rows
prop.table(tab, 2)  # Conditional on columns

# Plot of gender by align
ggplot(comics, aes(x = align, fill = gender)) +
  geom_bar()

# Plot proportion of gender, conditional on align
# position = "fill" means stacked bar chart
ggplot(comics, aes(x = align, fill = gender)) + 
  geom_bar(position = "fill") +
  ylab("proportion")

# sidenote: bar charts are preferable to pie charts because it can often be difficult to assess the relative size of each slice by eye

table(comics$align)

# Change the order of the levels in align
comics$align <- factor(comics$align, 
                       levels = c("Bad", "Neutral", "Good"))

# Create plot of align
ggplot(comics, aes(x = align)) + 
  geom_bar()

# Plot of alignment broken down by gender
ggplot(comics, aes(x = align)) + 
  geom_bar(fill = "blue") + #change colour of bars
  facet_wrap(~ gender)

cars <- read.csv("https://assets.datacamp.com/production/course_1796/datasets/cars04.csv")

# Load package
library(ggplot2)

# Learn data structure
str(cars)

# Create faceted histogram
# Plot a histogram of city_mpg faceted by suv, a logical variable indicating whether the car is an SUV or not.
ggplot(cars, aes(x = city_mpg)) +
  geom_histogram() +
  facet_wrap(~ suv)

unique(cars$ncyl)
table(cars$ncyl)

# Filter cars with 4, 6, 8 cylinders
common_cyl <- filter(cars, ncyl %in% c(4,6,8))

# Create box plots of city mpg by ncyl
ggplot(common_cyl, aes(x = as.factor(ncyl), y = city_mpg)) +
  geom_boxplot()

# Create overlaid density plots for same data
ggplot(common_cyl, aes(x = city_mpg, fill = as.factor(ncyl))) +
  geom_density(alpha = .3)

# Create hist of horsepwr
cars %>%
  ggplot(aes(x = horsepwr)) +
  geom_histogram() +
  ggtitle("horse power all cars")

# Create hist of horsepwr for affordable cars
cars %>% 
  filter(msrp < 25000) %>%
  ggplot(aes(x = horsepwr)) +
  geom_histogram() +
  xlim(c(90, 550)) +
  ggtitle("horse power for cars < $25,000")

# Create hist of horsepwr with binwidth of 3
cars %>%
  ggplot(aes(x = horsepwr)) +
  geom_histogram(binwidth = 3) +
  ggtitle("binwidth = 3")

# Create hist of horsepwr with binwidth of 30
cars %>%
  ggplot(aes(x = horsepwr)) +
  geom_histogram(binwidth = 30) + 
  ggtitle("binwidth = 30")

# Create hist of horsepwr with binwidth of 60
cars %>% 
  ggplot(aes(x = horsepwr)) + 
  geom_histogram(binwidth = 60) + 
  ggtitle("binwidth = 60")

# Construct box plot of msrp
cars %>%
  ggplot(aes(x = 1, y = msrp)) +
  geom_boxplot()

# Exclude outliers from data
cars_no_out <- cars %>%
  filter(msrp < 100000)

# Construct box plot of msrp using the reduced dataset
cars_no_out %>%
  ggplot(aes(x = 1, y = msrp)) +
  geom_boxplot()

# Create plot of city_mpg
cars %>%
  ggplot(aes(x = 1, y = city_mpg)) +
  geom_boxplot()

# Create plot of width
cars %>% 
  ggplot(aes(x = width)) +
  geom_density()

# Facet hists using hwy mileage and ncyl
common_cyl %>%
  ggplot(aes(x = hwy_mpg)) +
  geom_histogram() +
  facet_grid(ncyl ~ suv) +
  ggtitle("rows = ncyl, columns = suv")

library(gapminder)

head(gapminder$year)
class(gapminder$year)
head(gapminder$continent)
names(gapminder)

# Graphical tools for numerical data

# - Histograms take continuous data and aggregate it into bins; then draw a bar to height the corresponse to a number of cases in that bin; and can be broken down by a categorical variable by faceting.
# - Boxplots excels at comparing multiple distributions; uses robust measures of median and IQR; and also flags potential outliers; but can hide more complicated shapes such as a bimodal distribution.
# - Density plots summarize data by drawing a smooth line to represent its shape; and can be faceted just like historams or overlaid on one another by maping the color of the fill of the distribution to a second variable.


# Create dataset of 2007 data
gap2007 <- filter(gapminder, year == 2007)

# Compute groupwise mean and median lifeExp
gap2007 %>%
  group_by(continent) %>%
  summarize(mean(lifeExp),
            median(lifeExp))

# Generate box plots of lifeExp for each continent
gap2007 %>%
  ggplot(aes(x = continent, y = lifeExp)) +
  geom_boxplot()

# The choice of measure for spread can dramatically impact how variable we consider our data to be, so it is important that you consider the shape of the distribution before deciding on the measure.

# - Standard deviation is convenient when interpreting because it’s in the same unit as in the raw data. It’s the most commonly used measure of variation. But SD (and variance) is sensitive to extreme values in the same way that the mean is as a measure of center.
# - Variance is, by comparison, hard to interpret because it’s in the unit in the raw data is squared.
# - IQR is the interquartile range, which is the distance between the first quartile and the third quartile (the height of the box in the boxplot). IQR is a good alternative to the standard deviation when working with a skewed distribution because it’s less sensitive to extreme values.
# - Range is the distance between the maximum and the minimum.

# If you're unsure whether you're working with symmetric or skewed distributions, it's a good idea to consider a robust measure like IQR in addition to the usual measures of variance or standard deviation.

# Compute groupwise measures of spread
gap2007 %>%
  group_by(continent) %>%
  summarize(sd(lifeExp),
            IQR(lifeExp),
            n())

# Generate overlaid density plots for each continent
gap2007 %>%
  ggplot(aes(x = lifeExp, fill = continent)) +
  geom_density(alpha = 0.3)

# Density plot of life expectancy for Americas
gap2007 %>% 
  filter(continent == "Americas") %>% 
  ggplot(aes(lifeExp)) + geom_density() + ggtitle("Life Expectancy in the Americas")

# Compute stats for lifeExp in Americas
gap2007 %>%
  filter(continent == "Americas") %>%
  summarize(mean(lifeExp),
            sd(lifeExp))

# Density plot of population for whole dataset
gap2007 %>% ggplot(aes(pop)) + geom_density()

# Compute stats for population
gap2007 %>%
  summarize(median(pop),
            IQR(pop))

# Filter for Asia, add column indicating outliers
gap_asia <- gap2007 %>%
  filter(continent == "Asia") %>%
  mutate(is_outlier = lifeExp < 50)

# Remove outliers, create box plot of lifeExp
gap_asia %>%
  filter(!is_outlier) %>%
  ggplot(aes(x = 1 , y = lifeExp)) +
  geom_boxplot()

install.packages("openintro")
library(openintro)
?email
head(email)

email %>% ggplot(aes(x = spam, y = num_char)) + geom_boxplot()
email %>% ggplot(aes(x = num_char, fill = spam)) + geom_density()

# Compute summary statistics
email %>%
  group_by(spam) %>%
  summarise(median(num_char),
            IQR(num_char))

# Create plot
email %>%
  mutate(log_num_char = log(num_char)) %>%
  ggplot(aes(x = spam, y = log_num_char)) +
  geom_boxplot()

# If you decide to use a log transformation, remember that log(0) is -Inf in R, which isn't a very useful value! You can get around this by adding a small number (like 0.01) to the quantity inside the log() function. This way, your value is never zero. This small shift to the right won't affect your results.

# Compute center and spread for exclaim_mess by spam
email %>%
  group_by(spam) %>%
  summarize(median(exclaim_mess),
            IQR(exclaim_mess))

# Create plot for spam and exclaim_mess
email %>%
  mutate(log_exclaim_mess = log(exclaim_mess + 0.01)) %>%
  ggplot(aes(x = log_exclaim_mess)) +
  geom_histogram() +
  facet_wrap(~ spam)

# Alternative plot: side-by-side box plots
email %>%
  mutate(log_exclaim_mess = log(exclaim_mess + 0.01)) %>%
  ggplot(aes(x = 1, y = log_exclaim_mess)) +
  geom_boxplot() +
  facet_wrap(~ spam)

# Alternative plot: Overlaid density plots
email %>%
  mutate(log_exclaim_mess = log(exclaim_mess + .01)) %>%
  ggplot(aes(x = log_exclaim_mess, fill = spam)) +
  geom_density(alpha = 0.3)

# We see zero inflation in the exclaim_mess variable (most cases are 0). With this you can do several things:
# - you can analyze the two part separatly
# - or turn it into a categorical variable of is-zero, not-zero

# With the latter case, you could make a barchart. First you need to decide if you are more interested in counts or proportions

table(email$image)

# Recall that this tabulates the number of cases in each category (so there were 3811 emails with 0 images, for example). Given the very low counts at the higher number of images, let's collapse image into a categorical variable that indicates whether or not the email had at least one image. In this exercise, you'll create this new variable and explore its association with spam.

email %>%
  mutate(has_image = image > 0) %>%
  ggplot(aes(x = has_image, fill = spam)) +
  geom_bar(position = "fill")

# make sure all emails have at least 1 char
sum(email$num_char < 0)

# Test if images count as attachments
sum(email$image > email$attach)

# "Within non-spam emails, is the typical length of emails shorter for those that were sent to multiple people?"

email %>%
  filter(spam == "not-spam") %>%
  group_by(to_multiple) %>%
  summarize(median(num_char))

# The code makes it clear that you are using num_char to measure the length of an email and median() as the measure of what is typical. If you run this code, you'll learn that the answer to the question is "yes": the typical length of non-spam sent to multiple people is a bit lower than those sent to only one person.
# 
# This chain concluded with summary statistics, but others might end in a plot; it all depends on the question that you're trying to answer.

# Question 1
# For emails containing the word "dollar", does the typical spam email contain a greater number of occurrences of the word than the typical non-spam email? Create a summary statistic that answers this question.
email %>%
  filter(dollar > 0) %>%
  group_by(spam) %>%
  summarize(median(dollar))

# Question 2
# If you encounter an email with greater than 10 occurrences of the word "dollar", is it more likely to be spam or not-spam? Create a barchart that answers this question.
email %>%
  filter(dollar > 10) %>%
  ggplot(aes(x = spam)) +
  geom_bar()

# For illustrating relationships between categorical variables, you've seen
# - Faceted barcharts
# - Side-by-side barcharts
# - Stacked and normalized barcharts.

# Reorder the levels of number so that they preserve the natural ordering of "none", then "small", then "big".
email$number <- factor(email$number, levels = c("none", "small", "big"))

# Construct a faceted barchart of the association between number and spam.
ggplot(email, aes(x = number)) +
  geom_bar() + 
  facet_wrap(~ spam)

# Shown in the viewer:
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_point()

# Solutions:
# 1 - With geom_jitter()
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_jitter()

# 2 - Set width in geom_jitter()
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_jitter(width = 0.1)

# 3 - Set position = position_jitter() in geom_point() ()
ggplot(mtcars, aes(x = cyl, y = wt)) +
  geom_jitter(position = position_jitter(0.1))

install.packages("car")
library(car)
str(Vocab)

# Examine the structure of Vocab
str(Vocab)

# Basic scatter plot of vocabulary (y) against education (x). Use geom_point()
ggplot(Vocab, aes(x = education, y = vocabulary)) +
  geom_point()


# Use geom_jitter() instead of geom_point()
ggplot(Vocab, aes(x = education, y = vocabulary)) +
  geom_jitter()


# Using the above plotting command, set alpha to a very low 0.2
ggplot(Vocab, aes(x = education, y = vocabulary)) +
  geom_jitter(alpha = 0.2)


# Using the above plotting command, set the shape to 1
ggplot(Vocab, aes(x = education, y = vocabulary)) +
  geom_jitter(shape = 1)

# The x axis/aesthetic: The documentation for geom_histogram() states the argument stat = "bin" as a default. Recall that histograms cut up a continuous variable into discrete bins - that's what the stat "bin" is doing. You always get 30 evenly-sized bins by default, which is specified with the default argument binwidth = range/30. This is a pretty good starting point if you don't know anything about the variable being ploted and want to start exploring.

# The y axis/aesthetic: geom_histogram() only requires one aesthetic: x. But there is clearly a y axis on your plot, so where does it come from? Actually, there is a variable mapped to the y aesthetic, it's called ..count... When geom_histogram() executed the binning statistic (see above), it not only cut up the data into discrete bins, but it also counted how many values are in each bin. So there is an internal data frame where this information is stored. The .. calls the variable count from this internal data frame. This is what appears on the y aesthetic. But it gets better! The density has also been calculated. This is the proportional frequency of this bin in relation to the whole data set. You use ..density.. to access this information.

# 1 - Make a univariate histogram
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram()

# 2 - Plot 1, plus set binwidth to 1 in the geom layer
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(binwidth = 1)


# 3 - Plot 2, plus MAP ..density.. to the y aesthetic (i.e. in a second aes() function)
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(aes(y = ..density..), binwidth = 1)


# 4 - plot 3, plus SET the fill attribute to "#377EB8"
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(aes(y = ..density..), binwidth = 1, fill = "#377EB8")

# In the previous chapter you saw that there are lots of ways to position scatter plots. Likewise, the geom_bar() and geom_histogram() geoms also have a position argument, which you can use to specify how to draw the bars of the plot.

# Three position arguments will be introduced here:
# - stack: place the bars on top of each other. Counts are used. This is the default position.
# - fill: place the bars on top of each other, but this time use proportions.
# - dodge: place the bars next to each other. Counts are used.

# Draw a bar plot of cyl, filled according to am
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar()

# Change the position argument to stack
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "stack")


# Change the position argument to fill
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "fill")


# Change the position argument to dodge
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge")

# Instead of using position = "dodge" you're going to use position_dodge(), like you did with position_jitter() in the Scatter plots and jittering (1) exercise. Here, you'll save this as an object, posn_d, so that you can easily reuse it.
# 
# Remember, the reason you want to use position_dodge() (and position_jitter()) is to specify how much dodging (or jittering) you want.

# 1 - The last plot form the previous exercise
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = "dodge")

# 2 - Define posn_d with position_dodge()
posn_d <- position_dodge(width = 0.2)

# 3 - Change the position argument to posn_d
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = posn_d)


# 4 - Use posn_d as position and adjust alpha to 0.6
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar(position = posn_d, alpha = 0.6)

# A basic histogram, add coloring defined by cyl
ggplot(mtcars, aes(mpg, fill = cyl)) +
  geom_histogram(binwidth = 1)

# Change position to identity
ggplot(mtcars, aes(mpg, fill = cyl)) +
  geom_histogram(binwidth = 1, position = "identity")


# Change geom to freqpoly (position is identity by default)
ggplot(mtcars, aes(mpg, color = cyl)) +
  geom_freqpoly(binwidth = 1)

Vocab <- Vocab %>%
  mutate(sex = as.factor(sex),
         education = as.factor(education),
         vocabulary = as.factor(vocabulary))
str(Vocab)

# Example of how to use a brewed color palette
# for a full list of colours try ?brewer.pal
ggplot(mtcars, aes(x = cyl, fill = am)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1")

# Use str() on Vocab to check out the structure
str(Vocab)
# Plot education on x and vocabulary on fill
# Use the default brewed color palette
ggplot(Vocab, aes(x = education, fill = vocabulary)) + 
  geom_bar(position = "fill") +
  scale_fill_brewer()

# In the previous exercise, you ended up with an incomplete bar plot. This was because for continuous data, the default RColorBrewer palette that scale_fill_brewer() calls is "Blues". There are only 9 colours in the palette, and since you have 11 categories, your plot looked strange.

# Final plot of last exercise
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
  geom_bar(position = "fill") +
  scale_fill_brewer()

# Definition of a set of blue colors
blues <- brewer.pal(9, "Blues") # from the RColorBrewer package

# 1 - Make a color range using colorRampPalette() and the set of blues
blue_range <- colorRampPalette(blues)

# 2 - Use blue_range to adjust the color of the bars, use scale_fill_manual()
ggplot(Vocab, aes(x = education, fill = vocabulary)) +
  geom_bar(position = "fill") +
  scale_fill_manual(values = blue_range(11))

# 1 - Basic histogram plot command
ggplot(mtcars, aes(mpg)) +
  geom_histogram(binwidth = 1)

# 2 - Plot 1, Expand aesthetics: am onto fill
ggplot(mtcars, aes(mpg, fill = am)) +
  geom_histogram(binwidth = 1)


# 3 - Plot 2, change position = "dodge"
ggplot(mtcars, aes(mpg, fill = am)) +
  geom_histogram(binwidth = 1, position = "dodge")


# 4 - Plot 3, change position = "fill"
ggplot(mtcars, aes(mpg, fill = am)) +
  geom_histogram(binwidth = 1, position = "fill")


# 5 - Plot 4, plus change position = "identity" and alpha = 0.4
ggplot(mtcars, aes(mpg, fill = am)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)


# 6 - Plot 5, plus change mapping: cyl onto fill
ggplot(mtcars, aes(mpg, fill = cyl)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)

head(economics)

# Print out head of economics
head(economics)

# Plot unemploy as a function of date using a line plot
ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line()

# Adjust plot to represent the fraction of total population that is unemployed
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_line()

# By themselves, time series often contain enough valuable information, but you always want to maximize the number of variables you can show in a plot. This allows you (and your viewers) to begin making comparisons between those variables that would otherwise be difficult or impossible.
# 
# Here, you'll add shaded regions to the background to indicate recession periods. How do unemployment rate and recession period interact with each other?
# 
# In addition to the economics dataset from before, you'll also use the recess dataset for the periods of recession. The recess data frame contains 2 variables: the begin period of the recession and the end. It's already available in your workspace.

# Basic line plot
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_line()

# Expand the following command with geom_rect() to draw the recess periods
ggplot(economics, aes(x = date, y = unemploy/pop)) +
  geom_rect(data = recess,
            aes(xmin = begin, xmax = end, ymin = -Inf, ymax = +Inf),
            inherit.aes = FALSE, fill = "red", alpha = 0.2) +
  geom_line()

load("fish.RData")

# Check the structure as a starting point
str(fish.species)
rm(fish.tidy)
# Use gather to go from fish.species to fish.tidy
fish.tidy <- gather(fish.species, Species, Capture, -Year)

# Recreate the plot shown on the right
ggplot(fish.tidy, aes(x = Year, y = Capture, colour = Species)) +
  geom_line()

# The old way (shown)
plot(mpg ~ wt, data = mtcars) # formula notation
with(mtcars, plot(wt, mpg)) # x, y notation

# Using ggplot:
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# Using qplot:
qplot(wt, mpg, data = mtcars)

# basic qplot scatter plot:
qplot(wt, mpg, data = mtcars)

# Categorical variable mapped onto size:
# cyl
qplot(wt, mpg, data = mtcars, size = factor(cyl))

# gear
qplot(wt, mpg, data = mtcars, size = factor(gear))


# Continuous variable mapped onto col:
# hp
qplot(wt, mpg, data = mtcars, color = hp)

# qsec
qplot(wt, mpg, data = mtcars, color = qsec)
