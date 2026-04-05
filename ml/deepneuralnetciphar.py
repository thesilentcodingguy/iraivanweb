
# %% [markdown]
# Import Required Libraries

# %%
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

# %% [markdown]
# Load CIFAR-10 Dataset

# %%
from tensorflow.keras.datasets import cifar10

(X_train, y_train), (X_test, y_test) = cifar10.load_data()

print("Training images shape:", X_train.shape)
print("Testing images shape:", X_test.shape)

# %% [markdown]
# Define Class Labels

# %%
class_names = [
    'Airplane', 'Automobile', 'Bird', 'Cat', 'Deer',
    'Dog', 'Frog', 'Horse', 'Ship', 'Truck'
]

print("Number of training images:", len(X_train))
print("Number of test images:", len(X_test))

# %% [markdown]
# Visualize Sample Images

# %%
plt.figure(figsize=(10,10))
for i in range(16):
    plt.subplot(4,4,i+1)
    plt.imshow(X_train[i])
    plt.title(class_names[y_train[i][0]])
    plt.axis('off')
plt.show()

# %% [markdown]
# Normalize Image Data

# %%
X_train = X_train / 255.0
X_test = X_test / 255.0

# %% [markdown]
# One-Hot Encode Labels

# %%
y_train = keras.utils.to_categorical(y_train, 10)
y_test = keras.utils.to_categorical(y_test, 10)

# %% [markdown]
# Build CNN Architecture

# %%
model = keras.Sequential([

    # Block 1
    layers.Conv2D(32, (3,3), padding='same', input_shape=(32,32,3)),
    layers.BatchNormalization(),
    layers.Activation('relu'),
    layers.Conv2D(32, (3,3), padding='same'),
    layers.BatchNormalization(),
    layers.Activation('relu'),
    layers.MaxPooling2D((2,2)),
    layers.Dropout(0.25),

    # Block 2
    layers.Conv2D(64, (3,3), padding='same'),
    layers.BatchNormalization(),
    layers.Activation('relu'),
    layers.Conv2D(64, (3,3), padding='same'),
    layers.BatchNormalization(),
    layers.Activation('relu'),
    layers.MaxPooling2D((2,2)),
    layers.Dropout(0.25),

    # Block 3
    layers.Conv2D(128, (3,3), padding='same'),
    layers.BatchNormalization(),
    layers.Activation('relu'),
    layers.MaxPooling2D((2,2)),
    layers.Dropout(0.3),

    layers.Flatten(),
    layers.Dense(256, activation='relu'),
    layers.BatchNormalization(),
    layers.Dropout(0.5),
    layers.Dense(10, activation='softmax')
])

# %% [markdown]
# Compile The Model

# %%
model.compile(
    optimizer=keras.optimizers.Adam(learning_rate=0.001),
    loss='categorical_crossentropy',
    metrics=['accuracy']
)

# %%
datagen = keras.preprocessing.image.ImageDataGenerator(
    rotation_range=15,
    width_shift_range=0.1,
    height_shift_range=0.1,
    horizontal_flip=True
)

datagen.fit(X_train)

# %%
lr_scheduler = keras.callbacks.ReduceLROnPlateau(
    monitor='val_loss',
    factor=0.5,
    patience=3,
    min_lr=1e-5
)

# %% [markdown]
# Train The Model

# %%
history = model.fit(
    datagen.flow(X_train, y_train, batch_size=64),
    epochs=30,
    validation_data=(X_test, y_test),
    callbacks=[lr_scheduler]
)

# %% [markdown]
# Plot Accuracy Graph

# %%
plt.plot(history.history['accuracy'], label='Training Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.legend()
plt.xlabel('Epochs')
plt.ylabel('Accuracy')
plt.title('Training vs Validation Accuracy')
plt.show()


test_loss, test_acc = model.evaluate(X_test, y_test)
print("Test Accuracy:", test_acc)

# %% [markdown]
# ## CIFAR-10 Dataset Overview  
# 
# The CIFAR-10 dataset consists of 60,000 color images of size 32×32 pixels grouped into 10 classes:
# 
# Airplane  
# Automobile  
# Bird  
# Cat  
# Deer  
# Dog  
# Frog  
# Horse  
# Ship  
# Truck  
# 
# It contains 50,000 training images and 10,000 testing images.
# 
# ---
# 
# ## Why Convolutional Layers Are Better Than Fully Connected Layers  
# 
# Fully connected layers flatten images and lose spatial information.
# 
# Convolutional layers preserve spatial structure, use shared weights, reduce parameters, and capture local patterns like edges and textures.
# 
# ### Role of Components  
# 
# **Convolution**  
# Extracts meaningful feature maps using filters.
# 
# **Pooling**  
# Reduces size of feature maps and controls overfitting.
# 
# **Fully Connected Layers**  
# Use extracted features to perform final classification.
# 
# ---
# 
# ## Why ReLU is Preferred  
# 
# ReLU helps avoid vanishing gradients and speeds up training.
# 
# It is simple to compute and allows faster convergence.
# 
# Formula:  
# ReLU(x) = max(0, x)
# 
# ---
# 
# ## Forward and Backpropagation in CIFAR-10  
# 
# **Forward Propagation**  
# The image passes through convolution and pooling layers, gets flattened, and produces class probabilities through dense layers.
# 
# **Backpropagation**  
# The loss is computed using categorical cross-entropy. Gradients are calculated and weights are updated using the Adam optimizer.
# 
# ---
# 
# ## Effect of Hyperparameters  
# 
# **Learning Rate**  
# High values cause unstable training. Low values slow down learning.
# 
# **Batch Size**  
# Small batches improve generalization. Large batches train faster but may generalize less.
# 
# **Number of Epochs**  
# Too few epochs cause underfitting. Too many cause overfitting.
# 
# ---
# 
# ## Model Evaluation  
# 
# Training accuracy shows performance on training data.
# 
# Validation accuracy shows how well the model generalizes during training.
# 
# Test accuracy measures final performance on unseen data.
# 
# ---
# 
# ## Why Validation Accuracy is More Important  
# 
# Training accuracy only reflects how well the model memorizes data.
# 
# Validation accuracy indicates generalization and helps detect overfitting.
# 
# It is a better measure of real-world performance.
# 
# ---
# 
# ## Possible Architectural Improvements  
# 
# Add batch normalization  
# Increase network depth  
# Use data augmentation  
# Apply dropout regularization  
# Use residual networks like ResNet  
# Apply transfer learning


