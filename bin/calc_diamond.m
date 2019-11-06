% This function calculates the diamond plots (e.g. QAPF diagrams). It
% requires 4 input values (x,y, y2, and z) anyway. If a y-value is given,
% then the y2-value requires to be NaN, else the sample / data point is
% calculated two times. The size of the input array should be the same,
% what is case for FastGAPPs input
% *************************************************************************
% M-File: calc_diamond.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2017
% *************************************************************************

function [xnorm,ynorm,x2norm,y2norm] = calc_diamond(x,y,z,y2)
    % Get the size of the x-value array 
    % (it is assumed that the other have the same size)
    [m,n] = size(x);
    % Preallocate zeros for output arrays
    ynorm = zeros(m,n);
    xnorm = zeros(m,n);
    y2norm = zeros(m,n); 
    x2norm = zeros(m,n);
    % Calculate the normalized output values in loop
    for i = 1:m
        % Calculate normalized values for upper triangle
        ynorm(i) = (y(i)./(x(i)+y(i)+z(i)))*sin((60.*(pi()/180)));
        xnorm(i) = (x(i)./(x(i)+y(i)+z(i)))+ynorm(i)*cot((60.*(pi()/180)));
        % Calculate normalized values for lower triangle
        y2norm(i) = -(y2(i)./(x(i)+y2(i)+z(i)))*sin((60.*(pi()/180)));
        x2norm(i) = (x(i)./(x(i)+y2(i)+z(i)))+-y2norm(i)*cot((60.*(pi()/180)));
    end
end