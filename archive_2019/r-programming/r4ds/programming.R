# install.packages("magrittr")
library(magrittr)

# Let’s use code to tell a story about a little bunny named Foo Foo:

# Little bunny Foo Foo
# Went hopping through the forest
# Scooping up the field mice
# And bopping them on the head

# We’ll start by defining an object to represent little bunny Foo Foo:
  
foo_foo <- little_bunny()

# And we’ll use a function for each key verb: hop(), scoop(), and bop(). Using this object and these verbs, there are (at least) four ways we could retell the story in code:
  
# Save each intermediate step as a new object.
# Overwrite the original object many times.
# Compose functions.
# Use the pipe.

# Intermediate steps:
# The simplest approach is to save each step as a new object:
  
foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)

# The main downside of this form is that it forces you to name each intermediate element. If there are natural names, this is a good idea, and you should do it. But many times, like this in this example, there aren’t natural names, and you add numeric suffixes to make the names unique. That leads to two problems:
  
# - The code is cluttered with unimportant names

# - You have to carefully increment the suffix on each line.

# Whenever I write code like this, I invariably use the wrong number on one line and then spend 10 minutes scratching my head and trying to figure out what went wrong with my code.

# You may also worry that this form creates many copies of your data and takes up a lot of memory. Surprisingly, that’s not the case. R will share columns across data frames, where possible. 
# Let’s take a look at an example

install.packages("pryr")
library(pryr)
diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>% 
  dplyr::mutate(price_per_carat = price / carat)

pryr::object_size(diamonds)
#> 3.46 MB
pryr::object_size(diamonds2)
#> 3.89 MB
pryr::object_size(diamonds, diamonds2)
#> 3.89 MB

# diamonds2 has 10 columns in common with diamonds: there’s no need to duplicate all that data, so the two data frames have variables in common. 
# These variables will only get copied if you modify one of them. 
# In the following example, we modify a single value in diamonds$carat. 
# That means the carat variable can no longer be shared between the two data frames, and a copy must be made.

diamonds$carat[1] <- NA
pryr::object_size(diamonds)
#> 3.46 MB
pryr::object_size(diamonds2)
#> 3.89 MB
pryr::object_size(diamonds, diamonds2)
#> 4.32 MB

# Overwrite the original:
# Instead of creating intermediate objects at each step, we could overwrite the original object:
  
foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)

# This is less typing (and less thinking), so you’re less likely to make mistakes. However, there are two problems:
  
# - Debugging is painful: if you make a mistake you’ll need to re-run the complete pipeline from the beginning.

# - The repetition of the object being transformed (we’ve written foo_foo six times!) obscures what’s changing on each line.

# Function composition:
# Another approach is to abandon assignment and just string the function calls together:
  
bop(
  scoop(
    hop(foo_foo, through = forest),
    up = field_mice
  ), 
  on = head
)

# Here the disadvantage is that you have to read from inside-out, from right-to-left, and that the arguments end up spread far apart (evocatively called the dagwood sandwhich problem). In short, this code is hard for a human to consume.

# Finally, we can use the pipe:
  
foo_foo %>%
  hop(through = forest) %>%
  scoop(up = field_mice) %>%
  bop(on = head)

# The pipe works by performing a “lexical transformation”: behind the scenes, magrittr reassembles the code in the pipe to a form that works by overwriting an intermediate object. When you run a pipe like the one above, magrittr does something like this:
  
my_pipe <- function(.) {
  . <- hop(., through = forest)
  . <- scoop(., up = field_mice)
  bop(., on = head)
}
my_pipe(foo_foo)

# This means that the pipe won’t work for two classes of functions:
  
# 1) Functions that use the current environment. For example, assign() will create a new variable with the given name in the current environment. Other functions with this problem include get() and load().

# 2) Functions that use lazy evaluation. In R, function arguments are only computed when the function uses them, not prior to calling the function. The pipe computes each element in turn, so you can’t rely on this behaviour.

# One place that this is a problem is tryCatch(), which lets you capture and handle errors

# I think you should reach for another tool when:
  
# Your pipes are longer than (say) ten steps. In that case, create intermediate objects with meaningful names. That will make debugging easier

# You have multiple inputs or outputs. If there isn’t one primary object being transformed, but two or more objects being combined together, don’t use the pipe.

# You are starting to think about a directed graph with a complex dependency structure. Pipes are fundamentally linear and expressing complex relationships with them will typically yield confusing code.

# If you’re working with functions that don’t have a data frame based API
# (i.e. you pass them individual vectors, not a data frame and expressions to be evaluated in the context of that data frame), you might find %$% useful. 

# It “explodes” out the variables in a data frame so that you can refer to them explicitly. This is useful when working with many functions in base R:
  
mtcars %$%
  cor(disp, mpg)
#> [1] -0.848