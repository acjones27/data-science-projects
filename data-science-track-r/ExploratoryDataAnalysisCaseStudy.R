# RPubs: https://rpubs.com/williamsurles/299664
library(dplyr)

# The vote column in the dataset has a number that represents that country's vote:
# 
# 1 = Yes
# 2 = Abstain
# 3 = No
# 8 = Not present
# 9 = Not a member

# Print the votes dataset
# Got data from here: https://github.com/wsurles/datacamp_courses/tree/master/r_courses/exploratory_data_analysis_in_r_case_study
votes <- readRDS('votes.rds')

unique(votes$vote)

# Filter for votes that are "yes", "abstain", or "no"
votes %>% 
  filter(vote <= 3)

# In this case, you have a session column that is hard to interpret intuitively. But since the UN started voting in 1946, and holds one session per year, you can get the year of a UN resolution by adding 1945 to the session number.
min(votes$session)

# Add another %>% step to add a year column
votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945)

install.packages("countrycode")
library(countrycode)
?codelist


# Convert country code 100
countrycode(100, "cown", "country.name")

# Add a country column within the mutate: votes_processed
votes_processed <- votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945,
         country = countrycode(ccode, "cown", "country.name"))

# Find total and fraction of "yes" votes
votes_processed %>% 
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Change this code to summarize by year
votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Summarize by country: by_country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Sort in ascending order of percent_yes
by_country %>%
  arrange(percent_yes)

# Now sort in descending order
by_country %>%
  arrange(desc(percent_yes))

# Filter out countries with fewer than 100 votes
by_country %>%
  arrange(percent_yes) %>%
  filter(total > 100)

# Load the ggplot2 package
library(ggplot2)

# Create line plot
ggplot(by_year, aes(x = year, y = percent_yes)) +
  geom_line()

# A line plot is one way to display this data. You could also choose to display it as a scatter plot, with each year represented as a single point. This requires changing the layer (i.e. geom_line() to geom_point()).

# You can also add additional layers to your graph, such as a smoothing curve with geom_smooth().

ggplot(by_year, aes(year, percent_yes)) +
  geom_point() + 
  geom_smooth()

# Group by year and country: by_year_country
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Start with by_year_country dataset
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Print by_year_country
by_year_country

# Create a filtered version: UK_by_year
UK_by_year <- by_year_country %>% 
  filter(country == "United Kingdom")

# Line plot of percent_yes over time for UK only
ggplot(UK_by_year, aes(x = year, y = percent_yes)) +
  geom_line()

# Vector of four countries to examine
countries <- c("United States", "United Kingdom",
               "France", "India")

# Filter by_year_country: filtered_4_countries
filtered_4_countries <- by_year_country %>% 
  filter(country %in% countries)

# Line plot of % yes in four countries
ggplot(filtered_4_countries, aes(x = year, y = percent_yes, color = country)) +
  geom_line()

# Vector of six countries to examine
countries <- c("United States", "United Kingdom",
               "France", "Japan", "Brazil", "India",
               "Spain", "Canada", "Mexico")

# Filtered by_year_country: filtered_6_countries
filtered_6_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes over time faceted by country
ggplot(filtered_6_countries, aes(x = year, y = percent_yes)) +
  geom_line() +
  facet_wrap(~country)

# Line plot of % yes over time faceted by country with different y axis for each
ggplot(filtered_6_countries, aes(year, percent_yes)) +
  geom_line() +
  facet_wrap(~ country, scales = "free_y")

# "~" means "explained by" in R. y ~ x

# A linear regression is a model that lets us examine how one variable changes with respect to another by fitting a best fit line. It is done with the lm() function in R.

# Percentage of yes votes from the US by year: US_by_year
US_by_year <- by_year_country %>%
  filter(country == "United States")

# Print the US_by_year data
US_by_year

# Perform a linear regression of percent_yes by year: US_fit
US_fit <- lm(percent_yes ~ year, US_by_year)

# Perform summary() on the US_fit object
summary(US_fit)

# Calling summary() on this gives you lots of useful information about the linear model.
# What is the estimated slope of this relationship? Said differently, what's the estimated change each year of the probability of the US voting "yes"? 
# -0.006

