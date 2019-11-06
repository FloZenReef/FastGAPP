function [val] = P_to_P2O5(val)
% P_to_P2O5
% Converts P to P2O5
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 2.2914;

end