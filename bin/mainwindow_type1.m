function mainwindow_type1(control,load_op,files,files_op,save_path)
%% 00a Status output to command window

% GUI Initialisation
fprintf('Launching %s... \n      - Time: %s\n',control.title,datestr(clock));

%% 00b Supress warnings and error messages in file

%#ok<*LAXES> % Supress axes function in loop warning

%% 00c Handle input files and create important variables

% Check if session was loaded
% Session was loaded ==> load_op = 1
if load_op == 1
    % Load data from matfile
    load(files_op,'-mat','data','control','files_op','opt_check','temp');
    control.files = files;
    % Status output
    fprintf('...session succesfully loaded...\n...preparing main window...\n      - Time: %s\n',datestr(clock));

% Session was not loaded
else
    % Parse and arrange input files in control structure
    control.files = parse_files(files,files_op); temp = struct();
    % Read the data
    [data,temp] = read_files(files_op,control.files,control.header.valid);
    % Special function switch
    [data,control] = special_fnc_switch(data,control,files_op);
    % Create line and font settings into control structure
    control = defaults_misc(control);

    % Create logical array to dispay datasets
    opt_check = true(files_op,1);
    % Preallocate some variables for user-supplied plots
    control.usup = struct();
    control.usupline = struct();
    control.usuppatch = struct();

    % Status output
    fprintf('...data succesfully imported... \n      - Time: %s\n',datestr(clock));
end

%% 00c Control elements after data processing

% Assign control and data structure to base workspace (normally deactivated)
% assignin('base','data',data)
% assignin('base','control',control)
% assignin('base','temp',temp)

%% 00d Create the GUI
% Create and then hide the GUI during the construction process
pp_main = figure('Visible','off');
% Deactivate numbering of the figure
set(pp_main,'NumberTitle','off')
% Set units of the figure to pixel and hide menu bar.
set(pp_main,'Units','pixel','MenuBar','none','Pointer','arrow','Renderer','zbuffer');
% Set size and position (absolute pixel) of the figure and set name of the GUI
set(pp_main,'OuterPosition',[75,75,1600,900],'Resize','Off','Name',control.title);
% Change the background color of the GUI to black
set(pp_main,'Color',[.8,.8,.8]);
% Create header line with text
uicontrol('Style','text',...
          'String',control.title,...
          'ForegroundColor',[1,1,1],'BackgroundColor',[0,0,0],...
          'FontSize',32,'FontWeight','bold','FontName','Arial','HorizontalAlignment','left',...
          'Units','normalized','Position',[.0,.94,1.,0.055]);
% Create white header line
uicontrol('Style','text','String','',...
          'ForegroundColor',[.0,.0,.0],'BackgroundColor',[1,1,1],...
          'Units','normalized','Position',[.0,.93,1.,.01]);
% Create black header line
uicontrol('Style','text','String','',...
          'ForegroundColor',[1,1,1],'BackgroundColor',[.0,.0,.0],...
          'Units','normalized','Position',[.0,.92,1.,.01]);
      
%% 00e Create edit fiels for session name

% Create tile for session name
uicontrol('Style','text',...
          'String','Session:',...
          'ForegroundColor',[1,1,1],'BackgroundColor',[0,0,0],...
          'FontSize',14,'FontWeight','bold','FontName','Arial','HorizontalAlignment','left',...
          'Units','normalized','Position',[0.39,0.9550,0.06,0.025]);

% Create session name
if isfield(control,'prj_name') == 0
    if files_op >= 2
        control.prj_name = strcat(control.program,'_',num2str(files_op),'datasets');
    else
        control.prj_name = strcat(control.program,'_',num2str(files_op),'dataset');
    end
    
end

% Create editable name to change the session name
session_edit = uicontrol('Style','Edit',...
                         'String',control.prj_name,...
                         'ForegroundColor',[1,1,1],'BackgroundColor',[0,0,0],...
                         'FontSize',14,'FontWeight','bold','FontName','Arial','HorizontalAlignment','left',...
                         'Units','normalized','Position',[0.45,0.9525,0.3,0.03],...
                         'Callback',@session_edit_callback);

%% 00f Create save buttons

% Create edge color button
gen_save_symbols = uicontrol('Style','pushbutton',...
                     'Units','normalized','Position',[0.85 0.95 0.06 0.035],...
                     'Parent',pp_main,...
                     'String','Save Setup',...
                     'HorizontalAlignment','center',...
                     'ForegroundColor',[1.0 1.0 1.0],...
                     'BackgroundColor',[0.0,0.0,0.0],...
                     'Fontsize',10,'FontWeight','bold',...
                     'TooltipString',sprintf('Save the current symbols setup! \n Label / marker columns are not saved!'));
set(gen_save_symbols,'Callback',@gensavesymb_callback,'Visible','on');
% Create edge color button
gen_load_symbols = uicontrol('Style','pushbutton',...
                     'Units','normalized','Position',[0.92 0.95 0.06 0.035],...
                     'Parent',pp_main,...
                     'String','Load Setup',...
                     'HorizontalAlignment','center',...
                     'ForegroundColor',[1.0 1.0 1.0],...
                     'BackgroundColor',[0.0,0.0,0.0],...
                     'Fontsize',10,'FontWeight','bold',...
                     'TooltipString',sprintf('Save the current symbols setup as! \n Label / marker columns are not overwritten!'));
set(gen_load_symbols,'Callback',@genloadsymb_callback,'Visible','on');
% Create edge color button
gen_save_session = uicontrol('Style','pushbutton',...
                     'Units','normalized','Position',[0.76 0.95 0.06 0.035],...
                     'Parent',pp_main,...
                     'String','Save Session',...
                     'HorizontalAlignment','center',...
                     'ForegroundColor',[1.0 1.0 1.0],...
                     'BackgroundColor',[0.0,0.0,0.0],...
                     'Fontsize',10,'FontWeight','bold',...
                     'TooltipString',sprintf('Save the current session including \n modified markers and labels!'));
set(gen_save_session,'Callback',@gensave_callback);

%% 01 GUI Objects
% In the following text cells all object showing and handling the plots are
% listed

%% 01a Buttongroup for overview and dataset selection

% Create buttongroup
opt_data = uibuttongroup('Title','Datasets','TitlePosition','centertop',...
                         'Units','normalized','Position',[0.01 0.65 0.21 0.25],...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'TitlePosition','lefttop',...
                         'Fontsize',12,'FontWeight','Bold',...
                         'Visible','Off');
                     
%% 01b Create radio buttons and checkboxes for overview and dataset selection

