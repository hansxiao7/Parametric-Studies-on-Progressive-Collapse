#load data from files
from scipy.io import loadmat
from scipy.io import savemat

import numpy as np
x_train = loadmat('x_train.mat')['x_train']
x_test = loadmat('x_test.mat')['x_test']
y_train = loadmat('y_train.mat')['y_train']
y_test = loadmat('y_test.mat')['y_test']
total_y = np.vstack((y_test, y_train))

#scale the data
from sklearn import preprocessing
x_scaler = preprocessing.MinMaxScaler(feature_range=(-1, 1))
y_scaler = preprocessing.MinMaxScaler(feature_range=(-1, 1)).fit(total_y)

x_train_scaled = x_scaler.fit_transform(x_train)
x_test_scaled = x_scaler.transform(x_test)
y_train_scaled = y_scaler.transform(y_train)
y_test_scaled = y_scaler.transform(y_test)

savemat('scaled_data.mat',{'x_train_scaled':x_train_scaled,'y_train_scaled':y_train_scaled, 'x_test_scaled':x_test_scaled,'y_test_scaled':y_test_scaled})


#build the MLP model
import matplotlib.pyplot as plt
import keras
from keras.models import Sequential
from keras.layers import Dense, Activation, Dropout
from keras import optimizers

epochs = 1000
model = Sequential()
model.add(Dense(100, activation='selu', input_shape= (4,)))
model.add(Dropout(0.2))
model.add(Dense(100, activation='selu'))
model.add(Dropout(0.2))
model.add(Dense(100, activation='selu'))
model.add(Dropout(0.2))
model.add(Dense(5, activation='selu'))

model.summary()

model.compile(loss='mse', optimizer=optimizers.RMSprop())

history = model.fit(x_train_scaled, y_train_scaled,
                    epochs=epochs,
                    verbose=1,
                    validation_data=(x_test_scaled, y_test_scaled))
score = model.evaluate(x_test_scaled, y_test_scaled, verbose=0)
print(score)

model.save('my_model.h5')

y_train_predict_scaled = model.predict(x_train_scaled)
y_test_predict_scaled = model.predict(x_test_scaled)

y_train_predict = y_scaler.inverse_transform(y_train_predict_scaled)
y_test_predict = y_scaler.inverse_transform(y_test_predict_scaled)

savemat('predicted_output.mat',{'y_train_predict':y_train_predict,'y_test_predict':y_test_predict})

#import sklearn.metrics
#print('real_training_error: '+sklearn.metrics.mean_squared_error(y_train, y_train_predict))
#print('real_test_error: '+sklearn.metrics.mean_squared_error(y_test, y_test_predict))