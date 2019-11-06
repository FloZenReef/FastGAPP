function [max_val] = own_nanmax(arr_nan)
% Reads and array containing NaN's and clears them out to calculate the
% maximum value from the array

arr_log = isnan(isnan(arr_nan)./0);

max_val = max(arr_nan(arr_log));


end

