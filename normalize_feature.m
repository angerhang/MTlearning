function [normed_feature] = normalize_feature(ref_rest, ...
                                              tonorm_rest, tonorm_fe)
%normalize_feature normalizes the target feature space using the same
% transformation procedure that makes the ref_rest and tonorm_rest
% have the same mean and variance. 
% TODO: might need to cahnge due to the dimensionality of the resting state

% adjust variance 
normed_feature = tonorm_fe / sqrt(var(tonorm_rest) / var(ref_rest));

% adjust mean
normed_feature = normed_feature - mean(tonorm_rest) + mean(ref_rest);

end

