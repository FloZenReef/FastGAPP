function multipl(control,data,files_op,opt_check,save_path)
%% 00a Create figure
% Set the program title
prog_title = 'MULTIPLotter v1.0';
% Create and then hide the GUI during the construction process
mp_main = figure('Visible','off');
% Deactivate numbering of the figure
set(mp_main,'NumberTitle','off')
% Set units of the figure to pixel and hide menu bar.
set(mp_main,'Units','pixel','MenuBar','none','Pointer','arrow','Renderer','zbuffer');
% Set size and position (absolute pixel) of the figure and set name of the GUI
set(mp_main,'Position',[100,100,1605,955],'Resize','Off','Name',prog_title);
% Change the background color of the GUI to black
set(mp_main,'Color',[0.8,0.8,0.8]);

%% 00b Allocate variables
    % This is the sample, which is selected by the select sample mode
    nr_sample = '';
    % This is the data, which is selected by the select sample mode
    nr_datset = [];
    % Setup the datatype, only raw data used
    control_datatype = 'dat';
% %% 00c Allocate sort orders
% SO_REE = {'La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Y','Ho','Er','Tm','Yb','Lu'};
% SO_MULTI_I = {'Sr','K','Rb','Ba','Th','Ta','Nb','Ce','P','Zr','Hf','Sm','Ti','Y','Yb'};
% SO_MULTI_II = {'Cs','Rb','Ba','Th','U','Nb','Ta','K','La','Ce','Pb','Pr','Nd','Sr','Zr','Hf','Sm','Eu','Gd','Tb','Dy','Ho','Y','Er','Tm','Yb','Lu'};

%% 00c Load the normalisation values database
norm_vals = normalisation_values();
% Control element
% assignin('base','norm_vals',norm_vals)

%% 01a Create control panel
% Create buttongroup
set_pan = uipanel('Title','Setup',...
                  'Parent',mp_main,...
                  'Units','pixel','Position',[5,5,400,950],...
                  'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                  'TitlePosition','lefttop',...
                  'Fontsize',12,'FontWeight','Bold',...
                  'Visible','Off');
              
%% 01b Create elements in control panel
% Create first popup for elemental arrangement selection
set_pan_txt1 = uicontrol('Style','Text',...
                         'String','Element arrangement',...
                         'FontSize',14,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[25,900,350,25]);
pop1_str = {'Rare-earth elements';'Multi-element I (Spider)';'Multi-element II'};
set_pan_pop1 = uicontrol('Style','popup',...
                         'String',pop1_str,...
                         'Value',1,...
                         'FontSize',14,'FontWeight','bold',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,1.0,1.0],...
                         'Parent',set_pan,...
                         'Position',[25,870,350,20],...
                         'Callback',@sort_order_callback);


% Create second popup to select the normalisation                     
set_pan_txt2 = uicontrol('Style','Text',...
                         'String','Normalisation values',...
                         'FontSize',14,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[25,820,350,20]);
% Create strings for norm vals popup
[m,~] = size(norm_vals.str); pop2_str = cell(m,1);
for i = 1:m
    if i == 1 || i == 2
        pop2_str{i,1} = sprintf('%s',norm_vals.str{i,1});
    else
        pop2_str{i,1} = sprintf('%s after %s',norm_vals.str{i,1},norm_vals.str{i,3});
    end
end;

set_pan_pop2 = uicontrol('Style','popup',...
                         'String',pop2_str,...
                         'Value',1,...
                         'FontSize',14,'FontWeight','bold',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,1.0,1.0],...
                         'Parent',set_pan,...
                         'Position',[25,790,350,20],...
                         'Callback',@norm_vals_callback);
set_pan_txt11 = uicontrol('Style','Text',...
                         'String','',...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[25,750,350,20]);
                     
% Create checkbox for missing value calculation (not this version)
set_pan_check1 = uicontrol('Style','checkbox',...
                           'String','Calculate missing values?',...
                           'FontSize',14,'FontWeight','bold',...
                           'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                           'Enable','Off',...
                           'ToolTipString','This function will be included in the next version!',...
                           'Parent',set_pan,...
                           'Position',[25,700,350,25]);
                       
% Create slider to adjust the line thickness
set_pan_txt3 = uicontrol('Style','Text',...
                         'String','Line Thickness',...
                         'FontSize',14,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[25,645,350,25]);
set_pan_sli = uicontrol('Style','slider',...
                        'Min',0.1,'Max',2.5,...
                        'Value',1,...
                        'SliderStep',[1/48 4/48],...
                        'ToolTipString','Click to change the line thickess!',...
                        'Callback',@slider_callback,...
                        'Parent',set_pan,...
                        'Position',[25,615,350,25]);
set_pan_txt4 = uicontrol('Style','Text',...
                         'String',sprintf('%1.2f points',get(set_pan_sli,'Value')),...
                         'FontSize',14,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[25,580,350,25]);