# Not all positive or negative slopes are necessarily real. A p-value is a way of assessing whether a trend could be due to chance. Generally, data scientists set a threshold by declaring that, for example, p-values below .05 are significant.
# In this linear model, what is the p-value of the relationship between year and percent_yes?  
# 1.37e-07

install.packages("broom")

# Load the broom package
library(broom)

# Call the tidy() function on the US_fit object
tidy(US_fit)

# Linear regression of percent_yes by year for US
US_by_year <- by_year_country %>%
  filter(country == "United States")
US_fit <- lm(percent_yes ~ year, US_by_year)

# Fit model for the United Kingdom
UK_by_year <- by_year_country %>%
  filter(country == "United Kingdom")
UK_fit <- lm(percent_yes ~ year, UK_by_year)

# Create US_tidied and UK_tidied
US_tidied <- tidy(US_fit)
UK_tidied <- tidy(UK_fit)

# Combine the two tidied models with bind_rows from dplyr
bind_rows(US_tidied, UK_tidied)

# Load the tidyr package
library(tidyr)

# Nest all columns besides country
nested <- by_year_country %>%
  nest(-country)

# This "nested" data has an interesting structure. The second column, data, is a list, a type of R object that hasn't yet come up in this course that allows complicated objects to be stored within each row. This is because each item of the data column is itself a data frame.
# You can use nested$data to access this list column and double brackets to access a particular element. For example, nested$data[[1]] would give you the data frame with Afghanistan's voting history (the percent_yes per year), since Afghanistan is the first row of the table.

# Print the nested data for Brazil
nested$data[[7]]

# Unnest the data column to return it to its original form
nested %>%
  unnest()

# Now that you've divided the data for each country into a separate dataset in the data column, you need to fit a linear model to each of these datasets.

# The map() function from purrr works by applying a formula to each item in a list, where . represents the individual item. For example, you could add one to each of a list of numbers:

# map(numbers, ~ 1 + .)

# This means that to fit a model to each dataset, you can do:
 
# map(data, ~ lm(percent_yes ~ year, data = .))

# where . represents each individual item from the data column in by_year_country. Recall that each item in the data column is a dataset that pertains to a specific country.

# Load tidyr and purrr
library(tidyr)
library(purrr)


# Perform a linear regression on each item in the data column
by_year_country %>%
  group_by(country) %>%
  nest() %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)))

# You've now performed a linear regression on each nested dataset and have a linear model stored in the list column model. But you can't recombine the models until you've tidied each into a table of coefficients. To do that, you'll need to use map() one more time and the tidy() function from the broom package.

# Recall that you can simply give a function to map() (e.g. map(models, tidy)) in order to apply that function to each item of a list.

# Load the broom package
library(broom)

# Add another mutate that applies tidy() to each model
# Add one more step that unnests the tidied column
by_year_country %>%
  group_by(country) %>%
  nest() %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)),
         tidied = map(model, tidy))

# You now have a tidied version of each model stored in the tidied column. You want to combine all of those into a large data frame, similar to how you combined the US and UK tidied models earlier. Recall that the unnest() function from tidyr achieves this.

# Add one more step that unnests the tidied column
country_coefficients <- by_year_country %>%
  group_by(country) %>%
  nest() %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)),
         tidied = map(model, tidy)) %>%
  unnest(tidied)

# Print the resulting country_coefficients variable
country_coefficients


# Filter for only the slope terms
slope_terms <- country_coefficients %>%
  filter(term == "year")

# Not all slopes are significant, and you can use the p-value to guess which are and which are not.

# However, when you have lots of p-values, like one for each country, you run into the problem of multiple hypothesis testing, where you have to set a stricter threshold. Search in google for "Multiple Hypothesis Testing Correction: Bonferroni". The p.adjust() function is a simple way to correct for this, where p.adjust(p.value) on a vector of p-values returns a set that you can trust.

# Here you'll add two steps to process the slope_terms dataset: use a mutate to create the new, adjusted p-value column, and filter to filter for those below a .05 threshold.

# Add p.adjusted column, then filter
slope_terms %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < 0.05)

# Now that you've filtered for countries where the trend is probably not due to chance, you may be interested in countries whose percentage of "yes" votes is changing most quickly over time. Thus, you want to find the countries with the highest and lowest slopes; that is, the estimate column.

# Filter by adjusted p-values
filtered_countries <- country_coefficients %>%
  filter(term == "year") %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < .05)

