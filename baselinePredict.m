% this script generates the predictions for 26 subjects using the 
% mt_linear model after the model is being optimized using the first 
% 20 trials to do benchmark comparison 

clc;
clear all;
% constant init 
num_sub = 26;
predicted_labels = cell(num_sub, 1);
% covariance flag: {'l2','l2-trace','l1-diag','l1'};
order_idx = 1;

% load data
basepath = pwd;
datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');
label_path = strcat(datapath, 'original_info');
load (realdata_path);
load (label_path);

for i=1:num_sub
    predictions = subject_predict(i, order_idx, ...
                  model_all_bands_bp, original_information_struct_am);
    predicted_labels{i} = predictions;
end

save('../data/baseline_predictions', 'predicted_labels');
