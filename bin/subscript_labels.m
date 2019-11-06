% This function gets an axis header and goes with loop through valid
% header entries and changes the header for written header with
% subscripts (e.g. SiO2 = SiO_2)
% Called by plot_diamond.m, plot_ternary.m, plot_ternary_inv.m, plot_linlog.m
% *************************************************************************
% m-file: subscript_labels.m
% Author: Florian Riefstahl
% Institution: Univ. Bremen, AWI, CAU
% Date: 2015-2019
% Last Change: 2019-10-05
% *************************************************************************

function [new_label] = subscript_labels(original_label,header)

    % Create the output label
    new_label = original_label;
    
    % Only replace the string when the content was found
    for i = 1:header.m
       if isempty(strfind(new_label,header.valid{i,1})) == false  
% Control elements
% disp(new_label)
% disp(header.valid{i,1})
% disp(header.valid{i,3})
           new_label = strrep(new_label,header.valid{i,1},header.valid{i,3});
       end
    end

    
end