% Create edit boxes to adjust the y-axis
set_pan_txt5 = uicontrol('Style','Text',...
                         'String','Y-Axis Minimum',...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[15,530,180,30]);
set_pan_txt6 = uicontrol('Style','Text',...
                         'String','Y-Axis Maximum',...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[205,530,180,30]);
% Allocate initial values
ymin_val = 0.01; ymax_val = 1000;
set_pan_edit1 = uicontrol('Style','Edit',...
                         'String',num2str(ymin_val),...
                         'Tag','ymin',...
                         'FontSize',14,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,1.0,1.0],...
                         'Parent',set_pan,...
                         'Position',[15,505,180,30],...
                         'Callback',@axeslim_callback);
set_pan_edit2 = uicontrol('Style','Edit',...
                         'String',num2str(ymax_val),...
                         'TAG','ymax',...
                         'FontSize',14,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,1.0,1.0],...
                         'Parent',set_pan,...
                         'Position',[205,505,180,30],...
                         'Callback',@axeslim_callback);

% Create slider to adjust the plot height
set_pan_txt7 = uicontrol('Style','Text',...
                         'String','Plot Height',...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[15,445,180,25]);
set_pan_sli_h = uicontrol('Style','slider',...
                        'Min',0.1,'Max',0.9,...
                        'Value',0.7,...
                        'SliderStep',[1/80 5/80],...
                        'ToolTipString','Click to change the height of the plot!',...
                        'Callback',@slider_h_callback,...
                        'Parent',set_pan,...
                        'Position',[15,420,180,25]);
set_pan_txt8 = uicontrol('Style','Text',...
                         'String',sprintf('%1.1f',get(set_pan_sli_h,'Value')),...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[15,390,180,25]);
                     
% Create slider to adjust the plot width
set_pan_txt9 = uicontrol('Style','Text',...
                         'String','Elemental Width',...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[205,445,180,25]);
set_pan_sli_w = uicontrol('Style','slider',...
                        'Min',0.01,'Max',0.05,...
                        'Value',0.028,...
                        'SliderStep',[1/45 2/45],...
                        'ToolTipString','Click to change the width between elements!',...
                        'Callback',@slider_w_callback,...
                        'Parent',set_pan,...
                        'Position',[205,420,180,25]);
set_pan_txt10 = uicontrol('Style','Text',...
                         'String',sprintf('%1.3f',get(set_pan_sli_w,'Value')),...
                         'FontSize',12,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[205,390,180,25]);
     
% Create update and plot button
set_pan_but1 = uicontrol('Style','Pushbutton',...
                         'String','Update',...
                         'FontSize',16,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[1.0,0.5,0.0],...
                         'Parent',set_pan,...
                         'Position',[30,90,165,50],...
                         'Callback',@update_callback);
set_pan_but2 = uicontrol('Style','Pushbutton',...
                         'String','Plot',...
                         'Tag','fig',...
                         'FontSize',16,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[205,90,165,50],...
                         'Callback',@plot_callback);
set_pan_but3 = uicontrol('Style','Pushbutton',...
                         'String','Export PNG',...
                         'Tag','png',...
                         'FontSize',16,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[30,30,165,50],...
                         'Callback',@plot_callback);
set_pan_but4 = uicontrol('Style','Pushbutton',...
                         'String','Export EPS',...
                         'Tag','eps',...
                         'FontSize',16,'FontWeight','bold',...
                         'HorizontalAlignment','center',...
                         'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                         'Parent',set_pan,...
                         'Position',[205,30,165,50],...
                         'Callback',@plot_callback);    
                 
%% 01x Make control panel and contents visible

% All other elements
set([set_pan_txt1,set_pan_pop1,set_pan_txt2,set_pan_pop2,set_pan_check1],'Visible','On')
set([set_pan_txt3,set_pan_txt4,set_pan_sli],'Visible','On')
set([set_pan_edit1,set_pan_edit2,set_pan_txt5,set_pan_txt6],'Visible','On')
set([set_pan_txt7,set_pan_txt8,set_pan_txt9,set_pan_txt10],'Visible','On')
set([set_pan_sli_h,set_pan_sli_w],'Visible','On')
set(set_pan_txt11,'Visible','On')
% Update / plot buttons
set([set_pan_but1,set_pan_but2],'Visible','On')
set([set_pan_but3,set_pan_but4],'Visible','On')
% Set panel visible
set(set_pan,'Visible','On')

%% 02a Create preview panel
% Create buttongroup
pre_pan = uipanel('Title','Preview',...
                  'Parent',mp_main,...
                  'Units','pixel','Position',[405,5,1200,950],...
                  'ForegroundColor',[0.0,0.0,0.0],'BackgroundColor',[0.8,0.8,0.8],...
                  'TitlePosition','lefttop',...
                  'Fontsize',12,'FontWeight','Bold',...
                  'Visible','Off');
              
%% 02x Make control panel visible
set(pre_pan,'Visible','On')



%% Callbacks

