# install.packages("infer")
library(infer)
library(ggplot2)

# df %>% # start with data frame
#   specify(response = ___) %>% # specify the variable of interest
#   generate(reps = ___, type = "bootstrap") %>% # generate many boostrap samples 
#   calculate(stat = "___") # calculate boostrap statistic

manhattan <- data.frame(rent = sample(2000:3000, 20, rep = TRUE))

# Generate bootstrap distribution of medians
rent_med_ci <- manhattan %>%
  # Specify the variable of interest
  specify(response = "rent") %>%  
  # Generate 15000 bootstrap samples
  generate(reps = 15000, type = "bootstrap") %>% 
  # Calculate the median of each bootstrap sample
  calculate(stat = "median")

# View its structure
str(rent_med_ci)

# Plot the rent_med_ci statistic
ggplot(rent_med_ci, aes(x = stat)) +
  # Make it a histogram with a binwidth of 50
  geom_histogram(binwidth = 50)

# Calculate bootstrap interval using both methods

# Method 1: the percentile method
# Calculate bootstrap CI as lower and upper quantiles of our sample statistic
rent_med_ci %>%
  summarize(
    l = quantile(stat, 0.025),
    u = quantile(stat, 0.975)
  ) 

# Method 2: Standard Error Method
# Calculate the observed median rent.
rent_med_obs <- manhattan %>%
  # Calculate observed median rent
  summarize(median_rent = median(rent)) %>%
  # Pull out the value
  pull()

# See the result
rent_med_obs

# Determine the critical value
# Calculate the degrees of freedom
degrees_of_freedom <- nrow(manhattan) - 1  

# Determine the critical value
t_star <- qt(p = 0.975, df = degrees_of_freedom)

# Complete the calculation of the 95% bootstrap confidence interval using the standard error method.
# Calculate the CI using the std error method
rent_med_ci %>%
  # Calculate the std error of the statistic
  summarize(boot_se = sd(stat)) %>%
  # Calculate the lower and upper limits of the CI
  summarize(
    l = rent_med_obs - t_star * boot_se,
    u = rent_med_obs + t_star * boot_se
  )

# Recall the CI using Method 1: the percentile method
rent_med_ci %>%
  summarize(
    l = quantile(stat, 0.025),
    u = quantile(stat, 0.975)
  )

# Doctor visits during pregnancy
# The state of North Carolina released to the public a large data set containing information on births recorded in this state. This data set has been of interest to medical researchers who are studying the relation between habits and practices of expectant mothers and the birth of their children. The ncbirths dataset (which is already loaded for you) is a random sample of 1000 cases from this data set. 

download.file("http://www.openintro.org/stat/data/nc.RData", destfile = "nc.RData")
load("nc.RData")

ncbirths <- nc

# Next, we construct a bootstrap interval for the average number of doctor's visits during pregnancy.

# Filter for rows with non-missing visits
ncbirths_complete_visits <- ncbirths %>%
  filter(!is.na(visits))

# See the result
glimpse(ncbirths_complete_visits)

# Generate 15000 bootstrap means
visit_mean_ci <- ncbirths_complete_visits %>%
  # Specify visits as the response
  specify(response = "visits") %>%
  # Generate 15000 bootstrap replicates
  generate(reps = 15000, type = "bootstrap") %>%
  # Calculate the mean
  calculate(stat = "mean")

# Calculate the 90% confidence interval via percentile method
visit_mean_ci %>%
  summarize(
    l = quantile(stat, 0.05),
    u = quantile(stat, 0.95)
  )

# SD of number of doctor's visits
# Suppose now we're interested in the standard deviation of the number of doctor's visits throughout pregnancy.
# Calculate 15000 bootstrap standard deviations of visits
visit_sd_ci <- ncbirths_complete_visits %>%
  specify(response = "visits") %>%
  generate(reps = 15000, type = "bootstrap") %>%
  calculate(stat = "sd")

# See the result
visit_sd_ci

# Calculate the 90% CI via percentile method
visit_sd_ci %>%
  summarize(
    l = quantile(stat, 0.05),
    u = quantile(stat, 0.95)
  )

# now you know how to estimate the standard deviation of a distribution!

# How do we test, using simulation methods, if a simgle parameter of a numerical dist is >, < or != to some value?
# Bootstrap distributions are, by design, centered at the observed sample statistic
# However, since in a hypothesis test we assume that the null hypothesis is true, we shift the bootstrap distribution to be centered at the null value
# p-value is then defined as the proportion of simulations that yield a sample statistic at least as extreme as the observed sample statistic

# Test for median price of 1 BR apartments in Manhattan
# Let's turn our attention back to Manhattan apartments. We would like to evaluate whether this data provides evidence that the median rent of 1 BR apartments in Manhattan is greater than $2,500.

n_replicates <- 15000

# Generate 15000 bootstrap samples centered at null
rent_med_ht <- manhattan %>%
  specify(response = rent) %>%
  # Use a point hypothesis with a median of 2500
  hypothesize(null = "point", med = 2950) %>% 
  generate(reps = n_replicates, type = "bootstrap") %>% 
  calculate(stat = "median")

# See the result
rent_med_ht

rent_med_obs <- manhattan %>%
  # Calculate observed median rent
  summarize(median_rent = median(rent)) %>%
  # Pull out the value
  pull()

# See the result
rent_med_obs

# Calculate the p-value as the proportion of bootstrap statistics greater than the observed statistic.
rent_p_value <- rent_med_ht %>%
  # Filter for bootstrap stat greater than or equal to observed stat
  filter(stat >= rent_med_obs) %>%
  # Calculate the p-value
  summarize(p_val = n() / n_replicates)

rent_p_value

# Conclude the hypothesis test on median
# The p-value you calculated in the previous exercise is available as rent_p_value.

# Recall the problem statement: We would like to evaluate whether this data provides evidence that the median rent of 1 BR apartments in Manhattan is greater than $2,500. What is the conclusion of the hypothesis test at the 5% significance level?

# We fail to reject H0 since the p-value is above the significance level, and conclude that the data do not provide convincing evidence that median rent of 1 BR apartments in Manhattan is greater than $2500.

n_replicates <- 1500

weight_mean_ht <- ncbirths %>%
  # Specify weight as the response
  specify(response = "weight") %>%
  # Set the hypothesis that weights are 7 pounds
  hypothesize(null = "point", mu = 7) %>% 
  # Generate 1500 bootstrap replicates
  generate(reps = 1500, type = "bootstrap") %>% 
  # Calculate the mean
  calculate(stat = "mean")

# Calculate observed mean
weight_mean_obs <- ncbirths %>%
  # Summarize to calculate the mean observed weight
  summarise(mean_weight = mean(weight)) %>% 
  # Pull out the value
  pull()

# Calculate p-value
weight_mean_ht %>%
  # Filter on stat greater than or equal to weight_mean_obs
  filter(stat >= weight_mean_obs) %>%
  # p_val is twice the number of filtered rows divided by the total number of rows
  summarize(
    one_sided_p_val = n() / n_replicates,
    two_sided_p_val = 2 * one_sided_p_val
  )