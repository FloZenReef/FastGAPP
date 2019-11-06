function [val] = TiO2_to_Ti(val)
% TiO2_to_Ti
% Converts TiO2 to Ti
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 0.5994;

end