%% 01a Sort order callback

    function sort_order_callback(obj,~)
        % Change the colour of the update button
        set(set_pan_but1,'BackGroundColor',[1.0,0.5,0.0])
        
        % Setup the elemental width slider
        % Get value from popup
        elem_so = get(obj,'Value');
        % Change values in elemental width slider        
        switch elem_so
            case 1
                set(set_pan_sli_w,'Min',0.01,'Max',0.055,'SliderStep',[1/45 2/45])
            case 2
                set(set_pan_sli_w,'Min',0.01,'Max',0.055,'SliderStep',[1/45 2/45])
            case 3
                % Change the value of the slider if it was higher
                if get(set_pan_sli_w,'Value') > 0.028
                    set(set_pan_sli_w,'Value',0.028)
                end
                set(set_pan_sli_w,'Min',0.01,'Max',0.028,'SliderStep',[1/18 2/18])
        end
        % Change the text below slider
        set(set_pan_txt10,'String',sprintf('%1.3f',get(set_pan_sli_w,'Value')))
    end

%% 01b Normalisation values changes

    function norm_vals_callback(obj,~)
        % Change the colour of the update button
        set(set_pan_but1,'BackGroundColor',[1.0,0.5,0.0])
        if get(obj,'Value') == 2

            list_dlg_str1 = cell(sum(opt_check),1);
            for I = 1:sum(sum(opt_check))
                list_dlg_str1{I,1} = sprintf('#%s - %s',num2str(I),control.files{I,1});
            end
            
            nr_datset = listdlg('PromptString','Select Dataset!',...
                                'SelectionMode','single',...
                                'ListString',list_dlg_str1,...
                                'ListSize',[300,200],...
                                'fus',6,'ffs',8);
                            
            if isempty(nr_datset)
                set(obj,'Value',1)
                set(set_pan_txt11,'String','')
            else
                control_datatype = 'dat'; 
                list_dlg_str2 = data(1,nr_datset).(control_datatype).Samples;
                nr_sample = listdlg('PromptString','Select Sample!',...
                                    'SelectionMode','single',...
                                    'ListString',list_dlg_str2,...
                                    'ListSize',[300,200],...
                                    'fus',6,'ffs',8);
                if isempty(nr_sample)
                    set(obj,'Value',1)
                    set(set_pan_txt11,'String','')
                else
                    set(set_pan_txt11,'String',sprintf('Normalisation on %s',data(1,nr_datset).(control_datatype).Samples{nr_sample,1}))
                    
                    so_multi2 = {'Cs','Rb','Ba','Th','U','Nb','Ta','K','La','Ce','Pb','Pr','Nd','Sr','P','Zr','Hf','Sm','Eu','Ti','Gd','Tb','Dy','Ho','Y','Er','Tm','Yb','Lu'}; 
                    % Get the size of the selected sort order
                    [~,N] = size(so_multi2);
                    for I = 1:N
                            cur_el = so_multi2{1,I};
                            if strcmpi('K',cur_el);
                                alt_el = 'K2O';
                                norm_vals.(cur_el)(2,1) = K2O_to_K(data(1,nr_datset).(control_datatype).(alt_el).Values(nr_sample,1).*10000);
                            elseif strcmpi('P',cur_el);
                                alt_el = 'P2O5';
                                norm_vals.(cur_el)(2,1) = P2O5_to_P(data(1,nr_datset).(control_datatype).(alt_el).Values(nr_sample,1).*10000);
                            elseif strcmpi('Ti',cur_el);
                                alt_el = 'TiO2';
                                norm_vals.(cur_el)(2,1) = TiO2_to_Ti(data(1,nr_datset).(control_datatype).(alt_el).Values(nr_sample,1).*10000);
                            else
                                norm_vals.(cur_el)(2,1) = data(1,nr_datset).(control_datatype).(cur_el).Values(nr_sample,1);
                            end
                    end
                        % Control element
                        assignin('base','norm_vals',norm_vals)
                end
            end
        else
            set(set_pan_txt11,'String','')
        end
    end

%% 02a Sliders Callback

    function slider_callback(obj,~)
        % Get the new value
        new_val = get(obj,'Value');
        % Setup the new value in text below the slider
        set(set_pan_txt4,'String',sprintf('%1.2f points',new_val))
        % Change the colour of the update button
        set(set_pan_but1,'BackGroundColor',[1.0,0.5,0.0])
    end

    function slider_h_callback(obj,~)
        % Get the new value
        new_val = get(obj,'Value');
        % Setup the new value in text below the slider
        set(set_pan_txt8,'String',sprintf('%1.2f',new_val))
        % Change the colour of the update button
        set(set_pan_but1,'BackGroundColor',[1.0,0.5,0.0])
    end        

    function slider_w_callback(obj,~)
        % Get the new value
        new_val = get(obj,'Value');
        % Setup the new value in text below the slider
        set(set_pan_txt10,'String',sprintf('%1.3f',new_val))
        % Change the colour of the update button
        set(set_pan_but1,'BackGroundColor',[1.0,0.5,0.0])
    end

