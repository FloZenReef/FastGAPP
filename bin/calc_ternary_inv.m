% This function calculates the inverted ternary plots (e.g. APF diagrams).
% It requires 3 input values (x,y, and z) anyway. The size of the input 
% array should be the same, what is case for FastGAPPs input!
% *************************************************************************
% M-File: calc_triangle_inv.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2017
% *************************************************************************

function [x2norm,y2norm] = calc_ternary_inv(x,y2,z)
    % Get the size of the x-value array (it is assumed that the other have 
    % the same size)
    [m,n] = size(x);
    % Preallocate zeros for output arrays
    y2norm = zeros(m,n);
    x2norm = zeros(m,n);
    % Calculate the normalized output values in loop
    for i = 1:m
        % Calculate normalized values for inverted triangle
        y2norm(i)     = -(y2(i)./(x(i)+y2(i)+z(i)))*sin((60.*(pi()/180)));
        x2norm(i)     = (x(i)./(x(i)+y2(i)+z(i)))+-y2norm(i)*cot((60.*(pi()/180)));
    end
end