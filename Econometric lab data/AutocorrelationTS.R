rm(list = ls())
# Install and load the readxl package
#install.packages("readxl")
library(readxl)

# Read the Excel file
ExportImportOil <- read_excel("C:/Users/hp/Downloads/ExportImportOil.xlsx")
View(ExportImportOil)
ExportImportOil
library(stats)
# Rename the variables with spaces using backticks
ExportImportOil$`Oil Exports` <- ExportImportOil$`Oil Exports`
ExportImportOil$`Oil Imports` <- ExportImportOil$`Oil Imports`

# Fit the linear regression model
model <- lm(`Oil Exports` ~ `Oil Imports`, data = ExportImportOil)
summary(model)
acf(model$residuals, type = "correlation")
pacf(model$residuals)
library(lmtest)
dwtest(model)
bgtest(model, order = 2)
bgtest(model, order = 3)
bgtest(model, order = 4)

model1<-lm(Non.Oil.Imports~Oil.Imports, data = ExportImportOil)
summary(model1)
acf(model1$residuals, type = "correlation")
pacf(model1$residuals)
dwtest(model1)
bgtest(model, order = 2)
bgtest(model, order = 3)
bgtest(model, order = 4)


#Time series Classical Decomposition
data.ts <- ts(ExportImportOil$'Oil Imports', frequency = 12)
data.ts
# Load necessary libraries if not already loaded
library(stats)

# Assuming data.ts is your time series data, make sure it's defined correctly

# Check the column names in ExportImportOil
colnames(ExportImportOil)

# Make sure the correct column names are used
# If the column names have spaces, use backticks around them
ts.plot(data.ts, xlab="Time Period", ylab="Oil Imports", main="Monthly Oil Imports")

# Use the correct column name for pacf
plot(pacf(ExportImportOil$`Correct_Column_Name`, plot=FALSE), main="Partial Autocorrelation Plot")

plot(acf(ExportImportOil$Oil.Imports,plot=FALSE),main="Autocorrelation Plot")
decomp<-decompose(data.ts) 
plot(decomp)
decomp$seasonal
decomp$trend
decomp$random
seasadj <- data.ts - decomp$seasonal
plot(seasadj)

#decomposition by loess method.
decomp1<-stl(data.ts,s.window="periodic") 
plot(decomp1) 
seasonal_stl_model1 <- decomp1$time.series[,1]
trend_stl_model1 <- decomp1$time.series[,2]
random_stl_model1 <- decomp1$time.series[,3]


seasadj1 <- data.ts - seasonal_stl_model1
trendadj1<-data.ts-trend_stl_model1
plot(trendadj1)

plot(pacf(ExportImportOil$Oil.Imports,plot=FALSE),main="Partial Autocorrelation Plot")
plot(acf(ExportImportOil$Non.Oil.Imports,plot=FALSE),main="Partial Autocorrelation Plot")

Diff1<-diff(ExportImportOil$Non.Oil.Exports, differences=1)
plot.ts(Diff1)

Diff21<-diff(trendadj1, differences=2)
plot.ts(Diff21)

Diff31<-diff(trendadj1, differences=3)
plot.ts(Diff31)


####Forecasting-Holt Winters

HW1 <- HoltWinters(data.ts)

HW2 <- HoltWinters(data.ts, alpha=0.2, beta=0.1, gamma=0.1)

HW1.pred <- predict(HW1, 6, prediction.interval = TRUE, level=0.95)
