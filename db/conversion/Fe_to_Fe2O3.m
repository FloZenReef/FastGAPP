function [val] = Fe_to_Fe2O3(val)
% Fe_to_Fe2O3
% Converts Fe to Fe2O3
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 1.4297;

end