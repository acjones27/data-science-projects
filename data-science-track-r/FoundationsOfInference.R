# Load packages
install.packages("NHANES")
library(NHANES)
library(ggplot2)

# What are the variables in the NHANES dataset?
colnames(NHANES)

# Create bar plot for Home Ownership by Gender
ggplot(NHANES, aes(x = Gender, fill = HomeOwn)) + 
  # Set the position to fill
  geom_bar(position = "fill") +
  ylab("Relative frequencies")

# Density plot of SleepHrsNight colored by SleepTrouble
ggplot(NHANES, aes(x = SleepHrsNight, color = SleepTrouble)) + 
  # Adjust by 2
  geom_density(adjust = 2) + 
  # Facet by HealthGen
  facet_wrap(~ HealthGen)

# As seen in the video, natural variability can be modeled from shuffling observations around to remove any relationships that might exist in the population. However, before you permute the data, you need to calculate the original observed statistic. In this exercise, you will calculate the difference in proportion of home owners who are men versus women.

install.packages("infer")
library(infer)

homes <- NHANES %>%
  # Select Gender and HomeOwn
  select(Gender, HomeOwn) %>%
  # Filter for HomeOwn equal to "Own" or "Rent"
  filter(HomeOwn %in% c("Own", "Rent"))

# Find the observed difference in proportions of men who own and women who own.

diff_orig <- homes %>%   
  # Group by gender
  group_by(Gender) %>%
  # Summarize proportion of homeowners
  summarize(prop_own = mean(HomeOwn == "Own")) %>%
  # Summarize difference in proportion of homeowners
  summarize(obs_diff_prop = diff(prop_own)) # male - female

# The infer package will allow you to model a particular null hypothesis and then randomize the data to calculate permuted statistics. In this exercise, after specifying your null hypothesis you will permute the home ownership variable 10 times. By doing so, you will ensure that there is no relationship between home ownership and gender, so any difference in home ownership proportion for female versus male will be due only to natural variability.

# This exercise will demonstrate the first three steps from the infer package: + specify will specify the response and explanatory variables. + hypothesize will declare the null hypothesis. + generate will generate resamples, permutations, or simulations.

# Specify variables
homeown_perm <- homes %>%
  specify(HomeOwn ~ Gender, success = "Own")

# Print results to console
homeown_perm

# Hypothesize independence
homeown_perm <- homes %>%
  specify(HomeOwn ~ Gender, success = "Own") %>%
  hypothesize(null = "independence")  

# Print results to console
homeown_perm

# Perform 10 permutations
homeown_perm <- homes %>%
  specify(HomeOwn ~ Gender, success = "Own") %>%
  hypothesize(null = "independence") %>% 
  generate(reps = 10, type = "permute") 


# Print results to console
homeown_perm

# Perform 100 permutations
homeown_perm <- homes %>%
  specify(HomeOwn ~ Gender, success = "Own") %>%
  hypothesize(null = "independence") %>% 
  generate(reps = 100, type = "permute") %>% 
  calculate("diff in props", order = c("male", "female"))

# Print results to console
homeown_perm

# Dotplot of 100 permuted differences in proportions
ggplot(homeown_perm, aes(x = stat)) + 
  geom_dotplot(binwidth = 0.001)

# Using 100 repetitions allows you to understand the mechanism of permuting. However, 100 is not enough to observe the full range of likely values for the null differences in proportions.

# Recall the four steps of inference. These are the same four steps that will be used in all inference exercises in this course and future statistical inference courses. Use the names of the functions to help you recall the analysis process. + specify will specify the response and explanatory variables. + hypothesize will declare the null hypothesis. + generate will generate resamples, permutations, or simulations. + calculate will calculate summary statistics.

# Perform 1000 permutations
homeown_perm <- homes %>%
  # Specify HomeOwn vs. Gender, with `"Own" as success
  specify(HomeOwn ~ Gender, success = "Own") %>%
  # Use a null hypothesis of independence
  hypothesize(null = "independence") %>% 
  # Generate 1000 repetitions (by permutation)
  generate(reps = 1000, type = "permute") %>% 
  # Calculate the difference in proportions (male then female)
  calculate("diff in props", order = c("male", "female"))

# Density plot of 1000 permuted differences in proportions
ggplot(homeown_perm, aes(x = stat)) + 
  geom_density()

# You can now see that the distribution is approximately normally distributed around -0.01, but what can we conclude from it? 

