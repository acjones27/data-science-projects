
# planets vector
planets <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")

# type vector
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")

# diameter vector
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)

# rotation vector
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)

# rings vector
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)

# construct a dataframe planet_df from all the above variables
planet_df <- data.frame(planets, type, diameter, rotation, rings)

# select the values in the first row and second and third columns
planet_df[1, 2:3]

# select the entire third column
planet_df[,3]