% Preallocate cell array for objects
opt_data_u = cell(files_op+1,1);
% Start position
posy = 0.84; posx = 0.005; 
% Create ten radio buttons to select overview or datasets
for i = 1:files_op+1
    % First overview radio button
    if i == 1
        opt_data_u{i,1} = uicontrol('Style','Radio','String','All datasets',...
                                    'Units','normalized','Position',[posx posy 0.80 0.08],...
                                    'parent',opt_data,'Tag',num2str(i-1),...
                                    'FontSize',8,'FontWeight','Bold',...
                                    'ForegroundColor',[.0 .0 .8],'BackgroundColor',[0.8,0.8,0.8]);
    % Dataset radio buttons
    else
        % Show only loaded datasets
        opt_data_u{i,1} = uicontrol('Style','Radio','String',sprintf('#%s %s',num2str(i-1),control.files{i-1,1}),...
                                    'Units','normalized','Position',[posx posy 0.80 0.08],...
                                    'parent',opt_data,'Tag',num2str(i-1),...
                                    'FontSize',8,'FontWeight','Bold',...
                                    'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                    'Visible','on');
    end
    % Change position
    posy = posy - 0.09;
end
% Preallocate cell array to display data
opt_check_u = cell(files_op+1,1);
% Start position
posy = 0.84; posx = 0.81;
% Create checkboxes to display data
for i = 1:files_op+1
    if i == 1
        % Create title for checkboxes
        opt_check_u{i,1} = uicontrol('Style','Text','String','Display?',...
                                     'Units','normalized','Position',[posx posy 0.17 0.08],...
                                     'Parent',opt_data,'Visible','On',...
                                     'FontSize',8,'FontWeight','Bold',...
                                     'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8]);
    else
        % Create checkboxes
        opt_check_u{i,1} = uicontrol('Style','Checkbox','String','',...
                                     'Units','normalized','Position',[posx+0.065 posy 0.06 0.08],...
                                     'Parent',opt_data,'Visible','On',...
                                     'FontSize',8,'FontWeight','Normal','Value',opt_check(i-1,1),...
                                     'Tag',sprintf('%s',num2str(i-1)),...
                                     'ForegroundColor',[.0 .0 .8],'BackgroundColor',[0.8,0.8,0.8],...
                                     'Callback',@opt_check_callback);
    end
    % Change position
    posy = posy - 0.09;
end
% Define callback and selection for button group
set(opt_data,'SelectionChangeFcn',@select_opt_data,'SelectedObject',opt_data_u{1,1});
% Make the button group visible
set(opt_data,'Visible','On');

%% 02a Panel to display data overview and datasets

% Create buttongroup
ove_vis = uipanel('Title','Data overview',...
                   'Units','normalized','Position',[0.23 0.65 0.60 0.25],...
                   'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                   'TitlePosition','lefttop',...
                   'Fontsize',12,'FontWeight','Bold',...
                   'Visible','Off');

%% 02b Create panel to switch the shown headers in data overview

ove_vis_bg = uibuttongroup('Title','Headers','TitlePosition','lefttop',...
                           'Units','normalized','Parent',ove_vis,...
                           'Position',[0.905,0.40,0.09,0.62],...
                           'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                           'Fontsize',10,'FontWeight','Bold',...
                           'Visible','On');
% Preallocate array for radio buttons
ove_vis_bg_u = cell(6,1);
% Define the maximum number of display
ove_vis_max = 22;
% Define strings for radio buttons
ove_vis_bg_utxt = {sprintf('%s-%s',num2str(1),num2str(ove_vis_max));...
                   sprintf('%s-%s',num2str(ove_vis_max+1),num2str(ove_vis_max*2));...
                   sprintf('%s-%s',num2str(ove_vis_max*2+1),num2str(ove_vis_max*3));...
                   sprintf('%s-%s',num2str(ove_vis_max*3+1),num2str(ove_vis_max*4));...
                   sprintf('%s-%s',num2str(ove_vis_max*4+1),num2str(ove_vis_max*5));...
                   sprintf('%s-%s',num2str(ove_vis_max*5+1),num2str(ove_vis_max*6))};
% Determine the number of required radio buttons
ove_vis_bg_u_nr = ceil(control.header.m./ove_vis_max);
% Define positions
posx = 0.1; posy = 0.86;

% Create radio buttons in the overview data switch
for i = 1:ove_vis_bg_u_nr
    % Create the radio buttons
    ove_vis_bg_u{i,1} = uicontrol('Style','Radio','String',ove_vis_bg_utxt{i,1},...
                                  'Units','normalized','Position',[posx,posy,0.80,0.14],...
                                  'parent',ove_vis_bg,'Tag',num2str(i),...
                                  'FontSize',9,'FontWeight','Bold',...
                                  'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8]);
    % Update positions
    posy = posy - 0.16;
end

% Define callback and selection for button group
set(ove_vis_bg,'SelectionChangeFcn',@select_ove_vis,'SelectedObject',ove_vis_bg_u{1,1});
% Color the initial selection in blue 
set(ove_vis_bg_u{1,1},'ForeGroundColor',[.0,.0,.8])
% Make the button group visible
set(ove_vis_bg,'Visible','On');

%% 02b Create panel to switch the type of data shown in the overview and table

ove_vis_bgt = uibuttongroup('Title','Data Type','TitlePosition','lefttop',...
                            'Units','normalized','Parent',ove_vis,...
                            'Position',[0.905,0.02,0.09,0.38],...
                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                            'Fontsize',10,'FontWeight','Bold',...
                            'Visible','On');
% Preallocate array for radio buttons
ove_vis_bgt_u = cell(3,1);
% Define positions
posx = 0.1; posy = 0.71;
% Define strings for radio buttons
ove_vis_bgt_utxt = {'Raw';'Norm.';'Molar'};
ove_vis_bgt_tag = {'dat';'norm';'mol'};
ove_vis_bgt_utxt_tts = {'Show raw data';'Show data normalised to 100 wt.%';'Show calculated molar weights'};
% Create radio buttons in the overview data switch
for i = 1:size(ove_vis_bgt_u)
    % Create the radio buttons
    ove_vis_bgt_u{i,1} = uicontrol('Style','Radio','String',ove_vis_bgt_utxt{i,1},...
                                   'Units','normalized','Position',[posx,posy,0.80,0.25],...
                                   'parent',ove_vis_bgt,'Tag',ove_vis_bgt_tag{i,1},...
                                   'ToolTipString',ove_vis_bgt_utxt_tts{i,1},...
                                   'FontSize',9,'FontWeight','Bold',...
                                   'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8]);
    % Update positions
    posy = posy - 0.33;
end

% Define callback and selection for button group
set(ove_vis_bgt,'SelectionChangeFcn',@select_ove_norm,'SelectedObject',ove_vis_bgt_u{1,1});
% Color the initial selection in blue 
set(ove_vis_bgt_u{1,1},'ForeGroundColor',[.0,.0,.8])
% Make the button group visible
set(ove_vis_bgt,'Visible','On');

%% 02c Create objects in overview panel

% Preallocate cell arrays for marker and label columns
ove_vis_uc = cell(files_op+1,2); ove_vis_uctxt = cell({'MC','LC'}); ove_vis_ut = cell(1,2); 
ove_vis_uttxt = {'symbol','op','marker';'label','op','label'};
% Preallocate cell arrays to display data
ove_vis_u = cell(files_op+1,ove_vis_max); ove_vis_t = cell(1,ove_vis_max);
% Y-start position
posy = 0.84; 
% Create objects to display data
for i = 1:files_op+1
% X-start position
posx = 0.02;
    % Display the header line (i = 1)
    if i == 1
        % Display marker and label operator
        for j = 1:2
        ove_vis_uc{i,j} = axes('Units','normalized',...
                               'Position',[posx posy 0.020 0.15],...
                               'Parent',ove_vis,...
                               'box','off',...
                               'Visible','on');
        ove_vis_ut{1,j} = text(0.5,0.01,ove_vis_uctxt{i,j},'Parent',ove_vis_uc{i,j},...
                                   'HorizontalAlignment','Left',...
                                   'FontSize',8,'FontWeight','Bold',...
                                   'Rotation',90);
        axis([0 1 0 1]); axis off;
        % Update position
        posx = posx + 0.0205;
        end
        % Update position
        posx = posx + 0.01;
        % Display the valid header line
        for j = 1:ove_vis_max
            ove_vis_u{i,j} = axes('Units','normalized',...
                                  'Position',[posx posy 0.035 0.15],...
                                  'Parent',ove_vis,...
                                  'box','off',...
                                  'Visible','on');
            % Handle long labels
            if strcmpi(control.header.valid{j,1},'Fe2O3tot')
                current_label = 'Fe2O3*';
            elseif strcmpi(control.header.valid{j,1},'FeOtot')
                current_label = 'FeO*';
            else
                current_label = control.header.valid{j,1};
            end
            ove_vis_t{1,j} = text(0.5,0.01,current_label,'Parent',ove_vis_u{i,j},...
                                                         'HorizontalAlignment','Left',...
                                                         'FontSize',8,'FontWeight','Bold',...
                                                         'Rotation',90); 
        axis([0 1 0 1]); axis off;
        % Update position
        posx = posx + 0.0365;
        end
    % Display overview boxes (i > 1)
    else
        % Display marker and label operator
        for j = 1:2
            if data(1,i-1).(ove_vis_uttxt{j,1}).(ove_vis_uttxt{j,2}).op == false
                % Make it yellow if header but no data were found
                ove_vis_uc{i,j} = uicontrol('Style','Text','String','-',...
                                            'Units','normalized','Position',[posx posy 0.020 0.08],...
                                            'Parent',ove_vis,...
                                            'HorizontalAlignment','Center',...
                                            'FontSize',8,'FontWeight','Bold',...
                                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[.8 .0 .0]);
                % Create tool tip
                set(ove_vis_uc{i,j},'TooltipString',sprintf('No complete or no %s column found!',ove_vis_uttxt{j,3}));
            else
                % Make it green if header and values were found
                ove_vis_uc{i,j} = uicontrol('Style','Text','String','x',...
                                            'Units','normalized','Position',[posx posy 0.020 0.08],...
                                            'Parent',ove_vis,...
                                            'HorizontalAlignment','Center',...
                                            'FontSize',8,'FontWeight','Bold',...
                                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[.0 .8 .0]);
                % Create tool tip
                set(ove_vis_uc{i,j},'TooltipString',sprintf('Complete %s column found!',ove_vis_uttxt{j,3}));
            end
        % Update position
        posx = posx + 0.0205;
        end
        % Update position
        posx = posx + 0.01;
        % Display the data information
        for j = 1:ove_vis_max
            if data(1,i-1).dat.(control.header.valid{j,1}).headerv_opsum >= 1
                % If more than 1000 values are available from the data,
                % create a text to show the approx. no of files
                no_vals = sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values));
                if no_vals > 999 && no_vals < 10000
                    no_vals_str = num2str(no_vals);
                    no_vals_str = sprintf('>%sk',no_vals_str(1));
                elseif no_vals > 9999 && no_vals < 100000
                    no_vals_str = num2str(no_vals);
                    no_vals_str = sprintf('>%sk',no_vals_str(1:2));
                elseif no_vals > 99999
                    no_vals_str = num2str(no_vals);
                    no_vals_str = sprintf('>%sk',no_vals_str(1:3));
                else
                    no_vals_str = num2str(no_vals);
                end
                
                if data(1,i-1).dat.(control.header.valid{j,1}).headerv_opsum == 1
                    if no_vals == 0;
                        % Make it yellow if header but no data were found
                        ove_vis_u{i,j} = uicontrol('Style','Text','String',no_vals_str,...
                                                   'Units','normalized','Position',[posx posy 0.035 0.08],...
                                                   'Parent',ove_vis,...
                                                   'HorizontalAlignment','Center',...
                                                   'FontSize',8,'FontWeight','Bold',...
                                                   'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[.8 .8 .0]);
                        % Create tool tip
                        set(ove_vis_u{i,j},'TooltipString',sprintf('%s\n%s values\nHeader entry present in file...\n...but no values found below!',...
                                                       control.header.valid{j,2},...
                                                       num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values)))));
                    else
                        % Make it green if header and values were found
                        ove_vis_u{i,j} = uicontrol('Style','Text','String',no_vals_str,...
                                                   'Units','normalized','Position',[posx posy 0.035 0.08],...
                                                   'Parent',ove_vis,...
                                                   'HorizontalAlignment','Center',...
                                                   'FontSize',8,'FontWeight','Bold',...
                                                   'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[.0 .8 .0]);
                       % Create the Tool Tip String
                        if data(1,i-1).dat.(control.header.valid{j,1}).Mean >= 10
                            tip_str = sprintf('%s\n%s values\nMax: %.1f %s\nMean: %.1f %s\n Median: %.1f %s\nMin: %.1f %s',...
                                                                control.header.valid{j,2},...
                                                                num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values))),...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Max,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Mean,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Median,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Min,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn);
                        elseif data(1,i-1).dat.(control.header.valid{j,1}).Mean <= 10 && data(1,i-1).dat.(control.header.valid{j,1}).Mean > 1
                            tip_str = sprintf('%s\n%s values\nMax: %.2f %s\nMean: %.2f %s\n Median: %.2f %s\nMin: %.2f %s',...
                                                                control.header.valid{j,2},...
                                                                num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values))),...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Max,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Mean,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Median,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Min,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn);
                        else
                            tip_str = sprintf('%s\n%s values\nMax: %.4f %s\nMean: %.4f %s\n Median: %.4f %s\nMin: %.4f %s',...
                                                                control.header.valid{j,2},...
                                                                num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values))),...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Max,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Mean,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Median,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Min,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn);
                        end
                        % Create tool tip
                        set(ove_vis_u{i,j},'TooltipString',tip_str);
                    end
                elseif data(1,i-1).dat.(control.header.valid{j,1}).headerv_opsum == 2
                    % Make it orange if the data was calculated
                    ove_vis_u{i,j} = uicontrol('Style','Text','String',no_vals_str,...
                                               'Units','normalized','Position',[posx posy 0.035 0.08],...
                                               'Parent',ove_vis,...
                                               'HorizontalAlignment','Center',...
                                               'FontSize',8,'FontWeight','Bold',...
                                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. .5 .0]);
                       % Create the Tool Tip String
                        if data(1,i-1).dat.(control.header.valid{j,1}).Mean >= 10
                            tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.1f %s\nMean: %.1f %s\n Median: %.1f %s\nMin: %.1f %s',...
                                                                control.header.valid{j,2},...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).headerv_calc,...
                                                                num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values))),...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Max,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Mean,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Median,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Min,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn);
                        elseif data(1,i-1).dat.(control.header.valid{j,1}).Mean <= 10 && data(1,i-1).dat.(control.header.valid{j,1}).Mean > 1
                            tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.2f %s\nMean: %.2f %s\n Median: %.2f %s\nMin: %.2f %s',...
                                                                control.header.valid{j,2},...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).headerv_calc,...
                                                                num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values))),...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Max,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Mean,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Median,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Min,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn);
                        else
                            tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.4f %s\nMean: %.4f %s\n Median: %.4f %s\nMin: %.4f %s',...
                                                                control.header.valid{j,2},...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).headerv_calc,...
                                                                num2str(sum(isfinite(data(1,i-1).dat.(control.header.valid{j,1}).Values))),...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Max,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Mean,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Median,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn,...
                                                                data(1,i-1).dat.(control.header.valid{j,1}).Min,data(1,i-1).dat.(control.header.valid{j,1}).UnitIn);
                        end
                    % Create tool tip
                    set(ove_vis_u{i,j},'TooltipString',tip_str);
                end
            else
                % Else no data was found = red background with "-"
                ove_vis_u{i,j} = uicontrol('Style','Text','String',' - ',...
                                           'Units','normalized','Position',[posx posy 0.035 0.08],...
                                           'Parent',ove_vis,...
                                           'HorizontalAlignment','Center',...
                                           'FontSize',8,'FontWeight','Normal',...
                                           'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[.8 .0 .0]);  
                set(ove_vis_u{i,j},'TooltipString','Header entry not found in file...')
            end
        posx = posx + 0.0365;
        end
    end
posy = posy - 0.09;
end

% Make the panel visible
set(ove_vis,'Visible','On');

%% 02d Panel for data table

% Create buttongroup
ove_tab = uipanel('Title','Dataset','TitlePosition','centertop',...
                   'Units','normalized','Position',[0.23 0.65 0.60 0.25],...
                   'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                   'TitlePosition','lefttop',...
                   'Fontsize',12,'FontWeight','Bold',...
                   'Visible','Off');
               
%% 02e Create table for the data and expand button

% Create table
ove_tab_u = uitable('Parent',ove_tab,'Data',[],...
                  'Units','normalized','Position',[0.001 0.06 0.99 0.93],...
                  'FontSize',8,...
                  'ColumnName',control.header.valid(:,1),...
                  'ColumnFormat',{'numeric','numeric','numeric','numeric','numeric',...
                                  'numeric','numeric','numeric','numeric','numeric',...
                                  'numeric','numeric','numeric','numeric'},...
                  'ColumnEditable',[false false false false false false false false false false false false false false],...
                  'ColumnWidth',{63 63 63 63 63 63 63 63 63 63 63 63 63 63},...
                  'Visible','On');
% Create expand / collapse table button
ove_tab_but = uicontrol('Parent',ove_tab,'Style','PushButton',...
                        'Units','normalized','Position',[0.001 0.01 0.99 0.04],...
                        'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.0,0.0,0.0],...
                        'ToolTipString','Expand table',...
                        'Callback',@expandtable_callback);
set(ove_tab_but,'Visible','On')

%% 03a Create symbol/label settings overview panel

symbset_ov = uipanel('Title','Marker / Label Overview','TitlePosition','centertop',...
                     'Units','normalized','Position',[0.84 0.33 0.15 0.57],...
                     'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                     'TitlePosition','lefttop',...
                     'Fontsize',12,'FontWeight','Bold',...
                     'Visible','On');
                 
%% 03b Create elements of the overview panel

% Preallocate cell array
marker_vis = cell(files_op,4);
% Start position
posy = 0.90; posx = 0.01;
% Create new array for legend
control.legend = control.files(:,1);
% Create objects to display data
for i = 1:files_op
        % Show only loaded datasets
       if control.files{i,6} == 1
           marker_vis{i,1} = uicontrol('Style','Edit','String',control.legend{i,1},...
                                       'Units','normalized','Position',[posx posy+0.06 0.98 0.035],...
                                       'Parent',symbset_ov,...
                                       'Tag',num2str(i),...
                                       'HorizontalALignment','Left',...
                                       'FontSize',8,'FontWeight','Bold',...
                                       'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                       'Callback',@datasetname_callback);
           % Create axes object
           marker_vis{i,2} = axes('Parent',symbset_ov,'Position',[posx posy-0.01 0.98 0.07],...
                                  'XLim',[0 2],'YLim',[0 1],'Color',[1 0 0]); 
           % Show marker if no marker column is available
           if data(1,i).symbol.op.op == true
               % Show that there is a marker column
               marker_vis{i,3} = text(0.5,0.5,sprintf('...marker columns!'),...
                                              'FontSize',7,'FontWeight','Bold',...
                                              'HorizontalAlignment','Center',...
                                              'VerticalAlignment','Middle');
               set(marker_vis{i,2},'box','off'); axis([0 2 0 1]); axis off;
           else
               % Plot the marker
               marker_vis{i,3} = plot(0.5,0.5,'Parent',marker_vis{i,2},...
                                              'Marker',markerid(data(1,i).symbol.symbol),...
                                              'MarkerSize',data(1,i).symbol.size,...
                                              'MarkerEdgeColor',data(1,i).symbol.mec,...
                                              'MarkerFaceColor',data(1,i).symbol.mfc);
               set(marker_vis{i,2},'box','off'); axis([0 2 0 1]); axis off;
           end

           if data(1,i).label.op.op == true
                marker_vis{i,4} = text(1.5,0.5,'...label columns!',...
                                               'Parent',marker_vis{i,2},...
                                               'FontSize',7,'FontWeight','Bold',...
                                               'HorizontalAlignment','Center',...
                                               'VerticalAlignment','Middle',...
                                               'Visible','off');
           else
                marker_vis{i,4} = text(1.5,0.5,'AaBbCc',...
                                               'Parent',marker_vis{i,2},...
                                               'Fontname',data(1,i).label.FontName,...
                                               'FontAngle',data(1,i).label.FontAngle,...
                                               'FontSize',data(1,i).label.FontSize,...
                                               'FontWeight',data(1,i).label.FontWeight,...
                                               'Color',data(1,i).label.Color,...
                                               'HorizontalAlignment','Center',...
                                               'VerticalAlignment','Middle',...
                                               'Visible','off');
           end
           % If the label column is activated display it
           if data(1,i).label.op.disp == true
                set(marker_vis{i,4},'Visible','on')
           end
       end
% Change position
posy = posy - 0.10;
end

%% 03c Create a button for displaying or exporting the legend

% Create label font button
symbset_legfig = uicontrol('Style','pushbutton',...
                           'Units','normalized','Position',[0.03 0.01 0.3 0.06],...
                           'Parent',symbset_ov,...
                           'String','Legend',...
                           'Tag','fig',...
                           'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                           'HorizontalAlignment','center',...
                           'Fontsize',10,'FontWeight','bold',...
                           'ToolTipString','Click to change label font',...
                           'Callback',@legend_callback,...
                           'Visible','on');
symbset_legpng = uicontrol('Style','pushbutton',...
                           'Units','normalized','Position',[0.35 0.01 0.3 0.06],...
                           'Parent',symbset_ov,...
                           'String','PNG',...
                           'Tag','png',...
                           'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                           'HorizontalAlignment','center',...
                           'Fontsize',10,'FontWeight','bold',...
                           'ToolTipString','Click to change label font',...
                           'Callback',@legend_callback,...
                           'Visible','off');
symbset_legpdf = uicontrol('Style','pushbutton',...
                           'Units','normalized','Position',[0.68 0.01 0.3 0.06],...
                           'Parent',symbset_ov,...
                           'String','EPS',...
                           'Tag','eps',...
                           'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                           'HorizontalAlignment','center',...
                           'Fontsize',10,'FontWeight','bold',...
                           'ToolTipString','Click to change label font',...
                           'Callback',@legend_callback,...
                           'Visible','off');
set([symbset_legpng,symbset_legfig,symbset_legpdf],'Visible','On')
                       
%% 04a Panel symbol/label setup

symbset = uipanel('Title','Marker / Label Setup','TitlePosition','centertop',...
                  'Units','normalized','Position',[0.84 0.33 0.15 0.57],...
                  'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                  'TitlePosition','lefttop',...
                  'Fontsize',12,'FontWeight','Bold',...
                  'Visible','Off');
              
%% 04b Create symbol setup

% Create checkbox to override marker column
symbset_symbcolcheck = uicontrol('Style','checkbox',...
                               'Units','normalized','Position',[0.10 0.95 0.80 0.04],...
                               'Parent',symbset,...
                               'Value',false,...
                               'String','Override marker column!',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                               'Fontsize',10,'FontWeight','Bold',...
                               'ToolTipString','Display label with data',...
                               'Callback',@symbcolcheck_callback,...
                               'Visible','off');
% Create table to display the marker columns
symbset_symbcoltab = uitable('Parent',symbset,'Data',[],...
                             'Units','normalized','Position',[0.005 0.51 0.99 0.44],...
                             'FontSize',8,...
                             'ColumnName',{'Marker','MarkerSize','EdgeColor','FaceColor','EdgeWidth'},...
                             'ColumnFormat',{'char'},...
                             'ColumnEditable',false,...
                             'ColumnWidth',{55},...
                             'Visible','off');
if data(1,1).symbol.op.op == true
    % Get the size of current dataset
    [ssm,~] = size(data(1,1).dat.Samples); 
    % Handle table
    % Preallocate cell array for table data
    symbdata = cell(ssm,5); 
    % Create new table data
    % assignin('base','symbol',data(1,1).symbol); % Control code 
    % assignin('base','ssm',size(data(1,1).dat.Samples)); % Control code 
    for i = 1:ssm
    symbdata{i,1} = sprintf('%.0f',data(1,1).symbol.symbol(i,1));
    symbdata{i,2} = sprintf('%.1f',data(1,1).symbol.size(i,1));
    symbdata{i,3} = sprintf('%.1f/%.1f/%.1f',data(1,1).symbol.mec{i,1}(1,1),data(1,1).symbol.mec{i,1}(1,2),data(1,1).symbol.mec{i,1}(1,3));
    symbdata{i,4} = sprintf('%.1f/%.1f/%.1f',data(1,1).symbol.mfc{i,1}(1,1),data(1,1).symbol.mfc{i,1}(1,2),data(1,1).symbol.mfc{i,1}(1,3));
    symbdata{i,5} = sprintf('%.1f',data(1,1).symbol.edgew(i,1));
    end
    set(symbset_symbcoltab,'Data',symbdata,'RowName',data(1,1).dat.Samples)
end
% Create preview header
symbset_symbprehead = uicontrol('Style','text',...
                               'Units','normalized','Position',[0.005 0.92 0.99 0.03],...
                               'Parent',symbset,...
                               'String','Preview:',...
                               'HorizontalAlignment','center',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                               'Fontsize',10,'FontWeight','Bold',...
                               'ToolTipString','Marker and label preview (not scaled)',...
                               'Visible','off');
% Create axes object for marker and label preview preview
symbset_symbax = axes('Parent',symbset,'Position',[0.1 0.78 0.80 0.13],...
                      'XLim',[0 1],'YLim',[0 1],'Color','none');
                  
if data(1,1).symbol.op.op == false
% Plot marker preview
symbset_symbpre = plot(0.5,0.5,'Parent',symbset_symbax,...
                               'Marker',markerid(data(1,1).symbol.symbol),...
                               'MarkerSize',data(1,1).symbol.size,...
                               'MarkerEdgeColor',data(1,1).symbol.mec,...
                               'MarkerFaceColor',data(1,1).symbol.mfc,...
                               'Visible','on');
else
% Plot marker preview
symbset_symbpre = plot(0.5,0.5,'Parent',symbset_symbax,...
                               'Marker',markerid(data(1,1).symbol.symbol(1,1)),...
                               'MarkerSize',data(1,1).symbol.size(1,:),...
                               'MarkerEdgeColor',data(1,1).symbol.mec{1,:},...
                               'MarkerFaceColor',data(1,1).symbol.mfc{1,:},...
                               'Visible','on');
end

% assignin('base','label',data(1,1).label); % Control element 
if data(1,1).label.op.op == false
% Plot label preview
symbset_symblabel = text(0.5,0.5,data(1,1).dat.Samples{1,1},...
                                 'FontName',data(1,1).label.FontName,...
                                 'FontWeight',data(1,1).label.FontWeight,...
                                 'FontAngle',data(1,1).label.FontAngle,...
                                 'FontSize',data(1,1).label.FontSize,...
                                 'Color',data(1,1).label.Color,...
                                 'FontUnits',data(1,1).label.FontUnits,...
                                 'VerticalAlignment',data(1,1).label.VertAlign,...
                                 'HorizontalAlignment',data(1,1).label.HoriAlign,...
                                 'Visible','off');
else
% Plot label preview
symbset_symblabel = text(0.5,0.5,data(1,1).dat.Samples{1,1},...
                                 'FontName',data(1,1).label.FontName{1,1},...
                                 'FontWeight',data(1,1).label.FontWeight{1,1},...
                                 'FontAngle',data(1,1).label.FontAngle{1,1},...
                                 'FontSize',data(1,1).label.FontSize(1,1),...
                                 'Color',data(1,1).label.Color{1,:},...
                                 'FontUnits',data(1,1).label.FontUnits{1,1},...
                                 'VerticalAlignment',data(1,1).label.VertAlign{1,1},...
                                 'HorizontalAlignment',data(1,1).label.HoriAlign{1,1},...
                                 'Visible','off'); %#ok<*ST2NM>
end
% Set the axis of the object off
set(symbset_symbax,'box','off'); axis([0 1 0 1]); axis off;
% Create title symbol size slider
symbset_symbslisiztit = uicontrol('Style','text',...
                             'Units','normalized','Position',[0.05 0.67 0.4 0.04],...
                             'Parent',symbset,...
                             'String','Marker Size',...
                             'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                             'HorizontalAlignment','center',...
                             'ToolTipString','Setup marker size',...
                             'Fontsize',10,'FontWeight','Bold',...
                             'Visible','off');
% Create slider for symbol size
symbset_symbslisiz = uicontrol('Style','slider',...
                            'Units','normalized','Position',[0.05 0.625 0.4 0.04],...
                            'Parent',symbset,...
                            'Min',1,'Max',30,...
                            'Value',data(1,1).symbol.size(1,1),...
                            'SliderStep',[1/58 4/58],...
                            'ToolTipString','Click to change marker size',...
                            'Callback',@symbsli_callback,...
                            'Visible','off');
% Create slider text
symbset_symbslisiztxt = uicontrol('Style','text',...
                               'Units','normalized','Position',[0.05 0.58 0.4 0.04],...
                               'Parent',symbset,...
                               'String',sprintf('%.1f pt.',data(1,1).symbol.size(1,1)),...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                               'HorizontalAlignment','center',...
                               'ToolTipString','Current marker size',...
                               'Fontsize',10,'FontWeight','Bold',...
                               'Visible','off');
% Create title for edge line width slider
symbset_symbsliedgtit = uicontrol('Style','text',...
                               'Units','normalized','Position',[0.55 0.67 0.4 0.04],...
                               'Parent',symbset,...
                               'String','Edge Width',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                               'HorizontalAlignment','center',...
                               'ToolTipString','Setup marker edge width',...
                               'Fontsize',10,'FontWeight','Bold',...
                               'Visible','off');
% Create slider for line width
symbset_symbsliedg = uicontrol('Style','slider',...
                               'Units','normalized','Position',[0.55 0.625 0.4 0.04],...
                               'Parent',symbset,...
                               'Min',0.1,'Max',6,...
                               'Value',data(1,1).symbol.edgew(1,1),...
                               'SliderStep',[1/59 5/59],...
                               'ToolTipString','Click to change marker edge width',...
                               'Callback',@symbsliedg_callback,...
                               'Visible','off');
% Create slider text
symbset_symbsliedgtxt = uicontrol('Style','text',...
                                  'Units','normalized','Position',[0.55 0.58 0.4 0.04],...
                                  'Parent',symbset,...
                                  'String',sprintf('%.1f pt.',data(1,1).symbol.edgew(1,1)),...
                                  'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                  'HorizontalAlignment','center',...
                                  'ToolTipString','Current marker edge width',...
                                  'Fontsize',10,'FontWeight','Bold',...
                                  'Visible','off');
% Create popup for symbol type selection
symbset_symbpop = uicontrol('Style','popup',...
                            'Parent',symbset,'Units','Normalized',...
                            'Value',data(1,1).symbol.symbol(1,1),'Position',[0.20 0.72 0.6 0.05],...
                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                            'String',...
                           {'Circle' ... % 1
                            'Square' ... % 2
                            'Diamond' ... % 3
                            'Triangle (normal)' ... % 4
                            'Triangle (inverted)' ... % 5
                            'Triangle (right)' ... % 6
                            'Triangle (left)' ... % 7
                            'Pentagon' ... % 8
                            'Hexagon'... % 9
                            'Plus' ... % 10
                            'Cross' ... % 11
                            'Asterisk'... % 12
                            'Point'},... % 13
                            'ToolTipString','Click to change marker',...
                            'Callback',@symbpop_callback,...
                            'Visible','off');
% Create edge color button
symbset_symbmecbut = uicontrol('Style','pushbutton',...
                               'Units','normalized','Position',[0.53 0.50 0.44 0.07],...
                               'Parent',symbset,...
                               'String','Edge Color',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                               'HorizontalAlignment','center',...
                               'Fontsize',10,'FontWeight','bold',...
                               'ToolTipString','Click to change marker edge color',...
                               'Callback',@symbmec_callback,...
                               'Visible','off');
% Create face color button
symbset_symbmfcbut = uicontrol('Style','pushbutton',...
                               'Units','normalized','Position',[0.03 0.50 0.44 0.07],...
                               'Parent',symbset,...
                               'String','Face Color',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                               'HorizontalAlignment','center',...
                               'Fontsize',10,'FontWeight','bold',...
                               'ToolTipString','Click to change marker face color',...
                               'Callback',@symbmfc_callback,...
                               'Visible','off');
if data(1,1).symbol.op.op == true
% Make the table and option visible
set([symbset_symbcolcheck symbset_symbcoltab],'Visible','on')
else
% Make the objects visible
set([symbset_symbprehead symbset_symbax],'Visible','on')
set([symbset_symbslisiztit symbset_symbslisiz symbset_symbslisiztxt],'Visible','on')
set([symbset_symbsliedgtit symbset_symbsliedg symbset_symbsliedgtxt],'Visible','on')
set([symbset_symbpop symbset_symbmecbut symbset_symbmfcbut],'Visible','on')
% Set the axis of the object off
set(symbset_symbax,'box','off'); axis([0 1 0 1]); axis off;
end

%% 04c Create elements for label setup

% Create popup for font selection
symbset_labelcolcheck = uicontrol('Style','checkbox',...
                                  'Units','normalized','Position',[0.10 0.45 0.80 0.04],...
                                  'Parent',symbset,...
                                  'Value',false,...
                                  'String','Override label column!',...
                                  'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],... 
                                  'Fontsize',10,'FontWeight','Bold',...
                                  'ToolTipString','Display label with data',...
                                  'Callback',@labelcolcheck_callback,...
                                  'Visible','off');
% Create table to display the marker columns
symbset_labelcoltab = uitable('Parent',symbset,'Data',[],...
                             'Units','normalized','Position',[0.001 0.01 0.99 0.39],...
                             'FontSize',8,...
                             'ColumnName',{'Font','Size','Color','Weight','Angle','VerticalAlignment','HorizontalAlignment','Unit'},...
                             'ColumnFormat',{'char'},...
                             'ColumnEditable',false,...
                             'ColumnWidth',{55},...
                             'Visible','off');
if data(1,1).label.op.op == true
    % Get the size of current dataset
    [ssm,~] = size(data(1,1).dat.Samples); 
    % Handle table
    % Preallocate cell array for table data
    labeldata = cell(ssm,8); 
    % Create new table data
    for i = 1:ssm
    labeldata{i,1} = sprintf('%s',data(1,1).label.FontName{i,1});
    labeldata{i,2} = sprintf('%.1f',data(1,1).label.FontSize(i,1));
    labeldata{i,3} = sprintf('%.1f/%.1f/%.1f',data(1,1).label.Color{i,1}(1,1),data(1,1).label.Color{i,1}(1,2),data(1,1).label.Color{i,1}(1,3));
    labeldata{i,4} = sprintf('%s',data(1,1).label.FontWeight{i,1});
    labeldata{i,5} = sprintf('%s',data(1,1).label.FontAngle{i,1});
    labeldata{i,6} = sprintf('%s',data(1,1).label.VertAlign{i,1});
    labeldata{i,7} = sprintf('%s',data(1,1).label.HoriAlign{i,1});
    labeldata{i,8} = sprintf('%s',data(1,1).label.FontUnits{i,1});
    end
    set(symbset_labelcoltab,'Data',labeldata,'RowName',data(1,1).dat.Samples)
end
% Create popup for font selection
symbset_labelcheck = uicontrol('Style','checkbox',...
                               'Units','normalized','Position',[0.10 0.4 0.80 0.04],...
                               'Parent',symbset,...
                               'Value',data(1,1).label.op.op,...
                               'String','Show labels?',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],... 
                               'Fontsize',10,'FontWeight','Bold',...
                               'ToolTipString','Display label with data',...
                               'Callback',@labelcheck_callback,...
                               'Visible','off');
% Create label font button
symbset_labelbut = uicontrol('Style','pushbutton',...
                               'Units','normalized','Position',[0.53 0.14 0.44 0.07],...
                               'Parent',symbset,...
                               'String','Font Setup',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                               'HorizontalAlignment','center',...
                               'Fontsize',10,'FontWeight','bold',...
                               'ToolTipString','Click to change label font',...
                               'Callback',@labelbut_callback,...
                               'Visible','off');
% Create label color button
symbset_labelcolorbut = uicontrol('Style','pushbutton',...
                               'Units','normalized','Position',[0.53 0.04 0.44 0.07],...
                               'Parent',symbset,...
                               'String','Font Color',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                               'HorizontalAlignment','center',...
                               'Fontsize',10,'FontWeight','bold',...
                               'ToolTipString','Click to change label font color',...
                               'Callback',@labelcolorbut_callback,...
                               'Visible','off');
% Create buttongroup for label position
symbset_labelpos = uibuttongroup('Title','Position','TitlePosition','centertop',...
                                 'Units','normalized','Position',[0.03 0.04 0.44 0.20],...
                                 'Parent',symbset,...
                                 'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                 'Fontsize',10,'FontWeight','Bold',...
                                 'Visible','off');
% Preallocate cell array for label position
symbset_labelpos_check = cell(3,3);
% Setup the initial position for loop
stposx = 0.1; stposy = 0.7; 
% Create radio buttons for label position
for i = 1:3
    for j = 1:3
    symbset_labelpos_check{i,j} = uicontrol('Style','Radio','String','',...
                                            'Units','normalized','Position',[stposx stposy 0.2 0.2],...
                                            'Parent',symbset_labelpos,'Visible','on',...
                                            'FontSize',14,'FontWeight','Bold',...
                                            'Tag',sprintf('%s%s',num2str(j),num2str(i)),...
                                            'ToolTipString','Click to change label position',...
                                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8]);
    stposx = stposx + 0.3;
    end
