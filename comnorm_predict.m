function [errors] = comnorm_predict(model_opt, subject_id)

% this script generates the predictions for 26 subjects using the 
% mt_linear model after the model is being optimized using the first 
% 20 trials to do benchmark comparison 

% covariance flag: {'l2','l2-trace','l1-diag','l1'};
order_idx = 2;
tic;
% load data
datapath = strcat(pwd, '/../data/');
if model_opt == 1
else 
end

label_path = strcat(datapath, 'original_information_struct_am');
load (label_path);

if model_opt == 1
   realdata_path = strcat(datapath, 'mt_final');
   load(realdata_path);        
elseif model_opt ~= 1
    realdata_path = strcat(datapath, 'sparse_ins/');
    realdata_path = strcat(realdata_path, 'mov_', num2str(subject_id));
    load(realdata_path);
    model_all_bands_bp.features.mov = mtl_data;
end

% model construction
[prior_predictions, prior_errors, predictions, errors] = ... 
    subject_predict(subject_id, order_idx, model_all_bands_bp, ... 
                    original_information_struct_am, model_opt);

if model_opt == 1
    base_prior_predictions = prior_predictions;
    base_prior_erros = prior_errors;
    
    base_pp_path = strcat('../data/mtl/baseline_pp', ...
                            num2str(subject_id), '.mat');
    base_pe_path = strcat('../data/mtl/baseline_pe', ...
                        num2str(subject_id), '.mat'); 
    base_p_path = strcat('../data/mtl/baseline_p', ...
                            num2str(subject_id), '.mat');
    base_e_path = strcat('../data/mtl/baseline_e', ...
                            num2str(subject_id), '.mat');                        
                                             
    save(base_pp_path, 'base_prior_predictions');
    save(base_pe_path, 'base_prior_erros');
    save(base_p_path, 'predictions');
    save(base_e_path, 'errors');
else 
    sparse_prior_predictions = prior_predictions;
    sparse_prior_erros = prior_errors;
    
    sparse_pp_path = strcat('../data/mtl/sparse_p', num2str(subject_id), '.mat');
    sparse_pe_path = strcat('../data/mtl/sparse_e', num2str(subject_id), '.mat');
    sparse_p_path = strcat('../data/mtl/baseline_p', ...
                            num2str(subject_id), '.mat');
    sparse_e_path = strcat('../data/mtl/baseline_e', ...
                            num2str(subject_id), '.mat'); 
                        
    save(sparse_pp_path, 'sparse_prior_predictions');
    save(sparse_pe_path, 'sparse_prior_erros');
    save(sparse_p_path, 'predictions');
    save(sparse_e_path, 'errors');
end

myT = toc;
fprintf('Model completed for subject %d. Time used: %f', subject_id, myT);
end
