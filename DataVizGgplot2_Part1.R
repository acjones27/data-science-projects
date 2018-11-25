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

# aesthetics are variable mappings
# attributes are fixed things about the graph e.g. colour of points
# data frame columns are mapped onto visible aestetics
# aesthetics called in aes_
# attributes called in geom_()

# colour = colour of dots, outlines
# fill = fill colour
# size = diameter of points, thickness of lines
# alpha = transparency 
# linetype = dashed patterns
# labels = text on plot or axis
# shape = shape of point

mtcars$cyl <- as.factor(mtcars$cyl)
str(mtcars)

# 1 - Map mpg to x and cyl to y
ggplot(mtcars, aes(x = mpg, y = cyl)) +
  geom_point()

# 2 - Reverse: Map cyl to x and mpg to y
ggplot(mtcars, aes(x = cyl, y = mpg)) +
  geom_point()

# 3 - Map wt to x, mpg to y and cyl to col
ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl)) +
  geom_point()

# 4 - Change shape and size of the points in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl)) +
  geom_point(shape = 1, size = 4)


# The color aesthetic typically changes the outside outline of an object and the fill aesthetic is typically the inside shading. However, as you saw in the last exercise, geom_point() is an exception. Here you use color, instead of fill for the inside of the point. But it's a bit subtler than that.

# Which shape to use? The default geom_point() uses shape = 19 (a solid circle with an outline the same colour as the inside). Good alternatives are shape = 1 (hollow) and shape = 16 (solid, no outline). These all use the col aesthetic (don't forget to set alpha for solid points).
 
# A really nice alternative is shape = 21 which allows you to use both fill for the inside and col for the outline! This is a great little trick for when you want to map two aesthetics to a dot.

mtcars$am <- as.factor(mtcars$am)

# am and cyl are factors, wt is numeric
class(mtcars$am)
class(mtcars$cyl)
class(mtcars$wt)

# From the previous exercise
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point(shape = 1, size = 4)

# 1 - Map cyl to fill
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(shape = 1, size = 4)


# 2 - Change shape and alpha of the points in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)


# 3 - Map am to col in the above plot
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl, col = am)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)

# Notice that mapping a categorical variable onto fill doesn't change the colors, although a legend is generated! This is because the default shape for points only has a color attribute and not a fill attribute! Use fill when you have another shape (such as a bar), or when using a point that does have a fill and a color attribute, such as shape = 21, which is a circle with an outline. Any time you use a solid color, make sure to use alpha blending to account for over plotting.

#  Inside aes(), map wt onto x and mpg onto y. Typically, you would say "mpg described by wt" or "mpg vs wt", but in aes(), it's x first, y second.

# Map cyl to size
ggplot(mtcars, aes(x = wt, y = mpg, size = cyl)) + 
  geom_point()


# Map cyl to alpha
ggplot(mtcars, aes(x = wt, y = mpg, alpha = cyl)) +
  geom_point()


# Map cyl to shape 
ggplot(mtcars, aes(x = wt, y = mpg, shape = cyl)) +
  geom_point()


# Map cyl to label
ggplot(mtcars, aes(x = wt, y = mpg, label = cyl)) +
  geom_text()

# In the video you saw that you can use all the aesthetics as attributes. Let's see how this works with the aesthetics you used in the previous exercises: x, y, color, fill, size, alpha, label and shape.

# This time you'll use these arguments to set attributes of the plot, not aesthetics. However, there are some pitfalls you'll have to watch out for: these attributes can overwrite the aesthetics of your plot!
 
# A word about shapes: In the exercise "All about aesthetics, part 2", you saw that shape = 21 results in a point that has a fill and an outline. Shapes in R can have a value from 1-25. Shapes 1-20 can only accept a color aesthetic, but shapes 21-25 have both a color and a fill aesthetic. See the pch argument in par() for further discussion.
 
