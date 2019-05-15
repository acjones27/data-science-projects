# https://moderndive.com/9-confidence-intervals.html#needed-packages-6
# Chapter 9: Confidence Intervals
library(dplyr)
library(ggplot2)
# install.packages("janitor")
library(janitor)
# install.packages("moderndive")
library(moderndive)
library(infer)

pennies_sample


# First, let’s visualize the values in this sample as a histogram:
  
ggplot(pennies_sample, aes(x = age_in_2011)) +
geom_histogram(bins = 10, color = "white")

# If pennies_sample is a representative sample from the population, we’d expect the age of all US pennies collected in 2011 to have a similar shape, a similar spread, and similar measures of central tendency like the mean.

# Where is the mean for this sample? 
# This point will be known as our point estimate and provides us with a single number that could serve as the guess to what the true population mean age might be
x_bar <- pennies_sample %>%
  summarise(stat = mean(age_in_2011))
x_bar

# Bootstrapping uses a process of sampling with replacement from our original sample to create new bootstrap samples of the same size as our original sample.

bootstrap_sample1 <- pennies_sample %>%
  rep_sample_n(size = nrow(pennies_sample), replace = TRUE, reps = 1)
bootstrap_sample1

# Let's visualise the new bootstrap sample
ggplot(bootstrap_sample1, aes(x = age_in_2011)) + 
  geom_histogram(bins = 10, color = "white")

# We now have another sample from what we could assume comes from the population of interest. We can similarly calculate the sample mean of this bootstrap sample, called a bootstrap statistic.

bootstrap_sample1 %>%
  summarise(stat = mean(age_in_2011))

# The process of sampling with replacement is how we can use the original sample to take a guess as to what other values in the population may be. Sometimes in these bootstrap samples, we will select lots of larger values from the original sample, sometimes we will select lots of smaller values, and most frequently we will select values that are near the center of the sample.

six_bootstrap_samples <- pennies_sample %>%
  rep_sample_n(size = 40, replace = TRUE, reps = 6)

ggplot(six_bootstrap_samples, aes(x = age_in_2011)) +
  geom_histogram(bins = 10, color = "white") +
  facet_wrap(~ replicate)

six_bootstrap_samples %>%
  group_by(replicate) %>%
  summarise(stat = mean(age_in_2011))

# Instead of doing this six times, we could do it 1000 times and then look at the distribution of stat across all 1000 of the replicates. This sets the stage for the infer R package

## SPECIFY
# The specify() function is used primarily to choose which variables will be the focus of the statistical inference. In addition, a setting of which variable will act as the explanatory and which acts as the response variable is done here.
# For proportion problems similar to those in Chapter 8, we can also give which of the different levels we would like to have as a success
# Create a confidence interval for the population mean age of US pennies in 2011:

# Let’s generate() 1000 bootstrap samples:
  
thousand_bootstrap_samples <- pennies_sample %>% 
  specify(response = age_in_2011) %>% 
  generate(reps = 1000)

# Create summary stats
bootstrap_distribution <- pennies_sample %>% 
  specify(response = age_in_2011) %>% 
  generate(reps = 1000) %>% 
  calculate(stat = "mean")

# It’s often helpful both in confidence interval calculations, but also in hypothesis testing to identify what the corresponding statistic is in the original data.
pennies_sample %>% 
  specify(response = age_in_2011) %>% 
  calculate(stat = "mean")

# The visualize() verb provides a simple way to view the bootstrap distribution as a histogram of the stat variable values.
bootstrap_distribution %>%
  visualise()

bootstrap_distribution %>% 
  summarize(mean_of_means = mean(stat))

# One way to calculate a range of plausible values for the unknown mean age of coins in 2011 is to use the middle 95% of the bootstrap_distribution to determine our endpoints.

percentile_ci <- bootstrap_distribution %>%
  get_ci(level = 0.95, type = "percentile")
# The level and type values are default
percentile_ci

bootstrap_distribution %>%
  visualise() +
  shade_ci(endpoints = percentile_ci)

