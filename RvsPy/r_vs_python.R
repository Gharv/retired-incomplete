

# Importing a CSV
nba <- read.csv("nba.csv")

# Looking at the Structure or Summary
str(nba)

# Finding the number of rows
dim(nba)

# Looking at the first row of the data
head(nba, 1)

# Find the average of each statistic
sapply(nba, mean, na.rm=TRUE)

# Histogram of Age
hist(nba$Age)
library(ggplot2)
ggplot(nba, aes(x='Age')) + geom_histogram(binwidth=2) # produces error

# Scatter plot and regression line with 95% CI layered
ggplot(data = nba) +
  aes(x = Rk, y = Age) +
  geom_point() +
  geom_smooth(method=lm)

# Make pairwise scatterplots
pairs(nba[,c("AST","FG","TRB")])

# Make clusters of the players
library(cluster)
set.seed(123)
isGoodCol <- function(col){
  sum(is.na(col)) == 0 && is.numeric(col) 
} # have to remove  columns that are not all numbers
goodCols <- sapply(nba, isGoodCol)
clusters <- kmeans(nba[,goodCols], centers=5)
labels <- clusters$cluster

# Plotting players by cluser
nba2d <- prcomp(nba[,goodCols], center=TRUE)
twoColumns <- nba2d$x[,c(1,2)] # the columns are rank vs age
clusplot(twoColumns, labels)

# Spliting data into training and testing sets
trainRowCount <- floor(0.8 * nrow(nba))
set.seed(123)
trainIndex <- sample(1:nrow(nba), trainRowCount)
train <- nba[trainIndex,]
test <- nba[-trainIndex,]

# Univariate linear regression
fit <- lm(AST ~ FG, data=train) # predict assists from field goals made
predictions <- predict(fit, test)

# Calculate summary statistics for the model
summary(fit)

# Fit a random forest model
library(randomForest)
predictorColumns <- c("Age", "MP", "FG", "TRB", "STL", "BLK")
rf <- randomForest(train[predictorColumns], train$AST, ntree=100)
predictions <- predict(rf, test[predictorColumns])

# Calculate MSE
mean((test["AST"] - predictions)^2)









