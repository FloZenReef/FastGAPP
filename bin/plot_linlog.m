% Plot a linear, semilog, or loglog plot with adjusted axis properties
% Called by: plot_samples.m
% *************************************************************************
% M-File: plot_linlog.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2019
% Last Change: 2019-10-05
% *************************************************************************

function [pax] = plot_linlog(linesetup,plotsel,header,scafac,labels,fonts,pax)
%% General stuff
% Define the frame line
line = 1;
% Show the box
set(pax,'Box','on')

%% Change the plots axis ticks and directions
switch labels{plotsel,2}
    case 'linear'
        % Set the scale of the axes
        set(pax,'xscale','linear','yscale','linear')
        
    case 'linear invx'
        % Set the scale of the axes
        set(pax,'xscale','linear','xdir','reverse','yscale','linear')
        
    case 'linear invy'
        % Set the scale of the axes
        set(pax,'xscale','linear','ydir','reverse','yscale','linear')
        
    case 'linear invxy'
        % Set the scale of the axes
        set(pax,'xdir','reverse','xscale','linear','ydir','reverse','yscale','linear')
        
    case 'semilogx'
        % Set the scale of the axes
        set(pax,'xscale','log','yscale','linear')
        new_xticklab = get(pax,'XTick');
        set(pax,'XTickLabel',new_xticklab)
        
    case 'semilogx invx'
        % Set the scale of the axes
        set(pax,'xscale','log','xdir','reverse','yscale','linear')
        new_xticklab = get(pax,'XTick');
        set(pax,'XTickLabel',new_xticklab)
        
    case 'semilogx invy'
        % Set the scale of the axes
        set(pax,'xscale','log','ydir','reverse','yscale','linear')
        new_xticklab = get(pax,'XTick');
        set(pax,'XTickLabel',new_xticklab)
        
    case 'semilogx invxy'
        % Set the scale of the axes
        set(pax,'xdir','reverse','xscale','log','ydir','reverse','yscale','linear')
        new_xticklab = get(pax,'XTick');
        set(pax,'XTickLabel',new_xticklab)
        
    case 'semilogy'
        % Set the scale of the axes
        set(pax,'xscale','linear','yscale','log')
        new_yticklab = get(pax,'YTick');
        set(pax,'YTickLabel',new_yticklab)
        
    case 'semilogy invx'
        % Set the scale of the axes
        set(pax,'xscale','linear','xdir','reverse','yscale','log')
        new_yticklab = get(pax,'YTick');
        set(pax,'YTickLabel',new_yticklab)
        
    case 'semilogy invy'
        % Set the scale of the axes
        set(pax,'xscale','linear','ydir','reverse','yscale','log')
        new_yticklab = get(pax,'YTick');
        set(pax,'YTickLabel',new_yticklab)
        
    case 'semilogy invxy'
        % Set the scale of the axes
        set(pax,'xdir','reverse','xscale','linear','ydir','reverse','yscale','log')
        new_yticklab = get(pax,'YTick');
        set(pax,'YTickLabel',new_yticklab)
        
    case 'loglog'
        % Set the scale of the axes
        set(pax,'xscale','log','yscale','log')
        new_xticklab = get(pax,'XTick'); new_yticklab = get(pax,'YTick');
        set(pax,'XTickLabel',new_xticklab,'YTickLabel',new_yticklab)
        
    case 'loglog invx'
        % Set the scale of the axes
        set(pax,'xscale','log','xdir','reverse','yscale','log')
        new_xticklab = get(pax,'XTick'); new_yticklab = get(pax,'YTick');
        set(pax,'XTickLabel',new_xticklab,'YTickLabel',new_yticklab)
        
    case 'loglog invy'
        % Set the scale of the axes
        set(pax,'xscale','log','ydir','reverse','yscale','log')
        new_xticklab = get(pax,'XTick'); new_yticklab = get(pax,'YTick');
        set(pax,'XTickLabel',new_xticklab,'YTickLabel',new_yticklab)
        
    case 'loglog invxy'
        % Set the scale of the axes
        set(pax,'xdir','reverse','xscale','log','ydir','reverse','yscale','log')
        new_xticklab = get(pax,'XTick'); new_yticklab = get(pax,'YTick');
        set(pax,'XTickLabel',new_xticklab,'YTickLabel',new_yticklab)
        
end

%% X-Axis label
% Concatenate a string for the x-axis
if strcmpi(labels{plotsel,4}{1,1},'ratio') == 1 || strcmpi(labels{plotsel,4}{1,1},'fraction') == 1
    xlab = subscript_labels(labels{plotsel,3}{1,1},header);
else
    xlab = subscript_labels(labels{plotsel,3}{1,1},header);
    xlab = sprintf('%s [%s]',xlab,labels{plotsel,4}{1,1});
end
% Set the x-axis label
xlab = xlabel(pax,xlab,'Color',fonts.Color,...
                       'FontName',fonts.FontName,...
                       'FontAngle',fonts.FontAngle,...
                       'FontSize',fonts.FontSize.*scafac,...
                       'FontUnits',fonts.FontUnits,...
                       'FontWeight',fonts.FontWeight); %#ok<NASGU>

%% Y-Axis labels
% Concatenate a string for the y-axis
if strcmpi(labels{plotsel,4}{2,1},'ratio') == 1 || strcmpi(labels{plotsel,4}{2,1},'fraction') == 1
    ylab = subscript_labels(labels{plotsel,3}{2,1},header);
else
    ylab = subscript_labels(labels{plotsel,3}{2,1},header);
    ylab = sprintf('%s [%s]',ylab,labels{plotsel,4}{2,1});
end           
% Set the y-axis label
ylab = ylabel(pax,ylab,'Color',fonts.Color,...
                       'FontName',fonts.FontName,...
                       'FontAngle',fonts.FontAngle,...
                       'FontSize',fonts.FontSize.*scafac,...
                       'FontUnits',fonts.FontUnits,...
                       'FontWeight',fonts.FontWeight); %#ok<NASGU>

%% Adjust the fonts of the tick labels
% NOTE!!!: The font size is coupled to the label font of axis label (font =
% 1), but scaled to 80%

set(pax,'FontName',fonts.FontName,...
        'FontAngle',fonts.FontAngle,...
        'FontSize',fonts.FontSize.*0.80.*scafac,...
        'FontUnits',fonts.FontUnits,...
        'FontWeight',fonts.FontWeight);
                   
%% Draw a patch for the background and outer line
% X-Axis values
len = length(labels{plotsel,5}{1,1});
res = strfind(labels{plotsel,5}{1,1},' ');
xaxmin = str2double(labels{plotsel,5}{1,1}(2:res-1)); 
xaxmax = str2double(labels{plotsel,5}{1,1}(res+1:len-1));
% Y-Axis values
len = length(labels{plotsel,5}{2,1});
res = strfind(labels{plotsel,5}{2,1},' ');
yaxmin = str2double(labels{plotsel,5}{2,1}(2:res-1)); 
yaxmax = str2double(labels{plotsel,5}{2,1}(res+1:len-1));
% Enable overlay plotting
hold(pax,'on')

% Plot the frame line
plot([xaxmin xaxmax xaxmax xaxmin xaxmin],...
     [yaxmin yaxmin yaxmax yaxmax yaxmin],...
     'Parent',pax,...
     'LineWidth',linesetup(1,line).LineWidth.*scafac,...
     'LineStyle',linesetup(1,line).LineStyle,...    
     'Color',linesetup(1,line).Color);

% Disable overlay plotting
hold(pax,'off')

% Set the axes invisible
set(pax,'Visible','Off');

end