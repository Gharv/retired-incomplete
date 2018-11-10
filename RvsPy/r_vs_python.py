import pandas as pd

# Importing a CSV
nba = pd.read_csv("nba.csv")

# Looking at the Structure or Summary
nba.sum

# Finding the number of rows
nba.shape

# Looking at the first row of the data
nba.head(1)

# Find the average of each statistic
nba.mean() #already ignores NA

# Get columns and the type of values they store
nba.dtypes

# Histogram of Age
from plotnine import *
ggplot(nba, aes(x='Age')) + geom_histogram(binwidth=2)

# Scatter plot and regression line with 95% CI layered
ggplot(data = nba) + aes(x = 'Rk', y = 'Age') + geom_point() + geom_smooth(method='lm')

# Make pairwise scatterplots
import seaborn as sns
import matplotlib.pyplot as plt
sns.pairplot(nba[["AST", "FG", "TRB"]])
plt.show()

# Make clusters of the players
from sklearn.cluster import KMeans
kmeans_model = KMeans(n_clusters=5, random_state=123)
good_columns = nba._get_numeric_data().dropna(axis=1)
kmeans_model.fit(good_columns)
labels = kmeans_model.labels_

# Plotting players by cluster
from sklearn.decomposition import PCA
pca_2 = PCA(2)
plot_columns = pca_2.fit_transform(good_columns)
# columns are rank vs age
plt.scatter(x=plot_columns[:,0], y=plot_columns[:,1], c=labels)
plt.show()

# Spliting data into training and testing sets
train = nba.sample(frac=0.8, random_state=123)
test = nba.loc[~nba.index.isin(train.index)]

# Univariate linear regression
from sklearn.linear_model import LinearRegression
lr = LinearRegression()
lr.fit(train[["FG"]], train["AST"]) # predict assists from field goals made
predictions = lr.predict(test[["FG"]])

# Calculate summary statistics for the model
import statsmodels.formula.api as sm
model = sm.ols(formula='AST ~ FG', data=train)
fitted = model.fit()
fitted.summary()

# Fit a random forest model
from sklearn.ensemble import RandomForestRegressor
predictor_columns = ["Age", "MP", "FG", "TRB", "STL", "BLK"]
rf = RandomForestRegressor(n_estimators=100, min_samples_leaf=3)
rf.fit(train[predictor_columns], train["AST"])
predictions = rf.predict(test[predictor_columns])

# Calculate MSE
from sklearn.metrics import mean_squared_error
mean_squared_error(test["AST"], predictions)








