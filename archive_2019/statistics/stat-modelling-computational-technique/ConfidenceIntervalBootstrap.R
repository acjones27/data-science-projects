# http://mosaic-web.org/go/SM2-technique/confidence-intervals.html

require(mosaic)

Runners = read.csv("http://tiny.cc/mosaic/Cherry-Blossom-2008.csv")
names( Runners )

# Here is a simulation of selecting a sample of size  n=100  from the population of runners.
Mysamp = deal( Runners, 100 ) # A Simulation of sampling

# Now that you have a sample, you can calculate the sample statistic that’s of interest to you. For instance:
  
mean( gun ~ sex, data = Mysamp )

# Theoretically, the sampling distribution reflects the variation from one randomly dealt sample to another, where each sample is taken from the population. In practice, your only ready access to the population is through your sample. So, to simulate the process of random sampling, re-sampling is used and the re-sampling distribution is used as a convenient approximation to the sampling distribution.

# Re-sampling involves drawing from the set of cases in your sample with replacement. 

nums = c(1,2,3,4,5)
nums
resample(nums)
resample(nums)
resample(nums)

# To use resampling to estimate the sampling distribution of a statistic, you apply the calculation of the statistic to a resampled version of your sample. For instance, here are the group-wise means from one resample of the running sample:
  
mean( gun ~ sex, data = resample(Mysamp) )

# The bootstrap procedure involves conducting many such trials and examining the variation from one trial to the next.

# The do() function lets you automate the collection of multiple trials. For instance, here are five trials carried out using do():
  
do(5) * mean( gun ~ sex, data = resample(Mysamp) )

# Typically, you will use several hundred trials for bootstrapping. The most common way to summarize the variation in bootstrap trials, you can calculate a coverage interval. (When applied to a sampling distribution, the coverage interval is called a confidence interval.)

# To do the computation, give a name to the results of the repeated bootstrap trials, here it’s called trials:
  
trials = do(500) * mean( gun ~ sex, data = resample(Mysamp) )
head(trials)

confint(trials)

histogram(trials$F)

# The idea of sampling distributions is based on drawing at random from the population, not resampling. Ordinarily, you can’t do this calculation since you don’t have the population at hand. But in this example, we happen to have the data for all runners. Here’s the population-based confidence interval for the mean running time, with sample size  n=100 , broken down by sex:
  
trials = do(500) * mean( gun ~ sex, data = deal(Runners, 100) )
confint(trials)

# The grade-point average is a kind of group-wise mean, where the group is an individual student. This is not the usual way of looking at things for a student, who sees only his or her own grades. But institutions have data on many students.

Grades = read.csv("http://tiny.cc/mosaic/grades.csv")
gp = read.csv("http://tiny.cc/mosaic/grade-to-number.csv")
all.students = merge(Grades, gp)
one.student = subset( all.students, sid=="S31509" )
one.student

# Calculating the mean grade-point for the one student is a simple matter:
  
mean( ~ gradepoint, data=one.student, na.rm = TRUE )

# It’s equally straightforward to calculate the grade-point averages for all students as individuals:
  
GPAs <- mean( gradepoint ~ sid, data=all.students, na.rm = TRUE )
head(GPAs)

# Bootstrapping can be used to find the confidence interval on the grade-point average for each student:
  
trials = do(100)*mean( ~ gradepoint, data=resample(one.student), na.rm = TRUE )

# The na.rm = TRUE argument tells the mean function to exclude sampled grades of NA which are incompletes, withdrawls and audits on the student’s record.

confint(trials)

# It’s important to point out that there are other methods for calculating confidence intervals that are based on the standard deviation of the data. Formulas and procedures for such methods are given in just about every standard introductory statistics book and would certainly be used instead of bootstrapping in a simple calculation of the sort illustrated here.

# However, such formulas don’t go to the heart of the problem: accounting for variation in the grades and the contribution from different sources of that variation. For example, some of the variation in this student’s grades might be due systematically to improvement over time or due to differences between instructor’s practices. The modeling techniques introduced in the following chapters provide a means to examine and quantify the different sources of variation.