stposx = 0.1; stposy = stposy - 0.3;
end
% Define callback and position for label position buttongroup
set(symbset_labelpos,'SelectionChangeFcn',@labelpos_callback,'SelectedObject',symbset_labelpos_check{2,2})



% Label checkbox is always visible
set(symbset_labelcheck,'Visible','on');
% Make object visible dependent on if a label column exists
if data(1,1).label.op.op
    % Make the table and override option visible
    set([symbset_labelcolcheck symbset_labelcoltab],'Visible','on');
else
    % Show options if label operator is true
    if data(1,1).label.op.disp
        set(symbset_symblabel,'Visible','on');
        set([symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','on')
    end
end

%% 05a Panel for plot font setup panel

% Create the panel
fontset = uipanel('Title','Font Setup','TitlePosition','centertop',...
                     'Units','normalized','Position',[0.84 0.17 0.15 0.15],...
                     'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                     'TitlePosition','lefttop',...
                     'Fontsize',12,'FontWeight','Bold',...
                     'Visible','On');
                 
%% 05b Font setup

% Create popup for font selection
fontset_fontpop = uicontrol('Style','popup',...
                               'Units','normalized','Position',[0.03 0.67 0.44 0.1],...
                               'Parent',fontset,...
                               'Value',1,...
                               'String',{'Font #1' 'Font #2' 'Font #3' 'Font #4'...
                               'Font #5' 'Font #6' 'Font #7' 'Font #8' 'Font #9'},...
                               'BackgroundColor',[0.0,0.0,0.0],'ForegroundColor',[1. 1. 1.],... 
                               'Fontsize',10,'FontWeight','Bold',...
                               'Callback',@fontpop_callback);
% Create preview header line
uicontrol('Style','text',...
          'Units','normalized','Position',[0.53 0.86 0.44 0.13],...
          'Parent',fontset,...
          'String','Preview:',...
          'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
          'HorizontalAlignment','center',...
          'Fontsize',10,'FontWeight','Bold');
% Create preview
fontset_fontpre = uicontrol('Style','text',...
                               'Units','normalized','Position',[0.53 0.45 0.44 0.35],...
                               'Parent',fontset,...
                               'String','AaBbCc',...
                               'FontName',control.setup.fonts(1).FontName,...
                               'ForegroundColor',control.setup.fonts(1).Color,...
                               'BackgroundColor',[0.8,0.8,0.8],...
                               'HorizontalAlignment','center',...
                               'FontSize',control.setup.fonts(1).FontSize,...
                               'FontWeight',control.setup.fonts(1).FontWeight,...
                               'FontAngle',control.setup.fonts(1).FontAngle);
% Create font setup button
fontset_fontbut = uicontrol('Style','pushbutton',...
                               'Units','normalized','Position',[0.03 0.09 0.44 0.30],...
                               'Parent',fontset,...
                               'String','Font Setup',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                               'HorizontalAlignment','center',...
                               'Fontsize',10,'FontWeight','bold',...
                               'Callback',@fontbut_callback);
set(fontset_fontbut,'Visible','on')
% Create font color button
fontset_fontcolbut = uicontrol('Style','pushbutton',...
                               'Units','normalized','Position',[0.53 0.09 0.44 0.30],...
                               'Parent',fontset,...
                               'String','Font Color',...
                               'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                               'HorizontalAlignment','center',...
                               'Fontsize',10,'FontWeight','bold',...
                               'Callback',@fontcolorbut_callback);
set(fontset_fontcolbut,'Visible','on')

%% 05c Panel for plot line setup panel

% Create the panel
lineset = uipanel('Title','Line Setup','TitlePosition','centertop',...
                     'Units','normalized','Position',[0.84 0.01 0.15 0.15],...
                     'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                     'TitlePosition','lefttop',...
                     'Fontsize',12,'FontWeight','Bold',...
                     'Visible','On');
                 
%% 05d Line setup

% Create popup for line selection
lineset_linepop = uicontrol('Style','popup',...
                           'Units','normalized','Position',[0.03 0.78 0.44 0.1],...
                           'Parent',lineset,...
                           'Value',1,...
                           'String',{'Line #1' 'Line #2' 'Line #3' 'Line #4'...
                           'Line #5' 'Line #6' 'Line #7' 'Line #8' 'Line #9'},...
                           'BackgroundColor',[0.0,0.0,0.0],'ForegroundColor',[1. 1. 1.],... 
                           'Fontsize',10,'FontWeight','Bold',...
                           'Callback',@linepop_callback);
% Create preview header
uicontrol('Style','text',...
          'Units','normalized','Position',[0.53 0.86 0.44 0.13],...
          'Parent',lineset,...
          'String','Preview:',...
          'HorizontalAlignment','center',...
          'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
          'Fontsize',10,'FontWeight','Bold');
% Create preview      
lineset_lineax = axes('Parent',lineset,'Position',[0.53 0.75 0.44 0.1],...
                           'XLim',[0 1],'YLim',[0 1],'Color','none');
lineset_linepre = line([0 1],[0.5 0.5],'Parent',lineset_lineax,'Marker','none',...
                                           'LineStyle',control.setup.lines(1).LineStyle,...
                                           'LineWidth',control.setup.lines(1).LineWidth,...
                                           'Color',control.setup.lines(1).Color);
set(lineset_lineax,'box','off'); axis off;
% Header for line width slider
uicontrol('Style','text',...
          'Units','Normalized','Position',[0.03 0.45 0.44 0.15],...
          'Parent',lineset,...
          'String','Line Width',...
          'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
          'HorizontalAlignment','center',...
          'Fontsize',10,'FontWeight','Bold');
% Create slider for line width
lineset_linesli = uicontrol('Style','slider',...
                           'Units','normalized','Position',[0.03 0.25 0.44 0.15],...
                           'Parent',lineset,...
                           'Min',0.1,'Max',6,...
                           'Value',control.setup.lines(1).LineWidth,...
                           'SliderStep',[1/59 5/59],...
                           'Callback',@linesli_callback);
% Create slider text
lineset_lineslitxt = uicontrol('Style','text',...
                              'Units','normalized','Position',[0.03 0.05 0.44 0.15],...
                              'Parent',lineset,...
                              'String',sprintf('%.1f pt.',control.setup.lines(1).LineWidth),...
                              'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                              'HorizontalAlignment','center',...
                              'Fontsize',10,'FontWeight','Bold');
% Create line color button
lineset_linecolbut = uicontrol('Style','pushbutton',...
                              'Units','normalized','Position',[0.53 0.05 0.44 0.3],...
                              'Parent',lineset,...
                              'String','Line Color',...
                              'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],...
                              'HorizontalAlignment','center',...
                              'Fontsize',10,'FontWeight','bold',...
                              'Callback',@linecolbut_callback);
set(lineset_linecolbut,'Visible','on');
% Create popup for line style selection
lineset_linestylepop = uicontrol('Style','popup',...
                                'Units','normalized','Position',[0.53 0.55 0.44 0.10],...
                                'Parent',lineset,...
                                'Value',lineid(control.setup.lines,1),...
                                'String',{'Solid' 'Dashed' 'Dotted' 'Dash-Dot'},...
                                'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1. 1. 1.],... 
                                'Fontsize',10,'FontWeight','Bold',...
                                'Callback',@linestylepop_callback);
set(lineset_linestylepop,'Visible','on');

%% 06a Buttongroup for plot selection

% Create a panel for plot selection
plotset = uipanel('Title','Plots','TitlePosition','centertop',...
                  'Units','normalized','Position',[0.01 0.12 0.21 0.52],...
                  'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                  'TitlePosition','lefttop',...
                  'Fontsize',12,'FontWeight','Bold',...
                  'Visible','Off');
             
%% 06b Create elements for plot selection

% Preallocate cell array for radio buttons
plotset_popup = cell(2,1);

% Allocate a cell array
plots.major = cell(1,1);
plots.minor = cell(1,1);
% Go through control.plots structure and create structure for popup windows
counter = 0;
for i = 1:control.plots.m
	% Start to write the first string into plots.major cell array
    if counter == 0
        counter = counter + 1;
        plots.major{counter,1} = control.plots.list{i,6};
        plots.minor{counter,1} = control.plots.list(strcmpi(plots.major{counter,1},control.plots.list(:,6)),11);
    % Compare each following string with current plots.major cell array and
    % write data if they do not match
    elseif sum(strcmpi(control.plots.list{i,6},plots.major)) == false
        counter = counter + 1;
        plots.major{counter,1} = control.plots.list{i,6};
        plots.minor{counter,1} = control.plots.list(strcmpi(plots.major{counter,1},control.plots.list(:,6)),11);
    end
end
% Add Plot-O-Mat and MULTIPLE to plot selections
[m_pmaj,~] = size(plots.major); plots.major{m_pmaj+1,1} = 'PLOT-O-MAT'; plots.major{m_pmaj+2,1} = 'MULTIPL';
[m_pmin,~] = size(plots.minor); plots.minor{m_pmin+1,1} = 'PLOT-O-MAT'; plots.minor{m_pmin+2,1} = 'MULTIPL';

% #1 Popup - Plot type
posy = 0.90; 
plotset_popup{1,1} = uicontrol('Style','popupmenu',...
                              'Units','normalized','Position',[0.05,posy,0.9,0.08],...
                              'Parent',plotset,...
                              'String',plots.major,'Value',1,...
                              'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,1.0,1.0],...
                              'HorizontalAlignment','left',...
                              'Fontsize',10,...
                              'FontWeight','Bold',...
                              'Callback',@plotset_popup1_callback);
% #2 Popup - Plot names
posy = posy - 0.09;
plotset_popup{2,1} = uicontrol('Style','popupmenu',...
                              'Units','normalized','Position',[0.05,posy,0.9,0.08],...
                              'Parent',plotset,...
                              'String',plots.minor{1,1},'Value',1,...
                              'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,1.0,1.0],...
                              'HorizontalAlignment','left',...
                              'Fontsize',10,...
                              'FontWeight','Bold',...
                              'Callback',@plotset_popup2_callback);

                         
% #3 Create axis information on panel
plotset_info = cell(5,3);
% Axis titles for #3a
plotset_info_str = {'X-Axis','Y-Axis','Z-Axis'};
% Create data for the first plot (see #3c-e)
for i = 1:3
    if i==3 && strcmpi(control.plots.list{1,2},'ternary') == false
        plotset_info_head = {control.plots.list{1,3}{1,1},control.plots.list{1,3}{2,1},''};
        plotset_info_unit = {control.plots.list{1,4}{1,1},control.plots.list{1,4}{2,1},''};
        plotset_info_lims = {control.plots.list{1,5}{1,1},control.plots.list{1,5}{2,1},''};
    elseif strcmpi(control.plots.list{1,2},'ternary') == true
        plotset_info_head = {control.plots.list{1,3}{1,1},control.plots.list{1,3}{2,1},control.plots.list{1,3}{3,1}};
        plotset_info_unit = {control.plots.list{1,4}{1,1},control.plots.list{1,4}{2,1},control.plots.list{1,4}{3,1}};
        plotset_info_lims = {control.plots.list{1,5}{1,1},control.plots.list{1,5}{2,1},control.plots.list{1,5}{3,1}}; 
    end
end

% #3a Create the axis header
posy = 0.72; posx = 0.025;
for i = 1:3
    % Header lines
    plotset_info{1,i} = uicontrol('Style','text',...
                                  'Units','normalized','Position',[posx,posy,0.3,0.05],...
                                  'Parent',plotset,...
                                  'String',plotset_info_str{1,i},...
                                  'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                                  'HorizontalAlignment','center',...
                                  'Fontsize',12,'FontWeight','Bold','Visible','Off');
     if i == 3 && strcmpi(control.plots.list{1,2},'ternary')
         set(plotset_info{1,i},'Visible','On');
     elseif i < 3
         set(plotset_info{1,i},'Visible','On')                           
     end
    % Update position
    posx = posx + 0.325;
end

% #3b Underline for the header
posy = 0.715; posx = 0.025;
for i = 1:3
    % Underlines
    plotset_info{2,i} = uicontrol('Style','text',...
                                  'Units','normalized','Position',[posx,posy,0.3,0.005],...
                                  'Parent',plotset,...
                                  'String','',...
                                  'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.0,.0,.0],...
                                  'HorizontalAlignment','center',...
                                  'Fontsize',12,'FontWeight','Bold','Visible','Off');
     if i == 3 && strcmpi(control.plots.list{1,2},'ternary')
         set(plotset_info{2,i},'Visible','On');
     elseif i < 3
         set(plotset_info{2,i},'Visible','On')                           
     end
    % Update position
    posx = posx + 0.325;
end

% #3c Show the axes units
posy = 0.65; posx = 0.025;
for i = 1:3
    % Axes headers
    plotset_info{3,i} = uicontrol('Style','text',...
                                  'Units','normalized','Position',[posx,posy,0.3,0.05],...
                                  'Parent',plotset,...
                                  'String',plotset_info_head{1,i},...
                                  'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                                  'HorizontalAlignment','center',...
                                  'Fontsize',11,'FontWeight','Bold','Visible','Off',...
                                  'ToolTipString',sprintf('Values on %s',plotset_info_str{1,i}));
     if i == 3 && strcmpi(control.plots.list{1,2},'ternary')
         set(plotset_info{3,i},'Visible','On');
     elseif i < 3
         set(plotset_info{3,i},'Visible','On')                           
     end
    % Update position
    posx = posx + 0.325;
end

% #3d Show the axes units
posy = 0.60; posx = 0.025;
for i = 1:3
    % Units
    plotset_info{4,i} = uicontrol('Style','text',...
                                  'Units','normalized','Position',[posx,posy,0.3,0.05],...
                                  'Parent',plotset,...
                                  'String',sprintf('in %s',plotset_info_unit{1,i}),...
                                  'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                                  'HorizontalAlignment','center',...
                                  'Fontsize',11,'FontWeight','Bold','Visible','Off',...
                                  'ToolTipString',sprintf('Unit of %s',plotset_info_str{1,i}));
     if i == 3 && strcmpi(control.plots.list{1,2},'ternary')
         set(plotset_info{4,i},'Visible','On');
     elseif i < 3
         set(plotset_info{4,i},'Visible','On')                           
     end
    % Update position
    posx = posx + 0.325;
end

%  #3 Show the axes limitatioes
posy = 0.54; posx = 0.025;
for i = 1:3
    % Axes Lim
    plotset_info{5,i} = uicontrol('Style','edit',...
                                  'Units','normalized','Position',[posx,posy,0.3,0.05],...
                                  'Parent',plotset,...
                                  'String',plotset_info_lims{1,i},...
                                  'Tag',num2str(i),...
                                  'ForegroundColor',[.0,.0,.0],'BackgroundColor',[1.,1.,1.],...
                                  'HorizontalAlignment','center',...
                                  'Fontsize',11,'FontWeight','Bold','Visible','Off',...
                                  'ToolTipString',sprintf('%s limitations! Enter new values to adjust!',plotset_info_str{1,i}),...
                                  'Callback',@plotset_axeslim_callback);
     if i == 3 && strcmpi(control.plots.list{1,2},'ternary')
         set(plotset_info{5,i},'Visible','On');
     elseif i < 3
         set(plotset_info{5,i},'Visible','On')                           
     end
    % Update position
    posx = posx + 0.325;
end

% Make the panel visible
set(plotset,'Visible','On');

%4 Create buttons for PLOT-O-MAT and MULTIPL
plotset_button1 = uicontrol('Style','pushbutton',...
                            'Units','normalized','Position',[0.05,0.55,0.9,0.2],...
                            'Parent',plotset,...
                            'String','Start PLOT-O-MAT',...
                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                            'HorizontalAlignment','center',...
                            'Fontsize',15,...
                            'FontWeight','Bold',...
                            'Visible','off',...
                            'Callback',@plotset_button_callback);

plotset_button2 = uicontrol('Style','pushbutton',...
                            'Units','normalized','Position',[0.05,0.55,0.9,0.2],...
                            'Parent',plotset,...
                            'String','Start MULTIPLotter',...
                            'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                            'HorizontalAlignment','center',...
                            'Fontsize',15,...
                            'FontWeight','Bold',...
                            'Visible','off',...
                            'Callback',@plotset_button_callback);

%% 07a Buttongroup for plot options

% Create the button group
plotopt = uibuttongroup('Title','Plot Options','TitlePosition','centertop',...
                         'Units','normalized','Position',[0.01 0.01 0.21 0.10],...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'TitlePosition','lefttop',...
                         'Fontsize',12,'FontWeight','Bold',...
                         'Visible','Off');
                     
%% 07b Plot options buttons

% Preallocate cell array for buttons
plotset_optbut = cell (2,3);
% Plot button
plotset_optbut{1,1} = uicontrol('Style','pushbutton',...
                                'Units','normalized','Position',[0.025,0.54,0.30,0.43],...
                                'Parent',plotopt,...
                                'String','Plot',...
                                'Tag','fig',...
                                'ForegroundColor',[.0,.0,.0],'BackgroundColor',[.8,.8,.8],...
                                'HorizontalAlignment','left',...
                                'Callback',@defplot_callback,...
                                'Fontsize',10,'FontWeight','Bold','Visible','On'); 
% Update button  
plotset_optbut{1,2} = uicontrol('Style','pushbutton',...
                                'Units','normalized','Position',[0.350 0.54 0.30 0.43],...
                                'Parent',plotopt,...
                                'String','Update',...
                                'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,0.5,0.0],...
                                'HorizontalAlignment','left',...
                                'Callback',@update_callback,...
                                'Fontsize',10,'FontWeight','Bold','Visible','On'); 
% Clear button  
plotset_optbut{1,3} = uicontrol('Style','pushbutton',...
                                'Units','normalized','Position',[0.675 0.54 0.30 0.43],...
                                'Parent',plotopt,...
                                'String','Clear',...
                                'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                'HorizontalAlignment','left',...
                                'Callback',@plotclear_callback,...
                                'Fontsize',10,'FontWeight','Bold','Visible','On');
% Load button
plotset_optbut{2,1} = uicontrol('Style','pushbutton',...
                                'Units','normalized','Position',[0.025 0.04 0.30 0.43],...
                                'Parent',plotopt,...
                                'String','Export PNG',...
                                'Tag','png',...
                                'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                'HorizontalAlignment','left',...
                                'Fontsize',10,'FontWeight','Bold',...
                                'Callback',@defplot_callback,...
                                'Visible','on');
% Load button
plotset_optbut{2,2} = uicontrol('Style','pushbutton',...
                                'Units','normalized','Position',[0.350 0.04 0.30 0.43],...
                                'Parent',plotopt,...
                                'String','Export EPS',...
                                'Tag','eps',...
                                'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                'HorizontalAlignment','left',...
                                'Fontsize',10,'FontWeight','Bold',...
                                'Callback',@defplot_callback,...
                                'Visible','on');
% Plot button
plotset_optbut{2,3} = uicontrol('Style','pushbutton',...
                                'Units','normalized','Position',[0.675 0.04 0.30 0.43],...
                                'Parent',plotopt,...
                                'String','Misc',...
                                'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                                'HorizontalAlignment','left',...
                                'Fontsize',10,'FontWeight','Bold','Visible','off'); 

% Make the button group visible
set(plotopt,'Visible','On');

%% 08a Create panel for plot preview

% Create panel
plotpre = uipanel('Title','Plot Preview','TitlePosition','centertop',...
                         'Units','normalized','Position',[0.23 0.01 0.60 0.63],...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'TitlePosition','lefttop',...
                         'Fontsize',14,'FontWeight','Bold',...
                         'Visible','On');
                     
%% 08b Create axes object in panel

% Create axes object   
plotax = axes('Parent',plotpre,'Position',[0.15 0.01 0.68 0.98],...
              'XLim',[0 1],'YLim',[0 1],'Color','white');
% Axes setup of axes object
axis(plotax,[0 1 0 1]); set(plotax,'Visible','Off');

%% Callbacks
% In the following text cells all callbacks from the GUI are listed



%% 01 Dataset selection callback

% This callback handles the selection of any radio buttons (datasets) in the 
% main button group
function select_opt_data(~,event)
% 'Downlight' old selection
set(event.OldValue,'ForegroundColor',[.0,.0,.0]);
% 'Highlight' new selection
set(event.NewValue,'ForegroundColor',[.0,.0,.8]);
    % If data all datasets were selected, then show status overview
    if strcmpi(get(event.NewValue,'String'),'All datasets')
        % Make symbol setup and data table invisible
        set([ove_tab symbset],'Visible','Off')
        % Change the size of the table if all datasets was selected
        % Adjust the size of the objects in table panel
        set(ove_tab,'Position',[0.23 0.65 0.60 0.25])
        set(ove_tab_u,'Position',[0.001 0.06 0.99 0.93])
        set(ove_tab_but,'Position',[0.001 0.01 0.99 0.04])
        % Reset checkboxes
        opt_check = true(files_op,1);
        % Make display checkboxes visible
        for I = 1:files_op+1
            if I > 1
            set(opt_check_u{I,1},'Value',opt_check(I-1,1))
            end
            set(opt_check_u{I,1},'Visible','on')
        end
        % Update the markers and label in overview panel
        for I = 1:files_op
           % Create axes object
           marker_vis{I,2} = axes('Parent',symbset_ov,'Position',get(marker_vis{I,2},'Position'),...
                                  'XLim',[0 2],'YLim',[0 1],'Color',[1 0 0]);

           % Show marker if no marker column is available
           if data(1,I).symbol.op.op == true && data(1,I).symbol.op.override == false
           % Show that there is a marker column
           delete(marker_vis{I,3})
           marker_vis{I,3} = text(0.5,0.5,sprintf('...marker columns!'),...
                                          'Parent',marker_vis{I,2},...
                                          'FontSize',7,'FontWeight','Bold',...
                                          'HorizontalAlignment','Center',...
                                          'VerticalAlignment','Middle','Visible','on');
           else
           % Plot the marker
           delete(marker_vis{I,3})
           marker_vis{I,3} = plot(0.5,0.5,'Parent',marker_vis{I,2},...
                                          'Marker',markerid(data(1,I).symbol.symbol),...
                                          'MarkerSize',data(1,I).symbol.size,...
                                          'MarkerEdgeColor',data(1,I).symbol.mec,...
                                          'MarkerFaceColor',data(1,I).symbol.mfc,'Visible','on');
           end
           % Set the axes object invisible
           set(marker_vis{I,2},'box','off'); axis([0 2 0 1]); axis off;
           set(marker_vis{I,2},'Visible','off')
           
           % Change the labels
           if data(1,I).label.op.op == true && data(1,I).label.op.override == false
                set(marker_vis{I,4},'String','...label columns!',...
                                    'Parent',marker_vis{I,2},...
                                    'FontSize',7,'FontWeight','Bold',...
                                    'HorizontalAlignment','Center',...
                                    'VerticalAlignment','Middle',...
                                    'BackgroundColor',[0.8,0.8,0.8],...
                                    'Visible','off');
           else
                set(marker_vis{I,4},'String','AaBbCc',...
                                    'Parent',marker_vis{I,2},...
                                    'Fontname',data(1,I).label.FontName,...
                                    'FontAngle',data(1,I).label.FontAngle,...
                                    'FontSize',data(1,I).label.FontSize,...
                                    'FontWeight',data(1,I).label.FontWeight,...
                                    'Color',data(1,I).label.Color,...
                                    'HorizontalAlignment','Center',...
                                    'VerticalAlignment','Middle',...
                                    'Visible','off');
           end
           % If the label column is activated display it
           if data(1,I).label.op.disp == true
               set(marker_vis{I,4},'Visible','on')
           end
        end
        % Make the overview panel and marker overview visible
        set([ove_vis symbset_ov],'Visible','On')
        % Make the plot preview visible
        set(plotpre,'Visible','On')
    % Else any dataset was selected
    else
        % Get the dataset number from buttongroup
        nr_dataset = str2double(get(event.NewValue,'Tag'));
        % Get the tag from data type selection
        data_type = get(ove_vis_bgt,'SelectedObject'); data_type = get(data_type,'Tag');
        % Update the title of table panel
        if strcmpi(data_type,'raw')
            set(ove_tab,'Title',sprintf('%s  -  %s',control.files{nr_dataset,1},'Raw data'))
        elseif strcmpi(data_type,'norm')
            set(ove_tab,'Title',sprintf('%s  -  %s',control.files{nr_dataset,1},'Normalised data'))
        elseif strcmpi(data_type,'mol')
            set(ove_tab,'Title',sprintf('%s  -  %s',control.files{nr_dataset,1},'Molar data'))
        end
        % Make symbol overview invisible
        set([ove_vis symbset_ov],'Visible','off')
        % Make display checkboxes invisible
        for I = 1:files_op+1
            set(opt_check_u{I,1},'Visible','off')
        end
        % Reset checkboxes and activate the current selection
        opt_check = false(files_op,1); opt_check(nr_dataset,1) = true;
        % Get the size of current dataset
        [dsm,~] = size(data(1,nr_dataset).dat.Samples);
        % Handle table
        % Preallocate cell array for table data
        tabdata = cell(dsm,control.header.m);
        % Create new table data
        for I = 1:control.header.m
            for J = 1:dsm
                if data(1,nr_dataset).(data_type).(control.header.valid{I,1}).Values(J,1) >= 10
                    tabdata{J,I} = sprintf('%.1f',data(1,nr_dataset).(data_type).(control.header.valid{I,1}).Values(J,1));
                elseif data(1,nr_dataset).(data_type).(control.header.valid{I,1}).Values(J,1) < 10 && data(1,nr_dataset).(data_type).(control.header.valid{I,1}).Values(J,1) > 1
                    tabdata{J,I} = sprintf('%.2f',data(1,nr_dataset).(data_type).(control.header.valid{I,1}).Values(J,1));
                else
                    tabdata{J,I} = sprintf('%.4f',data(1,nr_dataset).(data_type).(control.header.valid{I,1}).Values(J,1));
                end
            end
        end
        % Update data table
        [m,~] = size(control.header.valid); col_head = cell(m,1);
        for I = 1:m
            col_head{I,1} = sprintf('%s [%s]',control.header.valid{I,1},data(1,nr_dataset).(data_type).(control.header.valid{I,1}).UnitIn);
        end
        set(ove_tab_u,'Data',tabdata,...
                      'ColumnName',col_head(:,1),...
                      'RowName',data(1,nr_dataset).dat.Samples,...
                      'ColumnFormat',{'char'},...
                      'ColumnEditable',false,...
                      'ColumnWidth',{75});
                  
                  
        % Handle symbol selection
        % Update symbol preview
        if data(1,nr_dataset).symbol.op.op == false || data(1,nr_dataset).symbol.op.override == true
            if data(1,nr_dataset).symbol.op.override == true && data(1,nr_dataset).symbol.op.op == true
                % Change the visibility of marker column objects
                set(symbset_symbcoltab,'Visible','off')
                set(symbset_symbcolcheck,'Visible','on')
                set(symbset_symbcolcheck,'Value',data(1,nr_dataset).symbol.op.override)
            else
                % Make marker column objects visble
                set([symbset_symbcolcheck symbset_symbcoltab],'Visible','off')
            end
            % Update symbol selection popup
            set(symbset_symbpop,'Value',data(1,nr_dataset).symbol.symbol)
            % Update the symbol preview
            set(symbset_symbpre,'Parent',symbset_symbax,'LineStyle','none',...
                                'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                                'MarkerSize',data(1,nr_dataset).symbol.size,...
                                'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                                'MarkerFaceColor',data(1,nr_dataset).symbol.mfc,...
                                'LineWidth',data(1,nr_dataset).symbol.edgew);
            % Update symbol size slider
            set(symbset_symbslisiz,'Value',data(1,nr_dataset).symbol.size); 
            % Update symbol size slider text
            set(symbset_symbslisiztxt,'String',sprintf('%.1f pt.',data(1,nr_dataset).symbol.size));
            % Update symbol line width slider
            set(symbset_symbsliedg,'Value',data(1,nr_dataset).symbol.edgew); 
            % Update symbol line width slider text
            set(symbset_symbsliedgtxt,'String',sprintf('%.1f pt.',data(1,nr_dataset).symbol.edgew));
            % If any symbol without facecolor was selected
                if data(1,nr_dataset).symbol.symbol > 9
                    % Set facecolor button invisible
                    set(symbset_symbmfcbut,'Visible','Off')
                else
                    % Set facecolor button visible
                    set(symbset_symbmfcbut,'Visible','On')
                end
            % Make the objects visible
            set([symbset_symbprehead symbset_symbpre],'Visible','on')
            set([symbset_symbslisiztit symbset_symbslisiz symbset_symbslisiztxt],'Visible','on')
            set([symbset_symbsliedgtit symbset_symbsliedg symbset_symbsliedgtxt],'Visible','on')
            set([symbset_symbpop symbset_symbmecbut symbset_symbmfcbut],'Visible','on')

        else
%             assignin('base','data',data)
%             assignin('base','control',control)
            % Handle table   
            % Get the size of current dataset
            [cssm,~] = size(data(1,nr_dataset).dat.Samples); 
            % Preallocate cell array for table data
            csymbdata = cell(cssm,5);
                % Create new table data
                for I = 1:cssm
                    csymbdata{I,1} = sprintf('%.0f',data(1,nr_dataset).symbol.symbol(I,1));
                    csymbdata{I,2} = sprintf('%.1f',data(1,nr_dataset).symbol.size(I,1));
                    csymbdata{I,3} = sprintf('%.1f/%.1f/%.1f',data(1,nr_dataset).symbol.mec{I,1}(1,1),...
                                                             data(1,nr_dataset).symbol.mec{I,1}(1,2),...
                                                             data(1,nr_dataset).symbol.mec{I,1}(1,3));
                    csymbdata{I,4} = sprintf('%.1f/%.1f/%.1f',data(1,nr_dataset).symbol.mfc{I,1}(1,1),...
                                                             data(1,nr_dataset).symbol.mfc{I,1}(1,2),...
                                                             data(1,nr_dataset).symbol.mfc{I,1}(1,3));
                    csymbdata{I,5} = sprintf('%.1f',data(1,nr_dataset).symbol.edgew(I,1));
                end
            % Update the marker table
            set(symbset_symbcoltab,'Data',csymbdata,'RowName',data(1,1).dat.Samples)
            % Make object marker visble
            set([symbset_symbcolcheck symbset_symbcoltab],'Visible','on')
            set(symbset_symbcolcheck,'Value',data(1,nr_dataset).symbol.op.override)
            % Make the marker objects invisible
            set([symbset_symbprehead symbset_symbax],'Visible','off')
            set([symbset_symbslisiztit symbset_symbslisiz symbset_symbslisiztxt],'Visible','off')
            set([symbset_symbsliedgtit symbset_symbsliedg symbset_symbsliedgtxt],'Visible','off')
            set([symbset_symbpop symbset_symbmecbut symbset_symbmfcbut],'Visible','off')
        end
        
        % Handle the label selection
        % Update the selection of the label operator checkbox
        set(symbset_labelcheck,'Value',data(1,nr_dataset).label.op.disp)
        % Update the selection of the label override checkbox
        set(symbset_labelcolcheck,'Value',data(1,nr_dataset).label.op.override)
        % Handle label selection
        if data(1,nr_dataset).label.op.op == true && data(1,nr_dataset).label.op.override == false
            % Get the size of current dataset
            [cssm,~] = size(data(1,nr_dataset).dat.Samples); 
            % Handle table
            % Preallocate cell array for table data
            labeldata = cell(cssm,8); 
            % Create new table data
                for I = 1:cssm
                    labeldata{I,1} = sprintf('%s',data(1,nr_dataset).label.FontName{I,1});
                    labeldata{I,2} = sprintf('%.1f',data(1,nr_dataset).label.FontSize(I,1));
                    labeldata{I,3} = sprintf('%.1f/%.1f/%.1f',data(1,nr_dataset).label.Color{I,1}(1,1),...
                                                              data(1,nr_dataset).label.Color{I,1}(1,2),...
                                                              data(1,nr_dataset).label.Color{I,1}(1,3));
                    labeldata{I,4} = sprintf('%s',data(1,nr_dataset).label.FontWeight{I,1});
                    labeldata{I,5} = sprintf('%s',data(1,nr_dataset).label.FontAngle{I,1});
                    labeldata{I,6} = sprintf('%s',data(1,nr_dataset).label.VertAlign{I,1});
                    labeldata{I,7} = sprintf('%s',data(1,nr_dataset).label.HoriAlign{I,1});
                    labeldata{I,8} = sprintf('%s',data(1,nr_dataset).label.FontUnits{I,1});
                end
            % Update the table data
            set(symbset_labelcoltab,'Data',labeldata,'RowName',data(1,1).dat.Samples)
            % Make label objects invisible
            set([symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','off')
            % Make objects visible
            set(symbset_labelcolcheck,'Visible','on')
            % Check if the labels are activated
            if data(1,nr_dataset).label.op.disp == true
                set(symbset_labelcoltab,'Visible','on')
            else
                set(symbset_labelcoltab,'Visible','off')  
            end
        % Normal label mode
        else
            set(symbset_symblabel,'FontName',data(1,nr_dataset).label.FontName,...
                                  'FontSize',data(1,nr_dataset).label.FontSize,...
                                  'FontWeight',data(1,nr_dataset).label.FontWeight,...
                                  'FontAngle',data(1,nr_dataset).label.FontAngle,...
                                  'Color',data(1,nr_dataset).label.Color,...
                                  'FontUnits',data(1,nr_dataset).label.FontUnits,...
                                  'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                                  'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);     
            % Get the selected position
            hori = strcmpi(data(1,nr_dataset).label.HoriAlign,{'right';'center';'left'});
            vert = strcmpi(data(1,nr_dataset).label.VertAlign,{'bottom';'middle';'top'});
            % Set label position
            set(symbset_labelpos,'SelectedObject',symbset_labelpos_check{vert,hori})
            % Make label objects invisible
            set([symbset_labelcolcheck symbset_labelcoltab],'Visible','off')
            % Make lalbel objects visible
            if data(1,nr_dataset).label.op.disp == true
                set([symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','on')
                set(symbset_symblabel,'Visible','on')
            else
                set([symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','off')
                set(symbset_symblabel,'Visible','off')
            end
                % Check if the labels are activated
            if data(1,nr_dataset).label.op.op == true
                set(symbset_labelcolcheck,'Visible','on')
            end

        end
        % Finally, make table and symbol panel visible
        set([ove_tab symbset],'Visible','on')
    end
    
    % Change the colour of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0,0.5,0.0])

end

%% 02a Checkbox callback - Handles the display checkboxes

function opt_check_callback(hobj,~)
    % Capture the tag from the used checkbox
    nr_dataset = str2double(get(hobj,'Tag'));
    % Update the opt_check logical array
    opt_check(nr_dataset,1) = logical(get(hobj,'Value'));
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0,0.5,0.0])
end

%% 03a Switch data overview callback - Handle switching the shown headers

% This callback switches the displayed headers
function select_ove_vis(~,event)
    % 'Downlight' old selection
    set(event.OldValue,'ForegroundColor',[.0,.0,.0]);
    % 'Highlight' new selection
    set(event.NewValue,'ForegroundColor',[.0,.0,.8]);
    % Get the tag (1-6) from selected radio button (e.g. 1-22 = 1, 23-44 = 2...)
    current_selection = str2double(get(event.NewValue,'Tag'));
    % Get the tag from data type selection
    data_type = get(ove_vis_bgt,'SelectedObject'); data_type = get(data_type,'Tag');

    % Change the panel within loop
    for I = 1:files_op+1
        if I == 1
            % Change the header line of overview display
            for J = (ove_vis_max*current_selection)-ove_vis_max+1:ove_vis_max*current_selection
                if J <= control.header.m
                    % Handle long labels
                    if strcmpi(control.header.valid{J,1},'Fe2O3tot')
                        current_label = 'Fe2O3*';
                    elseif strcmpi(control.header.valid{J,1},'FeOtot')
                        current_label = 'FeO*';
                    else
                        current_label = control.header.valid{J,1};
                    end
                    set(ove_vis_t{1,J-(ove_vis_max*current_selection)+ove_vis_max},'String',current_label);
                else
                    set(ove_vis_t{1,J-(ove_vis_max*current_selection)+ove_vis_max},'String','');
                end
            end
        else
            % Change the display color, values and tooltipstring of each
            % box
            for J = (ove_vis_max*current_selection)-ove_vis_max+1:ove_vis_max*current_selection
                if J <= control.header.m
                    
                    % If more than 1000 values are available from the data,
                    % create a text to show the approx. no of files
                    no_vals = sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values));
                    if no_vals > 999 && no_vals < 10000
                        no_vals_str = num2str(no_vals);
                        no_vals_str = sprintf('>%sk',no_vals_str(1));
                    elseif no_vals > 9999 && no_vals < 100000
                        no_vals_str = num2str(no_vals);
                        no_vals_str = sprintf('>%sk',no_vals_str(1:2));
                    elseif no_vals > 99999
                        no_vals_str = num2str(no_vals);
                        no_vals_str = sprintf('>%sk',no_vals_str(1:3));
                    else
                        no_vals_str = num2str(no_vals);
                    end
                    
                    % Handle found header values without data
                    if data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 1 && no_vals == 0;
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',no_vals_str,'BackGroundColor',[.8,.8,.0],'Visible','On');
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},...
                                                           'TooltipString',sprintf('%s\n%s values\nHeader entry present in file...\n...but no values found below!',...
                                                           control.header.valid{J,2},...
                                                           num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values)))));
                    % Handle header values with data
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 1 && no_vals > 0;
                        % Change the string and color of the button
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',no_vals_str,'BackGroundColor',[.0,.8,.0],'Visible','On');
                        % Create the Tool Tip String
                        if data(1,I-1).(data_type).(control.header.valid{J,1}).Mean >= 10
                            TIP_STR = sprintf('%s\n%s values\nMax: %.1f %s\nMean: %.1f %s\n Median: %.1f %s\nMin: %.1f %s',...
                                                                control.header.valid{J,2},...
                                                                num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                        elseif data(1,I-1).(data_type).(control.header.valid{J,1}).Mean <= 10 && data(1,I-1).(data_type).(control.header.valid{J,1}).Mean > 1
                            TIP_STR = sprintf('%s\n%s values\nMax: %.2f %s\nMean: %.2f %s\n Median: %.2f %s\nMin: %.2f %s',...
                                                                control.header.valid{J,2},...
                                                                num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                        else
                            TIP_STR = sprintf('%s\n%s values\nMax: %.4f %s\nMean: %.4f %s\n Median: %.4f %s\nMin: %.4f %s',...
                                                                control.header.valid{J,2},...
                                                                num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                        end
                        % Insert the String
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString',TIP_STR);
                    % Handle calculated header values
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 2
                        % Change the string and color of the button
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',no_vals_str,'BackGroundColor',[1.,.5,.0],'Visible','On');
                        % Create the Tool Tip String
                        if sum(strcmpi(data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,{'ratio';'molar ratio'}))
                            if data(1,I-1).(data_type).(control.header.valid{J,1}).Mean >= 10
                                TIP_STR = sprintf('%s\nCalculated from %s\n%s values\nMax: %.1f\nMean: %.1f\n Median: %.1f\nMin: %.1f',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min);
                            elseif data(1,I-1).(data_type).(control.header.valid{J,1}).Mean <= 10 && data(1,I-1).(data_type).(control.header.valid{J,1}).Mean > 1
                                TIP_STR = sprintf('%s\nCalculated from %s\n%s values\nMax: %.2f\nMean: %.2f\n Median: %.2f\nMin: %.2f',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min);
                            else
                                TIP_STR = sprintf('%s\nCalculated from %s\n%s values\nMax: %.4f\nMean: %.4f\n Median: %.4f\nMin: %.4f',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min);
                            end
                        else
                            if data(1,I-1).(data_type).(control.header.valid{J,1}).Mean >= 10
                                TIP_STR = sprintf('%s\nCalculated from %s\n%s values\nMax: %.1f %s\nMean: %.1f %s\n Median: %.1f %s\nMin: %.1f %s',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                            elseif data(1,I-1).(data_type).(control.header.valid{J,1}).Mean <= 10 && data(1,I-1).(data_type).(control.header.valid{J,1}).Mean > 1
                                TIP_STR = sprintf('%s\nCalculated from %s\n%s values\nMax: %.2f %s\nMean: %.2f %s\n Median: %.2f %s\nMin: %.2f %s',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                            else
                                TIP_STR = sprintf('%s\nCalculated from %s\n%s values\nMax: %.4f %s\nMean: %.4f %s\n Median: %.4f %s\nMin: %.4f %s',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                            end
                        end
                        % Insert the String
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString',TIP_STR);

                    % Handle non-existant header values
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 0
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',' - ','BackGroundColor',[.8,.0,.0],'Visible','On');
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString','Header entry not found in file...')
                        
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 3
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',' - ','BackGroundColor',[.8,.0,.0],'Visible','On');
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString',sprintf('This value has been neglected during\nnormalisation and / or molar conversion!'))
                    end
                % Make display invisible if the maximum number of headers
                % is reached
                else
                    set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'Visible','Off')
                end
            end
        end
    end
end

% This callback switches the different data types
function select_ove_norm(~,event)
    % 'Downlight' old selection
    set(event.OldValue,'ForegroundColor',[.0,.0,.0]);
    % 'Highlight' new selection
    set(event.NewValue,'ForegroundColor',[.0,.0,.8]);
    % Get the tag from selected radio button (dat, norm, mol)
    data_type = get(event.NewValue,'Tag');
    % Get the tag (1-6) from selected radio button (e.g. 1-22 = 1, 23-44 = 2...)
    current_selection = get(ove_vis_bg,'SelectedObject'); current_selection = str2double(get(current_selection,'Tag'));
    
    % Change the panel within loop
    for I = 1:files_op+1
        if I == 1
            % Change the header line of overview display
            for J = (ove_vis_max*current_selection)-ove_vis_max+1:ove_vis_max*current_selection
                if J <= control.header.m
                    % Handle long labels
                    if strcmpi(control.header.valid{J,1},'Fe2O3tot')
                        current_label = 'Fe2O3*';
                    elseif strcmpi(control.header.valid{J,1},'FeOtot')
                        current_label = 'FeO*';
                    else
                        current_label = control.header.valid{J,1};
                    end
                    set(ove_vis_t{1,J-(ove_vis_max*current_selection)+ove_vis_max},'String',current_label);
                else
                    set(ove_vis_t{1,J-(ove_vis_max*current_selection)+ove_vis_max},'String','');
                end
            end
        else
            % Change the display color, values and tooltipstring of each
            % box
            for J = (ove_vis_max*current_selection)-ove_vis_max+1:ove_vis_max*current_selection
                if J <= control.header.m
                    
                    % If more than 1000 values are available from the data,
                    % create a text to show the approx. no of files
                    no_vals = sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values));
                    if no_vals > 999 && no_vals < 10000
                        no_vals_str = num2str(no_vals);
                        no_vals_str = sprintf('>%sk',no_vals_str(1));
                    elseif no_vals > 9999 && no_vals < 100000
                        no_vals_str = num2str(no_vals);
                        no_vals_str = sprintf('>%sk',no_vals_str(1:2));
                    elseif no_vals > 99999
                        no_vals_str = num2str(no_vals);
                        no_vals_str = sprintf('>%sk',no_vals_str(1:3));
                    else
                        no_vals_str = num2str(no_vals);
                    end
                    
                    % Handle found header values without data
                    if data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 1 && no_vals == 0;
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',no_vals_str,'BackGroundColor',[.8,.8,.0],'Visible','On');
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},...
                                                           'TooltipString',sprintf('%s\n%s values\nHeader entry present in file...\n...but no values found below!',...
                                                           control.header.valid{J,2},...
                                                           num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values)))));
                    % Handle header values with data
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 1 && no_vals > 0;
                        % Change the string and color of the button
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',no_vals_str,'BackGroundColor',[.0,.8,.0],'Visible','On');
                        % Create the Tool Tip String
                        if data(1,I-1).(data_type).(control.header.valid{J,1}).Mean >= 10
                            tip_str = sprintf('%s\n%s values\nMax: %.1f %s\nMean: %.1f %s\n Median: %.1f %s\nMin: %.1f %s',...
                                                                control.header.valid{J,2},...
                                                                num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                        elseif data(1,I-1).(data_type).(control.header.valid{J,1}).Mean <= 10 && data(1,I-1).(data_type).(control.header.valid{J,1}).Mean > 1
                            tip_str = sprintf('%s\n%s values\nMax: %.2f %s\nMean: %.2f %s\n Median: %.2f %s\nMin: %.2f %s',...
                                                                control.header.valid{J,2},...
                                                                num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                        else
                            tip_str = sprintf('%s\n%s values\nMax: %.4f %s\nMean: %.4f %s\n Median: %.4f %s\nMin: %.4f %s',...
                                                                control.header.valid{J,2},...
                                                                num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                        end
                        % Insert the String
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString',tip_str);
                    % Handle calculated header values
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 2
                        % Change the string and color of the button
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',no_vals_str,'BackGroundColor',[1.,.5,.0],'Visible','On');
                        % Create the Tool Tip String
                        if sum(strcmpi(data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,{'ratio';'molar ratio'}))
                            if data(1,I-1).(data_type).(control.header.valid{J,1}).Mean >= 10
                                tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.1f\nMean: %.1f\n Median: %.1f\nMin: %.1f',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min);
                            elseif data(1,I-1).(data_type).(control.header.valid{J,1}).Mean <= 10 && data(1,I-1).(data_type).(control.header.valid{J,1}).Mean > 1
                                tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.2f\nMean: %.2f\n Median: %.2f\nMin: %.2f',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min);
                            else
                                tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.4f\nMean: %.4f\n Median: %.4f\nMin: %.4f',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min);
                            end
                        else
                            if data(1,I-1).(data_type).(control.header.valid{J,1}).Mean >= 10
                                tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.1f %s\nMean: %.1f %s\n Median: %.1f %s\nMin: %.1f %s',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                            elseif data(1,I-1).(data_type).(control.header.valid{J,1}).Mean <= 10 && data(1,I-1).(data_type).(control.header.valid{J,1}).Mean > 1
                                tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.2f %s\nMean: %.2f %s\n Median: %.2f %s\nMin: %.2f %s',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                            else
                                tip_str = sprintf('%s\nCalculated from %s\n%s values\nMax: %.4f %s\nMean: %.4f %s\n Median: %.4f %s\nMin: %.4f %s',...
                                                                    control.header.valid{J,2},...
                                                                    sprintf(data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_calc),...
                                                                    num2str(sum(isfinite(data(1,I-1).(data_type).(control.header.valid{J,1}).Values))),...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Max,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Mean,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Median,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn,...
                                                                    data(1,I-1).(data_type).(control.header.valid{J,1}).Min,data(1,I-1).(data_type).(control.header.valid{J,1}).UnitIn);
                            end
                        end
                        % Insert the String
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString',tip_str);

                    % Handle non-existant header values
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 0
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',' - ','BackGroundColor',[.8,.0,.0],'Visible','On');
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString','Header entry not found in file...')
                    % Neglected values during normalisation
                    elseif data(1,I-1).(data_type).(control.header.valid{J,1}).headerv_opsum == 3
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'String',' - ','BackGroundColor',[.8,.0,.0],'Visible','On');
                        set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'TooltipString',sprintf('This value has been neglected during\nnormalisation and / or molar conversion!'))
                    end
                % Make display invisible if the maximum number of headers
                % is reached
                else
                    set(ove_vis_u{I,J-(ove_vis_max*current_selection)+ove_vis_max},'Visible','Off')
                end
            end
        end
    end
end

%% 03b Expand/collapse table callback

function expandtable_callback(~,~)
    % Get the current size of the table panel
    current_size = get(ove_tab,'Position'); 
    % Check the size and the adjust it
    if isequal(current_size,[0.23 0.65 0.60 0.25])
        % Make the plot preview visible
        set(plotpre,'Visible','Off')
        % Adjust the size of the objects in table panel
        set(ove_tab,'Position',[0.23 0.01 0.60 0.89])
        set(ove_tab_u,'Position',[0.001 0.02 0.99 0.975])
        set(ove_tab_but,'Position',[0.001 0.005 0.99 0.01],'ToolTipString','Collapse table')
    else
        % Make the plot preview visible
        set(plotpre,'Visible','On')
        % Adjust the size of the objects in table panel
        set(ove_tab,'Position',[0.23 0.65 0.60 0.25])
        set(ove_tab_u,'Position',[0.001 0.06 0.99 0.93])
        set(ove_tab_but,'Position',[0.001 0.01 0.99 0.04],'ToolTipString','Expand table')
    end
end

%% 04 Legend callbacks

% This callback simply overwrite the dataset name, when edit fiels in
% Marker / Label overview panel is used
function datasetname_callback(obj,~)
    % Overwrite name in control legend cell array
    control.legend{str2double(get(obj,'Tag')),1} = get(obj,'String');
end

% This callback displays the legend as figure or export the legend as png /
% pdf
function legend_callback(obj,~)
    % Create and then hide the GUI during the construction process
    leg_fig = figure('Visible','off');
    % Deactivate numbering of the figure
    set(leg_fig,'NumberTitle','off')
    % Set units of the figure to pixel and hide menu bar.
    set(leg_fig,'Units','pixel','MenuBar','none','Pointer','arrow','Renderer','zbuffer'); 
    % Set size and position (absolute pixel) of the figure and set name of the GUI
    set(leg_fig,'OuterPosition',[1000,100,500,files_op*45+30],'Resize','Off','Name','Legend');
    % Set initial Y position and preallocate axes cell array
    posY = 1.0 - (15 / (files_op * 45 + 15)) - (45 / (files_op * 45 + 30)); legend_vis = cell(files_op,1);
    % Create objects on that legend figure
    for I = 1:files_op
        % Create axes object
        legend_vis{I,1} = axes('Parent',leg_fig,'Position',[0.0 posY 1.0 0.2],...
                               'XLim',[0 2],'YLim',[0 1],'Color',[1 0 0],...
                               'Units','Normalized','Visible','On');
                            plot(2.0,0.5,'Parent',legend_vis{I,1},...
                                       'Marker',markerid(data(1,I).symbol.symbol),...
                                       'MarkerSize',data(1,I).symbol.size,...
                                       'MarkerEdgeColor',data(1,I).symbol.mec,...
                                       'MarkerFaceColor',data(1,I).symbol.mfc);
                            text(4.0,0.5,control.legend{I,1},...
                                      'Interpreter','none',...
                                      'Parent',legend_vis{I,1},...
                                      'HorizontalALignment','Left',...
                                      'FontSize',14,'FontWeight','Bold',...
                                      'Color',[0.0,0.0,0.0]);
        set(legend_vis{I,1},'box','off'); axis([0 30 0 1]); axis off;
        posY = posY - (45 / (files_op * 45 + 30));
    end

    if strcmpi(get(obj,'Tag'),'fig')
        % Change the background color of the GUI to black
        set(leg_fig,'Color',[1.0,1.0,1.0],'Visible','On');
    else
        % Change the background color of the GUI to black
        set(leg_fig,'Color',[1.0,1.0,1.0],'PaperPositionMode','auto');
        % Print the figure out
        if strcmpi(get(obj,'Tag'),'png')
            % Open save window to select output file
            [file,path] = uiputfile('*.png','Save legend as portable network graphics!',...
                                            strcat(save_path,'/export/',control.prj_name,'_legend','.png'));
            % Only print if file was selected
            if ischar(file)
                print(leg_fig,fullfile(path,file),'-dpng','-zbuffer','-r500')
            end
        elseif strcmpi(get(obj,'Tag'),'eps')
            % Open save window to select output file
            [file,path] = uiputfile('*.eps','Save legend as encapsuled post script!',...
                                            strcat(save_path,'/export/',control.prj_name,'_legend','.eps'));
            % Only print if file was selected
            if ischar(file)
                print(leg_fig,fullfile(path,file),'-depsc2','-painters')
            end
        end
    end
end

%% 05a Marker callbacks

% Override marker column callback
function symbcolcheck_callback(~,~)
    % Get the current selected dataset
    nr_dataset = str2double(get(get(opt_data,'SelectedObject'),'Tag'));
    % Override the operator
    data(1,nr_dataset).symbol.op.override = get(symbset_symbcolcheck,'Value');
    % Check and handle the input from checkbox
    if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
        % Get the old marker column from temp structure
        current_data = temp(1,nr_dataset).symbol;
        temp(1,nr_dataset).symbol = data(1,nr_dataset).symbol;
        data(1,nr_dataset).symbol = current_data;
        % Set the override operator again
        data(1,nr_dataset).symbol.op.override = false;
        % Make objects visbile / invisible
        set([symbset_symbprehead symbset_symbpre],'Visible','off')
        set([symbset_symbslisiztit symbset_symbslisiz symbset_symbslisiztxt],'Visible','off')
        set([symbset_symbsliedgtit symbset_symbsliedg symbset_symbsliedgtxt],'Visible','off')
        set([symbset_symbpop symbset_symbmecbut symbset_symbmfcbut],'Visible','off')
        set(symbset_symbcoltab,'Visible','on')
    else
        % Buffer marker columns in temp structure
        current_data = temp(1,nr_dataset).symbol;
        temp(1,nr_dataset).symbol = data(1,nr_dataset).symbol;
        data(1,nr_dataset).symbol = current_data;
        % Set the override operator again
        data(1,nr_dataset).symbol.op.override = true; 
        % Update the symbol preview
        set(symbset_symbpre,'Parent',symbset_symbax,'LineStyle','none',...
                            'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                            'MarkerSize',data(1,nr_dataset).symbol.size,...
                            'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                            'MarkerFaceColor',data(1,nr_dataset).symbol.mfc,...
                            'LineWidth',data(1,nr_dataset).symbol.edgew);
        % Make objects visbile / invisible
        set(symbset_symbcoltab,'Visible','off')
        set([symbset_symbprehead symbset_symbpre],'Visible','on')
        set([symbset_symbslisiztit symbset_symbslisiz symbset_symbslisiztxt],'Visible','on')
        set([symbset_symbsliedgtit symbset_symbsliedg symbset_symbsliedgtxt],'Visible','on')
        set([symbset_symbpop symbset_symbmecbut symbset_symbmfcbut],'Visible','on')
        % Handle the display operator
        if data(1,nr_dataset).label.op.disp == false;
        % Hide the table
        set(symbset_symblabel,'Visible','off')
        else
        % Show the table
        set(symbset_symblabel,'Visible','on')
        end
    end
    % Set the operator again
%     data(1,nr_dataset).symbol.op.op = true;
    
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Symbol type popup callback
function symbpop_callback(~,~)
    % Get the current selected dataset
    nr_dataset = get(get(opt_data,'SelectedObject'),'String');
    nr_dataset = str2double(nr_dataset(2));
    % Get the value from current selection
    symbsel = get(symbset_symbpop,'Value');
    % Overwrite old value
    data(1,nr_dataset).symbol.symbol = symbsel;
    % Update symbol preview
    set(symbset_symbpre,'Parent',symbset_symbax,...
                        'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                        'MarkerSize',data(1,nr_dataset).symbol.size,...
                        'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                        'MarkerFaceColor',data(1,nr_dataset).symbol.mfc);                    
    % Make face color invisible/visible for some symbols
    if data(1,nr_dataset).symbol.symbol > 9
        set(symbset_symbmfcbut,'Visible','Off')
    else
        set(symbset_symbmfcbut,'Visible','On')
    end
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Marker size slider callback
function symbsli_callback(~,~)
    % Get the current selected dataset
    nr_dataset = get(get(opt_data,'SelectedObject'),'String');
    nr_dataset = str2double(nr_dataset(2));
    % Get the current value from slider
    sizesel = get(symbset_symbslisiz,'Value');
    % Overwrite old value
    data(1,nr_dataset).symbol.size = sizesel;
    % Update symbol preview
    set(symbset_symbpre,'Parent',symbset_symbax,...
                        'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                        'MarkerSize',data(1,nr_dataset).symbol.size,...
                        'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                        'MarkerFaceColor',data(1,nr_dataset).symbol.mfc,...
                        'LineWidth',data(1,nr_dataset).symbol.edgew);
    % Update the text beneath the slider
    set(symbset_symbslisiztxt,'String',sprintf('%.1f pt.',data(1,nr_dataset).symbol.size));
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Marker edge width slider callback
function symbsliedg_callback(~,~)
    % Get the current selected dataset
    nr_dataset = get(get(opt_data,'SelectedObject'),'String');
    nr_dataset = str2double(nr_dataset(2));
    % Get the current value from slider
    sizesel = get(symbset_symbsliedg,'Value');
    % Overwrite old value
    data(1,nr_dataset).symbol.edgew = sizesel;
    % Update symbol preview
    set(symbset_symbpre,'Parent',symbset_symbax,...
                        'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                        'MarkerSize',data(1,nr_dataset).symbol.size,...
                        'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                        'MarkerFaceColor',data(1,nr_dataset).symbol.mfc,...
                        'LineWidth',data(1,nr_dataset).symbol.edgew);

    % Update the text beneath the slider
    set(symbset_symbsliedgtxt,'String',sprintf('%.1f pt.',data(1,nr_dataset).symbol.edgew));
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Marker edge color callback
function symbmec_callback(~,~)
    % Get the current selected dataset
    nr_dataset = get(get(opt_data,'SelectedObject'),'String');
    nr_dataset = str2double(nr_dataset(2));
    % Select new color
    newcolor = uisetcolor;
    % Get the size of the output element
    [m,~] = size(newcolor');
    % If color was not aborted
    if m == 3
    % Overwrite color
    data(1,nr_dataset).symbol.mec = newcolor;
    % Update symbol preview
    set(symbset_symbpre,'Parent',symbset_symbax,...
                        'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                        'MarkerSize',data(1,nr_dataset).symbol.size,...
                        'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                        'MarkerFaceColor',data(1,nr_dataset).symbol.mfc,...
                        'LineWidth',data(1,nr_dataset).symbol.edgew);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

% Marker face color callback
function symbmfc_callback(~,~)
    % Get the current selected dataset
    nr_dataset = get(get(opt_data,'SelectedObject'),'String');
    nr_dataset = str2double(nr_dataset(2));
    % Select new color
    newcolor = uisetcolor;
    % Get the size of the output element
    [m,~] = size(newcolor');
    % If color was not aborted
    if m == 3
    % Overwrite color
    data(1,nr_dataset).symbol.mfc = newcolor;
    % Update symbol preview
    set(symbset_symbpre,'Parent',symbset_symbax,...
                        'Marker',markerid(data(1,nr_dataset).symbol.symbol),...
                        'MarkerSize',data(1,nr_dataset).symbol.size,...
                        'MarkerEdgeColor',data(1,nr_dataset).symbol.mec,...
                        'MarkerFaceColor',data(1,nr_dataset).symbol.mfc,...
                        'LineWidth',data(1,nr_dataset).symbol.edgew);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

%% 05b Marker label callbacks

% Override label checkboc callback
function labelcolcheck_callback(~,~)
    % Get the current selected dataset
    nr_dataset = str2double(get(get(opt_data,'SelectedObject'),'Tag'));
    % Override the operator
    data(1,nr_dataset).label.op.override = get(symbset_labelcolcheck,'Value');
    % Get the current selection if labels should be shown checkbox
    data(1,nr_dataset).label.op.disp = get(symbset_labelcheck,'Value');
    temp(1,nr_dataset).label.op.disp = get(symbset_labelcheck,'Value');
    % If the label column should be overriden
    if data(1,nr_dataset).label.op.override == true
        % Hide the label column table
        set(symbset_labelcoltab,'Visible','off')
        % Handle the label operator
        if data(1,nr_dataset).label.op.disp == false;
        set([symbset_symblabel symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','off')
        else
        set([symbset_symblabel symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','on')
        end
        % Buffer label column in temp structure
        current_data = temp(1,nr_dataset).label;
        temp(1,nr_dataset).label = data(1,nr_dataset).label;
        data(1,nr_dataset).label = current_data;
        % Set the override operator again
        data(1,nr_dataset).label.op.override = true; temp(1,nr_dataset).label.op.override = false;
    % If the label column should NOT be overriden
    else
        % Hide the label selection objects
        set([symbset_labelbut symbset_labelcolorbut symbset_labelpos],'Visible','off')
        % Set the label operator to true
        if data(1,nr_dataset).label.op.disp == false;
        % Hide the table
        set([symbset_symblabel symbset_labelcoltab],'Visible','off')
        temp(1,nr_dataset).label.op.disp = false;
        else
        % Show the table
        set([symbset_symblabel symbset_labelcoltab],'Visible','on')
        temp(1,nr_dataset).label.op.disp = true;
        end
        % Buffer label column in temp structure
        current_data = temp(1,nr_dataset).label;
        temp(1,nr_dataset).label = data(1,nr_dataset).label;
        data(1,nr_dataset).label = current_data; 
        % Set the override operator again 
        data(1,nr_dataset).label.op.override = false; temp(1,nr_dataset).label.op.override = true;
    end
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Label checkbox used
function labelcheck_callback(~,~)
    % Get the current selected dataset
    nr_dataset = str2double(get(get(opt_data,'SelectedObject'),'Tag'));
    % Get the selection from checkbox
    data(1,nr_dataset).label.op.disp = get(symbset_labelcheck,'Value');
    temp(1,nr_dataset).label.op.disp = get(symbset_labelcheck,'Value');
    % Check if symbol column is available or override is on
    if data(1,nr_dataset).label.op.override == true
        % Change the visibility of label objects
        if data(1,nr_dataset).label.op.disp == true
        % Change the visibility of label objects
        set(symbset_symblabel,'Visible','on')
        set([symbset_labelpos symbset_labelbut symbset_labelcolorbut],'Visible','on')
        else
        % Change the visibility of label objects
    	set(symbset_labelcoltab,'Visible','off')
        set(symbset_symblabel,'Visible','off')
        set([symbset_labelpos symbset_labelbut symbset_labelcolorbut],'Visible','off')
        end
    else
        % Change the visibility of label objects
        if data(1,nr_dataset).label.op.disp == true
        set(symbset_labelcoltab,'Visible','on')
        set(symbset_symblabel,'Visible','on')
        else
        set(symbset_labelcoltab,'Visible','off')
        set(symbset_symblabel,'Visible','off')
        end
        set([symbset_labelpos symbset_labelbut symbset_labelcolorbut],'Visible','off')
    end
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Label button callback
function labelbut_callback(~,~)
    % Get the current selected dataset
    nr_dataset = str2double(get(get(opt_data,'SelectedObject'),'Tag'));
    % Get new fonts
    newfont = uisetfont(data(1,nr_dataset).label);
    % Overwrite font settings if 
    if isstruct(newfont)
    % Overwrite new values in control structure
    data(1,nr_dataset).label.FontName = newfont.FontName;
    data(1,nr_dataset).label.FontWeight = newfont.FontWeight;
    data(1,nr_dataset).label.FontAngle = newfont.FontAngle;
    data(1,nr_dataset).label.FontSize = newfont.FontSize;
    data(1,nr_dataset).label.FontUnits = newfont.FontUnits;
    % Update preview
    set(symbset_symblabel,...
                          'FontName',data(1,nr_dataset).label.FontName,...
                          'FontSize',data(1,nr_dataset).label.FontSize,...
                          'FontWeight',data(1,nr_dataset).label.FontWeight,...
                          'FontAngle',data(1,nr_dataset).label.FontAngle,...
                          'Color',data(1,nr_dataset).label.Color,...
                          'FontUnits',data(1,nr_dataset).label.FontUnits,...
                          'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                          'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

% Label color button callback
function labelcolorbut_callback(~,~)
    % Get the current selected dataset
    nr_dataset = str2double(get(get(opt_data,'SelectedObject'),'Tag'));
    % Get new color
    newcolor = uisetcolor;
    % Get the size of the output element
    [m,~] = size(newcolor');
    % If color was not aborted
    if m == 3
    % Overwrite color
    data(1,nr_dataset).label.Color = newcolor;
    % Update preview
    set(symbset_symblabel,...
                          'FontName',data(1,nr_dataset).label.FontName,...
                          'FontSize',data(1,nr_dataset).label.FontSize,...
                          'FontWeight',data(1,nr_dataset).label.FontWeight,...
                          'FontAngle',data(1,nr_dataset).label.FontAngle,...
                          'Color',data(1,nr_dataset).label.Color,...
                          'FontUnits',data(1,nr_dataset).label.FontUnits,...
                          'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                          'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

% Label position callback
function labelpos_callback(~,event)
    % Get the current selected dataset
    nr_dataset = str2double(get(get(opt_data,'SelectedObject'),'Tag'));
    % Get current selection
    pos = get(event.NewValue,'Tag');
    xpos = {'right';'center';'left'}; 
    x = str2double(pos(1)); hori = xpos{x,1};
    ypos = {'bottom';'middle';'top'}; 
    y = str2double(pos(2)); vert = ypos{y,1};
    % Overwrite old values
    data(1,nr_dataset).label.HoriAlign = hori;
    data(1,nr_dataset).label.VertAlign = vert;
    % Update preview
    set(symbset_symblabel,'FontName',data(1,nr_dataset).label.FontName,...
                          'FontSize',data(1,nr_dataset).label.FontSize,...
                          'FontWeight',data(1,nr_dataset).label.FontWeight,...
                          'FontAngle',data(1,nr_dataset).label.FontAngle,...
                          'Color',data(1,nr_dataset).label.Color,...
                          'FontUnits',data(1,nr_dataset).label.FontUnits,...
                          'VerticalAlignment',data(1,nr_dataset).label.VertAlign,...
                          'HorizontalAlignment',data(1,nr_dataset).label.HoriAlign);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

%% 06 Plot font settings callbacks
% Callback for font popup               
function fontpop_callback(~,~)
    % Get current selection from popup
    fontsel = get(fontset_fontpop,'Value');
    % Update preview
    set(fontset_fontpre,'ForegroundColor',control.setup.fonts(fontsel).Color,...
                        'FontName',control.setup.fonts(fontsel).FontName,...
                        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
                        'FontSize',control.setup.fonts(fontsel).FontSize,...
                        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
                        'FontWeight',control.setup.fonts(fontsel).FontWeight);
end

% Callback for font color button
function fontcolorbut_callback(~,~)
    % Get current selection from popup
    fontsel = get(fontset_fontpop,'Value');
    % Get new color
    newcolor = uisetcolor;
    % Get the size of the output element
    [m,~] = size(newcolor');
    % If color was not aborted
    if m == 3
    % Overwrite color
    control.setup.fonts(fontsel).Color = newcolor;
    % Update preview
    set(fontset_fontpre,'ForegroundColor',control.setup.fonts(fontsel).Color,...
                        'FontName',control.setup.fonts(fontsel).FontName,...
                        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
                        'FontSize',control.setup.fonts(fontsel).FontSize,...
                        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
                        'FontWeight',control.setup.fonts(fontsel).FontWeight);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

% Callback for font button
function fontbut_callback(~,~)
    % Get current selection from popup
    fontsel = get(fontset_fontpop,'Value');
    fontstr = get(fontset_fontpop,'String'); fontstr = fontstr{fontsel,1};
    % Get new fonts
    newfont = uisetfont(control.setup.fonts(fontsel),sprintf('Set color of %s',fontstr));
    if isstruct(newfont)
    % Overwrite new values in control structure
    control.setup.fonts(fontsel).FontName = newfont.FontName;
    control.setup.fonts(fontsel).FontWeight = newfont.FontWeight;
    control.setup.fonts(fontsel).FontAngle = newfont.FontAngle;
    control.setup.fonts(fontsel).FontSize = newfont.FontSize;
    control.setup.fonts(fontsel).FontUnits = newfont.FontUnits;
    % Update preview
    set(fontset_fontpre,'ForegroundColor',control.setup.fonts(fontsel).Color,...
                        'FontName',control.setup.fonts(fontsel).FontName,...
                        'FontAngle',control.setup.fonts(fontsel).FontAngle,...
                        'FontSize',control.setup.fonts(fontsel).FontSize,...
                        'FontUnits',control.setup.fonts(fontsel).FontUnits,...
                        'FontWeight',control.setup.fonts(fontsel).FontWeight);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

%% 07 Plot line settings callbacks
% Callback for line popup
function linepop_callback(~,~)
    % Get current selection from popup
    linesel = get(lineset_linepop,'Value');
    % Update preview
    set(lineset_linepre,'Parent',lineset_lineax,'Marker','none',...
                       'LineStyle',control.setup.lines(1,linesel).LineStyle,...
                       'LineWidth',control.setup.lines(1,linesel).LineWidth,...
                       'Color',control.setup.lines(1,linesel).Color);
                        
    % Update slider and text
    set(lineset_linesli,'Value',control.setup.lines(1,linesel).LineWidth)
    set(lineset_lineslitxt,'String',sprintf('%.1f pt.',control.setup.lines(1,linesel).LineWidth));
    % Update line style popup
        switch control.setup.lines(1,linesel).LineStyle
            case '-'
            set(lineset_linestylepop,'Value',1)
            case '--'
            set(lineset_linestylepop,'Value',2)
            case ':'
            set(lineset_linestylepop,'Value',3)
            case '-.'
            set(lineset_linestylepop,'Value',4)
        end
end

% Callback for line slider
function linesli_callback(~,~)
    % Get the currently selected line
    linesel = get(lineset_linepop,'Value');
    % Get the value from slider
    linwid = get(lineset_linesli,'Value');
    % Overwrite value in control structure
    control.setup.lines(linesel).LineWidth = linwid;
    % Update the text beneath the slider
    set(lineset_lineslitxt,'String',sprintf('%.1f pt.',control.setup.lines(linesel).LineWidth))
    % Update preview
    set(lineset_linepre,'LineWidth',control.setup.lines(linesel).LineWidth)
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

% Line color callback
function linecolbut_callback(~,~)
    % Get current selection from popup
    linesel = get(lineset_linepop,'Value');
    % Get new color
    newcolor = uisetcolor;
    % Get the size of the output element
    [m,~] = size(newcolor');
    % If color was not aborted
    if m == 3
    % Overwrite color
    control.setup.lines(linesel).Color = newcolor;
    % Update preview
    set(lineset_linepre,'Parent',lineset_lineax,'Marker','none',...
                       'LineStyle',control.setup.lines(1,linesel).LineStyle,...
                       'LineWidth',control.setup.lines(1,linesel).LineWidth,...
                       'Color',control.setup.lines(1,linesel).Color);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
    end
end

% Linestyle callback
function linestylepop_callback(~,~)
    % Get current selection from popup
    linesel = get(lineset_linepop,'Value');
    % Get current selection from popup
    linestyle = get(lineset_linestylepop,'Value');
    switch linestyle
            case 1 % solid
                control.setup.lines(1,linesel).LineStyle = '-';
            case 2 % dashed
                control.setup.lines(1,linesel).LineStyle = '--';
            case 3 % 3 = dotted
                control.setup.lines(1,linesel).LineStyle = ':';
            case 4 % 4 = dash-dot
                control.setup.lines(1,linesel).LineStyle = '-.';
    end
    % Update preview
    set(lineset_linepre,'Parent',lineset_lineax,'Marker','none',...
                       'LineStyle',control.setup.lines(1,linesel).LineStyle,...
                       'LineWidth',control.setup.lines(1,linesel).LineWidth,...
                       'Color',control.setup.lines(1,linesel).Color);
    % Change the color of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0 0.5 0.0])
end

%% 08 Plot selection and adjustment callbacks

% Callback for first plot selection popup
function plotset_popup1_callback(~,~)
    % Get the current selection from popup
    popup1_sel = get(plotset_popup{1,1},'Value');
    % Set popup2 with new data
    set(plotset_popup{2,1},'String',plots.minor{popup1_sel,1},'Value',1)
    % Get the current plot string
    current_plot_str = get(plotset_popup{2,1},'String'); current_plot = current_plot_str(get(plotset_popup{2,1},'Value'),1);
    % Find the position in control.plots.list structure within loop
    for I = 1:control.plots.m
        if strcmpi(current_plot,control.plots.list{I,11})
            current_plot_id = I;
        end
    end

    % Check if PLOT-O-MAT or MULTIPL have been selected
    if sum(strcmpi(current_plot_str,'PLOT-O-MAT')) == 1 || sum(strcmpi(current_plot_str,'MULTIPL')) == 1
        % Clear old axes object
        delete(get(plotpre,'child'))
        % Disable second popup
        set(plotset_popup{2,1},'Enable','Off')
        % Make the third column visible
        set([plotset_info{1,1},plotset_info{2,1},plotset_info{3,1},plotset_info{4,1},plotset_info{5,1}],'Visible','Off')
        set([plotset_info{1,2},plotset_info{2,2},plotset_info{3,2},plotset_info{4,2},plotset_info{5,2}],'Visible','Off')
        set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','Off')
        % Make the button visible
        if sum(strcmpi(current_plot_str,'PLOT-O-MAT')) == 1
            set(plotset_button2,'Visible','Off')
            set(plotset_button1,'Visible','On')
        elseif sum(strcmpi(current_plot_str,'MULTIPL')) == 1
            set(plotset_button1,'Visible','Off')
            set(plotset_button2,'Visible','On')
        end
        % Change the colour of the update button
        set(plotset_optbut{1,2},'BackGroundColor',[0.8,0.8,0.8])
        % Disable plot option buttons
        set([plotset_optbut{1,1},plotset_optbut{1,2},plotset_optbut{1,3}],'Enable','Off')
        set([plotset_optbut{2,1},plotset_optbut{2,2}],'Enable','Off')
    else
        % Make button invisible
        set([plotset_button1,plotset_button2],'Visible','Off')
        % Enable second popup
        set(plotset_popup{2,1},'Enable','On')
        % Check if the current plot is ternary and update information then
        % Ternary plots
        if strcmpi(control.plots.list{current_plot_id,2},'ternary')
            % Make the third column visible
            set([plotset_info{1,1},plotset_info{2,1},plotset_info{3,1},plotset_info{4,1},plotset_info{5,1}],'Visible','On')
            set([plotset_info{1,2},plotset_info{2,2},plotset_info{3,2},plotset_info{4,2},plotset_info{5,2}],'Visible','On')
            set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','On')
            % Update information in all three columns
            for I = 1:3
                set(plotset_info{3,I},'String',control.plots.list{current_plot_id,3}{I,1})
                set(plotset_info{4,I},'String',control.plots.list{current_plot_id,4}{I,1})
                set(plotset_info{5,I},'String',control.plots.list{current_plot_id,5}{I,1},'Enable','Off')
            end

        % All other than ternary
        else
            % Make the third column invisible
            set([plotset_info{1,1},plotset_info{2,1},plotset_info{3,1},plotset_info{4,1},plotset_info{5,1}],'Visible','On')
            set([plotset_info{1,2},plotset_info{2,2},plotset_info{3,2},plotset_info{4,2},plotset_info{5,2}],'Visible','On')
            set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','Off')
            % Update information in first and second column and put dummy value in third for 
            % consistency reasons
            for I = 1:3
                % Dummy values for third column
                if I == 3
                    set([plotset_info{3,I},plotset_info{4,I},plotset_info{5,I}],'String',' - ')
                % Update information in first two columns
                else
                    set(plotset_info{3,I},'String',control.plots.list{current_plot_id,3}{I,1})
                    set(plotset_info{4,I},'String',control.plots.list{current_plot_id,4}{I,1})
                    set(plotset_info{5,I},'String',control.plots.list{current_plot_id,5}{I,1},'Enable','On')
                end
            end
        end
        % Change the colour of the update button
        set(plotset_optbut{1,2},'BackGroundColor',[1.0,0.5,0.0])
        % Enable plot option buttons
        set([plotset_optbut{1,1},plotset_optbut{1,2},plotset_optbut{1,3}],'Enable','On')
        % Enable plot option buttons
        set([plotset_optbut{2,1},plotset_optbut{2,2}],'Enable','On')
    end
end

% Callback for second plot selection callback
function plotset_popup2_callback(~,~)
    % Get the current plot string
    current_plot_str = get(plotset_popup{2,1},'String'); current_plot = current_plot_str(get(plotset_popup{2,1},'Value'),1);
    % Find the position in control.plots.list structure within loop
    for I = 1:control.plots.m
        if strcmpi(current_plot,control.plots.list{I,11})
            current_plot_id = I;
        end
    end

    % Check if PLOT-O-MAT or MULTIPL have been selected
    if sum(strcmpi(current_plot_str,'PLOT-O-MAT')) == 1 || sum(strcmpi(current_plot_str,'MULTIPL')) == 1
        % Disable second popup
        set(plotset_popup{2,1},'Enable','Off')
        % Make the third column visible
        set([plotset_info{1,1},plotset_info{2,1},plotset_info{3,1},plotset_info{4,1},plotset_info{5,1}],'Visible','Off')
        set([plotset_info{1,2},plotset_info{2,2},plotset_info{3,2},plotset_info{4,2},plotset_info{5,2}],'Visible','Off')
        set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','Off')
        % Make the button visible
        if sum(strcmpi(current_plot_str,'PLOT-O-MAT')) == 1
            set(plotset_button2,'Visible','Off')
            set(plotset_button1,'Visible','On')
        elseif sum(strcmpi(current_plot_str,'MULTIPL')) == 1
            set(plotset_button1,'Visible','Off')
            set(plotset_button2,'Visible','On')
        end
        % Change the colour of the update button
        set(plotset_optbut{1,2},'BackGroundColor',[0.8,0.8,0.8])
        % Disable plot option buttons
        set([plotset_optbut{1,1},plotset_optbut{1,2},plotset_optbut{1,3}],'Enable','Off')
    else
        % Make button invisible
        set([plotset_button1,plotset_button2],'Visible','Off')
        % Enable second popup
        set(plotset_popup{2,1},'Enable','On')
        % Check if the current plot is ternary and update information then
        % Ternary plots
        if strcmpi(control.plots.list{current_plot_id,2},'ternary')
            % Make the third column visible
            set([plotset_info{1,1},plotset_info{2,1},plotset_info{3,1},plotset_info{4,1},plotset_info{5,1}],'Visible','On')
            set([plotset_info{1,2},plotset_info{2,2},plotset_info{3,2},plotset_info{4,2},plotset_info{5,2}],'Visible','On')
            set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','On')
            % Update information in all three columns
            for I = 1:3
                set(plotset_info{3,I},'String',control.plots.list{current_plot_id,3}{I,1})
                set(plotset_info{4,I},'String',control.plots.list{current_plot_id,4}{I,1})
                set(plotset_info{5,I},'String',control.plots.list{current_plot_id,5}{I,1},'Enable','Off')
            end

        % All other than ternary
        else
            % Make the third column invisible
            set([plotset_info{1,1},plotset_info{2,1},plotset_info{3,1},plotset_info{4,1},plotset_info{5,1}],'Visible','On')
            set([plotset_info{1,2},plotset_info{2,2},plotset_info{3,2},plotset_info{4,2},plotset_info{5,2}],'Visible','On')
            set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','Off')
            % Update information in first and second column and put dummy value in third for 
            % consistency reasons
            for I = 1:3
                % Dummy values for third column
                if I == 3
                    set([plotset_info{3,I},plotset_info{4,I},plotset_info{5,I}],'String',' - ')
                % Update information in first two columns
                else
                    set(plotset_info{3,I},'String',control.plots.list{current_plot_id,3}{I,1})
                    set(plotset_info{4,I},'String',control.plots.list{current_plot_id,4}{I,1})
                    set(plotset_info{5,I},'String',control.plots.list{current_plot_id,5}{I,1},'Enable','On')
                end
            end
        end
        % Change the colour of the update button
        set(plotset_optbut{1,2},'BackGroundColor',[1.0,0.5,0.0])
        % Enable plot option buttons
        set([plotset_optbut{1,1},plotset_optbut{1,2},plotset_optbut{1,3}],'Enable','On')
    end
end

% Callback for a changing the axis limitations
function plotset_axeslim_callback(obj,~)
    % Get the new values and axis tag (1=X,2=Y,3=Z)
    new_axeslim = get(obj,'String'); new_axes = str2double(get(obj,'Tag'));
    % Get the current plot string
    current_plot = get(plotset_popup{2,1},'String'); current_plot = current_plot(get(plotset_popup{2,1},'Value'),1);
    % Find the position in control.plots.list structure within loop
    for I = 1:control.plots.m
        if strcmpi(current_plot,control.plots.list{I,11})
            current_plot_id = I;
        end
    end
    
    % Check the input string if correct and correct
    % Check and correct for first bracket
    res = strfind(new_axeslim,'[');
    if isempty(res)
        new_axeslim = strcat('[',new_axeslim);
    end
    % Check and correct for second bracket
    res = strfind(new_axeslim,']');
    if isempty(res)
        new_axeslim = strcat(new_axeslim,']');
    end
    
    % Get the min and max values from input string
    len = length(new_axeslim); res = strfind(new_axeslim,' ');
    valmin = str2double(new_axeslim(2:res-1)); valmax = str2double(new_axeslim(res+1:len-1));
    % Check for the whitespaces and extract the values
    if isnan(valmin) || isnan(valmax) 
        % Send error messages if strings in expected area and restore
        errordlg(sprintf('The inserted axis limitations are not valid!\nInput options:\n[35 80] = two white-space separated values with brackets\n0.001 0.005 = two white-space separated values without brackets'),'Input Error');
        set(obj,'String',control.plots.list{current_plot_id,5}{new_axes,1})
    elseif valmin >= valmax
        % Send error messages if min val higher than max val and restore
        errordlg('Axes minimum is higher or equal axes maximum','Input Error');
        set(obj,'String',control.plots.list{current_plot_id,5}{new_axes,1})
    else
        % Overwrite the values in control.plots.list cell array
        control.plots.list{current_plot_id,5}{new_axes,1} = new_axeslim;
        % Change the colour of the update button
        set(plotset_optbut{1,2},'BackGroundColor',[1.0,0.5,0.0])
    end
end

% Callback to start PLOT-O-MAT or MULTIPL
function plotset_button_callback(obj,~)
    % Get the string from button
    button_str = get(obj,'String');
    
    if strcmpi(button_str,'Start PLOT-O-MAT')
        plotomat(control,data,files_op,opt_check,save_path);
    elseif strcmpi(button_str,'Start MULTIPLotter')
        multipl(control,data,files_op,opt_check,save_path);
    else
       fprintf('This is an unexpected error, this button should not exist!') 
    end
    
end

%% 09a Plot callback

% Defined plot callback - Handles plots defined in program
function defplot_callback(obj,~)

% Get the current plot string
current_plot = get(plotset_popup{2,1},'String'); current_plot = current_plot(get(plotset_popup{2,1},'Value'),1);
% Get the selected plot
plotsel = strcmpi(control.plots.list(:,11),current_plot);

% Create and then hide the GUI during the construction process
plotfig = figure('Visible','off');
% Set units of the figure to pixel and hide menu bar.
set(plotfig,'Units','Pixel','MenuBar','none','Color',[1.0 1.0 1.0],...
            'Pointer','arrow','Renderer','zbuffer');
% Set size and position (absolute pixel) of the figure and set name of the GUI
set(plotfig,'Position',[75,75,1600,950],'Name',control.plots.list{plotsel});
% Clear plot and create symbol preview      
plotax = axes('Parent',plotfig,...
              'XLim',[0 1],'YLim',[0 1],'Color','white');
          
% Setup scale factor for new figure
control.scafac = 1.0;

% Make update / plot button visible
set([plotset_optbut{1,1} plotset_optbut{1,3}],'Visible','On','BackgroundColor',[0.8 0.8 0.8])
set(plotset_optbut{1,2},'Visible','On') % leave colour of the update button as it is...
set([plotset_optbut{2,1} plotset_optbut{2,2}],'Visible','On','BackgroundColor',[0.8 0.8 0.8])

% Send all vars to program switch
plotax = program_switch(control,plotax,plotsel,data,files_op,opt_check);

% Make axes visible if lin / log
if sum(strcmpi(control.plots.list(plotsel,2),{'linear','linear invx','linear invy','semilogx','semilogx invx','semilogx invy','semilogy','semilogy invx','semilogy invy','loglog'}))
    set(plotax,'Visible','on')
else
    set(plotax,'Visible','off')
end

% Make figure visible or export in png / eps
if strcmpi(get(obj,'Tag'),'fig')
    % Make the new figure visible
    set(plotfig,'Visible','on');
else
    % Print the figure out
    if strcmpi(get(obj,'Tag'),'png')
        % Change the background color of the GUI to black
        set(plotfig,'Color',[1.0,1.0,1.0],'PaperPositionMode','auto');
        % Open save window to select output file
        [file,path] = uiputfile('*.png','Save plot as portable network graphics!',...
                                        strcat(save_path,'/export/',control.prj_name,'_diagram','.png'));
        % Only print if file was selected
        if ischar(file)
            print(plotfig,fullfile(path,file),'-dpng','-zbuffer','-r500')
        end
    elseif strcmpi(get(obj,'Tag'),'eps')
        % Change the background color of the GUI to black
        set(plotfig,'Color',[1.0,1.0,1.0],...
                    'PaperPositionMode','manual','PaperPosition',[-1.0,1,41.6,23.4],...
                    'PaperOrientation','landscape',...
                    'PaperSize',[42 30],'PaperUnits','centimeters');
        % Open save window to select output file
        [file,path] = uiputfile('*.eps','Save plot as encapsuled post script!',...
                                        strcat(save_path,'/export/',control.prj_name,'_diagram','.eps'));
        % Only print if file was selected
        if ischar(file)
            print(plotfig,fullfile(path,file),'-depsc2','-painters')
        end
    end
end

end

%% 09b Update callback

% Update plot callback - Update if look or whatever has been changed
function update_callback(~,~)

% Get the current plot string
current_plot = get(plotset_popup{2,1},'String'); current_plot = current_plot(get(plotset_popup{2,1},'Value'),1);
% Get the selected plot
plotsel = strcmpi(control.plots.list(:,11),current_plot);

% Make the panel invisible
set(plotpre,'Visible','Off')
% Clear old axes object
delete(get(plotpre,'child'))
% Clear plot and create symbol preview      
plotax = axes('Parent',plotpre,...
              'XLim',[0 1],'YLim',[0 1],'Color','white');
          
% Setup scale factor for preview
control.scafac = 0.6;

% Make update / plot button visible
set([plotset_optbut{1,1} plotset_optbut{1,2} plotset_optbut{1,3}],'Visible','On','BackgroundColor',[0.8 0.8 0.8])
set([plotset_optbut{2,1} plotset_optbut{2,2}],'Visible','On','BackgroundColor',[0.8 0.8 0.8])
% Send all vars to program switch
plotax = program_switch(control,plotax,plotsel,data,files_op,opt_check);
    
% Make axes visible if lin / log
if sum(strcmpi(control.plots.list(plotsel,2),{'linear','linear invx','linear invy','semilogx','semilogx invx','semilogx invy','semilogy','semilogy invx','semilogy invy','loglog'}))
    set(plotax,'Visible','on')
else
    set(plotax,'Visible','off')
end
    
% Make the axis visible
set(plotpre,'Visible','On'); 

end

%% 09c Clear plot callback

% Clear plot callback - Clears plot, whyever
function plotclear_callback(~,~)
    
    % Reset the popups
    set(plotset_popup{1,1},'Value',1)    
    set(plotset_popup{2,1},'String',plots.minor{1,1},'Value',1)
    
    % Get the current plot string
    current_plot = get(plotset_popup{2,1},'String'); current_plot = current_plot(get(plotset_popup{2,1},'Value'),1);
    % Find the position in control.plots.list structure within loop
    for I = 1:control.plots.m
        if strcmpi(current_plot,control.plots.list{I,11})
            current_plot_id = I;
        end
    end

	% Check if the current plot is ternary and update information then
    % Ternary plots
    if strcmpi(control.plots.list{current_plot_id,2},'ternary')
        % Make the third column visible
        set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','On')
        % Update information in all three columns
        for I = 1:3
            set(plotset_info{3,I},'String',control.plots.list{current_plot_id,3}{I,1})
            set(plotset_info{4,I},'String',control.plots.list{current_plot_id,4}{I,1})
            set(plotset_info{5,I},'String',control.plots.list{current_plot_id,5}{I,1},'Enable','Off')
            
        end
    % No ternary plot
    else
        % Make the third column invisible
        set([plotset_info{1,3},plotset_info{2,3},plotset_info{3,3},plotset_info{4,3},plotset_info{5,3}],'Visible','Off')
        % Update information in first and second column and put dummy value in third for 
        % consistency reasons
        for I = 1:3
            % Dummy values for third column
            if I == 3
                set([plotset_info{3,I},plotset_info{4,I},plotset_info{5,I}],'String',' - ')
            % Update information in first two columns
            else
                set(plotset_info{3,I},'String',control.plots.list{current_plot_id,3}{I,1})
                set(plotset_info{4,I},'String',control.plots.list{current_plot_id,4}{I,1})
                set(plotset_info{5,I},'String',control.plots.list{current_plot_id,5}{I,1},'Enable','On')
            end
        end
    end
    
    % Clear old axes object
    delete(get(plotpre,'child'))
    % Clear plot and create symbol preview      
    plotax = axes('Parent',plotpre,...
                  'XLim',[0 1],'YLim',[0 1],'Color','none');
    axis([0 1 0 1]); axis off;
    % Change the colour of the update button
    set(plotset_optbut{1,2},'BackGroundColor',[1.0,0.5,0.0])
end

%% 09d Outsourced callbacks
% Three other plot callbacks are outsourced into another m-file
% These handle invisible buttons to load fields / lines / patches into
% plots and will be a target for future development

%% 10 Save and load button + session name callback

% Callback to overwrite session name variable
function session_edit_callback(~,~)
    control.prj_name = get(session_edit,'String');
end

% General save button - Saves session to file
function gensave_callback(~,~)
    % Open save window to select output .session file
    [file,path] = uiputfile('*.session',sprintf('Save %s session!',control.title),...
                                        strcat(save_path,'/',control.prj_name,'.session'));
    if file ~= 0
    % Save the variables if any file was selected
    save(fullfile(path,file),'control','data','files','files_op','opt_check','temp');
    end
end

% Saves symbols / labels / plot setup into .sym file
function gensavesymb_callback(~,~)
    % Open save window to select output sym file
    [file,path] = uiputfile('*.sym',sprintf('Save symbols and labels! - %s',control.title),...
                                    strcat(save_path,'/',control.program,'.sym'));
    if file ~= 0
        % Create new var for symbols
        save_line = control.setup;                                             %#ok<NASGU>
        % Write symbols and labels into new structure within this loop
            for I = 1:9
                if data(1,I).symbol.op.op == true && data(1,I).symbol.op.override == false
                    save_symbol(1,I) = temp(1,I).symbol;                              %#ok<AGROW>
                    save_temp_symbol(1,I) = data(1,I).symbol;                         %#ok<AGROW>
                else
                    save_symbol(1,I) = data(1,I).symbol;                              %#ok<AGROW>
                    save_temp_symbol(1,I) = temp(1,I).symbol;                         %#ok<AGROW>
                end
                if data(1,I).label.op.op == true && data(1,I).label.op.override == false
                    save_label(1,I) = temp(1,I).label;                                 %#ok<AGROW>
                    save_temp_label(1,I) = data(1,I).label;                            %#ok<AGROW>
                else
                    save_label(1,I) = data(1,I).label;                                 %#ok<AGROW>
                    save_temp_label(1,I) = temp(1,I).label;                            %#ok<AGROW>
                end
            end
        % Save the variables if any file was selected
        save(fullfile(path,file),'save_line','save_symbol','save_temp_symbol','save_label','save_temp_label');
    end
end

% Loads symbols / labels / plot setup into .sym file
function genloadsymb_callback(~,~)
    % Open file selection window to select sym file
    [file,path] = uigetfile({'*.sym','Symbol Files (*.sym)';...
                             '*.*','All Files (*.*)'},'Select symbol file!',...
                             save_path);
    if file ~= 0                     
        % Load the variables from sym file
        load(fullfile(path,file),'-mat','save_line','save_symbol','save_temp_symbol','save_label','save_temp_label')
        % Write line setup into control struct
        control.setup = save_line;
        % Write symbols and labels into data structure
        for I = 1:9
            temp(1,I).symbol = save_temp_symbol(1,I);
            temp(1,I).label = save_temp_label(1,I);
            % Symbols
            if data(1,I).symbol.op.op == true && data(1,I).symbol.op.override == false
                temp(1,I).symbol = data(1,I).symbol;
                data(1,I).symbol = save_symbol(1,I);
                data(1,I).symbol.op.op = true; data(1,I).symbol.op.override = true;
            elseif data(1,I).symbol.op.op == true && data(1,I).symbol.op.override == true
                data(1,I).symbol = save_symbol(1,I);
                data(1,I).symbol.op.op = true; data(1,I).symbol.op.override = true;
            else
                data(1,I).symbol = save_symbol(1,I);
                data(1,I).symbol.op.op = false; data(1,I).symbol.op.override = true;
            end
            
            % Labels
            if data(1,I).label.op.op == true && data(1,I).label.op.override == false
                temp(1,I).label = data(1,I).label;
                data(1,I).label = save_label(1,I);
                data(1,I).label.op.op = true; data(1,I).label.op.disp = false; data(1,I).label.op.override = true;
            elseif data(1,I).label.op.op == true && data(1,I).label.op.override == true
                data(1,I).label = save_label(1,I);
                data(1,I).label.op.op = true; data(1,I).label.op.disp = false; data(1,I).label.op.override = true;
            else
                data(1,I).label = save_label(1,I);
                data(1,I).label.op.op = false; data(1,I).label.op.disp = false; data(1,I).label.op.override = true;
            end
        end

        % Reset current selection
        % Change the color of the currently selected radio button
        set(get(plotset,'SelectedObject'),'ForegroundColor',[0.0,0.0,0.0])
        % Reset current selection 
        set(plotset,'SelectedObject',[]);
        
        % Clear the current plot 
        % Clear old axes object
        delete(get(plotpre,'child'))
        % Clear plot and create symbol preview      
        plotax = axes('Parent',plotpre,...
                      'XLim',[0 1],'YLim',[0 1],'Color','none');
        axis([0 1 0 1]); axis off;
        
        % Make all plot buttons invisible
        set([plotset_optbut{1,1} plotset_optbut{1,2} plotset_optbut{1,3}],'Visible','Off','BackgroundColor',[0.8 0.8 0.8])
        set([plotset_optbut{2,1} plotset_optbut{2,2} plotset_optbut{2,3}],'Visible','Off','BackgroundColor',[0.8 0.8 0.8])
    
        % Switch selection to all datasets and change color
        set(get(opt_data,'SelectedObject'),'ForegroundColor',[0.0,0.0,0.0])
        set(opt_data,'SelectedObject',opt_data_u{1,1})
        set(get(opt_data,'SelectedObject'),'ForegroundColor',[.0 .0 .8])
        
        % Switch from table to overview panel
        set(ove_tab,'Visible','Off')
        set(ove_vis,'Visible','On')
        
        % Change and update the selected symbols
        for I = 1:files_op
           % Create axes object
           marker_vis{I,2} = axes('Parent',symbset_ov,'Position',get(marker_vis{I,2},'Position'),...
                                  'XLim',[0 2],'YLim',[0 1],'Color',[1 0 0]);

           % Show marker if no marker column is available
           if data(1,I).symbol.op.op == true && data(1,I).symbol.op.override == false
               % Show that there is a marker column
               delete(marker_vis{I,3})
               marker_vis{I,3} = text(0.5,0.5,sprintf('...marker columns!'),...
                                              'Parent',marker_vis{I,2},...
                                              'FontSize',7,'FontWeight','Bold',...
                                              'HorizontalAlignment','Center',...
                                              'VerticalAlignment','Middle','Visible','on');
           else
               % Plot the marker
               delete(marker_vis{I,3})
               marker_vis{I,3} = plot(0.5,0.5,'Parent',marker_vis{I,2},...
                                              'Marker',markerid(data(1,I).symbol.symbol),...
                                              'MarkerSize',data(1,I).symbol.size,...
                                              'MarkerEdgeColor',data(1,I).symbol.mec,...
                                              'MarkerFaceColor',data(1,I).symbol.mfc,'Visible','on');
           end
           
           % Set the axes object invisible
           set(marker_vis{I,2},'box','off'); axis([0 2 0 1]); axis off;
           set(marker_vis{I,2},'Visible','off')
           
           % Change the labels
           if data(1,I).label.op.op == true && data(1,I).label.op.override == false
                set(marker_vis{I,4},'String','...label columns!',...
                                    'Parent',marker_vis{I,2},...
                                    'FontSize',7,'FontWeight','Bold',...
                                    'HorizontalAlignment','Center',...
                                    'VerticalAlignment','Middle',...
                                    'BackgroundColor',[0.8,0.8,0.8],...
                                    'Visible','off');
           else
                set(marker_vis{I,4},'String','AaBbCc',...
                                    'Parent',marker_vis{I,2},...
                                    'Fontname',data(1,I).label.FontName,...
                                    'FontAngle',data(1,I).label.FontAngle,...
                                    'FontSize',data(1,I).label.FontSize,...
                                    'FontWeight',data(1,I).label.FontWeight,...
                                    'Color',data(1,I).label.Color,...
                                    'HorizontalAlignment','Center',...
                                    'VerticalAlignment','Middle',...
                                    'Visible','off');
           end
           
                     
           % If the label column is activated display it
           if data(1,I).label.op.disp == true
               set(marker_vis{I,4},'Visible','on')
           end
           
           
        end

    % Switch from symbol setup to symbol overview
        set(symbset,'Visible','Off')
        set(symbset_ov,'Visible','On')
        
    % Clear and update the current plot font selection
        set(fontset_fontpop,'Value',1)
        set(fontset_fontpre,'FontName',control.setup.fonts(1).FontName,...
                            'ForegroundColor',control.setup.fonts(1).Color,...
                            'FontSize',control.setup.fonts(1).FontSize,...
                            'FontWeight',control.setup.fonts(1).FontWeight,...
                            'FontAngle',control.setup.fonts(1).FontAngle);
    % Clear and update the current plot line selection
        set(lineset_linepop,'Value',1)
        set(lineset_linepre,'LineStyle',control.setup.lines(1).LineStyle,...
                            'LineWidth',control.setup.lines(1).LineWidth,...
                            'Color',control.setup.lines(1).Color);
        set(lineset_linesli,'Value',control.setup.lines(1).LineWidth)
        set(lineset_lineslitxt,'String',sprintf('%.1f pt.',control.setup.lines(1).LineWidth))
        set(lineset_linestylepop,'Value',lineid(control.setup.lines,1))

    end
end

%% 00 GUI Finalisation

%% 00f Make GUI visible

% Set figure visible
set(pp_main,'Visible','on');
% Output to command window
fprintf('...finished! \n      - Time: %s\n\n',datestr(clock));

%% 00g Control elements at the end of this function
% Assign control and data structure to base workspace (normally deactivated)
assignin('base','data',data)
assignin('base','control',control)
assignin('base','temp',temp)
end