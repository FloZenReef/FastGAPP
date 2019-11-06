function [val] = Cr2O5_to_Cr(val)
% Cr2O5_to_Cr
% Converts Cr2O5 to Cr
% Conversion factor was calculated from the molar weights of each oxide
% Function is called whenever required!
% *************************************************************************
% Project FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 23.11.16
% *************************************************************************

val = val .* 0.5652;

end