function [val] = Ti_to_TiO2(val)
% Ti_to_TiO2
% Converts Ti to TiO2
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 1.6683;

end