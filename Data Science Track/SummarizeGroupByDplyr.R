# Print out a summary with variables min_dist and max_dist
summarize(hflights, min_dist = min(Distance), max_dist = max(Distance))

# Print out a summary with variable max_div
summarize(filter(hflights, Diverted == 1), max_div = max(Distance))

# You can use any function you like in summarize() 
# so long as the function can take a vector of data and return a single number. 
# R contains many aggregating functions, as dplyr calls them:
#   
# min(x) - minimum value of vector x.
# max(x) - maximum value of vector x.
# mean(x) - mean value of vector x.
# median(x) - median value of vector x.
# quantile(x, p) - pth quantile of vector x.
# sd(x) - standard deviation of vector x.
# var(x) - variance of vector x.
# IQR(x) - Inter Quartile Range (IQR) of vector x.
# diff(range(x)) - total range of vector x

# Remove rows that have NA ArrDelay: temp1
temp1 <- filter(hflights, !is.na(ArrDelay))

# Generate summary about ArrDelay column of temp1
summarize(temp1, earliest = min(ArrDelay), average = mean(ArrDelay),
          latest = max(ArrDelay), sd = sd(ArrDelay))

# Keep rows that have no NA TaxiIn and no NA TaxiOut: temp2
temp2 <- filter(hflights, !is.na(TaxiIn) & !is.na(TaxiOut))

# Print the maximum taxiing difference of temp2 with summarize()
summarize(temp2, max_taxi_diff = max(abs(TaxiIn - TaxiOut)))

# dplyr provides several helpful aggregate functions of its own, 
# in addition to the ones that are already defined in R. These include:
#   
# first(x) - The first element of vector x.
# last(x) - The last element of vector x.
# nth(x, n) - The nth element of vector x.
# n() - The number of rows in the data.frame or group of observations that summarize() describes.
# n_distinct(x) - The number of unique values in vector x

# Generate summarizing statistics for hflights
summarize(hflights,
          n_obs = n(),
          n_carrier = n_distinct(UniqueCarrier),
          n_dest = n_distinct(Dest))

# All American Airline flights
aa <- filter(hflights, UniqueCarrier == "American")

# Generate summarizing statistics for aa 
summarize(aa,
          n_flights = n(),
          n_canc = sum(Cancelled),
          avg_delay = mean(ArrDelay, na.rm = TRUE))


# Use dplyr functions and the pipe operator to transform the following English sentences into R code:
#   
# - Take the hflights data set and then ...
# - Add a variable named diff that is the result of subtracting TaxiIn from TaxiOut, and then ...
# - Pick all of the rows whose diff value does not equal NA, and then ...
# - Summarize the data set with a value named avg that is the mean diff value.

# Write the 'piped' version of the English sentences.
hflights %>%
  mutate(diff = TaxiOut - TaxiIn) %>%
  filter(!is.na(diff)) %>%
  summarize(avg = mean(diff))


# - mutate() the hflights dataset and add two variables:
#   - RealTime: the actual elapsed time plus 100 minutes (for the overhead that flying involves) and
#   - mph: calculated as 60 times Distance divided by RealTime, then
# - filter() to keep observations that have an mph that is not NA and that is below 70, finally
# - summarize() the result by creating four summary variables:
#   - n_less, the number of observations,
#   - n_dest, the number of destinations,
#   - min_dist, the minimum distance and
#   - max_dist, the maximum distance.

hflights %>%
  mutate(RealTime = ActualElapsedTime + 100,
         mph = 60 * Distance / RealTime) %>%
  filter(!is.na(mph) & mph < 70) %>%
  summarize(n_less = n(), 
            n_dest = n_distinct(Dest), 
            min_dist = min(Distance),
            max_dist = max(Distance))

# - filter() the result of mutate to:
#   - keep observations that have an mph under 105 
#     or for which Cancelled equals 1 
#     or for which Diverted equals 1.
# - summarize() the result by creating four summary variables:
#   - n_non, the number of observations,
#   - n_dest, the number of destinations,
#   - min_dist, the minimum distance and
#   - max_dist, the maximum distance.


hflights %>%
  mutate(
    RealTime = ActualElapsedTime + 100, 
    mph = 60 * Distance / RealTime
  ) %>%
  filter(mph < 105 | Cancelled == 1 | Diverted == 1) %>%
  summarize(n_non = n(),
            n_dest = n_distinct(Dest),
            min_dist = min(Distance),
            max_dist = max(Distance))

# filter() the hflights tbl to keep only observations whose DepTime is not NA, 
# whose ArrTime is not NA and for which DepTime exceeds ArrTime.
# Pipe the result into a summarize() call to create a single summary variable: 
#   num, that simply counts the number of observations.

# Count the number of overnight flights
hflights %>%
  filter(!is.na(DepTime) & !is.na(ArrTime) & DepTime > ArrTime) %>%
  summarize(num = n())

# Use group_by() to group hflights by UniqueCarrier.
# summarize() the grouped tbl with two summary variables:
#   - p_canc, the percentage of cancelled flights.
#   - avg_delay, the average arrival delay of flights whose delay does not equal NA.

# Make an ordered per-carrier summary of hflights
hflights %>%
  group_by(UniqueCarrier) %>%
  summarize(
    p_canc = 100*mean(Cancelled == 1),
    avg_delay = mean(ArrDelay, na.rm = TRUE)
  ) %>%
  arrange(avg_delay, p_canc)

# Ordered overview of average arrival delays per carrier
hflights %>% 
  filter(!is.na(ArrDelay) & ArrDelay > 0) %>%
  group_by(UniqueCarrier) %>%
  summarize(avg = mean(ArrDelay)) %>%
  mutate(rank = rank(avg)) %>%
  arrange(rank)

# How many airplanes only flew to one destination?
hflights %>%
  group_by(TailNum) %>%
  summarize(bytail = n_distinct(Dest)) %>%
  filter(bytail == 1) %>%
  summarize(nplanes = n())

# Find the most visited destination for each carrier
hflights %>%
  group_by(UniqueCarrier, Dest) %>%
  summarize(n = n()) %>%
  mutate(rank = rank(desc(n))) %>%
  filter(rank == 1)

library(data.table)
hflights2 <- as.data.table(hflights)

# Use summarize to calculate n_carrier
hflights2 %>% summarize(n_carrier = n_distinct(UniqueCarrier))