%% 02b Axis limitations callback

    function axeslim_callback(obj,~)
        % Get the new value from used object
        new_val = str2double(get(obj,'String'));
        % Get the tag from the used object
        new_val_tag = get(obj,'Tag');
        % Report an error if the input was empty or text
        if isnan(new_val)
            if strcmpi(new_val_tag,'ymin')
                errordlg(sprintf('The Y-axis minimum input is not valid!\nOnly numeric inputs allowed!\nValid inputs: e.g., 0.0001, 42'),'Y-Axis Minimum Input Error','modal')
                set(set_pan_edit1,'String',num2str(ymin_val))
            elseif strcmpi(new_val_tag,'ymax')
                errordlg(sprintf('The Y-axis maximum input is not valid!\nOnly numeric inputs allowed!\nValid inputs: e.g., 0.0001, 42'),'Y-Axis Maximum Input Error','modal')
                set(set_pan_edit2,'String',num2str(ymax_val))
            end
        % Report an error if the axis limit is higher or lower than the vice versa
        % minimum or maximum
        elseif strcmpi(new_val_tag,'ymin') && new_val >= ymax_val
                errordlg(sprintf('The Y-axis minimum input is > than the Y-axis maximum!\nOnly use minimum values < than the maximum!'),'Y-Axis Min>Max Error','modal')
                set(set_pan_edit1,'String',num2str(ymin_val))
                
        % Report an error if the axis limit is higher or lower than the vice versa
        % minimum or maximum
        elseif strcmpi(new_val_tag,'ymax') && new_val <= ymin_val
                errordlg(sprintf('The Y-axis maximum input is < than the Y-axis minimum!\nOnly use minimum values > than the minimum!'),'Y-Axis Max<Min Error','modal')
                set(set_pan_edit2,'String',num2str(ymax_val))

        % Report an error if the axis mimum is negative
        elseif strcmpi(new_val_tag,'ymin') && new_val <= 0
                errordlg(sprintf('The Y-axis minimum input is negative or zero!\nOnly use positive minimum values!'),'Y-Axis minimum <=0 Error','modal')
                set(set_pan_edit1,'String',num2str(ymin_val))

        % Here the input should be valid and therefore the values are
        % overwritten and the update button colour is changed to orange
        else
            if strcmpi(new_val_tag,'ymin')
                ymin_val = new_val;
            elseif strcmpi(new_val_tag,'ymax')
                ymax_val = new_val;
            end
                        
            % Change colour of the update button
            set(set_pan_but1,'BackGroundColor',[1.0,0.5,0.0])
        end
    end

