#Sampling Distribution
library(dplyr)
library(ggplot2)
ames <- read.csv("http://bit.ly/315N5R5") 
glimpse(ames) # you need dplyr to use this function
area <- ames$Gr.Liv.Area
price <- ames$SalePrice
head(area, n=10) #show first 10 observations 
head(price, n=10) #show first 10 observations 
length(area) #how many observations in the vector?
any(is.na(area)) #is there any NA in the vector area?
area.pop.sd<-sqrt(sum((area - mean(area))^2)/(2930)) # Population standard deviation
area.pop.sd
summary(area)
hist(area,
     main = "Histogram of above ground living area",
     xlab = "Above ground living area (sq.ft.)",
)
area <- ames$Gr.Liv.Area # create new dataset containing only variable 'Gr.Liv.Area' from dataset 'ames'

samp1 <- sample(area, 50) #take a random sample of 50 observations from the dataset 'area'

mean(samp1) # mean of the sample distribution for area. Note difference from population mean.
area <- ames$Gr.Liv.Area 

sample_means50 <- rep(NA, 5000) #initialise a vector

for(i in 1:5000){   # use of a loop function to draw a random sample 5000 times
  samp <- sample(area, 50)
  sample_means50[i] <- mean(samp)
}

hist(sample_means50, breaks = 25, 
     main = "Sampling distribution of sample mean for Above ground living area",
     xlab = "Means (sq.ft.)") #Histogram of the 5000 samples (sampling distribution of the samples mean)


#2 Sample Size and Sampling Distribution
area <- ames$Gr.Liv.Area 
area
sample_means50 <- rep(NA, 5000)
#to compute sampling distribution
for(i in 1:5000){
  samp <- sample(area, 50)
  sample_means50[i] <- mean(samp)
}
#Estimating the avg living area in homes in ames
hist(sample_means50)
#To get a sense of the effect that sample size has 
#on our distribution, let’s build up two more sampling distributions: 
#one based on a sample size of 10 and another based on a sample size of 100 
#from a population size of 5000.
area <- ames$Gr.Liv.Area 

sample_means10 <- rep(NA, 5000)
sample_means10
sample_means100 <- rep(NA, 5000)
sample_means100 
for(i in 1:5000){
  samp <- sample(area, 10)
  sample_means10[i] <- mean(samp)
  samp <- sample(area, 100)
  sample_means100[i] <- mean(samp)
}

#To see the effect that different sample sizes
#have on the sampling distribution, 
#let’s plot the three distributions on top of one another.
area <- ames$Gr.Liv.Area 

sample_means10 <- rep(NA, 5000)
sample_means10
sample_means50 <- rep(NA, 5000)
sample_means50
sample_means100 <- rep(NA, 5000)
sample_means100
for(i in 1:5000){
  samp <- sample(area, 10)
  sample_means10[i] <- mean(samp)
  samp <- sample(area, 50)
  sample_means50[i] <- mean(samp)
  samp <- sample(area, 100)
  sample_means100[i] <- mean(samp)
}

par(mfrow = c(3, 1))  # this creates 3 rows and 1 column for graphs

xlimits <- range(sample_means10)
xlimits
hist(sample_means10,  breaks = 25, xlim = xlimits)

hist(sample_means50,  breaks = 25, xlim = xlimits)

hist(sample_means100, breaks = 25, xlim = xlimits)



