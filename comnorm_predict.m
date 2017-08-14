function comnorm_predict(model_opt)

% this script generates the predictions for 26 subjects using the 
% mt_linear model after the model is being optimized using the first 
% 20 trials to do benchmark comparison 

% constant init 
num_sub = 26;
predicted_labels = cell(num_sub, 1);
prior_predicted_labels = cell(num_sub, 1);

% model_opt = 2; % baseline linear regression
% covariance flag: {'l2','l2-trace','l1-diag','l1'};
order_idx = 2;

% load data
datapath = strcat(pwd, '/../data/');
if model_opt == 1
else 
end

label_path = strcat(datapath, 'original_information_struct_am');
load (label_path);
errors = zeros(26, 1);
prior_errors = zeros(26, 1);

for i=1:num_sub
    if model_opt == 1
       realdata_path = strcat(datapath, 'mt_final');
       load(realdata_path);        
    elseif model_opt ~= 1
        realdata_path = strcat(datapath, 'sparse_ins/');
        realdata_path = strcat(realdata_path, 'mov_', num2str(i));
        load(realdata_path);
        model_all_bands_bp.features.mov = mtl_data;
    end
  
    [prior_predictions, prior_errors(i), predictions, errors(i)] = ... 
        subject_predict(i, order_idx, model_all_bands_bp, ... 
                        original_information_struct_am, model_opt);
    
    predicted_labels{i} = predictions;
    prior_predicted_labels{i} = prior_predictions;
end

if model_opt == 1
    base_prior_predictions = prior_predicted_labels;
    base_prior_erros = prior_errors;
    save('../data/baseline_prior_predictions', 'base_prior_predictions');
    save('../data/baseline_prior_errors', 'base_prior_erros');
    save('../data/baseline_predictions', 'predicted_labels');
    save('../data/baseline_errors', 'errors');
else 
    sparse_prior_predictions = prior_predicted_labels;
    sparse_prior_erros = prior_errors;
    save('../data/sparse_predictions', 'sparse_prior_predictions');
    save('../data/sparse_errors', 'sparse_prior_erros');
end

end

