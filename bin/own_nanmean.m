function [mean_val] = own_nanmean(arr_nan)
% Reads and array containing NaN's and clears them out to calculate the
% mean value from the array

arr_log = isnan(isnan(arr_nan)./0);

mean_val = mean(arr_nan(arr_log));


end

