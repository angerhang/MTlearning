function comnorm_predict(model_opt, imp_opt)

% this script generates the predictions for 26 subjects using the 
% mt_linear model after the model is being optimized using the first 
% 20 trials to do benchmark comparison 
% INPUT model_opt: 1 for the baseline linear regression 
%                  2 for the baseline linear with input norm
%                  3 for the linear with covariate shift 
%       imp_opt: 1 for res - res
%                2 for res - move 
%                3 for move - move 

% constant init 
num_sub = 26;
predicted_labels = cell(num_sub, 1);
prior_predicted_labels = cell(num_sub, 1);
errors = zeros(26, 1);
prior_errors = zeros(26, 1);

% model_opt = 2; % baseline linear regression
% model_opt = 2; % baseline linear regression with simple normalization

% covariance flag: {'l2','l2-trace','l1-diag','l1'};
order_idx = 2;

% load data
datapath = strcat(pwd, '/../data/');
% realdata_path = strcat(datapath, 'new_features');
% realdata_path = strcat(datapath, 'mt_final');
realdata_path = strcat(pwd, '/results/reduced');
label_path = strcat(datapath, 'original_info');
load (realdata_path);
load (label_path);

if imp_opt == 1
    load('results/reduced_base_importance');
elseif imp_opt == 2
    load('results/reduced_movres_importance'); 
else
    load('results/reduced_mov_importance');
end


rng('default')

for i=1:num_sub
   [prior_predicted_labels{i}, prior_errors(i), predicted_labels{i}, errors(i)] =  ...
       subject_predict(i, order_idx, model_all_bands_bp, ... 
                        original_information_struct_am, model_opt, importance(i, :));
    
  %  predicted_labels{i} = predictions;
end


% covar_prior_pre = prior_predicted_labels;
% covar_errors = prior_errors;
% save('../data/covar_prior_pre', 'covar_prior_pre');
% save('../data/covar_errors', 'covar_errors');
% 


if importance == 1
    redu_res_predictions = prior_predicted_labels;
    redu_res_errors = prior_errors;
    save('results/redu_res_predictions', 'redu_res_predictions');
    save('results/redu_res_errors', 'redu_res_errors');
    save('results/redu_res_predictions', 'predicted_labels');
    save('results/redu_res_errors', 'errors');
elseif importance == 2
    redu_resm_predictions = prior_predicted_labels;
    redu_resm_errors = prior_errors;
    save('results/redu_resm_predictions', 'redu_resm_predictions');
    save('results/redu_resm_errors', 'redu_resm_errors');
    save('results/redu_resm_predictions', 'predicted_labels');
    save('results/redu_resm_errors', 'errors');
else 
    redu_move_predictions = prior_predicted_labels;
    redu_move_errors = prior_errors;
    save('results/redu_move_predictions', 'redu_move_predictions');
    save('results/redu_move_errors', 'redu_move_errors');
    save('results/redu_move_predictions', 'predicted_labels');
    save('results/redu_move_errors', 'errors');
end

% 
% if model_opt == 1
%     base_prior_predictions = prior_predicted_labels;
%     base_prior_erros = prior_errors;
%     save('../data/redu_e_prior_predictions', 'base_prior_predictions');
%     save('../data/redu_prior_errors', 'base_prior_erros');
%     save('../data/redu_predictions', 'predicted_labels');
%     save('../data/redu_errors', 'errors');
% elseif model_opt == 2
%     normed_prior_predictions = prior_predicted_labels;
%     normed_prior_erros = prior_errors;
%     save('../data/nomred_predictions', 'normed_prior_predictions');
%     save('../data/normed_errors', 'normed_prior_erros');
% end


end

