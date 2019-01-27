library(dplyr)
library(readr)
# tables needed
artists <- tibble(
  first = c("Jimmy", "George", "Mick", "Tom", "Davy", "John", "Paul", "Jimmy", "Joe", "Elvis", "Keith", "Paul", "Ringo", "Joe", "Brian", "Nancy"), 
  last = c("Buffett", "Harrison", "Jagger", "Jones", "Jones", "Lennon", "McCartney", "Page", "Perry", "Presley", "Richards", "Simon", "Starr", "Walsh", "Wilson", "Wilson"),
  instrument = c("Guitar", "Guitar", "Vocals", "Vocals", "Vocals", "Guitar", "Bass", "Guitar", "Guitar", "Vocals", "Guitar", "Guitar", "Drums", "Guitar", "Vocals", "Vocals"))

bands <- tibble(
  first = c("John", "John Paul", "Jimmy", "Robert", "George", "John", "Paul", "Ringo", "Jimmy", "Mick", "Keith", "Charlie", "Ronnie"), 
  last = c("Bonham", "Jones", "Page", "Plant", "Harrison", "Lennon", "McCartney", "Starr", "Buffett", "Jagger", "Richards", "Watts", "Wood"), 
  band = c("Led Zeppelin", "Led Zeppelin", "Led Zeppelin", "Led Zeppelin", "The Beatles", "The Beatles", "The Beatles", "The Beatles", "The Coral Reefers", "The Rolling Stones", "The Rolling Stones", "The Rolling Stones", "The Rolling Stones"))

albums <- tibble(
  album = c("A Hard Day's Night", "Magical Mystery Tour", "Beggar's Banquet", "Abbey Road", "Led Zeppelin IV", "The Dark Side of the Moon", "Aerosmith", "Rumours", "Hotel California"),
  band = c("The Beatles", "The Beatles", "The Rolling Stones", "The Beatles", "Led Zeppelin", "Pink Floyd", "Aerosmith", "Fleetwood Mac", "Eagles"), 
  year = c(1964,1967,1968,1969,1971,1973,1973,1977,1982)
)

songs <- tibble(
  song = c("Come Together", "Dream On", "Hello, Goodbye", "It's Not Unusual"),
  album  = c("Abbey Road", "Aerosmith", "Magical Mystery Tour", "Along Came Jones"), 
  first = c("John", "Steven", "Paul", "Tom"), 
  last = c("Lennon", "Tyler", "McCartney", "Jones")
)

labels <- tibble(
  album = c("Abbey Road", "A Hard Days Night", "Magical Mystery Tour", "Led Zeppelin IV", "The Dark Side of the Moon", "Hotel California", "Rumours", "Aerosmith", "Beggar's Banquet"),
  label = c("Apple", "Parlophone", "Parlophone", "Atlantic", "Harvest", "Asylum", "Warner Brothers", "Columbia", "Decca")
)

# Complete the code to join artists to bands
bands2 <- left_join(bands, artists, by = c("first", "last"))

# Examine the results
bands2

# Finish the code below to recreate bands3 with a right join
bands2 <- left_join(bands, artists, by = c("first", "last"))
bands3 <- right_join(artists, bands, by = c("first", "last"))

# Check that bands3 is equal to bands2
# This checks if the data is the same in any order. intersect() will check if the tables contain the same data in the same order, but setequal() can also do this
setequal(bands2, bands3)

# Join albums to songs using inner_join()
inner_join(songs, albums, by = "album")

# Join bands to artists using full_join()
full_join(artists, bands, by = c("first", "last"))

# The two pieces of code below do the same thing:

full_join(artists, bands, by = c("first", "last"))

artists %>% 
  full_join(bands, by = c("first", "last"))

# Find guitarists in bands dataset (don't change)
temp <- left_join(bands, artists, by = c("first", "last"))
temp <- filter(temp, instrument == "Guitar")
select(temp, first, last, band)

# Reproduce code above using pipes
bands %>% 
  left_join(artists, by = c("first", "last")) %>%
  filter(instrument == "Guitar") %>%
  select(first, last, band)

# Create goal2 using full_join() and inner_join() 
goal2 <- artists %>%
  full_join(bands, by = c("first", "last")) %>%
  inner_join(songs, by = c("first", "last"))


