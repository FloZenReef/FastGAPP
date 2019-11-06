function [val] = Al2O3_to_Al(val)
% Al2O3_to_Al
% Converts Al2O3 to Al
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 0.5293;

end