# Bayesian A/B testing with Python
# https://medium.com/hockey-stick/tl-dr-bayesian-a-b-testing-with-python-c495d375db4d
from scipy.stats import beta
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
np.random.seed(123)
people_in_branch = 50
# Control is Alpaca, Experiment is Bear
control, experiment = np.random.rand(2, people_in_branch)

# Generate dummy data
c_successes = sum(control < 0.16)

# Make it so Bears are about 10% better relative to Alpaca
e_successes = sum(experiment < 0.176)

c_failures = people_in_branch - c_successes
e_failures = people_in_branch - e_successes

# Our priors; We think the conversion rate is about 16% so Beta(16, 100-16), but we're skeptical about the performance so we scale down to Beta(8, 42)
prior_successes = 8
prior_failures = 42

# Let's take a look at the results. First we add our priors to our small amount of data in both branches. Then we'll generate the posterior distributions and make some graphs
def plot_dist(c_successes, c_failures, e_successes, e_failures, x = np.linspace(0., 0.5, 1000)):
    fig, ax = plt.subplots(1,1)

    # control
    c_alpha, c_beta = c_successes + prior_successes, c_failures + prior_failures

    # experiment
    e_alpha, e_beta = e_successes + prior_successes, e_failures + prior_failures

    # Generate and plot the distributions
    c_distribution = beta(c_alpha, c_beta)
    e_distribution = beta(e_alpha, e_beta)

    ax.plot(x, c_distribution.pdf(x))
    ax.plot(x, e_distribution.pdf(x))

    ax.set(xlabel = "conversion rate", ylabel = "density")
    return c_distribution, e_distribution

c_distribution, e_distribution = plot_dist(c_successes, c_failures, e_successes, e_failures)
# We can see a difference but it's hard to say which is the true winner. We got a random separation this time but it's still a week result due to the low sample size. We need more data

more_people_in_branch = 6000

control, experiment = np.random.rand(2, more_people_in_branch)

# Add to existing data
c_successes += sum(control < 0.16)
e_successes += sum(experiment < 0.176)

c_failures += more_people_in_branch - sum(control < 0.16)
e_failures += more_people_in_branch - sum(experiment < 0.176)

c_distribution, e_distribution = plot_dist(c_successes, c_failures, e_successes, e_failures, np.linspace(0., 0.3, 1000))

# looks better, at least more separation although it's hard to tell with smaller variation. But how do we know for sure?

# One way is to generate a confidence interval for each distribution. E.g. for 80% confidence interval we'd take the 10% and 90% values from the CDF

# Let's take a 95% confidence interval. Arguments are x values so use ppf, the inverse of cdf
print(c_distribution.ppf([0.025, 0.5, 0.975]))
print(e_distribution.ppf([0.025, 0.5, 0.975]))

# Looks like bears win! but there's still some overlap. Let's double check to be really sure.

# Bayesian equivalent of p-values
# We want to answer: What's the probability that Alpacas are actually better than Bears. To do this, we take samples from both distributions and compare which sample has the largest conversion rate.

sample_size = 100000

# Generate random variates
c_samples = pd.Series([c_distribution.rvs() for _ in range(sample_size)])
e_samples = pd.Series([e_distribution.rvs() for _ in range(sample_size)])

p_ish_value = 1.0 - sum(e_samples > c_samples)/sample_size
print(p_ish_value)

# Our "p-value" is less than 0.05 so we can declare Bears the winner!

# Doing testing to find really small wins is very expensive for most businesses. It makes sense to check just how much of an improvement we think Experiment is vs. Control
# To do this, we generate a CDF of the B samples over the A samples:

fig, ax = plt.subplots(1,1)

ser = pd.Series(e_samples/c_samples)

# Make the CDF
ser = ser.sort_values()
ser[len(ser)] = ser.iloc[-1]
cum_dist = np.linspace(0., 1., len(ser))
ser_cdf = pd.Series(cum_dist, index=ser)

ax.plot(ser_cdf)
ax.set(xlabel = "Bears / Alpacas", ylabel = "CDF")

# As expected there aren't many values below 1 so the A branch didn't win very often. The median is pretty close to 1.1, agreeing with our initial 10% better setting
np.median(ser[:-1])
ser_cdf[ser_cdf == 0.5].index[0]
