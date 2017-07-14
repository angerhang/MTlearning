% this script computes the pair-wise weight matrix based on the 
% trial baseline recording using uLSIF 

%% load data
datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');
load (realdata_path);

lsif_path = strcat(pwd, '/../uLSIF');
addpath (lsif_path)

%% compute importance
n_subjects = size(model_all_bands_bp.features.baseline, 2);
importance = eye(n_subjects);
% importance is a row based matrix 
% row i represents the importances of other subjects to the ith subject
for i=1:n_subjects
    x_nu = model_all_bands_bp.features.baseline{i};
    
    for j=1:n_subjects
        if i ~= j
            x_de = model_all_bands_bp.features.baseline{j};
            [wh_x_de, ~] = uLSIF(x_de, x_nu);
        end
        
        % might need to normalize the subject trial 
        importance(i, j) = mean(wh_x_de);
    end
    
end

% normalize the importnace using the largest element 
peaks = max(importance, [], 2);
importance = bsxfun(@rdivide, importance, peaks);
save('../data/importance', 'importance');

