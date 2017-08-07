function comnorm_predict(model_opt)

% this script generates the predictions for 26 subjects using the 
% mt_linear model after the model is being optimized using the first 
% 20 trials to do benchmark comparison 
% INPUT model_opt: 1 for the baseline linear regression 

% constant init 
num_sub = 26;
predicted_labels = cell(num_sub, 1);
prior_predicted_labels = cell(num_sub, 1);
errors = zeros(26, 1);
prior_errors = zeros(26, 1);

% covariance flag: {'l2','l2-trace','l1-diag','l1'};
order_idx = 1;

% load data
datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');
label_path = strcat(datapath, 'original_info');
load (realdata_path);
load (label_path);

for i=1:num_sub
   [prior_predictions, prior_error, ~, ~] =  subject_predict(i, order_idx, ...
           model_all_bands_bp, original_information_struct_am, model_opt);
    
  %  predicted_labels{i} = predictions;
   prior_predicted_labels{i} = prior_predictions;
   prior_errors(i) = prior_error;
end


covar_prior_pre = prior_predicted_labels;
covar_errors = prior_errors;
save('../data/covar_prior_pre', 'covar_prior_pre');
save('../data/covar_errors', 'covar_errors');

% 
% if model_opt == 1
%     base_prior_predictions = prior_predicted_labels;
%     base_prior_erros = prior_errors;
%     save('../data/baseline_prior_predictions', 'base_prior_predictions');
%     save('../data/baseline_prior_errors', 'base_prior_erros');
%     save('../data/baseline_predictions', 'predicted_labels');
%     save('../data/baseline_errors', 'errors');
% elseif model_opt == 2
%     normed_prior_predictions = prior_predicted_labels;
%     normed_prior_erros = prior_errors;
%     save('../data/nomred_predictions', 'normed_prior_predictions');
%     save('../data/normed_errors', 'normed_prior_erros');
% end


end

