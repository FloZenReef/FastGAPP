function [val] = Na2O_to_Na(val)
% Na2O_to_Na
% Converts Na2O to Na
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 0.7419;

end