# A word about hexadecimal colours: Hexadecimal, literally "related to 16", is a base-16 alphanumeric counting system. Individual values come from the ranges 0-9 and A-F. This means there are 256 possible two-digit values (i.e. 00 - FF). Hexadecimal colours use this system to specify a six-digit code for Red, Green and Blue values ("#RRGGBB") of a colour (i.e. Pure blue: "#0000FF", black: "#000000", white: "#FFFFFF"). R can accept hex codes as valid colours.

# Define a hexadecimal color
my_color <- "#4ABEFF"

# Draw a scatter plot with color *aesthetic*
ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl)) + 
  geom_point()


# Same, but set color *attribute* in geom layer 
ggplot(mtcars, aes(x = wt, y = mpg, colour = cyl)) + 
  geom_point(colour = my_color)



# Set the fill aesthetic; color, size and shape attributes
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) + 
  geom_point(shape = 23, size = 10, colour = my_color)

# Expand to draw points with alpha 0.5
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl)) +
  geom_point(alpha = 0.5)


# Expand to draw points with shape 24 and color yellow
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl))  + 
  geom_point(shape = 24, colour = "yellow")


# Expand to draw text with label rownames(mtcars) and color red
ggplot(mtcars, aes(x = wt, y = mpg, fill = cyl, label = rownames(mtcars))) +
  geom_text(colour = "red")

# For completeness, here is a list of all the features of the observations in mtcars:
  
# mpg -- Miles/(US) gallon
# cyl -- Number of cylinders
# disp -- Displacement (cu.in.)
# hp -- Gross horsepower
# drat -- Rear axle ratio
# wt -- Weight (lb/1000)
# qsec -- 1/4 mile time
# vs -- V/S engine.
# am -- Transmission (0 = automatic, 1 = manual)
# gear -- Number of forward gears
# carb -- Number of carburetors

# Note: In this chapter you saw aesthetics and attributes. Variables in a data frame are mapped to aesthetics in aes(). (e.g. aes(col = cyl)) within ggplot(). Visual elements are set by attributes in specific geom layers (geom_point(col = "red")). Don't confuse these two things - here you're focusing on aesthetic mappings.

# Map mpg onto x, qsec onto y and factor(cyl) onto col
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl))) +
  geom_point()


# Add mapping: factor(am) onto shape
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl), shape = factor(am))) +
  geom_point()


# Add mapping: (hp/wt) onto size
ggplot(mtcars, aes(x = mpg, y = qsec, col = factor(cyl), shape = factor(am), size = (hp/wt))) +
  geom_point()

# You saw how jittering worked in the video, but bar plots suffer from their own issues of overplotting, as you'll see here. Use the "stack", "fill" and "dodge" positions to reproduce the plot in the viewer.

# The ggplot2 base layers (data and aesthetics) have already been coded; they're stored in a variable cyl.am. It looks like this:

cyl.am <- ggplot(mtcars, aes(x = factor(cyl), fill = factor(am)))

# The base layer, cyl.am, is available for you
# Add geom (position = "stack" by default)
cyl.am + 
  geom_bar()

# Fill - show proportion
cyl.am + 
  geom_bar(position = "fill")  

# Dodging - principles of similarity and proximity
# side by side bars
cyl.am +
  geom_bar(position = "dodge") 

# Clean up the axes with scale_ functions
val = c("#E41A1C", "#377EB8") # colours of bars
lab = c("Manual", "Automatic") # labels of bars
cyl.am +
  geom_bar(position = "dodge") +
  scale_x_discrete("Cylinders") + 
  scale_y_continuous("Number") +
  scale_fill_manual("Transmission", 
                    values = val,
                    labels = lab) 

# That's because although you can make univariate plots (such as histograms, which you'll get to in the next chapter), a y-axis will always be provided, even if you didn't ask for it.

# Try to run ggplot(mtcars, aes(x = mpg)) + geom_point() in the console. x is only one of the two essential aesthetics for geom_point(), which is why you get an error message.

