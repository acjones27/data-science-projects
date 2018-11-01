# Load the ggplot2 package
library(ggplot2)

# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(x = cyl, y = mpg)) +
  geom_point()

# Change the command below so that cyl is treated as factor/categorical variable
ggplot(mtcars, aes(x = factor(cyl), y = mpg)) +
  geom_point()

# A scatter plot has been made for you
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()

# display the "disp" column (displacement of the car engine) in the dataset as color
ggplot(mtcars, aes(x = wt, y = mpg, color = disp)) +
  geom_point()

# display the "disp" column in the dataset as size
ggplot(mtcars, aes(x = wt, y = mpg, size = disp)) +
  geom_point()

# could also use "shape" here, 
# but since disp is a continuous variable and there are a finite number of shapes, R gives an error message

# Explore the diamonds data frame with str()
str(diamonds)

# Add geom_point() with +
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()


# Add geom_point() and geom_smooth() with +
# geom_smooth() will draw a smoothed line over the points.
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() + 
  geom_smooth()

# 1 - The plot you created in the previous exercise
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth()

# 2 - Copy the above command but show only the smooth line
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_smooth()

# 3 - Copy the above command and assign the correct value to col in aes()
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_smooth()

# 4 - Keep the color settings from previous command. Plot only the points with argument alpha. This will make the points 60% transparent/40% visible.
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.4)

# Create the object containing the data and aes layers: dia_plot
dia_plot <- ggplot(diamonds, aes(x = carat, y = price))

# Add a geom layer with + and geom_point()
dia_plot + geom_point()

# Add the same geom layer, but with aes() inside
dia_plot + geom_point(aes(color = clarity))

# 1 - The dia_plot object has been created for you
dia_plot <- ggplot(diamonds, aes(x = carat, y = price))

# 2 - Expand dia_plot by adding geom_point() with alpha set to 0.2
dia_plot <- dia_plot + geom_point(alpha = 0.2)

# 3 - Plot dia_plot with additional geom_smooth() with se set to FALSE (doesn't show error shading)
dia_plot + geom_smooth(se = FALSE)

# add clarity to the color argument
dia_plot + geom_smooth(aes(se = FALSE, col = clarity))

# Use lm() to calculate a linear model and save it as carModel
# Calculate a linear model of mpg described by wt and save it as an object called carModel.
carModel <- lm(mpg ~ wt, data = mtcars)


# Plot 1: add geom_point() in order to make a scatter plot.
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
geom_point()

# Plot 2: copy and paste Plot 1.
# Add a linear model for each subset according to cyl by adding a geom_smooth() layer
# Inside this geom_smooth(), set method to "lm" and se to FALSE.
# Note: geom_smooth() will automatically draw a line per cyl subset. It recognizes the groups you want to identify by color in the aes() call within the ggplot() command.
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)

# Plot 3: copy and paste Plot 2.
# Plot a linear model for the entire dataset, do this by adding another geom_smooth() layer.
# Set the group aesthetic inside this geom_smooth() layer to 1. This has to be set within the aes() function.
# Set method to "lm", se to FALSE and linetype to 2. These have to be set outside aes() of the geom_smooth().
# Note: the group aesthetic will tell ggplot() to draw a single linear model through all the points.

ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, linetype = 2)


# Load the tidyr package
library(tidyr)
head(iris)

# You'll use two functions from the tidyr package:
# - gather() rearranges the data frame by specifying the columns that are categorical variables with a - notation. Notice that only one variable is categorical in iris.
# - separate() splits up the new key column, which contains the former headers, according to '.' . The new column names "Part" and "Measure" are given in a character vector. 

head(iris)

iris.tidy <- iris %>%
  gather(key, Value, -Species) %>%
  separate(key, c("Part", "Measure"), "\\.")

head(iris.tidy)

ggplot(iris.tidy, aes(x = Species, y = Value, col = Part)) +
  geom_jitter() +
  facet_grid(. ~ Measure)

# Before you begin, you need to add a new column called Flower that contains a unique identifier for each row in the data frame. This is because you'll rearrange the data frame afterwards and you need to keep track of which row, or which specific flower, each value came from. 

iris$Flower <- 1:nrow(iris)


# gather() rearranges the data frame by specifying the columns that are categorical variables with a - notation. In this case, Species and Flower are categorical. 

# separate() splits up the new key column, which contains the former headers, according to . . The new column names "Part" and "Measure" are given in a character vector.

# The last step is to use spread() to distribute the new Measure column and associated value column into two columns.

head(iris)

iris.wide <- iris %>%
  gather(key, value, -Species, -Flower) %>%
  separate(key, c("Part", "Measure"), "\\.") %>%
  spread(Measure, value)

head(iris.wide)

ggplot(iris.wide, aes(x = Length, y = Width, color = Part)) +
  geom_jitter() +
  facet_grid(. ~ Species)