%% 03 Update callback
    function update_callback(~,~)

        % Get all values from control elements
        % Get the value from normalisation popup
        norm_nr = get(set_pan_pop2,'Value');
        % Get the value from element arrangement popup
        sort_sel = get(set_pan_pop1,'Value');
        % Get the line thickness
        line_plot = get(set_pan_sli,'Value');
        % Y-Axis limitations
        ymin = str2double(get(set_pan_edit1,'String'));
        ymax = str2double(get(set_pan_edit2,'String'));
        % Get the dimension of the plot
        plot_height = get(set_pan_sli_h,'Value');
        plot_width = get(set_pan_sli_w,'Value');
        
        % Get the correct elements sort order
        switch sort_sel
            case 1
                so_ree = {'La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu'};
                % Get the size of the selected sort order
                [~,N] = size(so_ree);
                % Create a counter for true values
                counter = 0;
                for I = 1:N
                    if isfinite(norm_vals.(so_ree{1,I})(norm_nr,1))
                        counter = counter+1;
                        so{counter} = so_ree{1,I};  %#ok<AGROW>
                    end
                end
            case 2
                so_multi1 = {'Sr','K','Rb','Ba','Th','Ta','Nb','Ce','P','Zr','Hf','Sm','Ti','Y','Yb'};
                % Get the size of the selected sort order
                [~,N] = size(so_multi1);
                % Create a counter for true values
                counter = 0;
                for I = 1:N
                    if isfinite(norm_vals.(so_multi1{1,I})(norm_nr,1))
                        counter = counter+1;
                        so{counter} = so_multi1{1,I};  %#ok<AGROW>
                    end
                end
            case 3 
                so_multi2 = {'Cs','Rb','Ba','Th','U','Nb','Ta','K','La','Ce','Pb','Pr','Nd','Sr','P','Zr','Hf','Sm','Eu','Ti','Gd','Tb','Dy','Ho','Y','Er','Tm','Yb','Lu'}; 
                % Get the size of the selected sort order
                [~,N] = size(so_multi2);
                % Create a counter for true values
                counter = 0;
                for I = 1:N
                    if isfinite(norm_vals.(so_multi2{1,I})(norm_nr,1))
                        counter = counter+1;
                        so{counter} = so_multi2{1,I}; %#ok<AGROW>
                    end
                end
        end

        % Control elements
        % disp(N)
        % Get the size of final sort order
        [~,N] = size(so);
        % Calculate and define the dimensions of the plot
        xdim = N*plot_width+0.1*N*plot_width; ydim = plot_height; xpos = 0.08; ypos = 0.079;
        
        % Create a linear array for x-axis
        xax_cat = linspace(1,N,N);
        
        % Clear the current axes objects
        delete(get(pre_pan,'child'))
        % Create a new plot in preview panel
        pre_plot = axes('Position',[xpos,ypos,xdim,ydim],...
                        'Units','Normalized',...
                        'Parent',pre_pan,...
                        'Box','On');
        % Create the y-axis title
        if norm_nr == 1
            ylab_str = sprintf('Concentration [ppm]');
        elseif norm_nr == 2
            ylab_str = sprintf('Sample / %s',data(1,nr_datset).(control_datatype).Samples{nr_sample,1});
        else
            ylab_str = sprintf('Sample / %s',norm_vals.str{norm_nr,1});
        end
        % Setup axes fonts and titles (scaled down when a lot of elements = multi II)
        if sort_sel == 3
            set(pre_plot,'FontName',control.setup.fonts(1,1).FontName,...
                         'FontSize',control.setup.fonts(1,1).FontSize.*0.7,...
                         'FontWeight',control.setup.fonts(1,1).FontWeight,...
                         'FontAngle',control.setup.fonts(1,1).FontAngle,...
                         'FontUnits',control.setup.fonts(1,1).FontUnits);
            ylabel(ylab_str,'FontName',control.setup.fonts(1,1).FontName,...
                    'FontSize',control.setup.fonts(1,1).FontSize.*0.9,...
                    'FontWeight',control.setup.fonts(1,1).FontWeight,...
                    'FontAngle',control.setup.fonts(1,1).FontAngle,...
                    'Color',control.setup.fonts(1,1).Color,...
                    'FontUnits',control.setup.fonts(1,1).FontUnits)
        else
            set(pre_plot,'FontName',control.setup.fonts(1,1).FontName,...
                         'FontSize',control.setup.fonts(1,1).FontSize.*0.7,...
                         'FontWeight',control.setup.fonts(1,1).FontWeight,...
                         'FontAngle',control.setup.fonts(1,1).FontAngle,...
                         'FontUnits',control.setup.fonts(1,1).FontUnits);
            ylabel(ylab_str,'FontName',control.setup.fonts(1,1).FontName,...
                    'FontSize',control.setup.fonts(1,1).FontSize.*0.9,...
                    'FontWeight',control.setup.fonts(1,1).FontWeight,...
                    'FontAngle',control.setup.fonts(1,1).FontAngle,...
                    'Color',control.setup.fonts(1,1).Color,...
                    'FontUnits',control.setup.fonts(1,1).FontUnits)
        end
        % Setup plot line width
        set(pre_plot,'LineWidth',control.setup.lines(1,1).LineWidth)
        % Setup plot tick length
        if 1200*xdim >= 950*ydim
            set(pre_plot,'TickLength',[10/(1200*xdim) 10/(1200*xdim)])
        else
            set(pre_plot,'TickLength',[10/(950*ydim) 10/(950*ydim)]) 
        end
        
        % Handle X-Axis
        set(pre_plot,'XTick',xax_cat,'XTickLabel',so,'XLim',[min(xax_cat)-0.5,max(xax_cat)+0.5])
        % Handle Y-Axis
        set(pre_plot,'YLim',[ymin,ymax])
        set(pre_plot,'YScale','log')
        yax_str = get(pre_plot,'YTick');
        set(pre_plot,'YTickLabel',yax_str)
        
                    % Setup scale factor
                    control.scafac = 0.8;
                    % Calculate the normalized values for ternary plot and plot them in
                    % inverted order, that the last dataset is found at the bottom
                    for nr_dataset = files_op:-1:1
                        % Get the size of the values for pre-allocation and
                        % later loop
                        [M,~] = size(data(1,nr_dataset).(control_datatype).Samples);
                        % Check if the checkbox for the dataset is enabled
                        if true(opt_check(nr_dataset,1))
                            xcalc = linspace(1,N,N);
                            ycalc = NaN(M,N);
                            % Start loop with the size of the selected
                            % elemental arrangement
                            for  I = 1:N
                                % The current element from sort order
                                ys = so{1,I};
                                
                                % Calculate the values for Y-Axis
                                for J = 1:M
                                        if strcmpi('K',so{1,I});
                                            ys_dat = 'K2O';
                                            ycalc(J,I) = K2O_to_K(data(1,nr_dataset).(control_datatype).(ys_dat).Values(J,1).*10000)./norm_vals.(ys)(norm_nr,1);
                                        elseif strcmpi('P',so{1,I});
                                            ys_dat = 'P2O5';
                                            ycalc(J,I) = P2O5_to_P(data(1,nr_dataset).(control_datatype).(ys_dat).Values(J,1).*10000)./norm_vals.(ys)(norm_nr,1);
                                        elseif strcmpi('Ti',so{1,I});
                                            ys_dat = 'TiO2';
                                            ycalc(J,I) = TiO2_to_Ti(data(1,nr_dataset).(control_datatype).(ys_dat).Values(J,1).*10000)./norm_vals.(ys)(norm_nr,1);
                                        else
                                            ycalc(J,I) = data(1,nr_dataset).(control_datatype).(ys).Values(J,1)./norm_vals.(ys)(norm_nr,1);
                                        end

                                end
                            end

                            % Enable hold
                            hold(pre_plot,'on')
                                % Plot the data in this loop
                                for nr_dat = 1:1:M
                                    % Check if columns were supplied in the input and not
                                    % overwritten by the label option
                                    if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
                                        plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
                                                           'LineStyle','-',...  % Additional line properties
                                                           'Color',data(1,nr_dataset).symbol.mfc{nr_dat,1},...
                                                           'LineWidth',line_plot);
                                        plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
                                                           'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(nr_dat,1).*control.scafac,...
                                                           'Marker',markerid(data(1,nr_dataset).symbol.symbol(nr_dat,1)),...
                                                           'MarkerSize',data(1,nr_dataset).symbol.size(nr_dat,1).*control.scafac,...
                                                           'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{nr_dat,1},...
                                                           'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{nr_dat,1})
                                    else
                                        plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
                                                           'LineStyle','-',...  % Additional line properties
                                                           'Color',data(1,nr_dataset).symbol.mfc,...
                                                           'LineWidth',line_plot);
                                        plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
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
                                            text(xcalc,ycalc(nr_dat,:),data(1,nr_dataset).(control_datatype).Samples{nr_dat,1},'Parent',pre_plot,...
                                                                 'FontName',data(nr_dat,nr_dataset).label.FontName{nr_dat,1},...
                                                                 'FontSize',data(nr_dat,nr_dataset).label.FontSize(nr_dat,1).*control.scafac,...
                                                                 'FontWeight',data(nr_dat,nr_dataset).label.FontWeight{nr_dat,1},...
                                                                 'FontAngle',data(nr_dat,nr_dataset).label.FontAngle{nr_dat,1},...
                                                                 'Color',data(nr_dat,nr_dataset).label.Color{nr_dat,1},...
                                                                 'FontUnits',data(nr_dat,nr_dataset).label.FontUnits{nr_dat,1},...
                                                                 'VerticalAlignment',data(nr_dat,nr_dataset).label.VertAlign{nr_dat,1},...
                                                                 'HorizontalAlignment',data(nr_dat,nr_dataset).label.HoriAlign{nr_dat,1});
                                        else
                                            text(xcalc,ycalc(nr_dat,:),data(1,nr_dataset).(control_datatype).Samples{nr_dat,1},'Parent',pre_plot,...
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
                            hold(pre_plot,'off')
                        end
                    end
        % Change the colour of the update button
        set(set_pan_but1,'BackGroundColor',[0.8,0.8,0.8])
    end

%% 04 Plot callback
    function plot_callback(obj,~)
   
        % Get all values from control elements
        % Get the value from normalisation popup
        norm_nr = get(set_pan_pop2,'Value');
        % Get the value from element arrangement popup
        sort_sel = get(set_pan_pop1,'Value');
        % Get the line thickness
        line_plot = get(set_pan_sli,'Value');
        % Y-Axis limitations
        ymin = str2double(get(set_pan_edit1,'String'));
        ymax = str2double(get(set_pan_edit2,'String'));
        % Get the dimension of the plot
        plot_height = get(set_pan_sli_h,'Value');
        plot_width = get(set_pan_sli_w,'Value');
        
        % Get the correct elements sort order
        switch sort_sel
            case 1
                so_ree = {'La','Ce','Pr','Nd','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu'};
                % Get the size of the selected sort order
                [~,N] = size(so_ree);
                % Create a counter for true values
                counter = 0;
                for I = 1:N
                    if isfinite(norm_vals.(so_ree{1,I})(norm_nr,1))
                        counter = counter+1;
                        so{counter} = so_ree{1,I};  %#ok<AGROW>
                    end
                end
            case 2
                so_multi1 = {'Sr','K','Rb','Ba','Th','Ta','Nb','Ce','P','Zr','Hf','Sm','Ti','Y','Yb'};
                % Get the size of the selected sort order
                [~,N] = size(so_multi1);
                % Create a counter for true values
                counter = 0;
                for I = 1:N
                    if isfinite(norm_vals.(so_multi1{1,I})(norm_nr,1))
                        counter = counter+1;
                        so{counter} = so_multi1{1,I};  %#ok<AGROW>
                    end
                end
            case 3 
                so_multi2 = {'Cs','Rb','Ba','Th','U','Nb','Ta','K','La','Ce','Pb','Pr','Nd','Sr','Zr','Hf','Sm','Eu','Gd','Tb','Dy','Ho','Y','Er','Tm','Yb','Lu'}; 
                % Get the size of the selected sort order
                [~,N] = size(so_multi2);
                % Create a counter for true values
                counter = 0;
                for I = 1:N
                    if isfinite(norm_vals.(so_multi2{1,I})(norm_nr,1))
                        counter = counter+1;
                        so{counter} = so_multi2{1,I}; %#ok<AGROW>
                    end
                end
        end

        % Control elements
        % disp(N)
        % Get the size of final sort order
        [~,N] = size(so);
        % Calculate and define the dimensions of the plot
        xdim = N*plot_width+0.1*N*plot_width; ydim = plot_height; xpos = 0.08; ypos = 0.079;
        % Create a linear array for x-axis
        xax_cat = linspace(1,N,N);
        

        % Create and then hide the GUI during the construction process
        plotfig = figure('Visible','off');
        % Set units of the figure to pixel and hide menu bar.
        set(plotfig,'Units','Pixel','MenuBar','Figure','Color',[1.0 1.0 1.0]);
        % Set size and position (absolute pixel) of the figure and set name of the GUI
        set(plotfig,'Position',[25,25,1200,938],'Name','Variation diagrams');
        % Create a new plot in preview panel
        pre_plot = axes('Position',[xpos,ypos,xdim,ydim],...
                        'Units','Normalized',...
                        'Parent',plotfig,...
                        'Box','On');
        % Create the y-axis title
        % Create the y-axis title
        if norm_nr == 1
            ylab_str = sprintf('Concentration [ppm]');
        elseif norm_nr == 2
            ylab_str = sprintf('Sample / %s',data(1,nr_datset).(control_datatype).Samples{nr_sample,1});
        else
            ylab_str = sprintf('Sample / %s',norm_vals.str{norm_nr,1});
        end
        % Setup axes fonts and titles (scaled down when a lot of elements = multi II)
        if sort_sel == 3
            set(pre_plot,'FontName',control.setup.fonts(1,1).FontName,...
                         'FontSize',control.setup.fonts(1,1).FontSize.*0.7,...
                         'FontWeight',control.setup.fonts(1,1).FontWeight,...
                         'FontAngle',control.setup.fonts(1,1).FontAngle,...
                         'FontUnits',control.setup.fonts(1,1).FontUnits);
            ylabel(ylab_str,'FontName',control.setup.fonts(1,1).FontName,...
                    'FontSize',control.setup.fonts(1,1).FontSize.*0.9,...
                    'FontWeight',control.setup.fonts(1,1).FontWeight,...
                    'FontAngle',control.setup.fonts(1,1).FontAngle,...
                    'Color',control.setup.fonts(1,1).Color,...
                    'FontUnits',control.setup.fonts(1,1).FontUnits)
        else
            set(pre_plot,'FontName',control.setup.fonts(1,1).FontName,...
                         'FontSize',control.setup.fonts(1,1).FontSize.*0.7,...
                         'FontWeight',control.setup.fonts(1,1).FontWeight,...
                         'FontAngle',control.setup.fonts(1,1).FontAngle,...
                         'FontUnits',control.setup.fonts(1,1).FontUnits);
            ylabel(ylab_str,'FontName',control.setup.fonts(1,1).FontName,...
                    'FontSize',control.setup.fonts(1,1).FontSize.*0.9,...
                    'FontWeight',control.setup.fonts(1,1).FontWeight,...
                    'FontAngle',control.setup.fonts(1,1).FontAngle,...
                    'Color',control.setup.fonts(1,1).Color,...
                    'FontUnits',control.setup.fonts(1,1).FontUnits)
        end
        % Setup plot line width
        set(pre_plot,'LineWidth',control.setup.lines(1,1).LineWidth)
        % Setup plot tick length
        if 1200*xdim >= 950*ydim
            set(pre_plot,'TickLength',[10/(1200*xdim) 10/(1200*xdim)])
        else
            set(pre_plot,'TickLength',[10/(950*ydim) 10/(950*ydim)]) 
        end
        
        % Handle X-Axis
        set(pre_plot,'XTick',xax_cat,'XTickLabel',so,'XLim',[min(xax_cat)-0.5,max(xax_cat)+0.5])
        % Handle Y-Axis
        set(pre_plot,'YLim',[ymin,ymax])
        set(pre_plot,'YScale','log')
        yax_str = get(pre_plot,'YTick');
        set(pre_plot,'YTickLabel',yax_str)
        

        % Setup the datatype
        control_datatype = 'dat';
        % Setup scale factor
        control.scafac = 0.8;
        % Calculate the normalized values for ternary plot and plot them in
        % inverted order, that the last dataset is found at the bottom
        for nr_dataset = files_op:-1:1
            % Get the size of the values for pre-allocation and
            % later loop
            [M,~] = size(data(1,nr_dataset).(control_datatype).Samples);
            % Check if the checkbox for the dataset is enabled
            if true(opt_check(nr_dataset,1))
                xcalc = linspace(1,N,N);
                ycalc = NaN(M,N);
                % Start loop with the size of the selected
                % elemental arrangement
                for  I = 1:N
                    % The current element from sort order
                    ys = so{1,I};

                    % Calculate the values for Y-Axis
                    for J = 1:M
                            if strcmpi('K',so{1,I});
                                ys_dat = 'K2O';
                                ycalc(J,I) = K2O_to_K(data(1,nr_dataset).(control_datatype).(ys_dat).Values(J,1).*10000)./norm_vals.(ys)(norm_nr,1);
                            elseif strcmpi('P',so{1,I});
                                ys_dat = 'P2O5';
                                ycalc(J,I) = P2O5_to_P(data(1,nr_dataset).(control_datatype).(ys_dat).Values(J,1).*10000)./norm_vals.(ys)(norm_nr,1);
                            elseif strcmpi('Ti',so{1,I});
                                ys_dat = 'TiO2';
                                ycalc(J,I) = TiO2_to_Ti(data(1,nr_dataset).(control_datatype).(ys_dat).Values(J,1).*10000)./norm_vals.(ys)(norm_nr,1);
                            else
                                ycalc(J,I) = data(1,nr_dataset).(control_datatype).(ys).Values(J,1)./norm_vals.(ys)(norm_nr,1);
                            end

                    end
                end

                % Enable hold
                hold(pre_plot,'on')
                    % Plot the data in this loop
                    for nr_dat = 1:1:M
                        % Check if columns were supplied in the input and not
                        % overwritten by the label option
                        if data(1,nr_dataset).symbol.op.op == true && data(1,nr_dataset).symbol.op.override == false
                            plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
                                               'LineStyle','-',...  % Additional line properties
                                               'Color',data(1,nr_dataset).symbol.mfc{nr_dat,1},...
                                               'LineWidth',line_plot);
                            plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
                                               'LineStyle','none','LineWidth',data(1,nr_dataset).symbol.edgew(nr_dat,1).*control.scafac,...
                                               'Marker',markerid(data(1,nr_dataset).symbol.symbol(nr_dat,1)),...
                                               'MarkerSize',data(1,nr_dataset).symbol.size(nr_dat,1).*control.scafac,...
                                               'MarkerEdgeColor',data(1,nr_dataset).symbol.mec{nr_dat,1},...
                                               'MarkerFaceColor',data(1,nr_dataset).symbol.mfc{nr_dat,1})
                        else
                            plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
                                               'LineStyle','-',...  % Additional line properties
                                               'Color',data(1,nr_dataset).symbol.mfc,...
                                               'LineWidth',line_plot);
                            plot(xcalc,ycalc(nr_dat,:),'Parent',pre_plot,...
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
                                text(xcalc,ycalc(nr_dat,:),data(1,nr_dataset).(control_datatype).Samples{nr_dat,1},'Parent',pre_plot,...
                                                     'FontName',data(nr_dat,nr_dataset).label.FontName{nr_dat,1},...
                                                     'FontSize',data(nr_dat,nr_dataset).label.FontSize(nr_dat,1).*control.scafac,...
                                                     'FontWeight',data(nr_dat,nr_dataset).label.FontWeight{nr_dat,1},...
                                                     'FontAngle',data(nr_dat,nr_dataset).label.FontAngle{nr_dat,1},...
                                                     'Color',data(nr_dat,nr_dataset).label.Color{nr_dat,1},...
                                                     'FontUnits',data(nr_dat,nr_dataset).label.FontUnits{nr_dat,1},...
                                                     'VerticalAlignment',data(nr_dat,nr_dataset).label.VertAlign{nr_dat,1},...
                                                     'HorizontalAlignment',data(nr_dat,nr_dataset).label.HoriAlign{nr_dat,1});
                            else
                                text(xcalc,ycalc(nr_dat,:),data(1,nr_dataset).(control_datatype).Samples{nr_dat,1},'Parent',pre_plot,...
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
                hold(pre_plot,'off')
            end
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
                                                strcat(save_path,'/export/',control.prj_name,'_multipl','.png'));
                % Only print if file was selected
                if ischar(file)
                    print(plotfig,fullfile(path,file),'-dpng','-zbuffer','-r500')
                end
            elseif strcmpi(get(obj,'Tag'),'eps')
                % Change the background color of the GUI to black
                set(plotfig,'Color',[1.0,1.0,1.0],...
                            'PaperPositionMode','manual','PaperPosition',[1,1,30,21.5],...
                            'PaperOrientation','landscape',...
                            'PaperSize',[42 30],'PaperUnits','centimeters');
                % Open save window to select output file
                [file,path] = uiputfile('*.eps','Save plot as encapsuled post script!',...
                                                strcat(save_path,'/export/',control.prj_name,'_multipl','.eps'));
                % Only print if file was selected
                if ischar(file)
                    print(plotfig,fullfile(path,file),'-depsc2','-painters')
                end
            end
        end
    end

%% 00 Make GUI visible
set(mp_main,'Visible','on');

end

