function PScreator
% This function creates for the selected master input files the plot's
% label and line switch and the control function

% Update / Revision July 2019
% Included all information from the program specific master files. These
% will be required at least in FastGAPP. The sort order of will be the same
% in the control.plots.list cell array.
% control.plots.list columns:
% 01: Name (--> what will be in popup #2 - name of diagram)
% 02: Plot Type (linear, loglog)
% 03: Components (as cell array = Headers)
% 04: Component Units (units as cell array)
% 05: Axis limits (as cell array)
% 06: Diagram Type (--> popup #1 describes what the plot does, e.g. rock classification)
% 07: Line Type (net, division line, fields)
% 08: Rock Type (all, basaltic, granitic...)
% 09: Lithology (volcanic, plutonic, igneous)
% 10: Setting (all, subduction)
% 11: Title Name + Citation (--> what will be in popup #2 - name of diagram + citation)

%% 00 Create the GUI and give ouput to command window
fprintf('Launching PlotScriptCreator v1.0... - Time: %s\n',datestr(clock));
% Create and then hide the GUI during the construction process
psc_ini = figure('Visible','Off');
% Deactivate figure number
set(psc_ini,'NumberTitle','Off')
% Setup the pointer and renderer
set(psc_ini,'Pointer','Arrow','Renderer','Zbuffer')
% Set units of the figure to pixel and hide menu bar.
set(psc_ini,'Units','Pixel','MenuBar','None');
% Set size and position (absolute pixel) of the figure and set name of the GUI
set(psc_ini,'Position',[75,75,1280,720],'Resize','Off','Name','PlotScriptCreator v1.0');
% Change the background color of the GUI to black
set(psc_ini,'Color',[.8,.8,.8]);
% Create header line with text
uicontrol('Style','text',...
          'String','PSC - PlotScriptCreator v1.0',...
          'ForegroundColor',[1,1,1],'BackgroundColor',[0,0,0],...
          'FontSize',25,'FontWeight','Bold','FontName','Arial','HorizontalAlignment','Left',...
          'Units','Normalized','Position',[.0,.94,1.,0.055]);
% Create white header line
uicontrol('Style','text','String','',...
          'ForegroundColor',[.0,.0,.0],'BackgroundColor',[1,1,1],...
          'Units','Normalized','Position',[.0,.93,1.,.01]);
% Create black header line
uicontrol('Style','text','String','',...
          'ForegroundColor',[1,1,1],'BackgroundColor',[.0,.0,.0],...
          'Units','Normalized','Position',[.0,.92,1.,.01]);
      
%% 00 Allocate structures
% Allocate structure for
inp = struct;
% Get the defaults for plot lines and labels
control = struct(); control = defaults_misc(control);

%% 01 Panel for options
optpanel = uipanel('Title','Options',...
                    'Units','Normalized','Position',[.01 .01 .16 .90],...
                    'FontSize',14,'FontWeight','Bold',...
                    'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                    'Visible','On');
optpanel_u = cell(2,1);

%% 01a Create buttons in options panel
% Load dataset button
optpanel_u{1,1} = uicontrol('Style','Pushbutton','String',sprintf('Load dataset'),...
                            'Units','Normalized','Position',[.2 .92 .60 .06],...
                            'Parent',optpanel,'Visible','On',...
                            'Callback',@load_callback);
% Write to MATLAB file button
optpanel_u{2,1} = uicontrol('Style','Pushbutton','String',sprintf('Create M-File'),...
                            'Units','Normalized','Position',[.2 .48 .60 .06],...
                            'Parent',optpanel,'Visible','Off',...
                            'Callback',@write_callback);
% Additional properties for buttons
set([optpanel_u{1,1} optpanel_u{2,1}],'FontSize',12,'FontWeight','Bold','BackGroundColor',[1.,1.,1.]);

%% 02 Panels for input data preview
% Panel for dataset selection
dataselpanel = uipanel('Title','Dataset selection',...
                       'Parent',optpanel,...
                       'Units','Normalized','Position',[.02 .59 .96 .30],...
                       'FontSize',14,'FontWeight','Bold',...
                       'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                       'Visible','Off');
% Allocate cell array for panel's childs        
dataselpanel_u = cell(2,1);
dataselpanel_u_txt = {''};

% Panel for data preview
prevpanel = uipanel('Title','Table Preview',...
                    'Units','Normalized','Position',[.18 .01 .81 .90],...
                    'FontSize',14,'FontWeight','Bold',...
                    'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                    'Visible','Off');
% Allocate cell array for panel's childs
prevpanel_u = cell(3,1);

%% 02a Create elements in preview panel
% Create popup for current file selection
dataselpanel_u{1,1} = uicontrol('Style','popup','String',dataselpanel_u_txt,...
                                'Units','Normalized','Position',[.10 .55 .80 .30],...
                                'Parent',dataselpanel,'Visible','On',...
                                'Callback',@datasel_callback);
% Create preview button
dataselpanel_u{2,1} = uicontrol('Style','radio','String',sprintf('Table Mode'),...
                                'Units','Normalized','Position',[.10 .33 .80 .20],...
                                'Parent',dataselpanel,'Visible','On','Value',1,...
                                'Callback',@preview_callback);
% Create tables button
dataselpanel_u{3,1} = uicontrol('Style','radio','String',sprintf('Preview Mode'),...
                                'Units','Normalized','Position',[.10 .08 .80 .20],...
                                'Parent',dataselpanel,'Visible','On','Value',0,...
                                'Callback',@preview_callback);
% Additional property setup for button and popup
set([dataselpanel_u{3,1} dataselpanel_u{2,1}],'FontSize',10,'FontWeight','Bold','BackGroundColor',[0.8,0.8,0.8]);
set(dataselpanel_u{1,1},'FontSize',10,'FontWeight','Bold','BackGroundColor',[1.0,1.0,1.0])

%% 02b Allocate table elements for line and label datasets
% General plot information
prevpanel_u{1,1} = uitable('Parent',prevpanel,'Visible','On',...
                           'Data',{},'Units','Normalized','Position',[0.01,0.81,0.98,0.18],...
                           'ColumnWidth',{180 280 180 80 80 80 80},'ColumnFormat',{'char'},'ColumnName',{});
% Line dataset
prevpanel_u{2,1} = uitable('Parent',prevpanel,'Visible','On',...
                           'Data',{},'Units','Normalized','Position',[0.01,0.01,0.24,0.78],...
                           'ColumnWidth',{30 80 80},...
                           'ColumnFormat',{'char'},...
                           'ColumnName',{'Type';'X-Values';'Y-Values'});
% Label dataset
prevpanel_u{3,1} = uitable('Parent',prevpanel,'Visible','On',...
                           'Data',{},'Units','Normalized','Position',[0.27,0.01,0.72,0.78],...
                           'ColumnWidth',{30 80 80 450 60},...
                           'ColumnFormat',{'char'},...
                           'ColumnName',{'Type';'X-Values';'Y-Values';'Label';'Rotation'});
% Additional property setup for button and popup
set([prevpanel_u{1,1} prevpanel_u{2,1} prevpanel_u{3,1}],'FontSize',9,'FontWeight','Bold')

%% 03 Panel for plot preview panel
% Panel for plot preview
prevplotpanel = uipanel('Title','Plot Preview',...
                    'Units','Normalized','Position',[.18 .01 .81 .90],...
                    'FontSize',14,'FontWeight','Bold',...
                    'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                    'Visible','Off');
                
%% 03a Create axes element in plot preview panel

% Create axes object with some properties and do not show the axes
prevplotpanel_ax = axes('Parent',prevplotpanel); axis off;

%% Callbacks

%% 01 Callbacks for loading datasets
function load_callback(~,~)
    % Select files and divide it into names, extension, fullfile ...
    [inp.file,inp.filepath] = uigetfile({'*.xls; *.xlsx',...
                                         'Excel Spreadsheets (*.xls, *.xlsx)'},...
                                         'Select master plot file!','MultiSelect','Off',...
                                         [pwd '/development/programs/']);
    % Check the input
    if isequal(inp.file,0)
        % If no file is selected make output to command window
        fprintf('No file selected!\n - Time: %s\n',datestr(clock))
        % Abort callback
        return
    else
        % Read the general information from master spreadsheet
        [~,~,inp.general] = xlsread(fullfile(inp.filepath,inp.file),'general');
        % Get the title and directory from master spreadsheet
        inp.programtitle = sprintf('%s v%1.0f.%1.0f',inp.general{1,2},inp.general{2,2},inp.general{3,2});
        inp.programname = inp.general{1,2};
        inp.programdir = inp.general{4,2};
        % Read the header information from master spreadsheet
        % Read the general information from master spreadsheet
        [~,~,inp.headers] = xlsread(fullfile(inp.filepath,inp.file),'headers');
        % Read the list of plots from selected master spreadsheet
        [~,~,inp.plots] = xlsread(fullfile(inp.filepath,inp.file),'plots');
        % Cut the input cell array, clear header line
        [m_in,n] = size(inp.plots); inp.plots = inp.plots(2:m_in,1:n); m_in = m_in-1;  
        % Give some out put to command window
        fprintf('%3.0f plot files listed in master file! \n',m_in);
        fprintf('Trying to find and read the plot files! \n');
        % Get the list of excel spreadsheets in loop
        % Preallocate cell array
        fullfilepath = cell(m_in,1);
        % Write the full input filenames in loop
        m_out = 0; m_err = 0;
        for i = 1:m_in
            fullfilepath{i,1} = fullfile(inp.filepath,inp.programdir,inp.plots{i,4});
            % Check if the excel sheet in master exists
            if exist(fullfilepath{i,1},'file') == 2
                % Increase correct files
                m_out = m_out + 1;
                % Output if file exists
                fprintf('%s does exist!\n',only_filename(fullfilepath{i,1}))
                % Read the plot files
                % Read the different tabs from spreadsheet
                fprintf('Reading %s of %s...\n',num2str(i),num2str(m_in));
                fprintf('%s\n',only_filename(fullfilepath{i,1}));
                % Read general information into cell array
                fprintf('...general...\n');
                [~,~,inp.dataset(i).general] = xlsread(fullfilepath{i,1},'general');
                % Read lines into double
                fprintf('...lines...\n');
                [~,~,inp.dataset(i).lines] = xlsread(fullfilepath{i,1},'lines');
                % Get the size of input array
                fprintf('...clearing NANs...\n');
                [m,~] = size(inp.dataset(i).lines);
                    % Kick out NaN values and replace with empty test values
                    for j = 1:m
                        if isnan(inp.dataset(i).lines{j,1})
                            inp.dataset(i).lines{j,1} = '';
                        end
                    end
                % Read labels into cell array
                fprintf('...labels...\n');
                [~,~,inp.dataset(i).labels] = xlsread(fullfilepath{i,1},'labels');
                fprintf('...finished!\n\n');
                
            else
                % Increase errorneous datasets
                m_err = m_err + 1;
                % Output of file NOT exists
                fprintf('%s does NOT exist!\n',fullfilepath{i,1})
            end
        end
    end
    
    % Summary of the reading process on command window
    fprintf('%s input summary:\n',inp.programtitle)
    fprintf('%3.0f plot files found in master file!\n',m_in);
    fprintf('%3.0f files are found and read!\n',m_out);
    fprintf('%3.0f errors!\n\n',m_err);
    
    % Charge the popup with filenames
    dataselpanel_u_txt = inp.plots(:,4);
    set(dataselpanel_u{1,1},'String',dataselpanel_u_txt,'Value',1)
    
    % Update the uitables with data
    % New values for general overview
    set(prevpanel_u{1,1},'ColumnName',inp.dataset(1).general(:,1)')
    set(prevpanel_u{1,1},'Data',inp.dataset(1).general(:,2)');
    % New values for line overview
    set(prevpanel_u{2,1},'ColumnName',{'Type';'X-Values';'Y-Values'});
    set(prevpanel_u{2,1},'Data',inp.dataset(1).lines);
    % New values for label overview
    set(prevpanel_u{3,1},'ColumnName',{'Type';'X-Values';'Y-Values';'Label';'Rotation'});
    set(prevpanel_u{3,1},'Data',inp.dataset(1).labels);
    
    % Make panels, subpanel and buttons visible
    % Change the selected radio button (table mode)
    set(dataselpanel_u{2,1},'Value',1)
    set(dataselpanel_u{3,1},'Value',0)
    % Make panels visible/invisible
    set(prevpanel,'Visible','On')
    set(prevplotpanel,'Visible','Off')
    % Panel for dataset selection
    set(dataselpanel,'Visible','On')
    % Make button visible
    set(optpanel_u{2,1},'Visible','On')
    % Update the plot
    prevplotpanel_ax = PSC_preview(inp.plots(get(dataselpanel_u{1,1},'Value'),:),...
                                   inp.dataset(get(dataselpanel_u{1,1},'Value')).general,...
                                   inp.dataset(get(dataselpanel_u{1,1},'Value')).lines,...
                                   inp.dataset(get(dataselpanel_u{1,1},'Value')).labels,...
                                   control,...
                                   prevplotpanel_ax);
                               
    % Summary in helpdialog
    str_a = sprintf('%s input summary:\n',inp.programtitle);
    str_b = sprintf('%3.0f plot files found in master file!\n',m_in);
    str_c = sprintf('%3.0f files are found and read!\n',m_out);
    str_d = sprintf('%3.0f errors!',m_err);
    helpdlg([str_a str_b str_c str_d],'Input summary');
    
    % Control elements
    % assignin('base','inp',inp)
end

%% 02 Callbacks for dataset selection

function datasel_callback(~,~)
    % Update the tables
    % New values for general overview
    set(prevpanel_u{1,1},'ColumnName',inp.dataset(get(dataselpanel_u{1,1},'Value')).general(:,1)')
    set(prevpanel_u{1,1},'Data',inp.dataset(get(dataselpanel_u{1,1},'Value')).general(:,2)');
    % New values for line overview
    set(prevpanel_u{2,1},'ColumnName',{'Type';'X-Values';'Y-Values'});
    set(prevpanel_u{2,1},'Data',inp.dataset(get(dataselpanel_u{1,1},'Value')).lines);
    % New values for label overview
    set(prevpanel_u{3,1},'ColumnName',{'Type';'X-Values';'Y-Values';'Label';'Rotation'});
    set(prevpanel_u{3,1},'Data',inp.dataset(get(dataselpanel_u{1,1},'Value')).labels);

    % Update the plot
    prevplotpanel_ax = PSC_preview(inp.plots(get(dataselpanel_u{1,1},'Value'),:),...
                                   inp.dataset(get(dataselpanel_u{1,1},'Value')).general,...
                                   inp.dataset(get(dataselpanel_u{1,1},'Value')).lines,...
                                   inp.dataset(get(dataselpanel_u{1,1},'Value')).labels,...
                                   control,...
                                   prevplotpanel_ax); % axis off;

end

function preview_callback(obj,~)
    % Get the string from 
    objstr = get(obj,'String');
    switch objstr
        case get(dataselpanel_u{2,1},'String')
            % Change the selected radio button (table mode)
            set(dataselpanel_u{2,1},'Value',1)
            set(dataselpanel_u{3,1},'Value',0)
            % Make panels visible/invisible
            set(prevpanel,'Visible','On')
            set(prevplotpanel,'Visible','Off')

        case get(dataselpanel_u{3,1},'String')
            % Change the selected radio button (plot mode)
            set(dataselpanel_u{2,1},'Value',0)
            set(dataselpanel_u{3,1},'Value',1)
            % Make panels visible/invisible
            set(prevpanel,'Visible','Off')
            set(prevplotpanel,'Visible','On')

    end
end

%% 03 Write function callback

function write_callback(~,~)
%% 03 control elements
% assignin('base','inp',inp)

%% 03a Write line switch function

    % Open plot switch funtion
    fid = fopen(['db/' inp.programdir '/' inp.programdir '_lineswitch.m'],'w');

    % Status command window output
    fprintf('Writing line switch... - Time: %s\n',datestr(clock));
    % Write begin of the function
    fprintf(fid,'function [plotax] = %s\n',[inp.programdir '_lineswitch(control,plotax,plotsel)']);
    % Write statement to get string of the plot array
    fprintf(fid,'\n');
    fprintf(fid,'%% Get the selected plot type\n');
    fprintf(fid,'plotsel = control.plots.list(plotsel,1);\n');
    fprintf(fid,'%% Enable overlay plotting\n');
    fprintf(fid,'hold(plotax,''on'')\n\n');
    % Get the number of files used by the following loops
    [m_in,~] = size(inp.plots);
    % Start writing plotswitch in this loop
    for i = 1:m_in
        
        % Write if-elseif-else statement into the plotswitch
        if i == 1
            % Write if statement
            fprintf(fid,'  if strcmpi(plotsel,''%s'')\n',inp.plots{i,11});
            % Write commend
            fprintf(fid,'  %% %2.0f of %2.0f - %s\n',i,m_in,inp.plots{i,11});
            % Write function name
            fprintf(fid,'  [plotax] = %s(control,plotax);\n',['lines_' inp.plots{i,5}]);
        elseif i == m_in
            % Write elseif statement
            fprintf(fid,'  elseif strcmpi(plotsel,''%s'')\n',inp.plots{i,11});
            % Write comment
            fprintf(fid,'  %% %2.0f of %2.0f - %s\n',i,m_in,inp.plots{i,11});
            % Write function name
            fprintf(fid,'  [plotax] = %s(control,plotax);\n',['lines_' inp.plots{i,5}]);
            % Some comment lines
            fprintf(fid,'  %%\n');
            fprintf(fid,'  %%\n');
            %Write additional else - the plot should not exist...
            fprintf(fid,'  else\n');
            fprintf(fid,'    fprintf(''Error: Unknown plot!%s'');\n','\n');
            fprintf(fid,'  end\n');
        else
            % Write elseif statement
            fprintf(fid,'  elseif strcmpi(plotsel,''%s'')\n',inp.plots{i,11});
            % Write comment
            fprintf(fid,'  %% %2.0f of %2.0f - %s\n',i,m_in,inp.plots{i,11});
            % Write function name
            fprintf(fid,'  [plotax] = %s(control,plotax);\n',['lines_' inp.plots{i,5}]);
        end
        % Some comment lines
        fprintf(fid,'  %%\n');
        fprintf(fid,'  %%\n');
        
    end
    % Write code to disable overlay plotting
    fprintf(fid,'%% Disable overlay plotting\n');
    fprintf(fid,'hold(plotax,''on'')\n');
    % Write end of function
    fprintf(fid,'end\n');
    fprintf('...finished! - Time: %s\n\n',datestr(clock));
    
    % Close the plot switch function
    fclose(fid);

%% 03b Write new line functions
    % Status output to command window
    fprintf('Writing line functions... - Time: %s\n',datestr(clock));
    % Start writing the line functions in loop
    for i = 1:m_in
        fprintf('Writing lines_%s...\n',[inp.plots{i,5} '.m'])
        % Open the new m-file
        fid = fopen(['db/' inp.programdir '/' 'lines_' inp.plots{i,5} '.m'],'w');
        % Write begin of the function
        fprintf(fid,'function [plotax] = lines_%s(control,plotax)\n\n',inp.plots{i,5});
        % Get the size of the input line array
        [mlines,nlines] = size(inp.dataset(i).lines); % disp(mlines); disp(nlines);
        % Check if all columns are available
        if nlines == 3
            % Write the plot commands
            for j = 1:2:mlines
                % Write comment
                fprintf(fid,'%% Line segment #%02.0f\n',(j/2)+0.5);
                % Write line number
                fprintf(fid,'line = %1.0f;\n',inp.dataset(i).lines{j,1});
                % Write plot command
                fprintf(fid,'plot([%5.5f %5.5f],[%5.5f %5.5f],...\n',inp.dataset(i).lines{j,2},...
                                                                     inp.dataset(i).lines{j+1,2},...
                                                                     inp.dataset(i).lines{j,3},...
                                                                     inp.dataset(i).lines{j+1,3});
                % Write properties
                fprintf(fid,'        ''LineWidth'',control.setup.lines(1,line).LineWidth.*control.scafac,...\n');
                fprintf(fid,'        ''LineStyle'',control.setup.lines(1,line).LineStyle,...\n');
                fprintf(fid,'        ''Color'',control.setup.lines(1,line).Color);\n\n');
            end
        else
            %  Give error output
            fprintf('Error: Wrong number of columns in line array input.\n')
            fprintf('Check the file %s for error!\n',inp.plots{i,4})
        end
        % Write end of the function
        fprintf(fid,'end');
        % Close the plot file
        fclose(fid);
        fprintf('...finished with line function!\n');
    end
    fprintf('...all plots completed! - Time: %s\n\n',datestr(clock));

%% 03c Write label switch function
    % Open plot switch funtion
    fid = fopen(['db/' inp.programdir '/' inp.programdir '_labelswitch.m'],'w');
    % Status command window output
    fprintf('Writing label switch... - Time: %s\n',datestr(clock));
    % Write begin of the function
    fprintf(fid,'function [plotax] = %s\n',[inp.programdir '_labelswitch(control,plotax,plotsel)']);
    % Write statement to get string of the plot array
    fprintf(fid,'\n');
    fprintf(fid,'%% Get the selected plot type\n');
    fprintf(fid,'plotsel = control.plots.list(plotsel,1);\n');
    fprintf(fid,'%% Enable overlay plotting\n');
    fprintf(fid,'hold(plotax,''on'')\n\n');
    % Get the number of files used by the following loops
    [m_in,~] = size(inp.plots);
    % Start writing plotswitch in this loop
    for i = 1:m_in
        % Write if-elseif-else statement into the plotswitch
        if i == 1
            fprintf(fid,'  if strcmpi(plotsel,''%s'')\n',inp.plots{i,11});
            fprintf(fid,'  %% %2.0f of %2.0f - %s\n',i,m_in,inp.plots{i,11});
            
            fprintf(fid,'  [plotax] = %s(control,plotax);\n',['labels_' inp.plots{i,5}]);
        elseif i == m_in
            % Write elseif statement
            fprintf(fid,'  elseif strcmpi(plotsel,''%s'')\n',inp.plots{i,11});
            % Write comment
            fprintf(fid,'  %% %2.0f of %2.0f - %s\n',i,m_in,inp.plots{i,11});
            % Write function name
            fprintf(fid,'  [plotax] = %s(control,plotax);\n',['labels_' inp.plots{i,5}]);
            % Some comment lines
            fprintf(fid,'  %%\n');
            fprintf(fid,'  %%\n');
            %Write additional else - the plot should not exist...
            fprintf(fid,'  else\n');
            fprintf(fid,'    fprintf(''Error: Unknown plot!%s'');\n','\n');
            fprintf(fid,'  end\n');
        else
            % Write elseif statement
            fprintf(fid,'  elseif strcmpi(plotsel,''%s'')\n',inp.plots{i,11});
            % Write comment
            fprintf(fid,'  %% %2.0f of %2.0f - %s\n',i,m_in,inp.plots{i,11});
            % Write function name
            fprintf(fid,'  [plotax] = %s(control,plotax);\n',['labels_' inp.plots{i,5}]);
        end
        % Some comment lines
        fprintf(fid,'  %%\n');
        fprintf(fid,'  %%\n');
    end
    % Write code to disable overlay plotting
    fprintf(fid,'%% Disable overlay plotting\n');
    fprintf(fid,'hold(plotax,''on'')\n');
    % Write end of function
    fprintf(fid,'end\n');
    fprintf('...finished! - Time: %s\n\n',datestr(clock));
    % Close the plot switch function
    fclose(fid);
     
%% 03d Write new label functions
    % Status output to command window
    fprintf('Writing label functions... - Time: %s\n',datestr(clock));
    % Start writing the label functions in loop
    for i = 1:m_in
        fprintf('Writing labels_%s...\n',[inp.plots{i,5} '.m']);
        % Open the new m-file
        fid = fopen(['db/' inp.programname '/' 'labels_' inp.plots{i,5} '.m'],'w');
        % Write begin of the function
        fprintf(fid,'function [plotax] = labels_%s(control,plotax)\n\n',inp.plots{i,5});
        % Get the size of the input label array
        [mlines,nlines] = size(inp.dataset(i).labels);
        if nlines == 5
            % Write the text commands
            for j = 1:mlines
                % Write comment
                fprintf(fid,'%% Label segment #%02.0f\n',j);
                % Write font number
                fprintf(fid,'fontsel = %1.0f;\n',inp.dataset(i).labels{j,1});
                % Write text command
                fprintf(fid,'text(%5.3f,%5.3f,sprintf(''%s''),''Rotation'',%2.0f,...\n',...
                            inp.dataset(i).labels{j,2},inp.dataset(i).labels{j,3},inp.dataset(i).labels{j,4},inp.dataset(i).labels{j,5});
                % Write properties
                fprintf(fid,'        ''Parent'',plotax,''HorizontalAlignment'',''center'',''VerticalAlignment'',''middle'',...\n');
                fprintf(fid,'        ''Color'',control.setup.fonts(fontsel).Color,...\n');
                fprintf(fid,'        ''FontName'',control.setup.fonts(fontsel).FontName,...\n');
                fprintf(fid,'        ''FontAngle'',control.setup.fonts(fontsel).FontAngle,...\n');
                fprintf(fid,'        ''FontSize'',control.setup.fonts(fontsel).FontSize.*control.scafac,...\n');
                fprintf(fid,'        ''FontUnits'',control.setup.fonts(fontsel).FontUnits,...\n');
                fprintf(fid,'        ''FontWeight'',control.setup.fonts(fontsel).FontWeight);\n\n');
            end
        else
            %  Give error output
            fprintf('Error: Wrong number of columns in line array input.\n')
            fprintf('Check the file %s for error!\n',inp.plots{i,4})
        end
        % Write end of the function
        fprintf(fid,'end');
        % Close the plot file
        fclose(fid);
        fprintf('...finished with label function!\n');
    end
    fprintf('...all labels completed! - Time: %s\n\n',datestr(clock));
    
%% 03e Write program control script
% i.e. the input of the specific program

    % Status output to command window
    fprintf('Writing program control function... - Time: %s\n',datestr(clock));
    
    % Open new file for write access
    fid = fopen(['db/' inp.programdir '/' inp.programdir '_control' '.m'],'w');
    % Write begin of the function  
    fprintf(fid,'function [control] = %s_control\n\n',inp.programdir);
    % Write comment and program title
    fprintf(fid,'%% Title of the program\n');
    fprintf(fid,'control.title = ''%s'';\n\n',inp.programtitle);
    fprintf(fid,'%% Name of the program\n');
    fprintf(fid,'control.program = ''%s'';\n\n',inp.programname);

    % Get the size of the header input
    [m_in,~] = size(inp.headers); headers = inp.headers(2:m_in,:); m_in = m_in - 1;

    % Write the number of valid headers into file
    fprintf(fid,'%% Number valid header entries\n');
    fprintf(fid,'control.header.m = %2.0f;\n',m_in);

    % Write valid header entries and corresponding fulltext header in loop
    for i = 1:m_in
        % Write comment and the beginning of the cell array
        if i == 1
            fprintf(fid,'%% Valid header and fulltext header entries\n');
            fprintf(fid,'control.header.valid = {...\n');
        end
               % Write data into cell array
            fprintf(fid,'                        ''%s'',''%s'',''%s'',''%s'';...\n',headers{i,1},headers{i,2},headers{i,3},headers{i,4});
        % Finish cell array
        if i == m_in
            fprintf(fid,'                        };\n\n');
        end

    end

    % Get the size of the plot structure
    [m_in,~] = size(inp.plots);
    
    % Write the number of plots into file
    fprintf(fid,'%% Number of plots\n');
    fprintf(fid,'control.plots.m = %2.0f;\n',m_in);
    
    % Write additional information into the plot
    for i = 1:m_in
        % Write comment and the beginning of the plot list cell array
        if i == 1
            fprintf(fid,'%% List of plot for button names and plot information\n');
            fprintf(fid,'control.plots.list = {...\n');
        end
            % Check how many input units are required for each plot
            if sum(strcmpi(inp.plots{i,12},{'linear','linear invx','linear invy','semilogx','semilogx invx','semilogx invy','semilogy','semilogy invx','semilogy invy','loglog'})) == true 
                % Write plot name and type information in cell array
                fprintf(fid,'                      ''%s'',''%s'',{''%s'';''%s''},{''%s'';''%s''},{''%s'';''%s''},''%s'',''%s'',''%s'',''%s'',''%s'',''%s'';...\n',...
                                                                                  inp.plots{i,11},...
                                                                                  inp.plots{i,12},...
                                                                                  inp.plots{i,13},...
                                                                                  inp.plots{i,16},...
                                                                                  inp.plots{i,15},...
                                                                                  inp.plots{i,18},...
                                                                                  inp.plots{i,14},...
                                                                                  inp.plots{i,17},...
                                                                                  inp.plots{i,6},...
                                                                                  inp.plots{i,7},...
                                                                                  inp.plots{i,8},...
                                                                                  inp.plots{i,9},...
                                                                                  inp.plots{i,10},...
                                                                                  sprintf('%s (after %s)',inp.plots{i,11},inp.plots{i,25})...
                                                                                  );

            elseif strcmpi(inp.plots{i,12},'ternary')
                % Write plot name and type information in cell array
                fprintf(fid,'                      ''%s'',''%s'',{''%s'';''%s'';''%s''},{''%s'';''%s'';''%s''},{''%s'';''%s'';''%s''},''%s'',''%s'',''%s'',''%s'',''%s'',''%s'';...\n',...
                                                                                  inp.plots{i,11},...
                                                                                  inp.plots{i,12},...
                                                                                  inp.plots{i,13},...
                                                                                  inp.plots{i,16},...
                                                                                  inp.plots{i,22},...
                                                                                  inp.plots{i,15},...
                                                                                  inp.plots{i,18},...
                                                                                  inp.plots{i,24},...
                                                                                  inp.plots{i,14},...
                                                                                  inp.plots{i,17},...
                                                                                  inp.plots{i,23},...
                                                                                  inp.plots{i,6},...
                                                                                  inp.plots{i,7},...
                                                                                  inp.plots{i,8},...
                                                                                  inp.plots{i,9},...
                                                                                  inp.plots{i,10},...
                                                                                  sprintf('%s (after %s)',inp.plots{i,11},inp.plots{i,25})...
                                                                                  );
                
            elseif strcmpi(inp.plots{i,12},'ternary inverted')
                % Write plot name and type information in cell array
                fprintf(fid,'                      ''%s'',''%s'',{''%s'';''%s'';''%s''},{''%s'';''%s'';''%s''},{''%s'';''%s'';''%s''},''%s'',''%s'',''%s'',''%s'',''%s'',''%s'';...\n',...
                                                                                  inp.plots{i,11},...
                                                                                  inp.plots{i,12},...
                                                                                  inp.plots{i,13},...
                                                                                  inp.plots{i,19},...
                                                                                  inp.plots{i,22},...
                                                                                  inp.plots{i,15},...
                                                                                  inp.plots{i,21},...
                                                                                  inp.plots{i,24},...
                                                                                  inp.plots{i,14},...
                                                                                  inp.plots{i,18},...
                                                                                  inp.plots{i,23},...
                                                                                  inp.plots{i,6},...
                                                                                  inp.plots{i,7},...
                                                                                  inp.plots{i,8},...
                                                                                  inp.plots{i,9},...
                                                                                  inp.plots{i,10},...
                                                                                  sprintf('%s (after %s)',inp.plots{i,11},inp.plots{i,25})...
                                                                                  );
                                                                              
            elseif strcmpi(inp.plots{i,12},'diamond')
                % Write plot name and type information in cell array
                fprintf(fid,'                      ''%s'',''%s'',{''%s'';''%s'';''%s'';''%s''},{''%s'';''%s'';''%s'';''%s''},{''%s'';''%s'';''%s'';''%s''},''%s'',''%s'',''%s'',''%s'',''%s'',''%s'';...\n',...
                                                                                  inp.plots{i,11},...
                                                                                  inp.plots{i,12},...
                                                                                  inp.plots{i,13},...
                                                                                  inp.plots{i,16},...
                                                                                  inp.plots{i,19},...
                                                                                  inp.plots{i,22},...
                                                                                  inp.plots{i,15},...
                                                                                  inp.plots{i,18},...
                                                                                  inp.plots{i,21},...
                                                                                  inp.plots{i,24},...
                                                                                  inp.plots{i,14},...
                                                                                  inp.plots{i,17},...
                                                                                  inp.plots{i,20},...
                                                                                  inp.plots{i,23},...
                                                                                  inp.plots{i,6},...
                                                                                  inp.plots{i,7},...
                                                                                  inp.plots{i,8},...
                                                                                  inp.plots{i,9},...
                                                                                  inp.plots{i,10},...
                                                                                  sprintf('%s (after %s)',inp.plots{i,11},inp.plots{i,25})...
                                                                                  );
            end
        % Write end of cell array
        if i == m_in
            fprintf(fid,'                      };\n');
        end
    end
    
    
    % Write additional information into the plot
    for i = 1:m_in
        % Write comment and the beginning of the plot list cell array
        if i == 1
            fprintf(fid,'%% List of plot for button names and plot information\n');
            fprintf(fid,'control.plots.description = {...\n');
        end
        % Write citation and description into file
        fprintf(fid,'                      ''%s'',''%s'';...\n',inp.plots{i,25},...
                                                                inp.plots{i,26});
        % Write end of cell array
        if i == m_in
            fprintf(fid,'                      };\n');
        end
    end

    % Write end of the function
    fprintf(fid,'end');
    % Close the plot file
    fclose(fid);
    % Status output to command window
    fprintf('...all plots completed! - Time: %s\n\n',datestr(clock));
end

%% Control elements
% assignin('base','inp',inp)

%% 00 Make GUI visible
% Set figure visible
set(psc_ini,'Visible','On');
% Output to command window
fprintf('...PSC launched! - Time: %s\n\n',datestr(clock)); % + blank row

end

