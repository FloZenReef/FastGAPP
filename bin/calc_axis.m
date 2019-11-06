function [val_axis] = calc_axis(data,valid_headers,header_axis)
% This function solves a simple formula for an axis with two components.
% The function works the same way for ternary, linear and logarithmic
% plots! - Allowed operators are +, -, *, and /
% However, this function has been updated. It checks now how many operators
% are in within the headers - If only one the still the way applied as
% before (see above), if more than one then the formula is solved manually
% *************************************************************************
% Overwrite the input to test around
% header_axis = 'Ls + Lm'
% header_axis = 'Lm + Ls'
% header_axis = 'Lvm + Lvs'
% header_axis = 'Lm + Lvs'
% header_axis = 'Lvm + Ls'
% header_axis = '10 * Lm'
% header_axis = 'Ls / 100'
%
% *************************************************************************
% M-File: plot_samples.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2019
% Last Change: 2019-10-07
% Called by: plot_samples.m
% *************************************************************************
% Revisions: July 2019 - Enable symbol and label columns to plot
%            October 2019 - control.header passed to plot functions
%                         - if-statement insertend to calculate axis with
%                           more than 2 component or components not
%                           calculated so far
% *************************************************************************

% Control elements
% disp(header_axis)


if strcmpi(header_axis,'Zr / TiO2')
    % Solve Zr / TiO2 for Winchester & Floyd (1977) - requires TiO2 * 10000
    val_axis = data.dat.Zr.Values ./ ( data.dat.TiO2.Values .* 10000);

elseif strcmpi(header_axis,'10000 * Ga / Al')
    % Solve 10000 * Ga / Al for Whalen et al. (1987)
     val_axis = data.dat.Ga.Values ./ Al2O3_to_Al(data.dat.Al2O3.Values);
%     disp(val_axis)
elseif strcmpi(header_axis,'( Na2O + K2O ) / CaO')
    % Solve ( Na2O + K2O ) / CaO for Whalen et al. (1987)
    val_axis = ( data.dat.Na2O.Values + data.dat.K2O.Values ) ./ data.dat.CaO.Values;
    
elseif strcmpi(header_axis,'Zr + Nb + Ce + Y')
    % Solve Zr + Nb + Ce + Y for Whalen et al. (1987)
    val_axis = data.dat.Zr.Values + data.dat.Nb.Values + data.dat.Ce.Values + data.dat.Y.Values;
     
elseif strcmpi(header_axis,'Eu / Eu*')
    % Solve Eu / Eu* for Eby (1992)
    val_axis = data.dat.Eu.Values ./ sqrt( data.dat.Sm.Values .* data.dat.Gd.Values );

elseif strcmpi(header_axis,'Ti')
    % Solve Ti for Pearce and Cann (1973)
    val_axis = TiO2_to_Ti(data.dat.TiO2.Values) .* 10000;
    
elseif strcmpi(header_axis,'Ti / 100')
    % Solve Ti for Pearce and Cann (1973)
    val_axis = TiO2_to_Ti(data.dat.TiO2.Values) .* 10000 ./ 100;
    
elseif strcmpi(header_axis,'CaO / ( Na2O + K2O )')
    % Solve CaO / ( Na2O + K2O ) for Brown (1982)
    val_axis =  data.dat.CaO.Values ./ ( data.dat.Na2O.Values + data.dat.K2O.Values );
    
elseif strcmpi(header_axis,'( 17.9 * Ta ) / La')
    % Solve ( 17.9 * Ta ) / La for Hollocher et al. (2012)
    val_axis =  (17.9 * data.dat.Ta.Values ) ./ data.dat.La.Values;
    
elseif strcmpi(header_axis,'( ( Nb + 17.9 * Ta )  / 2 ) / La')
    % Solve ( ( Nb + 17.9 * Ta )  / 2 ) / La for Hollocher et al. (2012)
    val_axis =  ( ( data.dat.Nb.Values + 17.9 * data.dat.Ta.Values ) ./ 2 ) ./ data.dat.La.Values;
    
elseif strcmpi(header_axis,'FeOtot / ( MgO + FeOtot )')
    % Solve CaO / ( Na2O + K2O ) for Brown (1982)
    val_axis =  data.dat.FeOtot.Values ./ ( data.dat.MgO.Values + data.dat.FeOtot.Values );
    
% All other simple formulas with only 2 components
else
    % First step: Determine header length and find the position of the operator and 
    % find out which one is in input axis header.
    % Determine the header length
    header_len = length(header_axis);
    % Check for the operators in loop
    op_str = {'+';'-';'*';'/'};
    for i = 1:size(op_str)
        if isempty(strfind(header_axis,op_str{i})) == 0
            op_pos = strfind(header_axis,op_str{i});
            op_det = op_str{i};
        end
    end

    % 2nd step: Get the headers and check if they exist, else they are numeric
    % and then immediately converted to double precision
    % First axis header
    if sum(strcmpi(header_axis(1:op_pos-2),valid_headers)) == 1
        header1 = header_axis(1:op_pos-2);
    else
        header1 = str2double(header_axis(1:op_pos-2));
    end
    % Second axis header
    if sum(strcmpi(header_axis(op_pos+2:header_len),valid_headers)) == 1
        header2 = header_axis(op_pos+2:header_len);
    else
        header2 = str2double(header_axis(op_pos+2:header_len));
    end

    % Third step: Calculate the axis with this simple switch, which is more or
    % less self-explained
    switch op_det
        case '+'
            if isnumeric(header1)
                val_axis = header1 + data.dat.(header2).Values;
            elseif isnumeric(header2)
                val_axis = data.dat.(header1).Values + header2;
            else
                val_axis = data.dat.(header1).Values + data.dat.(header2).Values;
            end
        case '-'
            if isnumeric(header1)
                val_axis = header1 - data.dat.(header2).Values;
            elseif isnumeric(header2)
                val_axis = data.dat.(header1).Values - header2;
            else
                val_axis = data.dat.(header1).Values - data.dat.(header2).Values;
            end
        case '*'
            if isnumeric(header1)
                val_axis = header1 .* data.dat.(header2).Values;
            elseif isnumeric(header2)
                val_axis = data.dat.(header1).Values .* header2;
            else
                val_axis = data.dat.(header1).Values .* data.dat.(header2).Values;
            end
        case '/'
            if isnumeric(header1)
                val_axis = header1 ./ data.dat.(header2).Values;
            elseif isnumeric(header2)
                val_axis = data.dat.(header1).Values ./ header2;
            else
                val_axis = data.dat.(header1).Values ./ data.dat.(header2).Values;
            end
    end
end

end