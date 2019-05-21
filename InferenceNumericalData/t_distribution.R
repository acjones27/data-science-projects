# We can use the pt() function to find probabilities under the t-distribution. 
# For a given cutoff value q and a given degrees of freedom df, pt(q, df) gives us the probability under the t-distribution with df degrees of freedom for values of t less than q. 
# In other words, P(t_df<T) = pt(q = T, df)

# P(T < 3) for df = 10
(x <- pt(q = 3, df = 10))

# P(T > 3) for df = 10
(y <- 1 - pt(q = 3, df = 10))

# P(T > 3) for df = 100
(z <- 1 - pt(q = 3, df = 100))

# Comparison
y == z
y > z
y < z

# We can use the qt() function to find cutoffs under the t-distribution. 
# For a given probability p and a given degrees of freedom df, qt(p, df) gives us the cutoff value for the t-distribution with df degrees of freedom for which the probability under the curve is p. 
# In other words, if P(tdf<T)=p, then T = qt(p, df). 
# For example, if T corresponds to the 95th percentile of a distribution, p=0.95. The "middle 95%" means from p = 0.025 to p = 0.975

# 95th percentile for df = 10
(x <- qt(0.95, df = 10))

# Upper bound of middle 95th percent for df = 10
(y <- qt(0.975, df = 10))

# Upper bound of middle 95th percent for df = 100
(z <- qt(0.975, df = 100))

# Comparison
y == z
y > z
y < z

# CLT: The distibution of the sample means is approximately normally distributed, centered at the population mean and with standard error equal to the standard deviation of the population divided by the sqrt of the sample size
# Standard error = standard deviation of the sampling distribution
# We can't generate this distribution because we don't have the option to access the population for resampling and the pop standard deviation is often not known. Instead of using the population standard deviation, we use the sample standard deviation instead. This error is mitigated by using a t-distribution with n-1 degrees of freedom since compared with the normal distribution the t-distribution is more conservative with fatter tails
# Conditions:
# - Independent observations (random sampling, sample size < 10% of population)
# - Sample size/skew: The more skewed the original population, the larger the sample size should be

### DO NOT RUN CODE BELOW, AS NO DATASET COULD BE FOUND

t.test(gss$moredays, conf.level = 0.95)
# outputs a bunch of stuff and then a CI 5.273 6.147

# "We are 95% confident that the average number of days per month americans work overtime is between 5.27 and 6.15"

# When given one argument, t.test() tests whether the population mean of its input is different than 0. That is H0:μdiff=0 and HA:μdiff≠0. It also provides a 95% confidence interval.

# Filter for employed respondents
acs12_emp <- acs12 %>%
  filter(employment == "employed")

# Construct 95% CI for avg time_to_work
t.test(acs12_emp$time_to_work, conf.level = 0.95)

# Run a t-test on hrs_work and look at the CI
t.test(acs12_emp$hrs_work)

# The CI output is 38.05811 39.80429
# For this analysis, it would have made more sense to use a subset excluding part time workers.


# A random sample was taken of nearly 10% of UCLA courses. The most expensive textbook for each course was identified, and its price at the UCLA Bookstore and on Amazon.com were recorded. These data are recorded in the textbooks dataset. We want to test whether there is a difference between the average prices of textbooks sold in the bookstore vs. on Amazon.
# Since the book price data are paired (the price of the same book at the two stores are not independent), rather than using individual variables for the prices from each store, you will look at the a single variables of the differences in price. The diff column the UCLA Bookstore price minus the Amazon.com price for each book

# Run a t-test on diff with a 90% CI
t.test(textbooks$diff, conf.level = 0.9)

# Same with 95% CI
t.test(textbooks$diff, conf.level = 0.95)

# Same with 99% CI
t.test(textbooks$diff, conf.level = 0.99)