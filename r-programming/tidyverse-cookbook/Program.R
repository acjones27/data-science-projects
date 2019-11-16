install.packages("tidyverse")
library(tidyverse)
tidyverse_update()
tidyverse_packages()

# %>% can be typed with the shortcut Cmd + Shift + M
starwars %>% 
  group_by(species) %>% 
  summarise(avg_height = mean(height, na.rm = TRUE)) %>% 
  arrange(avg_height)

# You want to use %>% to pass the result of the left hand side to an argument that is not the first argument of the function on the right hand side.

# Solution:
starwars %>% 
  lm(mass ~ height, data = .)

# By default %>% passes the result of the left hand side to the the first unnamed argument of the function on the right hand side. To override this default, use . as a placeholder within the function call on the right hand side. %>% will evaluate . as the result of the left hand side, instead of passing the result to the first unnamed argument.