clear all

sampling_rate=8000;
location_sensor = 1;
file_num = 1;

%% Import train data
location_current = cd;
location_train = strcat(location_current,'\data_train');  %%training import

listing_train = dir(location_train);
temp_name = struct2cell(listing_train(3:end,1));
for i=1:size(temp_name,2)
name_train{i} = temp_name{1,i};
end
location_file = strcat(location_train,'\',name_train{file_num});
load_csv = csvread(location_file,3,1);

%%
for location_sensor = 1:2

    data_raw{location_sensor} = load_csv(1:end,location_sensor);

    figure
    n=1:length(data_raw{location_sensor});
    plot(n/sampling_rate,data_raw{location_sensor})
    title('Robot Vibration(time domain)')
    xlabel('time(sec)')
    ylabel('amplitude')

end





