% This function calculates the ternary plots (e.g. QAP diagrams). It
% requires 3 input values (x,y, and z) anyway. The size of the input array 
% should be the same, what is case for FastGAPPs input!
% *************************************************************************
% M-File: calc_triangle.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2017
% *************************************************************************

function [xnorm,ynorm] = calc_ternary(x,y,z)
    % Get the size of the x-value array 
    % (it is assumed that the other have the same size)
    [m,n] = size(x);
    % Preallocate zeros for output arrays
    ynorm = zeros(m,n); 
    xnorm = zeros(m,n);
    % Calculate the normalized output values in loop
    for i = 1:m
        % Calculate normalized values for triangle
        ynorm(i)     = (y(i)./(x(i)+y(i)+z(i)))*sin((60.*(pi()/180)));
        xnorm(i)     = (x(i)./(x(i)+y(i)+z(i)))+ynorm(i)*cot((60.*(pi()/180)));
    end
end