datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');

load (realdata_path);

n_sub = size(model_all_bands_bp.features.mov, 2);
for i=1:n_sub
    % compute baseline
    baseline = model_all_bands_bp.features.baseline{i};
    pooled = mean(baseline, 2);
    
    % add to feature
    n_trial = size(baseline, 2);
    toadd = repmat(pooled, 1, n_trial);
    
    % first labeled features than baseline 
    model_all_bands_bp.features.mov{i} = [model_all_bands_bp.features.mov{i}; toadd];
end

% save to mat
save('../data/final_base', 'model_all_bands_bp');
