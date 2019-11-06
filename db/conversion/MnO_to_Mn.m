function [val] = MnO_to_Mn(val)
% MnO_to_Mn
% Converts MnO to Mn
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 0.0.7745;

end