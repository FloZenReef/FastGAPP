function [val] = Mg_to_MgO(val)
% Mg_to_MgO
% Converts Mg to MgO
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 1.6583;

end