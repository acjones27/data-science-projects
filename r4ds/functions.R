# An if statement allows you to conditionally execute code. It looks like this:
  
if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}

# The condition must evaluate to either TRUE or FALSE. If it’s a vector, you’ll get a warning message; if it’s an NA, you’ll get an error.

# You can use || (or) and && (and) to combine multiple logical expressions. These operators are “short-circuiting”: as soon as || sees the first TRUE it returns TRUE without computing anything else. As soon as && sees the first FALSE it returns FALSE.

# You should never use | or & in an if statement: these are vectorised operations that apply to multiple values (that’s why you use them in filter()). If you do have a logical vector, you can use any() or all() to collapse it to a single value.

# Be careful when testing for equality. == is vectorised, which means that it’s easy to get more than one output. Either check the length is already 1, collapse with all() or any(), or use the non-vectorised identical()

# use dplyr::near() for comparisons

# You can chain multiple if statements together:
  
if (this) {
  # do that
} else if (that) {
  # do something else
} else {
  # 
}

# if you end up with a very long series of chained if statements, you should consider rewriting. One useful technique is the switch() function. in this switch function, it will return the formula that corresponds to the given op

switch_ops <- function(x, y, op) {
  switch(op,
  plus = x + y,
  minus = x - y,
  times = x * y,
  divide = x / y,
  stop("Unknown op!")
  )
}

switch_ops(13, 5, "plus")
switch_ops(13, 5, "times")

# An opening curly brace should never go on its own line and should always be followed by a new line. A closing curly brace should always go on its own line, unless it’s followed by else. Always indent the code inside curly braces.

# It’s ok to drop the curly braces if you have a very short if statement that can fit on one line:
  
y <- 10
x <- if (y < 20) "Too low" else "Too high"

if (y < 20) {
  x <- "Too low" 
} else {
  x <- "Too high"
}