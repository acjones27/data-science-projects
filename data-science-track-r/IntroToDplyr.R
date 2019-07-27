install.packages("dplyr")
library(dplyr)
install.packages("hflights")
library(hflights)

# Call both head() and summary() on hflights
head(hflights)
summary(hflights)

hflights <- tbl_df(hflights)
# adapts to window size
hflights

glimpse(hflights)
#convert back
# as.data.frame(hflights)

# Both the dplyr and hflights packages are loaded into workspace
lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue", "CO" = "Continental", 
         "DL" = "Delta", "OO" = "SkyWest", "UA" = "United", "US" = "US_Airways", 
         "WN" = "Southwest", "EV" = "Atlantic_Southeast", "F9" = "Frontier", 
         "FL" = "AirTran", "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")

# Add the Carrier column to hflights
hflights$Carrier <- lut[hflights$UniqueCarrier]

# Glimpse at hflights
glimpse(hflights)

unique(hflights$CancellationCode)

# VERBS in dplyr
# select(), which returns a subset of the columns,
# filter(), that is able to return a subset of the rows,
# arrange(), that reorders the rows according to single or multiple variables,
# mutate(), used to add columns from existing data,
# summarize(), which reduces each group to a single row by calculating aggregate measures.
# tidyr package

hflights <- as_tibble(hflights)

select(hflights, ActualElapsedTime, AirTime, ArrDelay, DepDelay)

names(hflights)

# comparing base R with dplyr
# Finish select call so that ex1d matches ex1r
ex1r <- hflights[c("TaxiIn", "TaxiOut", "Distance")]
ex1d <- select(hflights, "TaxiIn", "TaxiOut", "Distance")

# Finish select call so that ex2d matches ex2r
ex2r <- hflights[c("Year", "Month", "DayOfWeek", "DepTime", "ArrTime")]
ex2d <- select(hflights, 1:6, -3)

# Finish select call so that ex3d matches ex3r
ex3r <- hflights[c("TailNum", "TaxiIn", "TaxiOut")]
ex3d <- select(hflights, starts_with("T"))

# Add the new variable ActualGroundTime to a copy of hflights and save the result as g1.
g1 <- mutate(hflights, ActualGroundTime = ActualElapsedTime - AirTime)

# Add the new variable GroundTime to g1. Save the result as g2.
g2 <- mutate(g1, GroundTime = TaxiIn + TaxiOut)

# Add the new variable AverageSpeed to g2. Save the result as g3.
g3 <- mutate(g2, AverageSpeed = 60 * Distance / AirTime)

# Add a second variable loss_ratio to the dataset: m1
m1 <- mutate(hflights, loss = ArrDelay - DepDelay, loss_ratio = loss / DepDelay)

# Add the three variables as described in the third instruction: m2
m2 <- mutate(hflights, TotalTaxi = TaxiIn + TaxiOut, 
             ActualGroundTime = ActualElapsedTime - AirTime,
             Diff = TotalTaxi - ActualGroundTime)

# filter
?Comparison

# All flights that traveled 3000 miles or more
filter(hflights, Distance >= 3000)

# All flights flown by one of JetBlue, Southwest, or Delta
filter(hflights, UniqueCarrier %in% c("JetBlue", "Southwest", "Delta"))

# All flights where taxiing took longer than flying
filter(hflights, TaxiIn + TaxiOut > AirTime)

# All flights that departed before 5am or arrived after 10pm
filter(hflights, DepTime < 500  | ArrTime > 2200)

# All flights that departed late but arrived ahead of schedule
filter(hflights, DepDelay > 0 & ArrDelay < 0)

# All flights that were cancelled after being delayed
filter(hflights, DepDelay > 0, Cancelled == 1)

# Select the flights that had JFK as their destination: c1
c1 <- filter(hflights, Dest == "JFK")

# Combine the Year, Month and DayofMonth variables to create a Date column: c2
c2 <- mutate(c1, Date = paste(Year, Month, DayofMonth, sep = '-'))

# Print out a selection of columns of c2
select(c2, "Date", "DepTime", "ArrTime", "TailNum")

# Definition of dtc
dtc <- filter(hflights, Cancelled == 1, !is.na(DepDelay))

# Arrange
# Arrange dtc by departure delays
arrange(dtc, DepDelay)

# Arrange dtc so that cancellation reasons are grouped
arrange(dtc, CancellationCode )

# Arrange dtc according to carrier and departure delays
arrange(dtc, UniqueCarrier, DepDelay)

# Arrange according to carrier and decreasing departure delays
arrange(hflights, UniqueCarrier, desc(DepDelay))

# Arrange flights by total delay (normal order).
arrange(hflights,  DepDelay + ArrDelay )