# Plot permuted differences, diff_perm
ggplot(homeown_perm, aes(x = diff_perm)) + 
  # Add a density layer
  geom_density() +
  # Add a vline layer with intercept diff_orig
  geom_vline(aes(xintercept = diff_orig), color = "red")

# Compare permuted differences to observed difference
homeown_perm %>%
  summarize(sum(diff_perm <= diff_orig))

disc <- read_csv('disc.csv')

disc %>%
  # Count the rows by promote and sex
  count(promote, sex)

# Find proportion of each sex who were promoted
disc %>%
  # Group by sex
  group_by(sex) %>%
  # Calculate proportion promoted summary stat
  summarize(promoted_prop = mean(promote == "promoted"))

# Replicate the entire data frame, permuting the promote variable
disc_perm <- disc %>%
  specify(promote ~ sex, success = "promoted") %>%
  hypothesize(null = "independence") %>%
  generate(reps = 5, type = "permute")

disc_perm %>%
  # Group by replicate
  group_by(replicate) %>%
  # Count per group
  count(promote, sex)

disc_perm %>%
  # Calculate difference in proportion, male then female
  calculate(stat = "diff in props", order = c("male", "female"))

# Recall that we are considering a situation where the number of men and women are fixed (representing the resumes) and the number of people promoted is fixed (the managers were able to promote only 35 individuals).
# 
# In this exercise, you'll create a randomization distribution of the null statistic with 1000 replicates as opposed to just 5 in the previous exercise. As a reminder, the statistic of interest is the difference in proportions promoted between genders (i.e. proportion for males minus proportion for females). From the original dataset, you can calculate how the promotion rates differ between males and females. Using the specify-hypothesis-generate-calculate workflow in infer, you can calculate the same statistic, but instead of getting a single number, you get a whole distribution. In this exercise, you'll compare that single number from the original dataset to the distribution made by the simulation.

# Calculate the observed difference in promotion rate
diff_orig <- disc %>%
  # Group by sex
  group_by(sex) %>%
  # Summarize to calculate fraction promoted
  summarize(prop_prom = mean(promote == "promoted")) %>%
  # Summarize to calculate difference
  summarize(stat = diff(prop_prom)) %>% 
  pull() #pulls out just the value

# See the result
diff_orig

# Create data frame of permuted differences in promotion rates
disc_perm <- disc %>%
  # Specify promote vs. sex
  specify(promote ~ sex, success = "promoted") %>%
  # Set null hypothesis as independence
  hypothesize(null = "independence") %>%
  # Generate 1000 permutations
  generate(reps = 1000, type = "permute") %>%
  # Calculate difference in proportions
  calculate(stat = "diff in props", order = c("male", "female"))

# Using permutation data, plot stat
ggplot(disc_perm, aes(x = stat)) + 
  # Add a histogram layer
  geom_histogram(binwidth = 0.01) +
  # Using original data, add a vertical line at stat
  geom_vline(aes(xintercept = diff_orig), color = "red")

disc_perm %>% 
  summarize(
    # Find the 0.9 quantile of diff_perm's stat
    q.90 = quantile(stat, p = 0.9),
    # ... and the 0.95 quantile
    q.95 = quantile(stat, p = 0.95),
    # ... and the 0.99 quantile
    q.99 = quantile(stat, p = 0.99)
  )

# For the discrimination data, the question at hand is whether or not women were promoted less often than men. However, there are often scenarios where the research question centers around a difference without directionality.
# 
# For example, you might be interested in whether the rate of promotion for men and women is different. In that case, a difference in proportions of -0.29 is just as "extreme" as a difference of positive 0.29.
# 
# If you had seen that women were promoted more often, what would the other side of the distribution of permuted differences look like? That is, what are the smallest (negative) values of the distribution of permuted differences?

# Use disc_perm
disc_perm %>% 
  # ... to calculate summary stats
  summarize(
    # Find the 0.01 quantile of stat
    q.01 = quantile(stat, p = 0.01),
    # ... and 0.05
    q.05 = quantile(stat, p = 0.05),
    # ... and 0.1 
    q.10 = quantile(stat, p = 0.1)
  )

disc_small <- readRDS('disc_small.rds')
disc_big <- readRDS('disc_big.rds')

# Tabulate the small dataset
disc_small %>% 
  # Select sex and promote
  select(sex, promote) %>%
  count(sex, promote)

# Do the same for disc_big
disc_big %>% 
  # Select sex and promote
  select(sex, promote) %>%
  count(sex, promote)

diff_orig_small <- 0.25

