% Plot an inverted ternary patch and axis labels
% Called by: plot_samples.m
% *************************************************************************
% M-File: plot_ternary_inv.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2019
% Last Change: 2019-10-05
% *************************************************************************

function [pax] = plot_ternary_inv(linesetup,plotsel,header,scafac,labels,fonts,pax)
% Define the frame line
line = 1;
% Enable overlay plotting
hold(pax,'on')
% Create a white background patch
patch('XData',[0 0.5 1],'YData',[0 -sin(1/3*pi) 0],...
      'Parent',pax,'FaceColor',[1,1,1],'Visible','on')
% Plot the frame line
plot([0 0.5 1 0],[0 -sin(1/3*pi) 0 0],'Parent',pax,...
     'LineWidth',linesetup(1,line).LineWidth.*scafac,...
     'LineStyle',linesetup(1,line).LineStyle,...    
     'Color',linesetup(1,line).Color);
% Plot the labels
text(1.01,0,subscript_labels(labels{plotsel,3}{1,1},header),...
                             'Parent',pax,...
                             'HorizontalAlignment','left',...
                             'Color',fonts.Color,...
                             'FontName',fonts.FontName,...
                             'FontAngle',fonts.FontAngle,...
                             'FontSize',fonts.FontSize.*scafac,...
                             'FontUnits',fonts.FontUnits,...
                             'FontWeight',fonts.FontWeight);
text(0.50,-0.88,subscript_labels(labels{plotsel,3}{2,1},header),...
                             'Parent',pax,...
                             'HorizontalAlignment','center',...
                             'Color',fonts.Color,...
                             'FontName',fonts.FontName,...
                             'FontAngle',fonts.FontAngle,...
                             'FontSize',fonts.FontSize.*scafac,...
                             'FontUnits',fonts.FontUnits,...
                             'FontWeight',fonts.FontWeight);
text(-0.01,0,subscript_labels(labels{plotsel,3}{3,1},header),...
                             'Parent',pax,...
                             'HorizontalAlignment','right',...
                             'Color',fonts.Color,...
                             'FontName',fonts.FontName,...
                             'FontAngle',fonts.FontAngle,...
                             'FontSize',fonts.FontSize.*scafac,...
                             'FontUnits',fonts.FontUnits,...
                             'FontWeight',fonts.FontWeight);
% Disable overlay plotting
hold(pax,'off')
% Adjust the axes
axis(pax,[0 1 -0.9 0.01]); 
% Set the axes invisible
set(pax,'Visible','Off');

end