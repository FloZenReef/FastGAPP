function [med_val] = own_nanmed(arr_nan)
% Reads and array containing NaN's and clears them out to calculate the
% median value from the array

arr_log = isnan(isnan(arr_nan)./0);

med_val = median(arr_nan(arr_log));


end

