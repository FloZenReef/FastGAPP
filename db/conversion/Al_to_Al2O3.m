function [val] = Al_to_Al2O3(val)
% Al_to_Al2O3
% Converts Al to Al2O3
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 1.8895;

end