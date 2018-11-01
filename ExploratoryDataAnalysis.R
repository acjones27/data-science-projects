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