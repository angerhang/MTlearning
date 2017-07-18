% normalize_all_feature

datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');
load (realdata_path);

for j=1:size(model_all_bands_bp.features.mov)
    
    ref_base = model_all_bands_bp.features.baseline{j};
    tonorm = model_all_bands_bp.features.mov{j};
    
    normed_feature =  bsxfun(@rdivide, tonorm, sqrt(var(tonorm, ... 
                       0, 2) ./ var(ref_base, 0, 2)));
    normed_feature = bsxfun(@plus, normed_feature, mean(ref_base, 2) ...
                                   - mean(normed_feature, 2));
                               
    model_all_bands_bp.features.mov{j} = normed_feature;

end

save('../data/new_features', 'model_all_bands_bp');
