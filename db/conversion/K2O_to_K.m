function [val] = K2O_to_K(val)
% K2O_to_K
% Converts K2O to K
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 0.8301;

end