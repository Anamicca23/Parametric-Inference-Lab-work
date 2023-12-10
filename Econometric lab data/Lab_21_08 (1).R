mtcars
#dimension of the dataframe
dim(mtcars)
#structure of data
str(mtcars)

#install.packages("pastecs")
library(pastecs)
#summary statistics
stat.desc(mtcars)

#OLS
model <- lm(mpg ~ disp + hp + wt + drat, data = mtcars)
summary(model)

model2 <- lm(mpg ~  hp + wt , data = mtcars)
summary(model2)

####Heteroskedasticity######
###Create residual vs fitted plot
plot(fitted(model),resid(model),xlab='Fitted values',ylab = 'Residuals', abline(0,0))

#install.packages("lmtest")
#install.packages("sandwich")
library(lmtest)
library(sandwich)

##Goldfeld Quandt test- change the number of central observations and see what happens
gqtest(model, order.by = ~disp+hp, data = mtcars, fraction = 7)

##Bruesch Pagan test
bptest(model)
##White test
bptest(model, ~ disp*hp + I(disp^2) + I(hp^2), data = mtcars)

###Perform weighted least squares/feasible GLS
#define weights
# estimating the variance of y for different values of x
wgt<-1/lm(abs(model$residuals)~model$fitted.values)$fitted.values^2
wls_model<-lm(mpg ~ disp + hp + wt + drat, data = mtcars, weights=wgt)

summary(wls_model)

####Heteroskedasticity robust standard errors
coeftest(model, vcov = vcovHC(model, type = "HC0"))



####Lab Date:28 August,2023####

####Multicollinearity#####
##Correlation matrix
#install.packages("corrplot")
library(corrplot)
corrplot(cor(mtcars))
corrplot(cor(mtcars),method="color")
corrplot(cor(mtcars),method="number",type="upper")

#####Tolerances and variance inflation factor
#install.packages("olsrr")
library(olsrr)
ols_vif_tol(model)
ols_eigen_cindex(model)
##An conditional index value greater than 15 indicates presence of multicollinearity and
#greater than 30 indicates severe multicollinearity. Associated with conditional index 
#is output of variance decomposition for each principal component into intercept
#and regressors. For each component where conditional index exceeds 15,
#one should look for presence of variance concentration


####Ridge Regression####
install.packages("glmnet")
library(glmnet)
#Getting the independent variable
x_var<-data.matrix(mtcars[,c("hp", "wt", "drat")])

#Getting the dependent variable
y_var<-mtcars[, "mpg"]

#Setting the range of lambda values

lambda_seq<-10^seq(2,-2, by=-.1)
#Using glmnet function to build the ridge regression in r
fit<-glmnet(x_var, y_var, alpha=0, lambda = lambda_seq)
summary(fit)

#Next task is to identify the optimal value of lambda that will result in a minimum error
#This can be obtained by using cv.glmnet( ) function

ridge_cv<-cv.glmnet(x_var,y_var,alpha=0, lambda = lambda_seq)

best_lambda<-ridge_cv$lambda.min
best_lambda


###Building the final model with the best lambda
best_ridge<-glmnet(x_var,y_var,alpha=0,lambda = 0.5011872)
coef(best_ridge)

library(haven)
finaldata_ihds2 <- read_dta("G:/ScienceEdu_Jain_etal_DataTut/Replication Files/raw data/finaldata_ihds2.dta")
View(finaldata_ihds2)
###Task 1: For each regression get the heteroskedasticity robust SE and compare the standard errors of coefficients of 'science_eng' ####
m1<-lm(log_earnings~science_eng ,data=finaldata_ihds2)
summary(m1)
m2<-lm(log_earnings~science_eng+first_div+second_div+repeated+eng_vfl+eng_lfl ,data=finaldata_ihds2)
summary(m2)
m3<-lm(log_earnings~science_eng+first_div+second_div+repeated+eng_vfl+eng_lfl+ iedu_level1+iedu_level4+iedu_level2+iedu_level3 ,data=finaldata_ihds2)
summary(m3)
finaldata_ihds2$District<-as.character(finaldata_ihds2$district)
m4<-lm(log_earnings~science_eng+first_div+second_div+repeated+eng_vfl+eng_lfl+ iedu_level1+iedu_level4+iedu_level2+iedu_level3+District ,data=finaldata_ihds2)
summary(m4)
m5<-lm(log_earnings~science_eng+first_div+second_div+repeated+eng_vfl+eng_lfl+ iedu_level1+iedu_level4+iedu_level2+age_lab +sq_age+ married +sc +st +obc +muslim+ christ +av_edu_min_i+District ,data=finaldata_ihds2)
summary(m5)

####Fixed-Effects Estimation in R with the fixest Package
install.packages("fixest")
install.packages("AER")
library(fixest)
library(AER)

data(Grunfeld)
feols_model<- feols(invest ~ value + capital | firm + year , data = Grunfeld)
# one-way cluster by firm
feols_model<- feols(invest ~ value + capital | firm + year , data = Grunfeld, cluster = ~firm)

# two-way clustering by firm and year
feols_model<- feols(invest ~ value + capital | firm + year , data = Grunfeld, cluster = ~firm + year)

# estimate linear two-way fixed effect model with two-way clusting
feols_model<- feols(invest ~ value + capital | firm + year , data = Grunfeld, cluster = ~firm + year)

# get variance-covariance matrix with heteroskedasticity robust standard errors
hetero = vcov(feols_model, se = "hetero")

summary(feols_model)
# Alternatively, use etable:
etable(feols_model, tex = TRUE)

summary(feols_model, .vcov = hetero) # hetero is the var-cov matrix that was previously computed using the vcov function
# OR
etable(feols_model, se = "white")





####Task2: Import the following .dta file to R

Class28_8 <- read_dta("Class28_8.dta")
View(Class28_8)

#This data is from PLFS 2017-18. The data includes employed males not working as casual labour.
#It includes males working in household enterprises/self employed or as salaried individuals.
#Q1: You want to examine whether social group-ie, caste identity affects earnings. 
#What should be your hypothesis? 
#What should your dependent and main explanatory variables be?
#Q2: What variables should you control for, given your data?
#Q3: Do you think you can estimate causal effect from this exercise?If yes why?If not why?
#Q4: Interpret the results you get by running the regressions in Q1 and Q2.




#Now suppose you want to examine that self employment is not as rewarding as salaried employment.
#Q5: What will be your hypothesis?
#What should your dependent and main explanatory variables be?
#Q6: What variables should you control for, given your data?
#Q7: Do you think any variable can potentially cause hetroskedasticity?
#Q8: Can you say from your specification about existence of multicollinearity?What should you do?
#Q7: Do you think you can estimate causal effect from this exercise?If yes why?If not why?
#Q8: Interpret the results you get by running the OLS regressions in Q5 and Q6.



feols_model<- feols(GrossMonthlyEarnings ~ 0+ SC | StateCode , data = Class28_8, weights=Weight,cluster = ~Fsu)