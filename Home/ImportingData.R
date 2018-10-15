install.packages("readxl")
library(readxl)
dir()
excel_sheets("cities.xlsx")
read_excel("cities.xlsx", sheet = 2)
read_excel("cities.xlsx", sheet = "year_2000")

excel_sheets("urbanpop.xlsx")

# Read the sheets, one by one
pop_1 <- read_excel("urbanpop.xlsx", sheet = 1)
pop_2 <- read_excel("urbanpop.xlsx", sheet = 2)
pop_3 <- read_excel("urbanpop.xlsx", sheet = 3)

# Put pop_1, pop_2 and pop_3 in a list: pop_list
pop_list <- list(pop_1, pop_2, pop_3)

str(pop_list)

# Read all Excel sheets with lapply(): pop_list
pop_list <- lapply(excel_sheets("urbanpop.xlsx"),
                   read_excel,
                   path = "urbanpop.xlsx")

# Display the structure of pop_list
str(pop_list)