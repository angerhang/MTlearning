datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');

load (realdata_path);

n_sub = size(model_all_bands_bp.features.mov, 2);

for i=1:n_sub
    % compute baseline
    baseline = model_all_bands_bp.features.baseline{i};
    smoves = model_all_bands_bp.features.mov{i};
    
    % add to feature
    mean_base = mean(baseline, 2);
    smoves = bsxfun(@rdivide, smoves, mean_base);
    smoves = 10 * log10(smoves);
    model_all_bands_bp.features.mov{i} = smoves;
end

save('../data/db_final', 'model_all_bands_bp');