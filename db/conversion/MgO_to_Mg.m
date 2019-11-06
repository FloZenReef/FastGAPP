function [val] = MgO_to_Mg(val)
% MgO_to_So
% Converts MgO to Mg
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 0.6030;

end