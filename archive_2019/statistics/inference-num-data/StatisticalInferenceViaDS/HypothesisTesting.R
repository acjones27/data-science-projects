library(dplyr)
library(ggplot2)
library(infer)
library(nycflights13)
library(ggplot2movies)
library(broom)

# We recommend you always do an exploratory analysis first, before running any inference test
# Example:

bos_sfo <- flights %>% 
  na.omit() %>% 
  filter(dest %in% c("BOS", "SFO")) %>% 
  group_by(dest) %>% 
  sample_n(100)

# Suppose we were interested in seeing if the air_time to SFO in San Francisco was statistically greater than the air_time to BOS in Boston.
# EDA:

bos_sfo_summary <- bos_sfo %>% 
  group_by(dest) %>% 
  summarize(mean_time = mean(air_time),
            sd_time = sd(air_time))
bos_sfo_summary

# To further understand just how different the air_time variable is for BOS and SFO, let’s look at a boxplot:
ggplot(data = bos_sfo, mapping = aes(x = dest, y = air_time)) +
  geom_boxplot()

# Since there is no overlap at all, we can conclude that the air_time for San Francisco flights is statistically greater (at any level of significance) than the air_time for Boston flights. This is a clear example of not needing to do anything more than some simple exploratory data analysis with descriptive statistics and data visualization to get an appropriate inferential conclusion. This is one reason why you should ALWAYS investigate the sample data first using dplyr and ggplot2 via exploratory data analysis.

# We assess the strength of evidence by assuming the null hypothesis is true and determining how unlikely it would be to see sample results/statistics as extreme (or more extreme) as those in the original sample

# We can think of hypothesis testing in the same context as a criminal trial in the United States.
# 
# The accuser of the crime must be judged either guilty or not guilty.
# Under the U.S. system of justice, the individual on trial is initially presumed not guilty.
# Only STRONG EVIDENCE to the contrary causes the not guilty claim to be rejected in favor of a guilty verdict
# The phrase “beyond a reasonable doubt” is often used to set the cutoff value for when enough evidence has been given to convict.
# 
# Now let’s compare that to how we look at a hypothesis test.
# The decision about the population parameter(s) must be judged to follow one of two hypotheses.
# We initially assume that the null hypothesis is true
# The null hypothesis will be rejected (in favor of the alternative) only if the sample evidence strongly suggests that the null is false. If the sample does not provide such evidence, it will not be rejected.
# The analogy to “beyond a reasonable doubt” in hypothesis testing is what is known as the significance level. This will be set before conducting the hypothesis test and is denoted as alpha
# Common values for alpha are 0.1, 0.01, and 0.05.
# 
# So we only have two outcomes
# Reject the null
# Fail to reject the null

# The possible erroneous conclusions in a criminal trial are
# - an innocent person is convicted (found guilty) or
# - a guilty person is set free (found not guilty).
# 
# The possible errors in a hypothesis test are
# - rejecting the null when it is true (Type I i.e. False Positive)
# - failing to reject the null when it is false (Type II i.e. False Negative)
# 
# The probability of a Type I is the significance value alpha
# The probability of a Type II error is beta


# Example: Comparing 2 means
# Our null hypothesis here is that mu_1 = mu_2 i.e. mu_1 - mu_2 = 0
# We are interested in the question here of whether Action movies are rated higher on IMDB than Romance movies

movies_trimmed <- movies %>% 
  select(title, year, rating, Action, Romance)

# Note that Action and Romance are binary variables here. Let's filter where they are both flagged

movies_trimmed <- movies_trimmed %>%
  filter(!(Action == 1 & Romance == 1))

# We will now create a new variable called genre that specifies whether a movie in our movies_trimmed data frame is an "Action" movie, a "Romance" movie, or "Neither". We aren’t really interested in the "Neither" category here so we will exclude those rows as well. Lastly, the Action and Romance columns are not needed anymore since they are encoded in the genre column.

movies_trimmed <- movies_trimmed %>%
  mutate(genre = case_when(Action == 1 ~ "Action",
                           Romance == 1 ~ "Romance",
                           TRUE ~ "Neither")) %>% # a logical statement equivalent to "else"
  filter(genre != "Neither") %>%
  select(-Action, -Romance)

# Now let's visualise
ggplot(data = movies_trimmed, aes(x = genre, y = rating)) +
  geom_boxplot()

# We are initially interested in comparing the mean rating across these two groups so a faceted histogram may also be useful:

ggplot(data = movies_trimmed, mapping = aes(x = rating)) +
  geom_histogram(binwidth = 1, color = "white") +
  facet_grid(genre ~ .)

# Let’s select a random sample of 34 action movies and a random sample of 34 romance movies. (The number 34 was chosen somewhat arbitrarily here.)

set.seed(2017)
movies_genre_sample <- movies_trimmed %>% 
  group_by(genre) %>%
  sample_n(34) %>% 
  ungroup()

