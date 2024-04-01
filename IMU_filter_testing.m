clear all;
clf;

% Reading raw data from file
%Uncomment for raw random movement data from imu
%imu_raw_data_file = fopen("IMU_raw_data.txt");
%Uncomment for raw data of a smooth back and forth motion
%imu_raw_data_file = fopen("IMU_raw_data_smooth_back_forth.txt");
%Uncomment for raw data of a spinning back and forth motion
imu_raw_data_file = fopen("IMU_raw_data_spinning.txt");

imu_raw_data = textscan(imu_raw_data_file, '%s', 'Delimiter', ';');
fclose(imu_raw_data_file);

% Finding cells that contain "cnt"
imu_raw_data = imu_raw_data{:};
index_of_count_string = strfind(imu_raw_data,"cnt");

% Find the indexes of the cells that contain "cnt"
index_to_remove = [];
for i = 1:length(index_of_count_string)
    if cell2mat(index_of_count_string(i)) == 1
        index_to_remove = [index_to_remove i];
    end
end

% Remove the cells that contain "cnt"
imu_raw_data(index_to_remove.') = [];

% Convert cells to normal integer values
imu_data_trimmed = str2double(imu_raw_data);

% Ensure the length is a multiple of 3 for X, Y, Z data
if mod(length(imu_data_trimmed),3) ~= 0
    disp("Trimming data");
    imu_data_trimmed = imu_data_trimmed(1:length(imu_data_trimmed)-mod(length(imu_data_trimmed),3));
end

x_data = imu_data_trimmed(1:3:length(imu_data_trimmed));
y_data = imu_data_trimmed(2:3:length(imu_data_trimmed));
z_data = imu_data_trimmed(3:3:length(imu_data_trimmed));

% Implement a Savitzky-Golay filter with a cubic polynomial and a window
% size of 5

%Throwing away the first 2 samples and last 2 samples to make analysis easier
x_data_filtered = zeros(0,length(x_data));
for i = 3:1:length(x_data)-2
    x_data_filtered(i) = floor((1/35)*(-3*x_data(i-2)+12*x_data(i-1)+17*x_data(i)+12*x_data(i+1)+-3*x_data(i+2)));
end

y_data_filtered = zeros(0,length(y_data));
for i = 3:1:length(y_data)-2
    y_data_filtered(i) = floor((1/35)*(-3*y_data(i-2)+12*y_data(i-1)+17*y_data(i)+12*y_data(i+1)+-3*y_data(i+2)));
end

z_data_filtered = zeros(0,length(z_data));
for i = 3:1:length(z_data)-2
    z_data_filtered(i) = floor((1/35)*(-3*z_data(i-2)+12*z_data(i-1)+17*z_data(i)+12*z_data(i+1)+-3*z_data(i+2)));
end

length_x_data = 1:length(x_data);
length_x_data_filtered = 1:length(x_data_filtered);
figure(1);
hold on
title("X data");
plot(length_x_data,x_data,'color','blue');
plot(length_x_data_filtered,x_data_filtered,'color','red');
legend('raw data', 'filtered data');
hold off

length_y_data = 1:length(y_data);
length_y_data_filtered = 1:length(y_data_filtered);
figure(2);
hold on
title("Y data");
plot(length_y_data,y_data,'color','blue');
plot(length_y_data_filtered,y_data_filtered,'color','red');
legend('raw data', 'filtered data');
hold off

length_z_data = 1:length(z_data);
length_z_data_filtered = 1:length(z_data_filtered);
figure(3);
hold on
title("Z data");
plot(length_z_data,z_data,'color','blue');
plot(length_z_data_filtered,z_data_filtered,'color','red');
hold off