# Create one table that combines all information
artists %>%
  full_join(bands, by = c("first", "last")) %>%
  full_join(songs, by = c("first", "last")) %>%
  full_join(albums, by = c("album", "band"))

# Semi-joins provide a concise way to filter data from the first dataset based on information in a second dataset.

# View the output of semi_join()
# a data frame of the artists who have written a song
artists %>% 
  semi_join(songs, by = c("first", "last"))

# Create the same result
artists %>% 
  right_join(songs, by = c("first", "last")) %>% 
  filter(!is.na(instrument)) %>% 
  select(first, last, instrument)

albums %>% 
  # Collect the albums made by a band
  semi_join(bands, by = "band") %>% 
  # Count the albums made by a band
  nrow()

# Return rows of artists that don't have bands info
artists %>% 
  anti_join(bands, by = c("first", "last"))

# Check whether album names in labels are mis-entered
# You can think of anti-join as a debugging tactic for joins
labels %>% 
  anti_join(albums, by = "album")

# Determine which key joins labels and songs
labels
songs

# Check your understanding
songs %>% 
  # Find the rows of songs that match a row in labels
  semi_join(labels, by = "album") %>% 
  # Number of matches between labels and songs
  nrow()

aerosmith <- tibble(
  song = c("Make It", "Somebody", "Dream On", "One Way Street", "Mama Kin", "Write me a Letter", "Moving Out", "Walking the Dog"),
  length = c(13260, 13500, 16080, 25200, 15900, 15060, 18180, 11520)
)

greatest_hits <- tibble(
  song = c("Dream On", "Mama Kin", "Same Old Song and Dance", "Seasons of Winter", "Sweet Emotion", "Walk this Way", "Big Ten Inch Record", "Last Child", "Back in the Saddle", "Draw the Line", "Kings and Queens", "Come Together", "Remember (Walking in the Sand)", "Lightning Strikes", "Chip Away the Stone", "Sweet Emotion (remix)", "One Way Street (live)"),
  length = c(16080, 16020, 11040, 17820, 11700, 12780, 8100, 12480, 16860, 12240, 13680, 13620, 14700, 16080, 14460, 16560, 24000)
)

live <- tibble(
  song = c("Back in the Saddle", " Sweet Emotion", "   Lord of the Thighs", "  Toys in the Attic", "   Last Child", "  Come Together", "   Walk this Way", "   Sick as a Dog", "   Dream On", "    Chip Away the Stone", " Sight for Sore Eyes", " Mama Kin", "    S.O.S. (Too Bad)", "    I Ain't Got You", " Mother Popcorn/Draw the Line", "    Train Kept A-Rollin'/Strangers in the Night"),
  length = c(15900,    16920,  26280,  13500,  12240,  17460,  13560,  16920,  16260,  15120,  11880,  13380,  9960,   14220,  41700,  17460)
)

# two datasets, aerosmith and greatest_hits, represent an album from the band Aerosmith. Each row in either of the datasets is a song on that album.

# How many unique songs do these two albums contain in total?

aerosmith %>% 
  # Create the new dataset using a set operation
  union(greatest_hits) %>% 
  # Count the total number of songs
  nrow()

# Which songs from Aerosmith made it onto Greatest Hits?
  
# Create the new dataset using a set operation
aerosmith %>% 
  intersect(greatest_hits)

# Select the song names from live
live_songs <- live %>% select(song)

# Select the song names from greatest_hits
greatest_songs <- greatest_hits %>% select(song)

# Create the new dataset using a set operation
# Create a dataset of songs in live that are not in greatest_hits.
live_songs %>% 
  setdiff(greatest_songs)

# There is no set operation to find rows that appear in one data frame or another, but not both. However, you can accomplish this by combining set operators

# "Which songs appear on one of Live! Bootleg or Greatest Hits, but not both?"

# Select songs from live and greatest_hits
live_songs <- live %>% select(song)
greatest_songs <- greatest_hits %>% select(song)


# Find songs in at least one of live_songs and greatest_songs
all_songs <- live_songs %>%
  union(greatest_songs)

# Find songs in both 
common_songs <- live_songs %>%
  intersect(greatest_songs)

# Find songs that only exist in one dataset
all_songs %>%
  setdiff(common_songs)

