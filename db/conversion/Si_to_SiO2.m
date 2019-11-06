function [val] = Si_to_SiO2(val)
% Si_to_SiO2
% Converts Si to SiO2
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 2.139;

end