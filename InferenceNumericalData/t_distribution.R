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