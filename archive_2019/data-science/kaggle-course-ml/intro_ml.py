# Data Loading Code Hidden Here
import pandas as pd

# Load data
iowa_file_path = 'train.csv'
home_data = pd.read_csv(iowa_file_path)
# Filter rows with missing price values
# filtered_data = data.dropna(axis=0)
# Choose target and features
y = home_data.SalePrice
features = ["LotArea", "YearBuilt", "1stFlrSF", "2ndFlrSF", "FullBath", "BedroomAbvGr", "TotRmsAbvGrd"]
X = home_data[features]

from sklearn.tree import DecisionTreeRegressor
# Define model
iowa_model = DecisionTreeRegressor()
# Fit model
iowa_model.fit(X, y)

from sklearn.metrics import mean_absolute_error

predicted_home_prices = iowa_model.predict(X)
mean_absolute_error(y, predicted_home_prices)

print("First in-sample predictions:", iowa_model.predict(X.head()))
print("Actual target values for those homes:", y.head().tolist())

# This is an in-sample prediction which of course doesn't tell you how the model will hold up against new, unseen data

from sklearn.model_selection import train_test_split

# split data into training and validation data, for both features and target
# The split is based on a random number generator. Supplying a numeric value to
# the random_state argument guarantees we get the same split every time we
# run this script.
train_X, val_X, train_y, val_y = train_test_split(X, y, random_state = 0)
# Define model
iowa_model = DecisionTreeRegressor()
# Fit model
iowa_model.fit(train_X, train_y)

# get predicted prices on validation data
val_predictions = iowa_model.predict(val_X)
print(mean_absolute_error(val_y, val_predictions))

# print the top few validation predictions
print(val_predictions[0:5])
# print the top few actual prices from validation data
print(val_y.head())

# WOW! Your mean absolute error for the in-sample data was about 62 dollars. Out-of-sample it is more than 33,000 dollars.

# Is that MAE good?  There isn't a general rule for what values are good that applies across applications. But you'll see how to use (and improve) this number in the next step.


# Here's the takeaway: Models can suffer from either:
#
# Overfitting: capturing spurious patterns that won't recur in the future, leading to less accurate predictions, or
# Underfitting: failing to capture relevant patterns, again leading to less accurate predictions.
# We use validation data, which isn't used in model training, to measure a candidate model's accuracy. This lets us try many candidate models and keep the best one.

# Loops over decision trees with different params and returns the MAE
def get_mae(max_leaf_nodes, train_X, val_X, train_y, val_y):
    model = DecisionTreeRegressor(max_leaf_nodes=max_leaf_nodes, random_state=0)
    model.fit(train_X, train_y)
    preds_val = model.predict(val_X)
    mae = mean_absolute_error(val_y, preds_val)
    return(mae)

candidate_max_leaf_nodes = [5, 25, 50, 100, 250, 500]
# Write loop to find the ideal tree size from candidate_max_leaf_nodes
mae_results = {}
for max_leaf_nodes in candidate_max_leaf_nodes:
    mae = get_mae(max_leaf_nodes, train_X, val_X, train_y, val_y)
    mae_results[max_leaf_nodes] = mae
# Store the best value of max_leaf_nodes (it will be either 5, 25, 50, 100, 250 or 500)
best_tree_size = min(mae_results, key=mae_results.get)

# You know the best tree size. If you were going to deploy this model in practice, you would make it even more accurate by using all of the data and keeping that tree size.  That is, you don't need to hold out the validation data now that you've made all your modeling decisions.

# Fill in argument to make optimal size and uncomment
final_model = DecisionTreeRegressor(max_leaf_nodes = best_tree_size)

# fit the final model and uncomment the next two lines
final_model.fit(X, y)

# You've tuned this model and improved your results. But we are still using Decision Tree models, which are not very sophisticated by modern machine learning standards. In the next step you will learn to use Random Forests to improve your models even more.

# Even today's most sophisticated modeling techniques face this tension between underfitting and overfitting. But, many models have clever ideas that can lead to better performance. We'll look at the random forest as an example.

# The random forest uses many trees, and it makes a prediction by averaging the predictions of each component tree. It generally has much better predictive accuracy than a single decision tree and it works well with default parameters. If you keep modeling, you can learn more models with even better performance, but many of those are sensitive to getting the right parameters.

# There are parameters which allow you to change the performance of the Random Forest much as we changed the maximum depth of the single decision tree. But one of the best features of Random Forest models is that they generally work reasonably even without this tuning.

# You'll soon learn the XGBoost model, which provides better performance when tuned well with the right parameters (but which requires some skill to get the right model parameters).

from sklearn.ensemble import RandomForestRegressor

# Define the model. Set random_state to 1
rf_model = RandomForestRegressor(random_state = 1)

# fit your model
rf_model.fit(train_X, train_y)

# Calculate the mean absolute error of your Random Forest model on the validation data
rf_val_mae = mean_absolute_error(rf_model.predict(val_X), val_y)

print("Validation MAE for Random Forest Model: {}".format(rf_val_mae))

# To improve accuracy, create a new Random Forest model which you will train on all training data
rf_model_on_full_data = RandomForestRegressor(random_state = 123)

# fit rf_model_on_full_data on all data from the training data
rf_model_on_full_data.fit(X, y)

# path to file you will use for predictions
test_data_path = 'test.csv'

# read test data file using pandas
test_data = pd.read_csv(test_data_path)

# create test_X which comes from test_data but includes only the columns you used for prediction.
# The list of columns is stored in a variable called features
test_X = test_data[features]

# make predictions which we will submit.
test_preds = rf_model_on_full_data.predict(test_X)

# The lines below shows how to save predictions in format used for competition scoring
# Just upload them and that's it.

output = pd.DataFrame({'Id': test_data.Id,
                       'SalePrice': test_preds})
output.to_csv('submission.csv', index=False)
