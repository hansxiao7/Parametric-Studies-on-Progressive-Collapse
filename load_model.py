import keras
model = keras.models.load_model('my_model.h5')

from scipy.io import loadmat

import numpy as np
x_train = loadmat('x_train.mat')['x_train']
x_test = loadmat('x_test.mat')['x_test']
y_train = loadmat('y_train.mat')['y_train']
y_test = loadmat('y_test.mat')['y_test']
total_y = np.vstack((y_test, y_train))