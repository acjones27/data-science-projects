# install.packages("tidyverse")
# install.packages("nycflights13")
# install.packages("ggplot2")
library(tidyverse)
library(nycflights13)
library(ggplot2)

# - filter() - Pick observations by their values.
# - arrange() - Reorder the rows.
# - select() - Pick variables by their names.
# - mutate() - Create new variables with functions of existing variables.
# - summarise() - Collapse many values down to a single summary.

# These can all be used in conjunction with group_by() which changes the scope of each function from operating on the entire dataset to operating on it group-by-group.

# filter() allows you to subset observations based on their values.
filter(flights, month == 1, day == 1)


# to save the output
jan1 <- filter(flights, month == 1, day == 1)

# R either prints out the results, or saves them to a variable. If you want to do both, you can wrap the assignment in parentheses:
  
(dec25 <- filter(flights, month == 12, day == 25))

# Whn using == be careful of floating point numbers

sqrt(2) ^ 2 == 2
# FALSE

1 / 49 * 49 == 1
# FALSE

# instead, use near()
near(sqrt(2) ^ 2,  2)
# TRUE

near(1 / 49 * 49, 1)
# TRUE

# us need to use boolean operators to do filters that aren't with AND
# & is AND, | is OR, ! is NOT

# filter on Nov or Dec
filter(flights, month == 11 | month == 12)
nov_dec <- filter(flights, month %in% c(11, 12))

# If you wanted to find flights that weren’t delayed (on arrival or departure) by more than two hours, you could use either of the following two filters:
  
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# R also has && and ||. Don’t use them here! You’ll learn when you should use them in conditional execution.

# NA represents an unknown value so missing values are “contagious”: almost any operation involving an unknown value will also be unknown.

x <- NA
is.na(x)

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

# arrange() works similarly to filter() except that instead of selecting rows, it changes their order. 

arrange(flights, year, month, day)

# arrange in descending order

arrange(flights, desc(dep_delay))

# NAs are always at the end, even in descending order
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# select() allows you to rapidly zoom in on a useful subset using operations based on the names of the variables.

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

# There are a number of helper functions you can use within select():

# - starts_with("abc"): matches names that begin with “abc”.
# - ends_with("xyz"): matches names that end with “xyz”.
# - contains("ijk"): matches names that contain “ijk”.
# - matches("(.)\\1"): selects variables that match a regular expression. This one matches any variables that contain repeated characters. You’ll learn more about regular expressions in strings
# - num_range("x", 1:3): matches x1, x2 and x3.

# select() can be used to rename variables, but it’s rarely useful because it drops all of the variables not explicitly mentioned. Instead, use rename()
rename(flights, tail_num = tailnum)

# Another option is to use select() in conjunction with the everything() helper. This is useful if you have a handful of variables you’d like to move to the start of the data frame.
select(flights, time_hour, air_time, everything())

# Besides selecting sets of existing columns, it’s often useful to add new columns that are functions of existing columns. That’s the job of mutate()

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

# you can even refer to columns you've just made
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# If you only want to keep the new variables, use transmute():
  
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# Modular arithmetic: %/% (integer division) and %% (remainder), where x == y * (x %/% y) + (x %% y). Modular arithmetic is a handy tool because it allows you to break integers up into pieces. For example, in the flights dataset, you can compute hour and minute from dep_time with:

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# Logs: log(), log2(), log10(). Logarithms are an incredibly useful transformation for dealing with data that ranges across multiple orders of magnitude. 

# I recommend using log2() because it’s easy to interpret: a difference of 1 on the log scale corresponds to doubling on the original scale and a difference of -1 corresponds to halving.

# Offsets: lead() and lag() allow you to refer to leading or lagging values.

(x <- 1:10)
lag(x)
lead(x)

#  R provides functions for running sums, products, mins and maxes: cumsum(), cumprod(), cummin(), cummax(); and dplyr provides cummean() for cumulative means.

#  If you need rolling aggregates (i.e. a sum computed over a rolling window), try the RcppRoll package.

x
cumsum(x)
cummean(x)

