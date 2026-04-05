
# %%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# %% [markdown]
# Task 1: Dataset Loading and Exploratory Data Analysis (EDA)

# %%
data = pd.read_csv(
    "imdb_labelled.txt",
    sep="\t",
    header=None,
    names=["review", "sentiment"]
)

# %%
data.head(10)

# %%
data.shape

# %%
data.info()

# %%
data.isnull().sum()

# %%
data.duplicated().sum()

# %%
data["sentiment"].value_counts()

# %%
data["sentiment"].value_counts().plot(
    kind="bar",
    title="Sentiment Distribution",
    xlabel="Sentiment (0 = Negative, 1 = Positive)",
    ylabel="Count"
)
plt.show()


# %% [markdown]
# Task 2: Text Preprocessing and Feature Engineering

# %%
from sklearn.feature_extraction.text import TfidfVectorizer

tfidf = TfidfVectorizer(
    stop_words="english",
    max_features=3000,
    min_df=2,
    max_df=0.9
)

X = tfidf.fit_transform(data["review"])
y = data["sentiment"]



# %% [markdown]
# Task 3: Sentiment Classification Using Decision Tree

# %%
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

dt_model = DecisionTreeClassifier(
    criterion="entropy",
    max_depth=14,
    min_samples_split=15,
    min_samples_leaf=7,
    class_weight="balanced",
    random_state=42
)

dt_model.fit(X_train, y_train)

# %%
from sklearn.tree import plot_tree

plt.figure(figsize=(16,6))
plot_tree(
    dt_model,
    max_depth=2,
    filled=True,
    feature_names=tfidf.get_feature_names_out(),
    class_names=["Negative", "Positive"]
)
plt.show()


# %%
y_pred = dt_model.predict(X_test)
print("Training Accuracy:", dt_model.score(X_train, y_train))
print("Testing Accuracy:", dt_model.score(X_test, y_test))


# %% [markdown]
# Task 4: Model Evaluation and Comparison

# %%
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
accuracy = accuracy_score(y_test, y_pred)
precision = precision_score(y_test, y_pred)
recall = recall_score(y_test, y_pred)
f1 = f1_score(y_test, y_pred)

print("Accuracy :", accuracy)
print("Precision:", precision)
print("Recall   :", recall)
print("F1-score :", f1)


# %%
# Confusion Matrix
from sklearn.metrics import confusion_matrix

cm = confusion_matrix(y_test, y_pred)
cm


# %%
# Confusion matrix visualization
plt.imshow(cm)
plt.title("Confusion Matrix")
plt.colorbar()
plt.xlabel("Predicted Label")
plt.ylabel("True Label")

for i in range(2):
    for j in range(2):
        plt.text(j, i, cm[i, j], ha="center", va="center")

plt.show()



