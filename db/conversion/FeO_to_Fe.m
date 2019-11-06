function [val] = FeO_to_Fe(val)
% FeO_to_Fe
% Converts FeO to Fe
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 0.7773;

end