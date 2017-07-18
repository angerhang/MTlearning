% The data input format: for the linear model we have 
% data in the form of features * labels. In this test data
% we have 24 by 300. We can understand for each trial we have
% 24 features, and we have 300 trials with 5 subjects. 
% For the bilinear model, the input is of the form 
% electrodes * features * labels, so the label here can be considered 
% as the trial label in a reocrding sessionn.

%% model prep
clear all;
clc;
fprintf('Script started...\n')

% Instantiate models
n_its = 10;
order = {'l2','l2-trace','l1-diag','l1'};

% data spliting 
% train data 
train_x = model_all_bands_bp.features.mov(1:25);
% only select the features after the 20th timestep
train_y = original_information_struct_am.log_of_narj_jerk_data(1:25);

% individual data for optimization 
test_x = model_all_bands_bp.features.mov(26);
opt_x = mat2cell(test_x{1}(:, 1:20), 590);
opt_y = mat2cell(original_information_struct_am.log_of_narj_jerk_data{26}(1:20, :), 20, 1);

% test data 
test_x = mat2cell(test_x{1}(:, 21:end), 590);
test_y = mat2cell(model_all_bands_bp.predictions_observations_update_subj_upd20. ... 
         observations_of_updated{26}, 1, 77);
      
%% model construction      
for i = 1:length(order)
    disp(['********************* Covariance update: ', order{i}, '*************************']);
    regression_model{i} = MT_linear_regression('dim_reduce',1,'n_its',1e2,'lambda_ml',0,'cov_flag',order{i},'zero_mean',1);
    disp('Confirm prior computation switches: ');
    regression_model{i}.printswitches;
    
    % Code to fit the prior (training on the first 4)
    disp('Training regression prior...')  
    regression_model{i}.fit_prior(train_x, train_y);

    % Code to fit the new task (with cross-validated lambda)
    new_regression = regression_model{i}.fit_new_task(opt_x{1}, opt_y{1},'ml',0);
    
    % Classifying after the new task update
    fprintf('rmse on new task for regression model: %.2f\n',  ... 
        sqrt(mean((new_regression.predict(test_x{1}) - test_y{1}').^2)));
end
