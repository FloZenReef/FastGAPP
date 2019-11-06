function [val] = Fe_to_FeO(val)
% Fe_to_FeO
% Converts Fe to FeO
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 1.2865;

end