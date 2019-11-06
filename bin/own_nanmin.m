function [min_val] = own_nanmin(arr_nan)
% Reads and array containing NaN's and clears them out to calculate the
% minimum value from the array

arr_log = isnan(isnan(arr_nan)./0);

min_val = min(arr_nan(arr_log));


end