# Ranking: there are a number of ranking functions, but you should start with min_rank(). It does the most usual type of ranking (e.g. 1st, 2nd, 2nd, 4th). The default gives smallest values the small ranks; use desc(x) to give the largest values the smallest ranks.

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

# If min_rank() doesn’t do what you need, look at the variants row_number(), dense_rank(), percent_rank(), cume_dist(), ntile().

row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# The last key verb is summarise(). It collapses a data frame to a single row:
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# summarise() is not terribly useful unless we pair it with group_by()
# For example, if we applied exactly the same code to a data frame grouped by date, we get the average delay per date:

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# All together
delay <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# looking at not cancelled flights
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Whenever you do any aggregation, it’s always a good idea to include either a count (n()), or a count of non-missing values (sum(!is.na(x))). That way you can check that you’re not drawing conclusions based on very small amounts of data.

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
  
# Wow, there are some planes that have an average delay of 5 hours (300 minutes)!

# The story is actually a little more nuanced. We can get more insight if we draw a scatterplot of number of flights vs. average delay:

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# When looking at this sort of plot, it’s often useful to filter out the groups with the smallest numbers of observations, so you can see more of the pattern and less of the extreme variation in the smallest groups. This is what the following code does, as well as showing you a handy pattern for integrating ggplot2 into dplyr flows. 

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# There’s another common variation of this type of pattern. Let’s look at how the average performance of batters in baseball is related to the number of times they’re at bat. Here I use data from the Lahman package to compute the batting average (number of hits / number of attempts) of every major league baseball player.

# When I plot the skill of the batter (measured by the batting average, ba) against the number of opportunities to hit the ball (measured by at bat, ab), you see two patterns:
  
# As above, the variation in our aggregate decreases as we get more data points.

# There’s a positive correlation between skill (ba) and opportunities to hit the ball (ab). This is because teams control who gets to play, and obviously they’ll pick their best players.

# install.packages("Lahman")
library(Lahman)
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

# This also has important implications for ranking. If you naively sort on desc(ba), the people with the best batting averages are clearly lucky, not skilled:
  
batters %>% 
  arrange(desc(ba))

# Useful summary functions
# Measures of location: we’ve used mean(x), but median(x) is also useful.
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

# Measures of spread: sd(x), IQR(x), mad(x). 
# The root mean squared deviation, or standard deviation sd(x), is the standard measure of spread 
# The interquartile range IQR(x) and median absolute deviation mad(x) are robust equivalents that may be more useful if you have outliers.

# Why is distance to some destinations more variable than to others?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Measures of rank: min(x), quantile(x, 0.25), max(x). Quantiles are a generalisation of the median. For example, quantile(x, 0.25) will find a value of x that is greater than 25% of the values, and less than the remaining 75%.

# When do the first and last flights leave each day?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )
  
# Measures of position: first(x), nth(x, 2), last(x)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

# These functions are complementary to filtering on ranks. Filtering gives you all variables, with each observation in a separate row:
  
  not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

# Counts: You’ve seen n(), which takes no arguments, and returns the size of the current group.
#  To count the number of non-missing values, use sum(!is.na(x)). 
#  To count the number of distinct (unique) values, use n_distinct(x)
  
# Which destinations have the most carriers?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

not_cancelled %>% 
  count(dest)
  
# You can optionally provide a weight variable. For example, you could use this to “count” (sum) the total number of miles a plane flew:
  
not_cancelled %>% 
  count(tailnum, wt = distance)

# Counts and proportions of logical values: sum(x > 10), mean(y == 0). 
# When used with numeric functions, TRUE is converted to 1 and FALSE to 0. 
# This makes sum() and mean() very useful: sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion.

# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# What proportion of flights are delayed by more than an hour?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_perc = mean(arr_delay > 60))

# When you group by multiple variables, each summary peels off one level of the grouping. That makes it easy to progressively roll up a dataset:

daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

# If you need to remove grouping, and return to operations on ungrouped data, use ungroup()
daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights
  
# Grouping is most useful in conjunction with summarise(), but you can also do convenient operations with mutate() and filter():

# Find the worst members of each group:
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a threshold:
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

# Standardise to compute per group metrics:
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)