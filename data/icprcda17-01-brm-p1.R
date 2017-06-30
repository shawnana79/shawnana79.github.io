
# title: "Section 1: Models for Binary Outcomes: Part 1"
# subtitle: ICPSR CDA
# date: "Last Updated: June, 29, 2017"

################################################################################

# 1.a Set up
# # Specify working folder
setwd("C:/Users/TamaravdD/Box Sync/Teaching/2017-2.5-ICPSR-CA/spex/Rusecda")


## 1.b Load the Data
# Load library that enables you to load Stata data
library(foreign)

# Load the data
data <-as.data.frame(read.dta("icpsr_scireview3R.dta", convert.factor=TRUE))


## 1.c Examine the Data and Select Variables 

# Describe the data 
head(data)
summary(data)

# Select variables of interest
myvars <- c("faculty", "fellow", "phd", "mcit3", "mnas")
datasub <- data[myvars]

# Make sure the classs of variables are correct
datasub$faculty <- as.factor(datasub$faculty)
datasub$fellow <- as.factor(datasub$fellow)
datasub$mnas <- as.factor(datasub$mnas)
datasub$mcit3 <- as.numeric(datasub$mcit3)
datasub$phd <- as.numeric(datasub$phd)
```

## 1.d Drop cases with Missing Data and Verify

# Only keep non missing variables
dataclean <- na.omit(datasub)

# Check no missing values (both need to return 0)
sum(is.na(dataclean)) 
dataclean[!complete.cases(dataclean),]

# Save newly created dataset
write.dta(dataclean,"data/icpsr_scireview3_tvdd.dta")

## 2. Describe your Data

summary(dataclean)

### Alternatively:
# Library to present data for psychometrics
library(psych)
describe(dataclean)

## 3. Binary Logit Model 

# Logit model (format: DV ~ IVs)
mod.log <- glm(faculty~ fellow+phd+mcit3+mnas, data=dataclean, family=binomial)
# Present the results
summary(mod.log)

## 4. Computing Factor Change Coefficients

# Calculate standard deviation for all continuous variables 
sdX <- with(dataclean, c(NA, sd(phd), sd(mcit3), NA))

# Extract beta coefficients and z scores
bHat<- coef(mod.log)[2:5]
zscores <- cbind(summary(mod.log)$coefficients[2:5,3])

# Put everything in a table
facOdds <- cbind(bHat, exp(bHat), exp(bHat*sdX), sdX, zscores)
colnames(facOdds) <- c("b", "e^b", "e^(b*sd)", "SD of X", "Z-values")
facOdds

## 7.a Computing Predicted Probabilities
# Create the sub-sample 
s1 <- with(dataclean, data.frame(fellow=factor(1:2, levels =1:2, labels = levels(dataclean$fellow)), phd=mean(phd), mcit3=mean(mcit3), mnas="0_No"))
s1

# Apply the logit model to the sub-sample
predict(mod.log, s1, type="response", se.fit=TRUE)$fit

## 1.7.b Use Predicted Probabilities to Compute Factor Change Coefficient
a <- predict(mod.log, s1, type="response", se.fit=TRUE)$fit[1]
b <- predict(mod.log, s1, type="response", se.fit=TRUE)$fit[2]
(b/(1-b))/(a/(1-a))

## 8-9 Compare the Coefficients from Logit and Probit

# Probit model
mod.prob <- glm(faculty~ fellow+phd+mcit3+mnas, data=dataclean, family=binomial (link=probit))
summary(mod.prob)

### Table

logprob <- cbind(mod.log$coef, summary(mod.log)$coef[,3], mod.prob$coef, summary(mod.prob)$coef[,3])
colnames(logprob) <- c("logit estimates", "SE", "Probit estimates", "SE")
logprob

