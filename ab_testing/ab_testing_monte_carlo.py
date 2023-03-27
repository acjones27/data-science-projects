import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

rng = np.random.default_rng(123)

n_trials = 100_000
prior_alpha = 3
prior_beta = 7

# NOTE: A and B are the groups in the A/B test,
# not to be confused with the alpha and beta from the Beta distribution below
a_clicks, a_no_clicks = (36, 114)
b_clicks, b_no_clicks = (50, 100)

a_samples = rng.beta(
    a=a_clicks + prior_alpha, b=a_no_clicks + prior_beta, size=n_trials
)
b_samples = rng.beta(
    a=b_clicks + prior_alpha, b=b_no_clicks + prior_beta, size=n_trials
)
posterior_b_greater = np.mean(b_samples > a_samples)

improvement = b_samples / a_samples

sns.set()
sns.ecdfplot(improvement)
plt.xlabel("Improvement")
plt.ylabel("Cumulative probability")
plt.title("ecdf(b_samples / a_samples)")


# Q1. Suppose a director of marketing with many years of experience tells you he believes very strongly that the variant without images (B) won’t perform any differently than the original variant. How could you account for this in our model? Implement this change and see how your final conclusions change as well.
# A1. You can account for this by increasing the strength of the prior. For example:

prior_alpha = 300
prior_beta = 700


# Q2. The lead designer sees your results and insists that there’s no way that variant B should perform better with no images. She feels that you should assume the conversion rate for variant B is closer to 20% than 30%. Implement a solution for this and again review the results of our analysis.
# A2. Rather than using one prior to change our beliefs, we want to use two - one that reflects the original prior we had for A and one that reflects the lead designer’s belief in B. Rather than use the weak prior, we’ll use a slightly stronger one:

a_prior_alpha = 30
a_prior_beta = 70
b_prior_alpha = 20
b_prior_beta = 80

# And when we run this simulation, we need to use two separate priors:

a_samples = rng.beta(a_clicks + a_prior_alpha, a_no_clicks + a_prior_beta, n_trials)
b_samples = rng.beta(b_clicks + b_prior_alpha, b_no_clicks + b_prior_beta)
p_b_superior = np.mean(b_samples > a_samples)

# The p_b_superior this time is 0.66, which is lower than before, but still slightly suggests that B might be the superior variant.
