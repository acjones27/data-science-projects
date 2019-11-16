# Load the plotly package
# install.packages("plotly", dependencies = TRUE)
# say no to installing data.table
library(plotly)

# Store the scatterplot of Critic_Score vs. NA_Sales sales in 2016
vgsales = read.csv("vgsales.csv")

scatter <- vgsales %>%
  filter(Year == 2016) %>%
  ggplot(aes(x = NA_Sales, y = Critic_Score)) +
  geom_point(alpha = 0.3)

# Convert the scatterplot to a plotly graphic
ggplotly(scatter)