# If the bootstrap distribution is close to symmetric and bell-shaped, we can also use a shortcut formula 
# x_bar +/- multiplier*SE
# where x_bar is out original sample mean
# SE stands for standard error, and corresponds to the standard deviation of the bootstrap distribution

# The standard error is the standard deviation of the sampling distribution.
standard_error_ci <- bootstrap_distribution %>% 
  get_ci(type = "se", point_estimate = x_bar)
standard_error_ci

bootstrap_distribution %>% 
  visualise() +
  shade_confidence_interval(endpoints = standard_error_ci)

# Comparing bootstrap and sampling distributions

ggplot(pennies, aes(x = age_in_2011)) + 
  geom_histogram(bins = 10, color = "white")

pennies %>%
  summarise(mean_age = mean(age_in_2011),
            median_age = median(age_in_2011)) 

# Let’s assume that pennies represents our population of interest. We can then create a sampling distribution for the population mean age of pennies

ggplot(pennies_sample, aes(x = age_in_2011)) + 
  geom_histogram(bins = 10, color = "white")

pennies_sample %>%
  summarise(mean_age = mean(age_in_2011),
            median_age = median(age_in_2011))

thousand_samples <- pennies %>%
  rep_sample_n(size = 40, reps = 1000, replace = FALSE)

# When creating a sampling distribution, we do not replace the items when we create each sample. This is in contrast to the bootstrap distribution.

sampling_distribution <- thousand_samples %>% 
  group_by(replicate) %>% 
  summarize(stat = mean(age_in_2011))

ggplot(sampling_distribution, aes(x = stat)) +
  geom_histogram(bins = 10, fill = "salmon", color = "white")

# We can also examine the variability in this sampling distribution by calculating the standard deviation of the stat column. 
# Remember that the standard deviation of the sampling distribution is the standard error, frequently denoted as se.

sampling_distribution %>% 
  summarize(se = sd(stat))

# Now let's compare
bootstrap_distribution %>% 
  visualize(bins = 10, fill = "blue")

bootstrap_distribution %>% 
  summarize(se = sd(stat))

# Notice that while the standard deviations are similar, the center of the sampling distribution and the bootstrap distribution differ:
sampling_distribution %>% 
  summarize(mean_of_sampling_means = mean(stat))
bootstrap_distribution %>% 
  summarize(mean_of_bootstrap_means = mean(stat))

# Since the bootstrap distribution is centered at the original sample mean, it doesn’t necessarily provide a good estimate of the overall population mean  
# Let’s calculate the mean of age_in_2011 for the pennies data frame to see how it compares to the mean of the sampling distribution and the mean of the bootstrap distribution.
pennies %>% 
  summarize(overall_mean = mean(age_in_2011))

# If we had a different sample of size 40, would we expect the same confidence interval?
pennies_sample2 <- pennies %>% 
  sample_n(size = 40)

percentile_ci2 <- pennies_sample2 %>%
  specify(response = age_in_2011) %>% 
  generate(reps = 1000) %>% 
  calculate(stat = "mean") %>% 
  get_ci()

percentile_ci2

# Interpretation of the CI: 
# The procedure we have used to generate confidence intervals is “95% reliable” in that we can expect it to include the true population parameter 95% of the time if the process is repeated.
#  It is common to say: to be “95% confident” or “90% confident” that the true value falls within the range of the specified confidence interval. 
#  But remember that it has more to do with a measure of reliability of the building process.

# One proportion
# Now let's try to estimate the proportion of red balls selected from a bowl of red/blue

tactile_shovel1 <- data.frame(sample(c("red", "white"), replace = TRUE, size = 40))
colnames(tactile_shovel1) <- "color"
tactile_shovel1

p_hat <- tactile_shovel1 %>% 
  specify(response = color, success = "red") %>% 
  calculate(stat = "prop")
p_hat

# Now let's generate our bootstrap samples
bootstrap_props <- tactile_shovel1 %>% 
  specify(response = color, success = "red") %>% 
  generate(reps = 10000) %>% 
  calculate(stat = "prop")

bootstrap_props %>% 
  visualise(bins = 25)