# 1 - Create jittered plot of mtcars, mpg onto x, 0 onto y
ggplot(mtcars, aes(x = mpg, y = 0)) +
  geom_jitter()

# 2 - Add function to change y axis limits
ggplot(mtcars, aes(x = mpg, y = 0)) +
  geom_jitter() + 
  scale_y_continuous(limits = c(-2,2))

# Basic scatter plot: wt on x-axis and mpg on y-axis; map cyl to col
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point(size = 4)


# Hollow circles - an improvement
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point(size = 4, shape = 1)


# Add transparency - very nice
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) + 
  geom_point(size = 4, alpha = 0.6)

# Scatter plot: carat (x), price (y), clarity (color)
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_point()


# Adjust for overplotting
ggplot(diamonds, aes(x = carat, y = price, color = clarity)) +
  geom_point(alpha = 0.5)


# Scatter plot: clarity (x), carat (y), price (color)
ggplot(diamonds, aes(x = clarity, y = carat, color = price)) +
  geom_point(alpha = 0.5)


# Dot plot with jittering
ggplot(diamonds, aes(x = clarity, y = carat, color = price)) +
  geom_point(alpha = 0.5, position = "jitter")

# qplot() with x only
qplot(x = factor(cyl), data = mtcars)

# qplot() with x and y
qplot(x = factor(cyl), y = factor(vs), data = mtcars)

# qplot() with geom set to jitter manually
qplot(x = factor(cyl), y = factor(vs), data = mtcars, geom = "jitter")

# cyl and am are factors, wt is numeric
class(mtcars$cyl)
class(mtcars$am)
class(mtcars$wt)

# "Basic" dot plot, with geom_point():
ggplot(mtcars, aes(cyl, wt, col = am)) +
  geom_point(position = position_jitter(0.2, 0))

# 1 - "True" dot plot, with geom_dotplot():
ggplot(mtcars, aes(cyl, wt, fill = am)) +
  geom_dotplot(binaxis = "y", stackdir = "center")

# 2 - qplot with geom "dotplot", binaxis = "y" and stackdir = "center"
qplot(
  cyl, wt,
  data = mtcars,
  fill = am,
  geom = "dotplot",
  binaxis = "y",
  stackdir = "center"
)

# ChickWeight is available in your workspace
# 1 - Check out the head of ChickWeight
head(ChickWeight)

# 2 - Basic line plot
ggplot(ChickWeight, aes(x = Time, y = weight)) +
  geom_line(aes(group = Chick))

# 3 - Take plot 2, map Diet onto col.
ggplot(ChickWeight, aes(x = Time, y = weight, color = Diet)) +
  geom_line(aes(group = Chick))



# 4 - Take plot 3, add geom_smooth()
ggplot(ChickWeight, aes(x = Time, y = weight, color = Diet)) +
  geom_line(aes(group = Chick), alpha = 0.3) +
  geom_smooth(lwd = 2, se = FALSE)

install.packages("titanic")
library(titanic)
titanic <- titanic_train[,c(2,3,5,6)]
titanic$Sex <- as.factor(titanic$Sex)
str(titanic)

# titanic is avaliable in your workspace
# 1 - Check the structure of titanic
str(titanic)

# 2 - Use ggplot() for the first instruction
ggplot(titanic, aes(x = Pclass, fill = Sex)) +
  geom_bar(position = "dodge")

# 3 - Plot 2, add facet_grid() layer
ggplot(titanic, aes(x = Pclass, fill = Sex)) +
  geom_bar(position = "dodge") +
  facet_grid(.~Survived)

# 4 - Define an object for position jitterdodge, to use below
posn.jd <- position_jitterdodge(0.5, 0, 0.6)

# 5 - Plot 3, but use the position object from instruction 4
ggplot(titanic, aes(x = Pclass, y = Age, color = Sex)) +
  geom_point(position = posn.jd, size = 3, alpha = 0.5) +
  facet_grid(.~Survived)

