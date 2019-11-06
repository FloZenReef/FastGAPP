function [val] = Na_to_Na2O(val)
% Na_to_Na2O
% Converts Na to Na2O
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 1.3480;

end