# Sort for the countries increasing most quickly
filtered_countries %>%
  arrange(desc(estimate))

# Sort for the countries decreasing most quickly
filtered_countries %>%
  arrange(estimate)

#  You'll now combine that with the new descriptions dataset, which includes topic information about each country, so that you can analyze votes within particular topics.

# To do this, you'll make use of the inner_join() function from dplyr

# Load dplyr package
library(dplyr)

# Print the votes_processed dataset
votes_processed

# Print the descriptions dataset
descriptions <- readRDS("descriptions.rds")
descriptions

# Join them together based on the "rcid" and "session" columns
votes_joined <- votes_processed %>%
  inner_join(descriptions, by = c("rcid", "session"))

# There are six columns in the descriptions dataset (and therefore in the new joined dataset) that describe the topic of a resolution:

# me: Palestinian conflict
# nu: Nuclear weapons and nuclear material
# di: Arms control and disarmament
# hr: Human rights
# co: Colonialism
# ec: Economic development

# Each contains a 1 if the resolution is related to this topic and a 0 otherwise.

# Filter for votes related to colonialism
votes_joined %>%
  filter(co == 1)

# Load the ggplot2 package
library(ggplot2)

# Filter, then summarize by year: US_co_by_year
US_co_by_year <- votes_joined %>%
  filter(country == "United States" & co == 1) %>%
  group_by(year) %>%
  summarise(percent_yes = mean(vote == 1))

# Graph the % of "yes" votes over time
ggplot(US_co_by_year, aes(x = year, y = percent_yes)) +
  geom_line()

# Load the tidyr package
library(tidyr)

# Gather the six me/nu/di/hr/co/ec columns
votes_joined %>%
  gather(topic, has_topic, me:ec)

# Perform gather again, then filter
votes_gathered <- votes_joined %>%
  gather(topic, has_topic, me:ec) %>%
  filter(has_topic == 1)

# There's one more step of data cleaning to make this more interpretable. Right now, topics are represented by two-letter codes:

# me: Palestinian conflict
# nu: Nuclear weapons and nuclear material
# di: Arms control and disarmament
# hr: Human rights
# co: Colonialism
# ec: Economic development

example <- c("apple", "banana", "apple", "orange")
recode(example,
       apple = "plum",
       banana = "grape")

# Replace the two-letter codes in topic: votes_tidied
votes_tidied <- votes_gathered %>%
  mutate(topic = recode(topic,
                        me = "Palestinian conflict",
                        nu = "Nuclear weapons and nuclear material",
                        di = "Arms control and disarmament",
                        hr = "Human rights",
                        co = "Colonialism",
                        ec = "Economic development"))

# Print votes_tidied
votes_tidied

# Summarize the percentage "yes" per country-year-topic
by_country_year_topic <- votes_tidied %>%
  group_by(country, year, topic) %>%
  summarize(total = n(), percent_yes = mean(vote == 1)) %>%
  ungroup()

# Print by_country_year_topic
by_country_year_topic

# Load the ggplot2 package
library(ggplot2)

# Filter by_country_year_topic for just the US
US_by_country_year_topic <- by_country_year_topic %>%
  filter(country == "United States")

# Plot % yes over time for the US, faceting by topic
ggplot(US_by_country_year_topic, aes(x = year, y = percent_yes)) + 
  geom_line() + 
  facet_wrap(~topic)


# Print by_country_year_topic
by_country_year_topic

# Fit model on the by_country_year_topic dataset
country_topic_coefficients <- by_country_year_topic %>%
  nest(-country, -topic) %>%
  mutate(model = map(data, ~lm(percent_yes ~ year, data = .)),
         tidied = map(model, tidy)) %>%
  unnest(tidied)


# Print country_topic_coefficients
country_topic_coefficients

# Create country_topic_filtered
country_topic_filtered <- country_topic_coefficients %>%
  filter(term == "year") %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < 0.05)

# Create vanuatu_by_country_year_topic
vanuatu_by_country_year_topic <- by_country_year_topic %>%
  filter(country == "Vanuatu")

# Plot of percentage "yes" over time, faceted by topic
ggplot(vanuatu_by_country_year_topic, aes(x = year, y = percent_yes)) +
  geom_line() +
  facet_wrap(~topic)