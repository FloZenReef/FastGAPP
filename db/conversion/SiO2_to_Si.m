function [val] = SiO2_to_Si(val)
% SiO2_to_Si
% Converts SiO2 to Si
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 0.4674;

end