# We can now observe the distributions of our two sample ratings for both groups. Remember that these plots should be rough approximations of our population distributions of movie ratings
ggplot(data = movies_genre_sample, aes(x = genre, y = rating)) +
  geom_boxplot()

ggplot(data = movies_genre_sample, mapping = aes(x = rating)) +
  geom_histogram(binwidth = 1, color = "white") +
  facet_grid(genre ~ .)

# It’s often useful to calculate the mean and standard deviation as well, conditioned on the two levels.

summary_ratings <- movies_genre_sample %>% 
  group_by(genre) %>%
  summarize(mean = mean(rating),
            std_dev = sd(rating),
            n = n())
summary_ratings

# But is it statistically significantly greater (thus, leading us to conclude that the means are statistically different)? The standard deviation can provide some insight here but with these standard deviations being so similar it’s still hard to say for sure
# H0: mu_r - mu_a = 0
# HA: mu_r - mu_a != 0
# We are, therefore, interested in seeing whether the difference in the sample means, is statistically different than 0

obs_diff <- movies_genre_sample %>% 
specify(formula = rating ~ genre) %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action"))
obs_diff

# If we assume that the two population means are equal, we are saying that there is no association between ratings and genre (romance vs action). We can create two new groups for romance and action movies. Note that the new “romance group" will likely have some of the original action movies in it and likewise for the “action movie group” including some romance movies from our original set. 
# Since we are assuming that each movie is equally likely to have appeared in either one of the groups this makes sense. 

movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>%
  hypothesize(null = "independence") %>% 
  generate(reps = 1) %>% # implied type = "permute"
  calculate(stat = "diff in means", order = c("Romance", "Action"))

# The generate() step completes a permutation sending values of ratings to potentially different values of genre from which they originally came.

generated_samples <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  hypothesize(null = "independence") %>% # implied type = "permute"
  generate(reps = 5000)

null_distribution_two_means <- generated_samples %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action"))

null_distribution_two_means %>% visualize()

null_distribution_two_means %>% 
  visualize(bins = 50) +
  shade_p_value(obs_stat = obs_diff, direction = "both")

pvalue <- null_distribution_two_means %>% 
  get_pvalue(obs_stat = obs_diff, direction = "both")
pvalue

# We have around 8% of values as extreme or more extreme than our observed statistic in both directions

# One of the great things about the infer pipeline is that going between hypothesis tests and confidence intervals is incredibly simple. To create a null distribution, we ran

null_distribution_two_means <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  hypothesize(null = "independence") %>% 
  generate(reps = 5000) %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action"))

# To get the corresponding bootstrap distribution with which we can compute a confidence interval, we can just remove or comment out the hypothesize() step since we are no longer assuming the null hypothesis is true when we bootstrap:

percentile_ci_two_means <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  #  hypothesize(null = "independence") %>% 
  generate(reps = 5000) %>% 
  calculate(stat = "diff in means", order = c("Romance", "Action")) %>% 
  get_ci()

percentile_ci_two_means

# To review, these are the steps one would take whenever you’d like to do a hypothesis test comparing values from the distributions of two groups:

# Simulate many samples using a random process that matches the way the original data were collected and that assumes the null hypothesis is true.

# Collect the values of a sample statistic for each sample created using this random process to build a null distribution.

# Assess the significance of the original sample by determining where its sample statistic lies in the null distribution.

# If the proportion of values as extreme or more extreme than the observed statistic in the randomization distribution is smaller than the pre-determined significance level then we reject the null. Otherwise we fail to reject it


# Example: t-test for two independent samples
# What is commonly done in statistics is the process of standardization. 
# What this entails is calculating the mean and standard deviation of a variable. Then you subtract the mean from each value of your variable and divide by the standard deviation. The most common standardization is known as the z-score = (x - mu) / sigma
# 
# x represent the value of a variable,  
# mu represents the mean of the variable, and  
# sigma represents the standard deviation of the variable. 
# Thus, if your variable has 10 elements, each one has a corresponding z-score that gives how many standard deviations away that value is from its mean.  
# z-scores are normally distributed with mean 0 and standard deviation 1

# Recall this distribution:
  
ggplot(data = null_distribution_two_means, aes(x = stat)) +
geom_histogram(color = "white", bins = 20)

# The infer package also includes some built-in theory-based statistics as well, so instead of going through the process of trying to transform the difference into a standardized form, we can just provide a different value for stat in calculate()

# Recall the generated_samples data frame created via:

generated_samples <- movies_genre_sample %>% 
  specify(formula = rating ~ genre) %>% 
  hypothesize(null = "independence") %>% 
  generate(reps = 5000)

null_distribution_t <- generated_samples %>% 
  calculate(stat = "t", order = c("Romance", "Action"))
null_distribution_t %>% visualize()

# A traditional t-test doesn’t look at this simulated distribution, but instead it looks at the t-curve
null_distribution_t %>% 
  visualize(method = "both")