# Use identical(table1, table2) to determine whether table1 and table2 contain the same rows in the same order.
# Use setequal(table1, table2) to determine whether table1 and table2 contain the same rows in any order.
# Use setdiff(table1, table2) to see which rows (if any) are in table1 but not table2
# Use setdiff(table2, table1) to see which rows (if any) are in table2 but not table1

# intersect() is analagous to a semi_join() when two datasets contain the same variables and each variable is used in the key.

# setdiff() is also analagous to anti_join() under the same conditions

discography <- tibble(
  album=c("Are You Experienced", "Axis: Bold as Love", "Electric Ladyland"),
  year=c(1967, 1967, 1968)
)

jimi <- list(
  "Are You Experienced"=tibble(
  song=c("Purple Haze", "Manic Depression", "Hey Joe", "May This Be Love", "I Don't Live Today", "The Wind Cries Mary", "Fire", "Third Stone from the Sun", "Foxy Lady", "Are You Experienced?"),
  length=c(9960, 13560, 12180, 11640, 14100, 12060, 9240, 24000, 11700, 14100)
  ),
  "Axis: Bold As Love"=tibble(
    song=c("EXP", "Up from the Skies", "Spanish Castle Magic", "Wait Until Tomorrow", "Ain't No Telling", "Little Wing", "If 6 was 9", "You Got Me Floatin", "Castles Made of Sand", "She's So Fine", "One Rainy Wish", "Little Miss Lover", "Bold as Love"),
    length=c(6900, 10500, 10800, 10800, 6360, 8640, 19920, 9900, 9960, 9420, 13200, 8400, 15060)
  ),
  "Electric Ladyland"=tibble(
    song=c("And the Gods Made Love", "Have You Ever Been (To Electric Ladyland)", "Crosstown Traffic", "Voodoo Chile", "Little Miss Strange", "Long Hot Summer Night", "Come On (Part 1)", "Gypsy Eyes", "Burning of the Midnight Lamp", "Rainy Day, Dream Away", "1983... (A Merman I Should Turn to Be)", "Moon, Turn the Tides... Gently Gently Away", "Still Raining, Still Dreaming", "House Burning Down", "All Along the Watchtower", "Voodoo Child (Slight Return)"),
    length=c(4860, 7860, 8700, 54000, 10320, 12420, 14940, 13380, 13140, 13320, 49140, 3720, 15900, 16380, 14460, 18720)
  )
)

# Examine discography and jimi
discography
jimi

jimi %>% 
  # Bind jimi by rows, with ID column "album"
  bind_rows(.id = "album") %>% 
  # Make a complete data frame
  left_join(discography, by = "album")

# hank_years contains the name and release year of each of Hank Williams' 67 singles.
# hank_charts contains the name of each of Hank Williams' 67 singles as well as the highest position it earned on the Billboard sales charts.
hank_years <- read_csv("Joining Data/hank_williams/hank_years.csv")
hank_charts <- read_csv("Joining Data/hank_williams/hank_charts.csv")

# Examine hank_years and hank_charts
hank_years
hank_charts

hank_df <- hank_years %>% 
  # Reorder hank_years alphabetically by song title
  arrange(song) %>% 
  # Select just the year column
  select(year) %>% 
  # Bind the year column
  bind_cols(hank_charts) %>% 
  # Arrange the finished dataset
  arrange(year, song)

hank_year <- hank_df %>% 
  select(year)

hank_song <- hank_df %>% 
  select(song)

hank_peak <- hank_df %>% 
  select(peak)

# Make combined data frame using data_frame()
data_frame("year" = hank_year, 
           "song" = hank_song, 
           "peak" = hank_peak) %>% 
  # Extract songs where peak equals 1
  filter(peak == 1)

hank <- list("year" = hank_year, 
             "song" = hank_song, 
             "peak" = hank_peak)

# Examine the contents of hank
hank

# Convert the hank list into a data frame
as_data_frame(hank) %>% 
  # Extract songs where peak equals 1
  filter(peak == 1)

michael1 <- read_csv("Joining Data/michael_jackson/michael1.csv")
michael2 <- read_csv("Joining Data/michael_jackson/michael2.csv")
michael3 <- read_csv("Joining Data/michael_jackson/michael3.csv")

michael <- list("Got to Be There" = michael1, 
                "Ben" = michael2,
                "Music & Me" = michael3)
# Examine the contents of michael
michael

