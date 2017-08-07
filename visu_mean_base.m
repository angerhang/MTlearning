datapath = strcat(pwd, '/../data/');
realdata_path = strcat(datapath, 'mt_final');

load (realdata_path);

n_sub = size(model_all_bands_bp.features.mov, 2);
mean_mov = zeros(590, n_sub);
mean_base = zeros(590, n_sub);

for i=1:n_sub
    % compute baseline
    baseline = model_all_bands_bp.features.baseline{i};
    mov_data = model_all_bands_bp.features.mov{i};
    
    % add to feature
    mean_mov(:, i) = mean(mov_data, 2);
    mean_base(:, i) = mean(baseline, 2);
end

for i=1:25
    subplot(5 , 5 , i);
    scatter(mean_base(:, i) , mean_mov(:, 1))
    refline(1,0)
    corrcoef(mean_base(:, i), mean_mov(:, i));
end
