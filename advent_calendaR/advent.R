# sleigh data
sl_dat <- read.csv("sleigh.data.csv")

dim(sl_dat)
head(sl_dat)
colnames(sl_dat)
rownames(sl_dat)

# how much deerpower
sl_dat[, 4]

# christmas cruiser
sl_dat[5, ]

# how much bag space in christmas cruiser
sl_dat[5, 3]

install.packages("dplyr")
library(dplyr)

R.version
old.packages()
# update.packages()
# update.packages(ask = FALSE)

red <- subset(sl_dat, colour == 0)
green <- subset(sl_dat, colour == 1)
heavy_red <- subset(red, weight > 2)
# We could also use the filter function from dplyr here

sl_var <- select(sl_dat, km_per_carrot:bells)
head(sl_var)

sl_var2 <- select(sl_dat, -deerpower)

tree_dat <- read.csv("xmas.trees.csv")
tree_dat %>% 
  mutate(needles.by.height = tree_dat$needle.drop/tree_dat$height)

new_tree_dat <- tree_dat %>% 
  mutate(needles.by.height = tree_dat$needle.drop/tree_dat$height)
write.csv(new_tree_dat, file = "tree_data.csv")

hist(sl_dat$deerpower)

hist(red$deerpower)

boxplot(xmas.magic ~ type, data = tree_dat)

pines <- filter(tree_dat, type == "pine")
firs <- filter(tree_dat, type == "fir")
spruces <- filter(tree_dat, type == "spruce")

boxplot(pines$height ~ spruces$height)

boxplot(pines$height, spruces$height,
        col = c("red", "forestgreen"),
        names = c("Pines", "Spruces"))

xmas <- c("naughty", "nice", "nice", "naughty", "nice", "naughty", "nice", "naughty")
kids_age <- c(2, 6, 7, 10, 3, 4, 5, 9)

max(kids_age)
min(kids_age)

mean(kids_age)

# To get the mean age for each category, naughty vs. nice
tapply(kids_age, xmas, mean)

summary(tree_dat$height)

# mean xmas magic for pine trees
mean(pines$xmas.magic)

# mean xmas magic for spruce trees
mean(spruces$xmas.magic)

# are they statistically different?
t.test(pines$xmas.magic, spruces$xmas.magic)

tree_dat2 <- data.frame(type = c(rep("pine", 5),
                                 rep("spruce", 5),
                                 rep("maple", 5)),
                        xmas.magic = c(rep("8", 5),
                                       rep("6", 5),
                                       rep(NA, 5)))

# Removes rows with NA
tree_dat3 <- na.omit(tree_dat2)

# Is there a relationship between tree fragrance and the amount of xmas magic
tree.lm <- lm(fragrance ~ xmas.magic, data = tree_dat)
summary(tree.lm)
# We have a p-value close to 0 so it seems that there's a significant relationship

# Plot the results of this regression
plot(fragrance ~ xmas.magic, data = tree_dat)
abline(tree.lm)

# Customise the plots
plot(fragrance ~ xmas.magic, data = tree_dat,
     pch = 9, cex = 1.2, bg = 3, 
     xlab = "Tree Fragrance", ylab = "Christmas Magic",
     col.lab = "red")
abline(tree.lm, lty = 3)

# col = colour
# cex = size of points
# bg = background colour
# pch = point style
# xlab = X label
# ylab = Y label
# lty = line type (dashed, dotted, etc.)
# col.lab = label colours

# PLOT XMAS TREE
plot(1:10, 1:10, xlim=c(-5,5), ylim=c(0,10), 
     type="n", xlab="", ylab="", xaxt="n", yaxt="n")

rect(-1, 0, 1, 2, col="tan3", border="tan4", lwd=3)
polygon(c(-5,0,5), c(2,4,2), col="palegreen3", 
        border="palegreen4", lwd=3)
polygon(c(-4,0,4), c(3.5,5.5,3.5), col="palegreen4",
        border="palegreen3", lwd=3)
polygon(c(-3,0,3),c(5,6.5,5),col="palegreen3",border="palegreen4",lwd=3)
polygon(c(-2,0,2),c(6.25,7.5,6.25),col="palegreen4",border="palegreen3",lwd=3)

points(x=runif(4,-5,5),y=rep(2,4),col=sample(c("blue","red"),size=4,replace=T),cex=3,pch=19)
points(x=runif(4,-4,4),y=rep(3.5,4),col=sample(c("blue","red"),size=4,replace=T),cex=3,pch=19)
points(x=runif(4,-3,3),y=rep(5,4),col=sample(c("blue","red"),size=4,replace=T),cex=3,pch=19)
points(x=runif(4,-2,2),y=rep(6.25,4),col=sample(c("blue","red"),size=4,replace=T),cex=3,pch=19)
points(0,7.5,pch=8,cex=5,col="gold",lwd=3)

xPres = runif(10,-4.5,4.5)
xWidth = runif(10,0.1,0.5)
xHeight=runif(10,0,1)
for(i in 1:10){
  rect(xPres[i]-xWidth[i],0,xPres[i]+xWidth[i],xHeight[i],col=sample(c("blue","red"),size=1))
  rect(xPres[i]-0.2*xWidth[i],0,xPres[i]+0.2*xWidth[i],xHeight[i],col=sample(c("gold","grey87"),size=1))
}