# It's a list of dataframes. So as_data_frame won't work

# bind_rows will ensure that each song has its own row with a new column "album"
bind_rows(michael, .id = "album") %>%
  group_by(album) %>%
  mutate(rank = min_rank(peak)) %>%
  filter(rank == 1) %>%
  select(-rank, -peak)

sixties <- read_csv("Joining Data/top_sellers/sixties.csv")
seventies <- readRDS("Joining Data/top_sellers/seventies.rds")
eighties <- readRDS("Joining Data/top_sellers/eighties.rds")

both <- seventies %>% bind_rows(eighties)

seventies %>% 
  # Coerce seventies$year into a useful numeric
  mutate(year = as.numeric(as.character(seventies$year)) ) %>% 
  # Bind the updated version of seventies to sixties
  bind_rows(sixties) %>% 
  arrange(year)

stage_songs <- data.frame(read_csv("Joining Data/musicals/stage_songs.csv"))
rownames(stage_songs) <- stage_songs[,1]
stage_songs[,1] <- NULL

stage_writers <- read_csv("Joining Data/musicals/stage_writers.csv")

stage_songs %>% 
  # Add row names as a column named song
  rownames_to_column(var = "song") %>% 
  # Left join stage_writers to stage_songs
  left_join(stage_writers, by = "song")

shows <- read_csv("Joining Data/musicals/shows.csv")
composers <- read_csv("Joining Data/musicals/composers.csv")

show_songs <- read_csv("Joining Data/musicals/show_songs.csv")

singers <- read_csv("Joining Data/julie_andrews/singers.csv")
two_songs <- read_csv("Joining Data/julie_andrews/two_songs.csv")

# Examine the result of joining singers to two_songs
two_songs %>% inner_join(singers, by = "movie")

# Remove NA's from key before joining
two_songs %>% 
  filter(!is.na(movie)) %>% 
  inner_join(singers, by = "movie")

movie_years <- read_csv("Joining Data/movies/movie_years.csv")
movie_songs <- read_csv("Joining Data/movies/movie_songs.csv")

movie_studios <- read_csv("Joining Data/movies/movie_studios.csv")

movie_years %>% 
  # Left join movie_studios to movie_years
  left_join(movie_studios, by = "movie") %>% 
  # Rename the columns: artist and studio
  rename("artist" = "name.x" , "studio" = "name.y")

elvis_songs <- read_csv("Joining Data/elvis/elvis_songs.csv")
elvis_movies <- read_csv("Joining Data/elvis/elvis_movies.csv")

# Identify the key column
elvis_songs
elvis_movies

elvis_movies %>% 
  # Left join elvis_songs to elvis_movies by this column
  left_join(elvis_songs, by = c("name" = "movie")) %>% 
  # Rename columns
  rename("movie" = "name", "song" =  "name.y")

movie_years
movie_directors <- read_csv("Joining Data/movies/movie_directors.csv")

# Identify the key columns
movie_directors
movie_years

movie_years %>% 
  # Left join movie_directors to movie_years
  left_join(movie_directors, by = c("movie" = "name")) %>% 
  # Arrange the columns using select()
  select(year, movie, artist = name, director, studio)

# # Load the purrr library
# library(purrr)
# 
# # Place supergroups, more_bands, and more_artists into a list
# list(supergroups, more_bands, more_artists) %>% 
#   # Use reduce to join together the contents of the list
#   reduce(left_join, by = c("first", "last"))
#   
# list(more_artists, more_bands, supergroups) %>% 
#   Return rows of more_artists in all three datasets
#   reduce(semi_join, by = c("first", "last"))

# Alter the code to perform the join with a dplyr function
# merge(bands, artists, by = c("first", "last"), all.x = TRUE) %>%
#   arrange(band)

bands %>%
  left_join(artists, by = c("first", "last"))


require(Lahman)
lahmanNames <- readRDS("Joining Data/lahmanNames.rds")

# Examine lahmanNames
lahmanNames

# Find variables in common
lahmanNames %>%
  reduce(intersect, by = "var")

lahmanNames %>%  
  # Bind the data frames in lahmanNames
  bind_rows(.id =  "dataframe") %>%
  # Group the result by var
  group_by(var) %>%
  # Tally the number of appearances
  tally() %>%
  # Filter the data
  filter(n > 1) %>% 
  # Arrange the results
  arrange(desc(n))

