
# %% [markdown]
# ## Import Statements

# %%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix, roc_auc_score, roc_curve

# %%
data = load_breast_cancer()
X = data.data
y = data.target

print("Shape:", X.shape)
print("Class distribution:", np.bincount(y))

# %%
print(data.feature_names)

# %% [markdown]
# ## Train and Test Data split

# %%
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# %% [markdown]
# ## Decision Tree Algorithm

# %%
from collections import Counter

class DecisionTree:
    def __init__(self, max_depth=5):
        self.max_depth = max_depth
        self.tree = None

    def gini(self, y):
        classes = np.unique(y)
        impurity = 1
        for c in classes:
            p = np.sum(y == c) / len(y)
            impurity -= p**2
        return impurity

    def best_split(self, X, y):
        best_gini = 1
        best_feature = None
        best_threshold = None

        for feature in range(X.shape[1]):
            thresholds = np.unique(X[:, feature])
            for t in thresholds:
                left = y[X[:, feature] <= t]
                right = y[X[:, feature] > t]
                if len(left) == 0 or len(right) == 0:
                    continue
                g = (len(left)/len(y))*self.gini(left) + \
                    (len(right)/len(y))*self.gini(right)
                if g < best_gini:
                    best_gini = g
                    best_feature = feature
                    best_threshold = t
        return best_feature, best_threshold

    def build(self, X, y, depth):
        if depth == self.max_depth or len(np.unique(y)) == 1:
            return Counter(y).most_common(1)[0][0]

        feature, threshold = self.best_split(X, y)
        if feature is None:
            return Counter(y).most_common(1)[0][0]

        left_mask = X[:, feature] <= threshold
        right_mask = X[:, feature] > threshold

        return {
            "feature": feature,
            "threshold": threshold,
            "left": self.build(X[left_mask], y[left_mask], depth+1),
            "right": self.build(X[right_mask], y[right_mask], depth+1)
        }

    def fit(self, X, y):
        self.tree = self.build(X, y, 0)

    def predict_sample(self, x, node):
        if not isinstance(node, dict):
            return node
        if x[node["feature"]] <= node["threshold"]:
            return self.predict_sample(x, node["left"])
        return self.predict_sample(x, node["right"])

    def predict(self, X):
        return np.array([self.predict_sample(x, self.tree) for x in X])

# %%
dt = DecisionTree(max_depth=4)
dt.fit(X_train, y_train)

y_pred_dt = dt.predict(X_test)

print("Accuracy:", accuracy_score(y_test, y_pred_dt))
print("Precision:", precision_score(y_test, y_pred_dt))
print("Recall:", recall_score(y_test, y_pred_dt))
print("F1:", f1_score(y_test, y_pred_dt))

# %% [markdown]
# ## Random Forest

# %%
class RandomForest:
    def __init__(self, n_estimators=10, max_depth=4):
        self.n_estimators = n_estimators
        self.max_depth = max_depth
        self.trees = []

    def bootstrap(self, X, y):
        idx = np.random.choice(len(X), len(X), replace=True)
        return X[idx], y[idx]

    def fit(self, X, y):
        for _ in range(self.n_estimators):
            X_s, y_s = self.bootstrap(X, y)
            tree = DecisionTree(max_depth=self.max_depth)
            tree.fit(X_s, y_s)
            self.trees.append(tree)
            print(f"Estimator: {self.n_estimators}")

    def predict(self, X):
        predictions = np.array([tree.predict(X) for tree in self.trees])
        return np.round(np.mean(predictions, axis=0)).astype(int)

# %%
rf = RandomForest(n_estimators=20, max_depth=4)
rf.fit(X_train, y_train)

y_pred_rf = rf.predict(X_test)

print("RF Accuracy:", accuracy_score(y_test, y_pred_rf))

# %% [markdown]
# ## AdaBoost

# %%
class AdaBoost:
    def __init__(self, n_estimators=20):
        self.n_estimators = n_estimators
        self.models = []
        self.alphas = []

    def fit(self, X, y):
        y = np.where(y==0, -1, 1)
        w = np.ones(len(y)) / len(y)

        for _ in range(self.n_estimators):
            stump = DecisionTree(max_depth=1)
            stump.fit(X, y)
            pred = stump.predict(X)

            error = np.sum(w * (pred != y))
            alpha = 0.5 * np.log((1-error)/(error+1e-10))

            w *= np.exp(-alpha * y * pred)
            w /= np.sum(w)

            self.models.append(stump)
            self.alphas.append(alpha)

    def predict(self, X):
        final = sum(alpha * model.predict(X)
                    for model, alpha in zip(self.models, self.alphas))
        return np.where(final > 0, 1, 0)

# %% [markdown]
# ## Voting Classifier

# %%
class VotingClassifier:
    def __init__(self, models, soft=False):
        self.models = models
        self.soft = soft

    def predict(self, X):
        preds = np.array([model.predict(X) for model in self.models])
        if self.soft:
            return np.round(np.mean(preds, axis=0)).astype(int)
        else:
            return np.apply_along_axis(lambda x: np.bincount(x).argmax(), axis=0, arr=preds)

# %% [markdown]
# ## ROC Curve Companion

# %%
for model, name in [(dt,"DT"),(rf,"RF")]:
    y_score = model.predict(X_test)
    fpr, tpr, _ = roc_curve(y_test, y_score)
    auc = roc_auc_score(y_test, y_score)
    plt.plot(fpr, tpr, label=f"{name} AUC={auc:.2f}")

plt.legend()
plt.show()

# %%
print("DT Train:", accuracy_score(y_train, dt.predict(X_train)))
print("DT Test:", accuracy_score(y_test, y_pred_dt))

print("RF Train:", accuracy_score(y_train, rf.predict(X_train)))
print("RF Test:", accuracy_score(y_test, y_pred_rf))

# %%
scores = []
for n in range(1, 50, 5):
    rf = RandomForest(n_estimators=n, max_depth=4)
    rf.fit(X_train, y_train)
    scores.append(accuracy_score(y_test, rf.predict(X_test)))

plt.plot(range(1,50,5), scores)
plt.xlabel("n_estimators")
plt.ylabel("Accuracy")
plt.show()

# %%
ada = AdaBoost(n_estimators=20)
ada.fit(X_train, y_train)

ensemble = VotingClassifier([dt, rf, ada], soft=False)
y_pred_final = ensemble.predict(X_test)

print("Final Ensemble Accuracy:",
      accuracy_score(y_test, y_pred_final))

