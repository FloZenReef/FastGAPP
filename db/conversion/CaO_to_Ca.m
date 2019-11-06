function [val] = CaO_to_Ca(val)
% CaO_to_Ca
% Converts CaO to Ca
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 26.11.16
% *************************************************************************

val = val .* 0.7059;

end