lahmanNames %>% 
  # Bind the data frames
  bind_rows(.id = "dataframe") %>%
  # Filter the results
  filter(var == "playerID") %>% 
  # Extract the dataframe variable
  `$`(dataframe)

players <- Master %>% 
  # Return one row for each distinct player
  distinct(playerID, nameFirst, nameLast)

players %>% 
  # Find all players who do not appear in Salaries
  anti_join(Salaries, by = "playerID") %>%
  # Count them
  count()

players %>% 
  anti_join(Salaries, by = "playerID") %>% 
  # How many unsalaried players appear in Appearances?
  semi_join(Appearances) %>% 
  count()

players %>% 
  # Find all players who do not appear in Salaries
  anti_join(Salaries, by = "playerID") %>% 
  # Join them to Appearances
  left_join(Appearances,by = "playerID") %>% 
  # Calculate total_games for each player
  group_by(playerID) %>%
  summarize(total_games = sum(G_all, na.rm = TRUE)) %>%
  # Arrange in descending order by total_games
  arrange(desc(total_games))

players %>%
  # Find unsalaried players
  anti_join(Salaries, by = "playerID") %>% 
  # Join Batting to the unsalaried players
  left_join(Batting, by = "playerID") %>% 
  # Group by player
  group_by(playerID) %>% 
  # Sum at-bats for each player
  summarize(total_at_bat = sum(AB, na.rm = TRUE)) %>% 
  # Arrange in descending order
  arrange(desc(total_at_bat))

# Find the distinct players that appear in HallOfFame
nominated <- HallOfFame %>% 
  distinct(playerID)

nominated %>% 
  # Count the number of players in nominated
  count()

nominated_full <- nominated %>% 
  # Join to Master
  left_join(Master, by = "playerID") %>% 
  # Return playerID, nameFirst, nameLast
  select(playerID, nameFirst, nameLast)

# Find distinct players in HallOfFame with inducted == "Y"
inducted <- HallOfFame %>% 
  filter(inducted == "Y") %>%
  distinct(playerID)


inducted %>% 
  # Count the number of players in inducted
  count()

inducted_full <- inducted %>% 
  # Join to Master
  left_join(Master, by = "playerID") %>% 
  # Return playerID, nameFirst, nameLast
  select(playerID, nameFirst, nameLast)

# Let's start with a simple question: Did nominees who were inducted earn more awards than nominees who were not inducted?
# We can use AwardsPlayers to answer the question. It lists the playerID's of players who won baseball awards, and it contains one row for each award awarded in major league baseball.

# Tally the number of awards in AwardsPlayers by playerID
nAwards <- AwardsPlayers %>% 
  group_by(playerID) %>% 
  tally()

nAwards %>% 
  # Filter to just the players in inducted 
  semi_join(inducted, by = "playerID") %>% 
  # Calculate the mean number of awards per player
  summarize(avg_n = mean(n))

nAwards %>% 
  # Filter to just the players in nominated 
  semi_join(nominated, by = "playerID") %>% 
  # Filter to players NOT in inducted 
  anti_join(inducted, by = "playerID") %>% 
  # Calculate the mean number of awards per player
  summarize(avg_n = mean(n))

# Find the players who are in nominated, but not inducted
notInducted <- nominated %>% 
  setdiff(inducted)

Salaries %>% 
  # Find the players who are in notInducted
  semi_join(notInducted, by = "playerID") %>% 
  # Calculate the max salary by player
  group_by(playerID) %>% 
  summarize(max_salary = max(salary)) %>% 
  # Calculate the average of the max salaries
  summarize(avg_salary = mean(max_salary))

# Repeat for players who were inducted
Salaries %>% 
  semi_join(inducted, by = "playerID") %>% 
  group_by(playerID) %>% 
  summarize(max_salary = max(salary)) %>% 
  summarize(avg_salary = mean(max_salary))

Appearances %>% 
  # Filter Appearances against nominated
  semi_join(nominated, by = "playerID") %>% 
  # Find last year played by player
  group_by(playerID) %>% 
  summarize(last_year = max(yearID)) %>% 
  # Join to full HallOfFame
  left_join(HallOfFame, by = "playerID") %>% 
  # Filter for unusual observations
  filter(last_year >= yearID)