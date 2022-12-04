from sklearn import datasets
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
plt.style.use("ggplot")
iris = datasets.load_iris()

type(iris.data), type(iris.target)

iris.data.shape

iris.target_mames

X = iris.data
y = iris.target

df = pd.DataFrame(X, columns=iris.feature_names)
df.head()
df.info()

_ = pd.scatter_matrix(df, c=y, figsize=[8,8], s=150, marker = 'D')