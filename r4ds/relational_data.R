# install.packages("tidyverse")
# install.packages("nycflights13")
library(tidyverse)
library(nycflights13)

# there are 4 tables in nyc flights

airlines
airports
planes
weather

# KEYS connect tables together via a variable or set of variables:
# flights connects to planes via tailnum
# flights connects to airlines via carrier
# flights connects to airports via origin and dest
# flights connects to weather via origin, year, month, day, hour

# A primary key uniquely identifies an observation in its own table e.g. planes$tailnum
# A foreign key uniquely identifies an observation in another table e.g. flights$tailnum is a foreign key because it appears in the flights table and matches each flight to a unique plane
# A variable can be both a primary and a foreign key e.g. weather$origin

### SIDE NOTE: 
### Cmd + Shift + M --> '%>%'
### Alt + Shift + K --> Show all keybindings
### Option + '-' --> '<-'

# Check that tailnum is indeed unique
planes %>% 
  count(tailnum) %>% 
  filter(n > 1)

# turns out that this is not unique
weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)

# If a table lacks a primary key, it’s sometimes useful to add one with mutate() and row_number(). 
# That makes it easier to match observations if you’ve done some filtering and want to check back in with the original data. This is called a surrogate key.

weather %>% 
  mutate(surr_key = row_number()) %>% 
  select(surr_key, everything())

# Like mutate(), the join functions add variables to the right, so if you have a lot of variables already, the new variables won’t get printed out. For these examples, we’ll make it easier to see what’s going on in the examples by creating a narrower dataset

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

View(flights2)

# imagine you want to add the full airline name to the flights2 data. you can combine it with airlines with left_join

flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

# it could also have been achieved with mutate, but it's much harder

flights2 %>% 
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# to use a dummy dataset
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
x

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)
y

# An inner join keeps observations that appear in both tables.
x %>% 
  inner_join(y, by = "key")

# An outer join keeps observations that appear in at least one of the tables. There are three types of outer joins:
  
# - A left join keeps all observations in x.
# - A right join keeps all observations in y.
# - A full join keeps all observations in x and y

# The most commonly used join is the left join: you use this whenever you look up additional data from another table, because it preserves the original observations even when there isn’t a match. 
# The left join should be your default join: use it unless you have a strong reason to prefer one of the others.

# What happens when the keys are not unique?
# If one table has duplicate keys, it's ok

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, by = "key")

# If both tables have duplicate keys this is usually an error because in neither table do the keys uniquely identify an observation. When you join duplicated keys, you get all possible combinations, the Cartesian product

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")

# So far, we've used by = "key" as both tables have a single common column

# The default, 'by = NULL', uses all variables that appear in both tables, the so called natural join. For example, the flights and weather tables match on their common variables: year, month, day, hour and origin.

flights2 %>% 
  left_join(weather)

# A character vector, by = "x". This is like a natural join, but uses only some of the common variables. For example, flights and planes have year variables, but they mean different things so we only want to join by tailnum.

flights2 %>% 
  left_join(planes, by = "tailnum")

# A named character vector: by = c("a" = "b"). This will match variable a in table x to variable b in table y. The variables from x will be used in the output.

# For example, if we want to draw a map we need to combine the flights data with the airports data which contains the location (lat and lon) of each airport. Each flight has an origin and destination airport, so we need to specify which one we want to join to

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))

# Filtering joins match observations in the same way as mutating joins, but affect the observations, not the variables. There are two types:

# semi_join(x, y) keeps all observations in x that have a match in y.
# anti_join(x, y) drops all observations in x that have a match in y.

# Semi-joins are useful for matching filtered summary tables back to the original rows. For example, imagine you’ve found the top ten most popular destinations:
  
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)

top_dest

# Now you want to find each flight that went to one of those destinations. You could construct a filter yourself:
  
flights %>% 
  filter(dest %in% top_dest$dest)

# But it’s difficult to extend that approach to multiple variables. For example, imagine that you’d found the 10 days with highest average delays. How would you construct the filter statement that used year, month, and day to match it back to flights?
  
# Instead you can use a semi-join, which connects the two tables like a mutating join, but instead of adding new columns, only keeps the rows in x that have a match in y:
  
flights %>% 
  semi_join(top_dest)

# The inverse of a semi-join is an anti-join. An anti-join keeps the rows that don’t have a match
# Anti-joins are useful for diagnosing join mismatches. For example, when connecting flights and planes, you might be interested to know that there are many flights that don’t have a match in planes

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

# The final type of two-table verb are the set operations.
# These expect the x and y inputs to have the same variables, and treat the observations like sets:

# - intersect(x, y): return only observations in both x and y.
# - union(x, y): return unique observations in x and y.
# - setdiff(x, y): return observations in x, but not in y.

df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)

df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)