load("exampleData.rData")

summary(custdata[is.na(custdata$housing.type),
        c("recent.move", "num.vehicles")])

# missing data in categorical columns: most straightforward solution is just to make a new category called "missing

custdata$is.employed.fix <- ifelse(is.na(custdata$is.employed), "not in active workforce",
                                   ifelse(custdata$is.employed == T, "employed", "not employed"))

summary(as.factor(custdata$is.employed.fix)) # transformation turned it back to string

# missing numerical data is a bit trickier. 
# if you believe that the missing data is random, e.g. faulty sensor, then you can replace the missing values with the expected, or mean, income.

meanIncome <- mean(custdata$Income, na.rm = T)
Income.fix <- ifelse(is.na(custdata$Income), meanIncome, custdata$Income)

summary(Income.fix)

# could also use the knowledge of any relationship between the missing variable and other variables in the database. e.g. relationship between age and income could help fill in the NA's in the income column

# it could also be that the missing values are systematically different from the others. e.g. if the customers income information is missing, it could be that they truly have no income. If so then "filling in" their income woult be wrong. 
# Other methods:
# 1. can convert the numeric data into categorical data. e.g below $10,000, or from $100K to $250K and then treat the NAs as we did before

breaks <- c(0, 10000, 50000, 100000, 250000, 1000000)

Income.groups <- cut(custdata$Income, breaks = breaks, include.lowest = T)
summary(Income.groups)

Income.groups <- as.character(Income.groups)

Income.groups <- ifelse(is.na(Income.groups), "no income", Income.groups)

summary(as.factor(Income.groups))

# this grouping approach works well, espcially if the relationship between income and insurance is non-monotonic i.e. likelihood of having insurance doesn't strictly increase or decrease with income
# 2. Can also replace NA with 0. One trick is to replace the NAs with 0 and add an additional variable ("masking variable") to keep track of the points which have been altered

missingIncome <- is.na(custdata$Income) # lets you distinguish between the 0s that you're about to add and the ones which were already there

Income.fix <- ifelse(is.na(custdata$Income), 0, custdata$Income)

summary(medianincome)

# Median.Income already exists in the custdata dataset, but if it didn
custdata <- merge(custdata, medianincome, by.x = "state.of.res", by.y = "State")

summary(custdata[,c("state.of.res", "income", "Median.Income")])
custdata
