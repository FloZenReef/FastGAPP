function [val] = P2O5_to_P(val)
% P2O5_to_P
% Converts P2O5 to P
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 0.4364;

end