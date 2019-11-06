% This function uses the input data structure and plots data in different
% plot (i.e. diamond, ternary, ternary inverted)
% *************************************************************************
% Input variables:
% plotax    : Input / Output axes object
% data      : Structure containing all input data
% control   : Structure containing all line / font elements
% plotsel   : The number of the selected plot
% files_op  : The number of valid files
% opt_check : The checkboxes of the dataset
% *************************************************************************
% M-File: plot_samples.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2019
% Last Change: 2019-10-05
% *************************************************************************
% Revisions: July 2019 - Enable symbol and label columns to plot
%            October 2019 - control.header passed to plot functions
%                         - updated ternary plots for carbonatites*
%                           *requires molar data in ternary axes...
%                           *not optimal in this function, but easy solution
% *************************************************************************

function plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check)
% Get the selected plot type
plottype = control.plots.list(plotsel,2);
% Create modal waitbar
wb = waitbar(0,'Please wait...','Name','Drawing data...','WindowStyle','modal');

% Here the if-elseif-else statement starts to check the type of plot for
% the input from 
if strcmpi(plottype{1,1},'diamond')
    %% Diamond plot
    % Change the size of the plotax
    set(plotax,'Position',[0.30,0.005,0.4,0.99])
    % Change the YLim of the plot
    set(plotax,'YLim',[-0.9 0.9])
    % Plot the background patch
    plotax = plot_diamond(control.setup.lines(1,1),plotsel,control.header,control.scafac,...
                          control.plots.list,control.setup.fonts(1),plotax);
    % Check if a user-supplied diamond is used by the presence of num & txt
    % fields in control.usup structure
    if isfield(control.usup,'num') && isfield(control.usup,'txt')
        xs  = control.usup.txt{2,1};
        ys  = control.usup.txt{2,2};
        ys2 = control.usup.txt{2,3};
        zs  = control.usup.txt{2,4};
    else
        % No user-supplied values --> use normal components
        xs  = control.plots.list{plotsel,3}{1,1};
        ys  = control.plots.list{plotsel,3}{2,1};
        ys2 = control.plots.list{plotsel,3}{3,1};
        zs  = control.plots.list{plotsel,3}{4,1};
    end
    % Calculate the normalized values for diamnond plot and plot them in
    % inverted order, that the last dataset is found at the bottom
    for nr_dataset = files_op:-1:1
        % Check if the checkbox for the dataset is enabled
        if true(opt_check(nr_dataset,1))
            % Get the correct component from input data
            x = data(1,nr_dataset).dat.(xs).Values;
            y = data(1,nr_dataset).dat.(ys).Values;
            y2 = data(1,nr_dataset).dat.(ys2).Values;
            z = data(1,nr_dataset).dat.(zs).Values;
                % Control elements
                % assignin('base','x',x)
                % assignin('base','y',y)
                % assignin('base','z',z)
                % assignin('base','y2',y2)
            % Calculate the normalized values
            [xcalc,ycalc,x2calc,y2calc] = calc_diamond(x,y,z,y2);
            % Get the size of the 
            [m,~] = size(xcalc);
                % Control elements
                % assignin('base','xcalc',xcalc);
                % assignin('base','ycalc',ycalc);
                % assignin('base','x2calc',x2calc);
                % assignin('base','y2calc',y2calc);
            % Enable hold
            hold(plotax,'on')
            % Plot the data in this loop
            for i = 1:1:m
                % Check if columns were supplied in the input and not
                % overwritten by the label option
                if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
                    plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                       'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(i,1).*control.scafac,...
                                       'Marker',markerid(data(1,nr_dataset).symbol.symbol(i,1)),...
                                       'MarkerSize',data(1,nr_dataset).symbol.size(i,1).*control.scafac,...
                                       'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{i,1},...
                                       'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{i,1});
                    plot(x2calc(i),y2calc(i),'Parent',plotax,...
                                       'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(i,1).*control.scafac,...
                                       'Marker',markerid(data(1,nr_dataset).symbol.symbol(i,1)),...
                                       'MarkerSize',data(1,nr_dataset).symbol.size(i,1).*control.scafac,...
                                       'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{i,1},...
                                       'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{i,1});
                else
                    plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                       'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew.*control.scafac,...
                                       'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                                       'MarkerSize',data(1,nr_dataset).symbol.size.*control.scafac,...
                                       'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                                       'MarkerFaceColor',data(1,nr_dataset).symbol.mfc);
                    plot(x2calc(i),y2calc(i),'Parent',plotax,...
                                       'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew.*control.scafac,...
                                       'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                                       'MarkerSize',data(1,nr_dataset).symbol.size.*control.scafac,...
                                       'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                                       'MarkerFaceColor',data(1,nr_dataset).symbol.mfc);
                end
                % Plot also labels if enabled
                if data(1,nr_dataset).label.op.disp == true
                    % Check if columns were supplied in the input and not
                    % overwritten by the label option
                    if data(1,nr_dataset).label.op.op == true && data(1,nr_dataset).label.op.override == false
                        text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                             'FontName',data(1,nr_dataset).label.FontName{i,1},...
                                             'FontSize',data(1,nr_dataset).label.FontSize(i,1).*control.scafac,...
                                             'FontWeight',data(1,nr_dataset).label.FontWeight{i,1},...
                                             'FontAngle',data(1,nr_dataset).label.FontAngle{i,1},...
                                             'Color',data(1,nr_dataset).label.Color{i,1},...
                                             'FontUnits',data(1,nr_dataset).label.FontUnits{i,1},...
                                             'VerticalAlignment',data(1,nr_dataset).label.VertAlign{i,1},...
                                             'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign{i,1});
                        text(x2calc(i),y2calc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                             'FontName',data(1,nr_dataset).label.FontName{i,1},...
                                             'FontSize',data(1,nr_dataset).label.FontSize(i,1).*control.scafac,...
                                             'FontWeight',data(1,nr_dataset).label.FontWeight{i,1},...
                                             'FontAngle',data(1,nr_dataset).label.FontAngle{i,1},...
                                             'Color',data(1,nr_dataset).label.Color{i,1},...
                                             'FontUnits',data(1,nr_dataset).label.FontUnits{i,1},...
                                             'VerticalAlignment',data(1,nr_dataset).label.VertAlign{i,1},...
                                             'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign{i,1});
                    else
                        text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                             'FontName',data(1,nr_dataset).label.FontName,...
                                             'FontSize',data(1,nr_dataset).label.FontSize.*control.scafac,...
                                             'FontWeight',data(1,nr_dataset).label.FontWeight,...
                                             'FontAngle',data(1,nr_dataset).label.FontAngle,...
                                             'Color',data(1,nr_dataset).label.Color,...
                                             'FontUnits',data(1,nr_dataset).label.FontUnits,...
                                             'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                                             'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
                        text(x2calc(i),y2calc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                             'FontName',data(1,nr_dataset).label.FontName,...
                                             'FontSize',data(1,nr_dataset).label.FontSize.*control.scafac,...
                                             'FontWeight',data(1,nr_dataset).label.FontWeight,...
                                             'FontAngle',data(1,nr_dataset).label.FontAngle,...
                                             'Color',data(1,nr_dataset).label.Color,...
                                             'FontUnits',data(1,nr_dataset).label.FontUnits,...
                                             'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                                             'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
                    end
                end
            end
        % End hold
        hold(plotax,'off')
        % Update waitbar
        waitbar((10-nr_dataset)/9,wb);
        end
    end
    
elseif strcmpi(plottype{1,1},'ternary')
    %% Ternary plot
    % Change the size of the plotax
    set(plotax,'Position',[0.14 0.03 0.72 0.94])
    % Change the YLim of the plot
    set(plotax,'YLim',[0.0 0.9])
    % Plot the background patch
    plotax = plot_ternary(control.setup.lines(1,1),plotsel,control.header,control.scafac,...
                          control.plots.list,control.setup.fonts(1),plotax);
    % Check if a user-supplied ternary is used by the presence of num & txt
    % fields in control.usup structure
    if isfield(control.usup,'num') && isfield(control.usup,'txt')
        xs  = control.usup.txt{2,1};
        ys  = control.usup.txt{2,2};
        zs  = control.usup.txt{2,3};
    else
        % No user-supplied values --> use normal components
        xs  = control.plots.list{plotsel,3}{1,1};
        ys  = control.plots.list{plotsel,3}{2,1};
        zs  = control.plots.list{plotsel,3}{3,1};
    end
    
    % Calculate the normalized values for ternary plot and plot them in
    % inverted order, that the last dataset is found at the bottom
    for nr_dataset = files_op:-1:1
        % Check if the checkbox for the dataset is enabled
        if true(opt_check(nr_dataset,1))
            
            if strcmpi(control.plots.list{plotsel,4}{1,1},'molar fraction') && strcmpi(control.plots.list{plotsel,4}{2,1},'molar fraction') && strcmpi(control.plots.list{plotsel,4}{3,1},'molar fraction')
                % THIS IS AT THE MOMENT ONLY THE CASE FOR CARBONATITE CLASSIFICATION
                x = data(1,nr_dataset).mol.FeOtot.Values + data(1,nr_dataset).mol.MnO.Values;
                y = data(1,nr_dataset).mol.CaO.Values;
                z = data(1,nr_dataset).mol.MgO.Values;
            else
                % Get the correct components from data
                % For x-axis
                if isfield(data(1,nr_dataset).dat,xs)
                    x = data(1,nr_dataset).dat.(xs).Values;
                else
                    x = calc_axis(data(1,nr_dataset),control.header.valid(:,1),xs);
                end
                % For y-axis
                if isfield(data(1,nr_dataset).dat,ys)
                    y = data(1,nr_dataset).dat.(ys).Values;
                else
                    y = calc_axis(data(1,nr_dataset),control.header.valid(:,1),ys);
                end
                % For z-axis
                if isfield(data(1,nr_dataset).dat,zs)
                    z = data(1,nr_dataset).dat.(zs).Values;
                else
                    z = calc_axis(data(1,nr_dataset),control.header.valid(:,1),zs);
                end
            end
            % Control elements
            %assignin('base','x',x)
            %assignin('base','y',y)
            %assignin('base','z',z)
                
            % Calculate the normalized values
            [xcalc,ycalc] = calc_ternary(x,y,z);
            
            % Control elements
            %assignin('base','xcalc',xcalc)
            %assignin('base','ycalc',ycalc)
            
            % Get the size of the normalized values
            [m,~] = size(xcalc);
            % Enable hold
            hold(plotax,'on')
                % Plot the data in this loop
                for i = 1:1:m
                    % Check if columns were supplied in the input and not
                    % overwritten by the label option
                    if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
                        plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                           'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(i,1).*control.scafac,...
                                           'Marker',markerid(data(1,nr_dataset).symbol.symbol(i,1)),...
                                           'MarkerSize',data(1,nr_dataset).symbol.size(i,1).*control.scafac,...
                                           'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{i,1},...
                                           'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{i,1});
                    else
                        plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                           'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew.*control.scafac,...
                                           'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                                           'MarkerSize',data(1,nr_dataset).symbol.size.*control.scafac,...
                                           'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                                           'MarkerFaceColor',data(1,nr_dataset).symbol.mfc);
                    end
                    % Plot also labels if enabled
                    if data(1,nr_dataset).label.op.disp == true
                        % Check if columns were supplied in the input and not
                        % overwritten by the label option
                        if data(1,nr_dataset).label.op.op == true && data(1,nr_dataset).label.op.override == false
                            text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                                 'FontName',data(1,nr_dataset).label.FontName{i,1},...
                                                 'FontSize',data(1,nr_dataset).label.FontSize(i,1).*control.scafac,...
                                                 'FontWeight',data(1,nr_dataset).label.FontWeight{i,1},...
                                                 'FontAngle',data(1,nr_dataset).label.FontAngle{i,1},...
                                                 'Color',data(1,nr_dataset).label.Color{i,1},...
                                                 'FontUnits',data(1,nr_dataset).label.FontUnits{i,1},...
                                                 'VerticalAlignment',data(1,nr_dataset).label.VertAlign{i,1},...
                                                 'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign{i,1});
                        else
                            text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                                 'FontName',data(1,nr_dataset).label.FontName,...
                                                 'FontSize',data(1,nr_dataset).label.FontSize.*control.scafac,...
                                                 'FontWeight',data(1,nr_dataset).label.FontWeight,...
                                                 'FontAngle',data(1,nr_dataset).label.FontAngle,...
                                                 'Color',data(1,nr_dataset).label.Color,...
                                                 'FontUnits',data(1,nr_dataset).label.FontUnits,...
                                                 'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                                                 'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
                        end
                    end
                end
            % Disable hold
            hold(plotax,'off')
            % Update waitbar
            waitbar((10-nr_dataset)/9,wb);
        end
    end
    
elseif strcmpi(plottype{1,1},'ternary inverted')
    %% Inverted ternary plot
    % Change the size of the plotax
    set(plotax,'Position',[0.14 0.005 0.72 0.99])
    % Change the YLim of the plot
    set(plotax,'YLim',[-0.9 0.0])
    % Plot the background patch
    plotax = plot_ternary_inv(control.setup.lines(1,1),plotsel,control.header,control.scafac,...
                              control.plots.list,control.setup.fonts(1),plotax);
    % Check if a user-supplied ternary inverted is used by the presence of num & txt
    % fields in control.usup structure
    if isfield(control.usup,'num') && isfield(control.usup,'txt')
        xs  = control.usup.txt{2,1};
        ys  = control.usup.txt{2,2};
        zs  = control.usup.txt{2,3};
    else
        % No user-supplied values --> use normal components
        xs  = control.plots.list{plotsel,3}{1,1};
        ys  = control.plots.list{plotsel,3}{2,1};
        zs  = control.plots.list{plotsel,3}{3,1};
    end
    
    % Calculate the normalized values for inverted ternary plot and plot them in
    % inverted order, that the last dataset is found at the bottom
    for nr_dataset = files_op:-1:1
        % Check if the checkbox for the dataset is enabled
        if true(opt_check(nr_dataset,1))
            % Get the correct component from input data
            x = data(1,nr_dataset).dat.(xs).Values;
            y = data(1,nr_dataset).dat.(ys).Values; 
            z = data(1,nr_dataset).dat.(zs).Values;
                % Control elements
                %assignin('base','x',x)
                %assignin('base','y',y)
                %assignin('base','z',z)
            % Calculate the normalized values
            [xcalc,ycalc] = calc_ternary_inv(x,y,z);
                % Control elements
                %assignin('base','xcalc',xcalc)
                %assignin('base','ycalc',ycalc)
            % Get the size of the normalized values
            [m,~] = size(xcalc);
            % Enable hold
            hold(plotax,'on')
            % Plot the data in this loop
            for i = 1:1:m
                if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
                    plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                       'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(i,1).*control.scafac,...
                                       'Marker',markerid(data(1,nr_dataset).symbol.symbol(i,1)),...
                                       'MarkerSize',data(1,nr_dataset).symbol.size(i,1).*control.scafac,...
                                       'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{i,1},...
                                       'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{i,1});
                else
                    plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                       'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew.*control.scafac,...
                                       'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                                       'MarkerSize',data(1,nr_dataset).symbol.size.*control.scafac,...
                                       'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                                       'MarkerFaceColor',data(1,nr_dataset).symbol.mfc);
                end
                % Plot also labels if enabled
                if data(1,nr_dataset).label.op.disp == true
                    % Check if columns were supplied in the input and not
                    % overwritten by the label option
                    if data(1,nr_dataset).label.op.op == true && data(1,nr_dataset).label.op.override == false
                        text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                             'FontName',data(1,nr_dataset).label.FontName{i,1},...
                                             'FontSize',data(1,nr_dataset).label.FontSize(i,1).*control.scafac,...
                                             'FontWeight',data(1,nr_dataset).label.FontWeight{i,1},...
                                             'FontAngle',data(1,nr_dataset).label.FontAngle{i,1},...
                                             'Color',data(1,nr_dataset).label.Color{i,1},...
                                             'FontUnits',data(1,nr_dataset).label.FontUnits{i,1},...
                                             'VerticalAlignment',data(1,nr_dataset).label.VertAlign{i,1},...
                                             'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign{i,1});
                    else
                        text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                             'FontName',data(1,nr_dataset).label.FontName,...
                                             'FontSize',data(1,nr_dataset).label.FontSize.*control.scafac,...
                                             'FontWeight',data(1,nr_dataset).label.FontWeight,...
                                             'FontAngle',data(1,nr_dataset).label.FontAngle,...
                                             'Color',data(1,nr_dataset).label.Color,...
                                             'FontUnits',data(1,nr_dataset).label.FontUnits,...
                                             'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                                             'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
                    end
                end
            end
        % Disable hold
        hold(plotax,'off')
        % Update waitbar
        waitbar((10-nr_dataset)/9,wb);
        end
    end

elseif sum(strcmpi(plottype{1,1},{'linear','linear invx','linear invy','linear invxy','semilogx','semilogx invx','semilogx invy','semilogx invxy','semilogy','semilogy invx','semilogy invy','semilogy invxy','loglog','loglog invx','loglog invy','loglog invxy'}))
    %% Plot a linear plot
    % Change the size of the plotax
    set(plotax,'Position',[0.16 0.12 0.68 0.86])
    
    % Handle X-Axis limitations
    % Get the min and max values from input string via length and position of whitespace
    len = length(control.plots.list{plotsel,5}{1,1});
    res = strfind(control.plots.list{plotsel,5}{1,1},' ');
    axmin = str2double(control.plots.list{plotsel,5}{1,1}(2:res-1)); 
    axmax = str2double(control.plots.list{plotsel,5}{1,1}(res+1:len-1));
    % Change the XLim of the plot
    set(plotax,'XLim',[axmin axmax])
    
    % Handle Y-Axis limitations
    % Get the min and max values from input string via length and position of whitespace
    len = length(control.plots.list{plotsel,5}{2,1});
    res = strfind(control.plots.list{plotsel,5}{2,1},' ');
    axmin = str2double(control.plots.list{plotsel,5}{2,1}(2:res-1)); 
    axmax = str2double(control.plots.list{plotsel,5}{2,1}(res+1:len-1));
    % Change the YLim of the plot
    set(plotax,'YLim',[axmin axmax])
    
    % Plot the background patch
    plotax = plot_linlog(control.setup.lines(1,1),plotsel,control.header,control.scafac,...
                         control.plots.list,control.setup.fonts(1),plotax);
                      
    % Check if a user-supplied diamond is used by the presence of num & txt
    % fields in control.usup structure
    if isfield(control.usup,'num') && isfield(control.usup,'txt')
        xs  = control.usup.txt{2,1};
        ys  = control.usup.txt{2,2};
    else
        % No user-supplied values --> use normal components
        xs  = control.plots.list{plotsel,3}{1,1};
        ys  = control.plots.list{plotsel,3}{2,1};
    end
    
    % Calculate the normalized values for ternary plot and plot them in
    % inverted order, that the last dataset is found at the bottom
    for nr_dataset = files_op:-1:1
        % Check if the checkbox for the dataset is enabled
        if true(opt_check(nr_dataset,1))
                
            % Use the normalised data for TAS diagrams
            if strcmpi(control.plots.list{plotsel,1}(1:3),'TAS');
                % For x-axis
                xcalc = data(1,nr_dataset).norm.SiO2.Values;
                % For y-axis
                ycalc = data(1,nr_dataset).norm.Na2O.Values + data(1,nr_dataset).norm.K2O.Values;
                
            % Use not normalised data for all others
            else
                % Get the correct components from data
                % For x-axis
                if isfield(data(1,nr_dataset).dat,xs)
                    xcalc = data(1,nr_dataset).dat.(xs).Values;
                else
                    xcalc = calc_axis(data(1,nr_dataset),control.header.valid(:,1),xs);
                end
                % For y-axis
                if isfield(data(1,nr_dataset).dat,ys)
                    ycalc = data(1,nr_dataset).dat.(ys).Values;
                else
                    ycalc = calc_axis(data(1,nr_dataset),control.header.valid(:,1),ys);
                end
            end
                
            % Get the size of the normalized values
            [m,~] = size(xcalc);
            % Enable hold
            hold(plotax,'on')
                % Plot the data in this loop
                for i = 1:1:m
                    % Check if columns were supplied in the input and not
                    % overwritten by the label option
                    if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
                        plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                           'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(i,1).*control.scafac,...
                                           'Marker',markerid(data(1,nr_dataset).symbol.symbol(i,1)),...
                                           'MarkerSize',data(1,nr_dataset).symbol.size(i,1).*control.scafac,...
                                           'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{i,1},...
                                           'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{i,1});
                    else
                        plot(xcalc(i),ycalc(i),'Parent',plotax,...
                                           'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew.*control.scafac,...
                                           'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                                           'MarkerSize',data(1,nr_dataset).symbol.size.*control.scafac,...
                                           'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                                           'MarkerFaceColor',data(1,nr_dataset).symbol.mfc);
                    end
                    % Plot also labels if enabled
                    if data(1,nr_dataset).label.op.disp == true
                        % Check if columns were supplied in the input and not
                        % overwritten by the label option
                        if data(1,nr_dataset).label.op.op == true && data(1,nr_dataset).label.op.override == false
                            text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                                 'FontName',data(1,nr_dataset).label.FontName{i,1},...
                                                 'FontSize',data(1,nr_dataset).label.FontSize(i,1).*control.scafac,...
                                                 'FontWeight',data(1,nr_dataset).label.FontWeight{i,1},...
                                                 'FontAngle',data(1,nr_dataset).label.FontAngle{i,1},...
                                                 'Color',data(1,nr_dataset).label.Color{i,1},...
                                                 'FontUnits',data(1,nr_dataset).label.FontUnits{i,1},...
                                                 'VerticalAlignment',data(1,nr_dataset).label.VertAlign{i,1},...
                                                 'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign{i,1});
                        else
                            text(xcalc(i),ycalc(i),data(1,nr_dataset).dat.Samples{i,1},'Parent',plotax,...
                                                 'FontName',data(1,nr_dataset).label.FontName,...
                                                 'FontSize',data(1,nr_dataset).label.FontSize.*control.scafac,...
                                                 'FontWeight',data(1,nr_dataset).label.FontWeight,...
                                                 'FontAngle',data(1,nr_dataset).label.FontAngle,...
                                                 'Color',data(1,nr_dataset).label.Color,...
                                                 'FontUnits',data(1,nr_dataset).label.FontUnits,...
                                                 'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                                                 'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
                        end
                    end
                end
            % Disable hold
            hold(plotax,'off')
            % Update waitbar
            waitbar((10-nr_dataset)/9,wb);
        end
    end
    
else
    %% Not defined plot
    fprintf('Plot type (%s) is not defined in %s!!!\n\n',plottype{1,1},control.title)
end
% Close the waitbar
close(wb)
end

