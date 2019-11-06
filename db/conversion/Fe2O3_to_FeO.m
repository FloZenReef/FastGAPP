function [val] = Fe2O3_to_FeO(val)
% Fe2O3_to_FeO
% Converts Fe2O3 to FeO
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 0.8998;

end