function [val] = Mn_to_MnO(val)
% Mn_to_MnO
% Converts Mn to MnO
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 1.2912;

end