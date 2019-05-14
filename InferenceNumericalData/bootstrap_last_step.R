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