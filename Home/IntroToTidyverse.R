install.packages("gapminder")
library(gapminder)
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)

# filter by year 
# %>% means to pipe what's on left to right
gapminder %>%
  filter(year == 2007)

gapminder %>%
  filter(country == "United States")

gapminder %>%
  filter(year == 2007, country == "United States")

gapminder %>%
  filter(year == 2007) %>%
  arrange(desc(gdpPercap))

gapminder %>%
  mutate(gdp = gdpPercap * pop)

gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007) %>%
  arrange(desc(gdp))

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

gapminder_2007

ggplot(gapminder_2007, aes(x = pop, y = lifeExp)) + 
  geom_point() + 
  scale_x_log10()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent, 
                           size = pop)) + 
  geom_point() + 
  scale_x_log10()

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent)) + 
  geom_point() + 
  scale_x_log10() + 
  facet_wrap(~ year)

gapminder %>%
  filter(year == 1957) %>%
  summarize(medianLifeExp = median(lifeExp), 
            maxGdpPercap = max(gdpPercap))

# note: i had to add as.numeric here as i got warnings about integer overflow
gapminder %>%
  group_by(year) %>%
  summarize(meanLifeExp = mean(lifeExp), 
            totalPop = sum(as.numeric(pop)))

gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp = mean(lifeExp))

gapminder %>%
  group_by(year, continent) %>%
  summarize(meanLifeExp = mean(lifeExp))

by_year <- gapminder %>%
  group_by(year) %>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

# Create a scatter plot showing the change in medianLifeExp over time
ggplot(by_year, aes(x = year, y = medianLifeExp)) +
  geom_point() +
  expand_limits(y = 0)

by_year_continent <- gapminder %>%
  group_by(continent, year) %>%
  summarize(medianGdpPercap = median(gdpPercap))

# Plot the change in medianGdpPercap in each continent over time
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, 
                              color = continent)) + 
  geom_point() +
  expand_limits(y = 0)

ggplot(by_year_continent, aes(x = year, y = medianGdpPercap, 
                              color = continent)) +
  geom_line() + 
  expand_limits(y = 0)

by_continent <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(medianGdpPercap = median(gdpPercap))

ggplot(by_continent, aes(x = continent, y = medianGdpPercap)) + 
  geom_col()

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

ggplot(gapminder_2007, aes(x = lifeExp)) + 
  geom_histogram(binwidth = 5) + 
  ggtitle("My title")
