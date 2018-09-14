# Code Book

Each variable was imported form different files.
The files were sparated into *test* and *traning* sets a new variable called
**type** was created to identify the origin set.

The variables *X,body_acc_x,body_acc_y,body_acc_z,body_gyro_x,body_gyro_y,
body_gyro_z,total_acc_x,total_acc_y,total_acc_z,subject,activity* each
constitute of a series of 128 samples, the variables **session** and **timeFrame**
were created to identify the origin serie and its index inside the series

The variable **activity** was trasformed from integer to factor based on the
file *activity_labels.txt* that is part of the original data.


## Output Variables

**subject**: Identifies the person that performed the recorded activity

**activity**: Identify the type of activity being of the sample

**session**: Identifier of a recorded session

**type**: Identify the type of the data (traning or test)

**timeFrame**: Index of the sample of a recorded session

**X**: no clue

**body_acc_x**: The body acceleration X axis signal obtained by subtracting the
gravity from the total acceleration.

**body_acc_y**: The body acceleration X axis signal obtained by subtracting the
gravity from the total acceleration.

**body_acc_z**: The body acceleration X axis signal obtained by subtracting the
gravity from the total acceleration.

**body_gyro_x**: The angular velocity vector measured by the gyroscope X axis
for each window sample. The units are radians/second.

**body_gyro_y**: The angular velocity vector measured by the gyroscope Y axis
for each window sample. The units are radians/second.

**body_gyro_z**: The angular velocity vector measured by the gyroscope X axis
for each window sample. The units are radians/second.

**total_acc_x**: The acceleration signal from the smartphone accelerometer X axis
in standard gravity units 'g'

**total_acc_y**: The acceleration signal from the smartphone accelerometer Y axis
in standard gravity units 'g'

**total_acc_z**: The acceleration signal from the smartphone accelerometer Z axis
in standard gravity units 'g'

X_train.txt': Training set.

y_train.txt': Training labels.

test/X_test.txt': Test set.
