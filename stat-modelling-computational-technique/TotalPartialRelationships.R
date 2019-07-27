# Correlation and R^2
# The coefficient of determination,  R2 , compares the variation in the response variable to the variation in the fitted model value. It can be calculated as a ratio of variances:
  
require(mosaic)
require(mosaicData)
Swim <- SwimRecords # from mosaicData
mod <- lm( time ~ year + sex, data = Swim)
var(fitted(mod)) / var(Swim$time)

rsquared(mod)

# The regression report is a standard way of summarizing models.
summary(mod)

# Occasionally, you may be interested in the correlation coefficient  r  between two quantities.
# You can, of course, compute  r  by fitting a model, finding  R2 , and taking a square root.

mod2 <- lm( time ~ year, data = Swim)
coef(mod2)

sqrt(rsquared(mod2))

# The cor() function computes this directly:
  
cor(Swim$time, Swim$year)

# Note that the negative sign on  r  indicates that record swim time decreases as year increases. This information about the direction of change is contained in the sign of the coefficient from the model. The magnitude of the coefficient tells how fast the time is changing (with units of seconds per year). The correlation coefficient (like  R2 ) is without units.

# Keep in mind that the correlation coefficient  r  summarizes only the simple linear model A ~ B where B is quantitative. But the coefficient of determination,  R2 , summarizes any model; it is much more useful. If you want to see the direction of change, look at the sign of the correlation coefficient.
# 
# http://mosaic-web.org/go/SM2-technique/total-and-partial-relationships.html
# http://mosaic-web.org/go/SM2-technique/confidence-intervals.html
# 