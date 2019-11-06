function [val] = K_to_K2O(val)
% K_to_K2O
% Converts K to K2O
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 1.2046;

end