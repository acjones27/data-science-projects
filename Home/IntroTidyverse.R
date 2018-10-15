## VERBS

# Filter
gapminder %>% 
  filter(year==2007)

gapminder %>% 
  filter(country=="United States")

gapminder %>% 
  filter(year==2007, country=="United States")

# Arrange
gapminder %>% 
  arrange(gdpPercap)

gapminder %>%
  arrange(desc(gdpPercap))

# Mutate
gapminder %>%
  mutate(pop = pop / 1000000)

gapminder %>%
  mutate(gdp = gdpPercap * pop)

gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007) %>%
  arrange(desc(gdp))

# Summarise
gapminder %>%
  summarize(meanLifeExp = mean(lifeExp))

gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp), totalPop = sum(as.double(pop)))

# Group by
gapminder %>%
  group_by(year) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(as.double(pop)))

gapminder %>%
  group_by(year, continent) %>%
  summarize(totalPop = sum(as.double(pop),
            meanLifeExp = mean(lifeExp)))

# plotting with ggplot2
install.packages("ggplot2")
library(ggplot2)
gapminder_2007 <- gapminder %>%
  filter(year == 2007)

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color=continent)) +
  geom_point() +
  scale_x_log10()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color=continent, size=pop)) +
  geom_point() +
  scale_x_log10()

ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  geom_point() +
  scale_x_log10() + 
  facet_wrap( ~continent)

by_year <- gapminder %>%
  group_by(year) %>%
  summarize(totalPop = sum(as.double(pop)),
            meanLifeExp = mean(lifeExp))

ggplot(by_year, aes(x=year, y=totalPop)) +
  geom_point() +
  expand_limits(y = 0)

by_year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(totalPop = sum(as.double(pop)),
            meanLifeExp = mean(lifeExp))

ggplot(by_year_continent, aes(x = year, y = totalPop, color = continent)) +
  geom_point() +
  expand_limits(y = 0)

# Line graph
ggplot(by_year_continent, aes(x = year, y = meanLifeExp, color = continent)) +
  geom_line() +
  expand_limits(y = 0)

by_continent <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp = mean(lifeExp))

# Bar plot
ggplot(by_continent, aes(x=continent, y=meanLifeExp)) +
  geom_col() 

# Histogram
ggplot(gapminder_2007, aes(x=lifeExp)) +
  geom_histogram()

# Boxplot
ggplot(gapminder_2007, aes(x=continent, y=lifeExp)) +
  geom_boxplot()