function [val] = Cr_to_Cr2O5(val)
% Cr_to_Cr2O5
% Converts Cr to Cr2O5
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 1.7693;

end