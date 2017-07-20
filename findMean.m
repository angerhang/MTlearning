feature_n = 57;
sub_n = 26;

base_means = zeros(feature_n, sub_n);
base_vars = zeros(feature_n, sub_n);
lab_means = zeros(feature_n, sub_n);
lab_vars = zeros(feature_n, sub_n);

for i=1:sub_n
    base_means(:, i) = mean(model_all_bands_bp.features.baseline{i}, 2);
    base_vars(:, i) = var(model_all_bands_bp.features.baseline{i}, 0, 2);
    lab_means(:, i) = mean(model_all_bands_bp.features.mov{i}, 2);
    lab_vars(:, i) = var(model_all_bands_bp.features.mov{i}, 0, 2);
end


mean_dff = base_means - lab_means;
var_ratio = base_vars ./ lab_vars;

hist(mean(mean_dff))
hist(mean(var_ratio))

hist(mean_dff(:, 3))
