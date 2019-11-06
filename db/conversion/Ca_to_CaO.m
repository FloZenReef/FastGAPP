function [val] = Ca_to_CaO(val)
% Ca_to_CaO
% Converts Ca to CaO
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 1.4166;

end