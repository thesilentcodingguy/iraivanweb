
import numpy as np
from sklearn.datasets import load_digits

digits = load_digits()
X = digits.data / 16.0          
y = digits.target

Y = np.zeros((len(y), 10))
for i, label in enumerate(y):
    Y[i, label] = 1

from sklearn.model_selection import train_test_split

X_train, X_test, Y_train, Y_test, y_train_labels, y_test_labels = train_test_split(
    X, Y, y,
    test_size=0.2,
    random_state=42,
    stratify=y
)


def relu(z):
    return np.maximum(0, z)

def relu_derivative(z):
    return (z > 0).astype(float)

def softmax(z):
    e = np.exp(z - np.max(z))
    return e / np.sum(e)


class MLPClassifierScratch:
    def __init__(self, input_size=64, hidden_size=64, output_size=10, learningRate=0.1):
        self.lr = learningRate
        self.W1 = np.random.randn(input_size, hidden_size) * 0.01
        self.b1 = np.zeros(hidden_size)
        self.W2 = np.random.randn(hidden_size, output_size) * 0.01
        self.b2 = np.zeros(output_size)

    def forward(self, x):
        self.z1 = np.dot(x, self.W1) + self.b1
        self.a1 = relu(self.z1)
        self.z2 = np.dot(self.a1, self.W2) + self.b2
        self.a2 = softmax(self.z2)
        return self.a2

    def backward(self, x, y_true):
        dz2 = self.a2 - y_true
        dW2 = np.outer(self.a1, dz2)
        db2 = dz2

        da1 = np.dot(self.W2, dz2)
        dz1 = da1 * relu_derivative(self.z1)
        dW1 = np.outer(x, dz1)
        db1 = dz1

        self.W2 -= self.lr * dW2
        self.b2 -= self.lr * db2
        self.W1 -= self.lr * dW1
        self.b1 -= self.lr * db1

    def fit(self, X, Y, epochs=40):
        for epoch in range(epochs):
            loss = 0
            for i in range(len(X)):
                y_pred = self.forward(X[i])
                loss += -np.sum(Y[i] * np.log(y_pred + 1e-9))
                self.backward(X[i], Y[i])
            print(f"Epoch {epoch+1}, Loss: {loss/len(X):.4f}")

    def predict(self, X):
        preds = []
        for x in X:
            preds.append(np.argmax(self.forward(x)))
        return np.array(preds)


# %% [markdown]
# ### Testing and Prediction of the implemented MLP Classifier

# %%
mlp = MLPClassifierScratch(hidden_size=64, learningRate=0.1)
mlp.fit(X_train, Y_train)

y_pred = mlp.predict(X_test)
accuracy = np.mean(y_pred == y_test_labels)

print("\nTest Accuracy:", accuracy)

# %%
import matplotlib.pyplot as plt

# Find misclassified samples
misclassified_indices = np.where(y_pred = y_test_labels)[0]

print("Number of misclassified samples:", len(misclassified_indices))

# Display first 10 misclassified digits
plt.figure(figsize=(12, 4))

for i, idx in enumerate(misclassified_indices[:10]):
    plt.subplot(2, 5, i + 1)
    plt.imshow(X_test[idx].reshape(8, 8), cmap='gray')
    plt.title(f"True: {y_test_labels[idx]}\nPred: {y_pred[idx]}")
    plt.axis('off')

plt.suptitle("Misclassified Digits")
plt.tight_layout()
plt.show()

