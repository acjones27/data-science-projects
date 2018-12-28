# load the dplyr package
library(dplyr)

# Load sample student data
StudentData<-read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_1959/datasets/SampleClassData.csv")

# Dump the student data
StudentData

#Load the tidyr library
library(tidyr)

#Gather the data
GatheredStudentData <- StudentData %>% 
  gather(Indicator,Score, -SID,-First,-Last)

# Remove NA's
GatheredStudentData <- GatheredStudentData %>% 
  na.omit()

# Dump the student data
glimpse(GatheredStudentData)

# load the `plotly` package
library(plotly)

# This will create your very first plotly visualization
plot_ly(z = ~volcano)

# The diamonds dataset
str(diamonds)

# A firs scatterplot has been made for you
plot_ly(diamonds, x = ~carat, y = ~price)

# Replace ___ with the correct vector
plot_ly(diamonds, x = ~carat, y = ~price, color = ~carat)

# Replace ___ with the correct vector
plot_ly(diamonds, x = ~carat, y = ~price, color = ~carat, size = ~carat)


# Calculate the numbers of diamonds for each cut<->clarity combination
diamonds_bucket <- diamonds %>% count(cut, clarity)

# Replace ___ with the correct vector
plot_ly(diamonds_bucket, x = ~cut, y = ~n, type = "bar", color = ~clarity) 


# The Non Fancy Box Plot
plot_ly(y = ~rnorm(50), type = "box")

# The Fancy Box Plot
plot_ly(diamonds, y = ~price, color = ~cut, type = "box")

# The Super Fancy Box Plot
plot_ly(diamonds, x = ~cut, y = ~price, color = ~clarity, type = "box") %>%
  layout(boxmode = "group")

# Load the `plotly` library
library(plotly)

# Your volcano data
str(volcano)

# The heatmap
plot_ly(z = ~volcano, type = "heatmap")

# The 3d surface map
plot_ly(z = ~volcano, type = "surface")

# Create the ggplot2 graph
ggplot(mtcars, aes(x = wt, y = mpg, col = cyl)) +
  geom_point()

# Make your plot interactive
ggplotly()


# Most Trafficked US Airports
g <- list(
  scope = 'usa',
  showland = TRUE,
  landcolor = toRGB("gray95")
)

plot_geo(airport_traffic, lat = ~lat, lon = ~long) %>%
  add_markers(
    text = ~paste(airport, city, state, paste("Arrivals:", cnt), sep = "<br />"),
    color = ~cnt, symbol = I("square"), size = I(8), hoverinfo = "text"
  ) %>%
  colorbar(title = "Incoming flights<br />February 2011") %>%
  layout(
    title = 'Most trafficked US airports<br />(Hover for airport)', geo = g
  )


# Commercial Airports WorldWide
str(airports)

# Mapping all commercial airports in the world
g <- list(
  scope = 'world',
  showland = TRUE,
  landcolor = toRGB("gray95")
)

plot_geo(airports, lat = ~Latitude, lon = ~Longitude) %>%
  add_markers(
    text = ~paste(AirportID, City, Country, sep = "<br />"),
    color = ~Country, symbol = I("circle"), size = I(3), hoverinfo = "text", colors = "Set1"
  ) %>%
  layout(
    title = 'Commercial Airports Worldwide', geo = g
  )


# Monthly totals of accidental deaths in the USA
plot_ly(x = time(USAccDeaths), y = USAccDeaths) %>% 
  add_lines() %>%
  rangeslider()

# Apple Stock Price
str(apple_stock_price)


# Apple Stock Price With Rangeslider
plot_ly(apple_stock_price, x = ~Date) %>%
  add_lines(y = ~AAPL.Adjusted, name = "Apple") %>% 
  rangeslider() %>% 
  layout(
    title = "Stock Price Apple",
    xaxis = list(title = "Date"),
    yaxis = list(title = "Price"))