standard_error_ci <- bootstrap_props %>% 
  get_ci(type = "se", level = 0.95, point_estimate = p_hat)
standard_error_ci

bootstrap_props %>% 
  visualise(bins = 25) +
  shade_confidence_interval(endpoints = standard_error_ci)

# When the bootstrap distribution has the nice symmetric, bell shape that we saw in the red balls example above, we can also use a formula to quantify the standard error. This provides another way to compute a confidence interval, but is a little more tedious and mathematical.

# 1. Collect a sample of size n
# 2. Compute p_hat
# 3. Compute the standard error
# 4. Compute margin of error
# 5. Compute both end points of the confidence interval
# i.e p +/- 1.96 * SE

conf_ints <- tactile_prop_red %>% 
  mutate(
    p_hat = prop_red,
    n = 50,
    SE = sqrt(p_hat * (1 - p_hat) / n),
    MoE = 1.96 * SE,
    lower_ci = p_hat - MoE,
    upper_ci = p_hat + MoE
  )
conf_ints

# Let’s say however, we repeated the above 100 times
# First: Take 100 virtual samples of n=50 balls
virtual_samples <- bowl %>% 
  rep_sample_n(size = 50, reps = 100)

# Second: For each virtual sample compute the proportion red
virtual_prop_red <- virtual_samples %>% 
  group_by(replicate) %>% 
  summarize(red = sum(color == "red")) %>% 
  mutate(prop_red = red / 50)

# Third: Compute the 95% confidence interval as above
virtual_prop_red <- virtual_prop_red %>% 
  mutate(
    p_hat = prop_red,
    n = 50,
    SE = sqrt(p_hat*(1-p_hat)/n),
    MoE = 1.96 * SE,
    lower_ci = p_hat - MoE,
    upper_ci = p_hat + MoE
  )

# Comparing two proportions
# Fifty adults who thought they were being considered for an appearance on the show were interviewed by a show recruiter (“confederate”) who either yawned or did not. Participants then sat by themselves in a large van and were asked to wait. While in the van, the Mythbusters watched via hidden camera to see if the unaware participants yawned.
mythbusters_yawn

# Using the janitor package
mythbusters_yawn %>% 
  tabyl(group, yawn) %>% # contingency table
  adorn_percentages() %>% # change to proportions by row
  adorn_pct_formatting() %>% # format as percentages
  adorn_ns() # To show original counts as well

# We are interested in comparing the proportion of those that yawned after seeing a seed versus those that yawned with no seed interaction. We’d like to see if the difference between these two proportions is significantly larger than 0. 

# We are calling a success having a yawn value of "yes".
# Our response variable will always correspond to the variable used in the success so the response variable is yawn.
# The explanatory variable is the other variable of interest here: group.

mythbusters_yawn %>% 
  specify(formula = yawn ~ group, success = "yes")

# We next want to calculate the statistic of interest for our sample. This corresponds to the difference in the proportion of successes.

obs_diff <- mythbusters_yawn %>% 
  specify(formula = yawn ~ group, success = "yes") %>% 
  calculate(stat = "diff in props", order = c("seed", "control")) # order here means seed - control
obs_diff

# This value represents the proportion of those that yawned after seeing a seed yawn (0.2941) minus the proportion of those that yawned with not seeing a seed (0.25).

# Our next step in building a confidence interval is to create a bootstrap distribution of statistics (differences in proportions of successes)

head(mythbusters_yawn)

bootstrap_distribution <- mythbusters_yawn %>% 
  specify(formula = yawn ~ group, success = "yes") %>% 
  generate(reps = 1000) %>% 
  calculate(stat = "diff in props", order = c("seed", "control"))

bootstrap_distribution %>% 
  visualize(bins = 20)

# This distribution is roughly symmetric and bell-shaped but isn’t quite there. Let’s use the percentile-based method to compute a 95% confidence interval for the true difference in the proportion of those that yawn with and without a seed presented.

bootstrap_distribution %>% 
  get_ci(type = "percentile", level = 0.95)

# Since the CI includes 0, we aren't sure which has the higher proportion of yawns