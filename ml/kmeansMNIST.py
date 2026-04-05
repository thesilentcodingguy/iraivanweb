# %% [markdown]
# ## 1. MNIST Dataset
# 
# MNIST contains 70,000 grayscale images (28×28 pixels) of handwritten digits (0–9). Each image has 784 features. It is suitable for unsupervised learning because it has clear structure, high dimensionality, and natural variations within each digit class (style, thickness, rotation).
# 
# 
# ## 2. K-Means (k = 10)
# 
# With k = 10, each cluster roughly represents one digit. Centroids look like average digit images. Some overlap occurs due to similar digit shapes.
# 
# 
# ## 3. Elbow & Silhouette
# 
# The Elbow method typically shows a bend near k = 10. Silhouette score is also highest around this value. Thus, optimal k is close to the number of digits but not perfectly exact.
# 
# 
# 
# ## 4. Cluster vs True Labels
# 
# Digits like 0 and 1 cluster well. Digits 3, 5, 8, and 9 are often confused due to structural similarity.
# 
# 
# 
# ## 5. Cleanest & Hardest Digits
# 
# Cleanest: 0 and 1 (distinct shapes).  
# Hardest: 3, 5, 8, 9 (similar curves and writing styles).
# 
# 
# ## 6. Changing Distance Metrics
# 
# Euclidean works well for compact clusters.  
# Cosine distance can improve high-dimensional similarity.  
# Different metrics slightly change cluster separation.
# 
# 
# ## 7. When k ≠ 10
# 
# k < 10 → multiple digits merge.  
# k > 10 → digits split into sub-styles.  
# k ≈ 10 gives balanced clustering.

# %%
import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import fetch_openml
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

# Load MNIST
mnist = fetch_openml('mnist_784', version=1)
X = mnist.data
y = mnist.target.astype(int)

print(X.shape)   # (70000, 784)

# %%


# %%
X = X / 255.0


# %%
X = X[:10000]
y = y[:10000]

# %%
pca = PCA(n_components=30)
X_reduced = pca.fit_transform(X)
print("Reduced Shape:", X_reduced.shape)

# %% [markdown]
# Apply K-means with k = 10. What does each cluster represent?

# %%
import numpy as np

# %%
def euclidean_distance(a, b):
    return np.sqrt(np.sum((a - b) ** 2))

# %%
def assign_clusters(X, centroids):
    clusters = []

    for x in X:
        distances = []
        for c in centroids:
            distances.append(euclidean_distance(x, c))
        cluster_id = np.argmin(distances)
        clusters.append(cluster_id)

    return np.array(clusters)

# %%
def update_centroids(X, clusters, k):
    new_centroids = []

    for i in range(k):
        points = X[clusters == i]

        if len(points) == 0:
            new_centroids.append(X[np.random.randint(0, len(X))])
        else:
            new_centroids.append(np.mean(points, axis=0))

    return np.array(new_centroids)

# %%
def kmeans(X, k, max_iters=100):

    # Step 1: Initialize centroids randomly
    random_idx = np.random.choice(len(X), k, replace=False)
    centroids = X[random_idx]

    for iteration in range(max_iters):

        print("Iteration:", iteration)
        # Step 2: Assign clusters
        clusters = assign_clusters(X, centroids)

        # Step 3: Update centroids
        new_centroids = update_centroids(X, clusters, k)

        # Step 4: Check convergence
        if np.all(centroids == new_centroids):
            print("Converged at iteration:", iteration)
            break

        centroids = new_centroids

    return clusters, centroids

# %%
# @title
clusters, centroids = kmeans(X_reduced, k=10)

# %%
centroid_images = pca.inverse_transform(centroids)

# %% [markdown]
# Visualize cluster centroids as images.

# %%
import matplotlib.pyplot as plt

plt.figure(figsize=(10,4))
for i in range(10):
    plt.subplot(2,5,i+1)
    plt.imshow(centroid_images[i].reshape(28,28), cmap='gray')
    plt.title(f'Cluster {i}')
    plt.axis('off')
plt.show()

# %%
inertia = []

k_values = range(2,16)
for k in k_values:

    clusters, centroids = kmeans(X_reduced, k=k)

    current_inertia = 0
    for i in range(k):
        points_in_cluster = X_reduced[clusters == i]
        if len(points_in_cluster) > 0:
            centroid = centroids[i]

            current_inertia += np.sum(np.sum((points_in_cluster - centroid)**2, axis=1))
    inertia.append(current_inertia)

plt.plot(k_values, inertia, marker='o')
plt.xlabel("k")
plt.ylabel("Inertia")
plt.title("Elbow Method")
plt.show()

# %%



