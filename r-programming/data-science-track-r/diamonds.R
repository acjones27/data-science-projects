# install.packages("tidyverse")
# install.packages("hexbin")
library(tidyverse)
require(hexbin)

ggplot(diamonds, aes(carat, price)) + 
  geom_hex()
ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")

