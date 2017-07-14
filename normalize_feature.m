function [normed_feature] = normalize_feature(train_x, baseline_ft, ...
                                              subject_topredict)
%normalize_feature normalizes the target feature space using the same
% transformation procedure that makes the ref_rest and tonorm_rest
% have the same mean and variance. Alternatively one can also normalize
% with rest to the a subject's own resting state data 
% INPUT  train_x: all features to normalize 
%        baseline_ft: the resting EEG 
%        subject_topredict: the reference subject id 
%        normed_option: 1 normalization across feature band with respect
%        to the reference subject. 2 normalalization with respect the 
%        subject's own resting state 
%           
%                       
% adjust variance 

ref_base = baseline_ft{subject_topredict};
tonorm_base = 1:26;
tonorm_base = baseline_ft(tonorm_base ~= subject_topredict);
normed_feature = cell(1, 25);

for i=1:size(train_x, 2)
    % adjust var for each power band 
    tmp_x = bsxfun(@rdivide, tonorm_base{i}, sqrt(var(tonorm_base{i}, ... 
                   0, 2) ./ var(ref_base, 0, 2)));
   
    % adjust mean
    normed_feature{i} = bsxfun(@plus, tmp_x, mean(ref_base, 2) ...
                               - mean(tmp_x, 2));
end

end