disc_perm_small <- disc_small %>%
  # Specify promote vs. sex
  specify(promote ~ sex, success = "promoted") %>%
  # Set null hypothesis as independence
  hypothesize(null = "independence") %>%
  # Generate 1000 permutations
  generate(reps = 1000, type = "permute") %>%
  # Calculate difference in proportions
  calculate(stat = "diff in props", order = c("male", "female"))

# Using disc_perm_small, plot stat
ggplot(disc_perm_small, aes(x = stat)) + 
  # Add a histogram layer with binwidth 0.01
  geom_histogram(binwidth = 0.01) +
  # Add a vline layer, crossing x-axis at diff_orig_small
  geom_vline(aes(xintercept = diff_orig_small), color = "red")

diff_orig_big <- 0.2916667

disc_perm_big <- disc_big %>%
  # Specify promote vs. sex
  specify(promote ~ sex, success = "promoted") %>%
  # Set null hypothesis as independence
  hypothesize(null = "independence") %>%
  # Generate 1000 permutations
  generate(reps = 1000, type = "permute") %>%
  # Calculate difference in proportions
  calculate(stat = "diff in props", order = c("male", "female"))

# Swap the dataset to disc_perm_big
ggplot(disc_perm_big, aes(x = stat)) + 
  geom_histogram(binwidth = 0.01) +
  # Change the x-axis intercept to diff_orig_big
  geom_vline(aes(xintercept = diff_orig_big), color = "red")

calc_upper_quantiles <- function(dataset) {
  dataset %>% 
    summarize(
      q.90 = quantile(stat, p = 0.90),
      q.95 = quantile(stat, p = 0.95),
      q.99 = quantile(stat, p = 0.99)
    )
}

# Recall the quantiles associated with the original dataset
calc_upper_quantiles(disc_perm)

# Calculate the quantiles associated with the small dataset
calc_upper_quantiles(disc_perm_small)

# Calculate the quantiles associated with the big dataset
calc_upper_quantiles(disc_perm_big)

# In the video, you learned that a p-value measures the degree of disagreement between the data and the null hypothesis. Here, you will calculate the p-value for the original discrimination dataset as well as the small and big versions, disc_small and disc_big.
# 
# Recall that you're only interested in the one-sided hypothesis test here. That is, you're trying to answer the question, "Are men more likely to be promoted than women?"

# Visualize and calculate the p-value for the original dataset
disc_perm %>%
  visualize(obs_stat = diff_orig, direction = "greater")

disc_perm %>%
  summarize(p_value = mean(diff_orig <= stat))

# Visualize and calculate the p-value for the small dataset
disc_perm_small %>%
  visualize(obs_stat = diff_orig_small, direction = "greater")

disc_perm_small %>%
  summarize(p_value = mean(diff_orig_small <= stat))

# Visualize and calculate the p-value for the original dataset
disc_perm_big %>%
  visualize(obs_stat = diff_orig_big, direction = "greater")

disc_perm_big %>%
  summarize(p_value = mean(diff_orig_big <= stat))

# can play around with "two-sided", "less" for direction

disc_new <- readRDS('disc_new.rds')

# Recall the original data
disc %>% 
  count(sex, promote)

# Tabulate the new data
disc_new %>%
  count(sex, promote)

diff_orig_new <- 0.04166667

# Recall the distribution of the original permuted differences
ggplot(disc_perm, aes(x = stat)) + 
  geom_histogram() +
  geom_vline(aes(xintercept = diff_orig), color = "red")

# Plot the distribution of the new permuted differences
ggplot(disc_perm_new, aes(x = stat)) + 
  geom_histogram() +
  geom_vline(aes(xintercept = diff_orig_new), color = "red")

# Recall the p-value from the original data
disc_perm %>%
  summarize(p_value = mean(diff_orig <= stat))

# Find the p-value from the new data
disc_perm_new %>%
  summarize(p_value = mean(diff_orig_new <= stat))

# What if the original research hypothesis had focused on any difference in promotion rates between men and women instead of focusing on whether men are more likely to be promoted than women? In this case, a difference like the one observed would occur twice as often (by chance) because sometimes the difference would be positive and sometimes it would be negative.

# When there is no directionality to the alternative hypothesis, the hypothesis and p-value are considered to be two-sided. In a two-sided setting, the p-value is double the one-sided p-value.

# In this exercise, you'll calculate a two-sided p-value given the original randomization distribution and dataset.

# Calculate the two-sided p-value
disc_perm %>%
  summarize(p_value = 2*mean(diff_orig <= stat))