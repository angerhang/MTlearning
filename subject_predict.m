function [prior_predictions, prior_error, predictions, error] = subject_predict(subject_topredict, order_idx, ...
             model_all_bands_bp, original_information_struct_am, model_opt)
% takes a subject id and train on the other subjects
% after being optimized on the first 20 trials, returns the predictions
% The data input format: for the linear model we have 
% data in the form of features * labels. In this test data
% we have 24 by 300. We can understand for each trial we have
% 24 features, and we have 300 trials with 5 subjects. 
% For the bilinear model, the input is of the form 
% electrodes * features * labels, so the label here can be considered 
% as the trial label in a reocrding sessionn.
% INPUT subject_topredict : the subject id 
%       order_idx: the covariance index 
%       model_all_bands_bp: the EEG feature
%       original_information_struct_am: the data labels 
%       model_opt: toggle for normed or baseline model. 1 for baseline 
%                  2 for the normed model.

%% model prep
fprintf('Processing subject %d ...\n', subject_topredict)

% Instantiate models
% n_its = 10;
order = {'l2','l2-trace','l1-diag','l1'};

% data spliting 
% train data 
if model_opt == 2
    % this might need to change when changing the base vector size
    feature_n = 720;
else 
    % original data set feature
    feature_n = 590;
end

subject_to_train = 1:26;
subject_to_train = subject_to_train(subject_to_train~=subject_topredict);
train_x = model_all_bands_bp.features.mov(subject_to_train);
% only select the features after the 20th timestep
train_y = original_information_struct_am.log_of_narj_jerk_data(subject_to_train);

% individual data for optimization 
test_x = model_all_bands_bp.features.mov(subject_topredict);
opt_x = mat2cell(test_x{1}(:, 1:20), feature_n);
opt_y = mat2cell(original_information_struct_am. ... 
                 log_of_narj_jerk_data{subject_topredict}(1:20, :), 20, 1);

% test data 
test_x = mat2cell(test_x{1}(:, 21:end), feature_n);
test_y = mat2cell(original_information_struct_am. ... 
    log_of_narj_jerk_data{subject_topredict}(21:end, :), size(test_x{1}, 2), 1);
  

%% model construction      
disp(['********************* Covariance update: ', order{order_idx}, ... 
       '*************************']);
regression_model = MT_linear_regression('dim_reduce',1,'n_its',1e2, ... 
              'lambda_ml',0,'cov_flag',order{order_idx},'zero_mean',0);
disp('Confirm prior computation switches: ');
regression_model.printswitches;

% Code to fit the prior (training on the first 4)
disp('Training regression prior...')  
regression_model.fit_prior(train_x, train_y);

% prior error 
prior_predictions = regression_model.prior_predict(test_x{1});
prior_error = sqrt(mean((prior_predictions - test_y{1}').^2));
fprintf('rmse on new task for prior model: %.2f\n',  ... 
prior_error);

% Code to fit the new task (with cross-validated lambda)
% only optimize in model 1
if ((model_opt == 1) || (model_opt == 2))
    new_regression = regression_model.fit_new_task(opt_x{1}, opt_y{1},'ml',0);
    
    % Classifying after the new task update
    predictions = new_regression.predict(test_x{1});
    error = sqrt(mean((predictions - test_y{1}').^2));
    fprintf('rmse on new task for regression model: %.2f\n',  ... 
    error);
else 
    % Classifying after the new task update
    prior_predictions = regression_model.prior_predict(test_x{1});
    prior_error = sqrt(mean((prior_predictions - test_y{1}').^2));
    fprintf('rmse on new task for regression model: %.2f\n',  ... 
    prior_error);
    predictions =1;
    error = 1;
end


end

