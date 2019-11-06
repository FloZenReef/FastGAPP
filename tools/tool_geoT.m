function tool_geoT
% Tool - GeoT
% Calculate the geothermal gradient in purely conductive equilibrium
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Florian Riefstahl
% Institutions: University of Bremen, Bremen, Germany
%               Alfred-Wegener-Institute, Bremerhaven, Germany
%               Christian-Albrechts-University Kiel, Kiel, Germany
% Version: Initial version 2014-2015
%%% Revisions %%%
% 2019 - Some minor revisions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Create the GUI figure
% Resolution = 780p
mainGUI = figure('Visible','off','Color',[0.8,0.8,0.8],...
                                 'Position',[25,25,1280,780]);
% Set title of the figure
set(mainGUI,'Name','GeoT');
% Move the GUI into the center of the monitor
movegui(mainGUI,'center');
% Deactivate figure number and resizing
set(mainGUI,'NumberTitle','off','Resize','off')
% Setup the pointer and renderer
set(mainGUI,'Pointer','arrow','Renderer','zbuffer')
% Set units of the figure to pixel and hide menu bar.
set(mainGUI,'Units','pixel','MenuBar','none');

%% Set default values

% Model parameters
T_surface = 15;         % surface temperature [°C]
T_mantle  = 800;        % basal temperature [°C]
z_model   = 35 .* 1000; % model thickness or moho depth [m]
kappa     = 25;         % thermal diffusivity [km²/Ma]
H         = 10;         % heat production rate [°C/Ma]
rho       = 2700;       % density [kg/m³]
Cp        = 1000;       % specific heat capacity [J/kg*K]

% Time recalculations
oneMa    = 3600 .* 24 .* 365.24 .* 1000000; % 1 Ma [s]

% Deviated parameters
% Thermal conductivity [W/m*K / J/s*m*K]
k = (kappa.*1000000/oneMa) .* rho .* Cp;
% Heat production [µW/m³]
A = ((H  ./ oneMa) .* rho .* Cp) * 1000000;
% Surface heat flow [mW/m²)
q0 = (((T_mantle - T_surface) .* k ./ z_model) + (A ./ 1000000) .* z_model) .* 1000;

%% Calculate temperature field and geothermal gradient

[G_3km,G_5km,G_10km,G_all,z_step,T_step] = tool_geoT_field(A,k,q0,T_surface,z_model);

%% Create parameter objects
hpanel1 = uipanel('Title','Model parameters',...
                 'Parent',mainGUI,...
                 'Position',[.01,.61,.23,.34],...
                 'Units','Normalized',...
                 'Fontsize',12,...
                 'FontWeight','bold',...
                 'TitlePosition','CenterTop',...
                 'BackgroundColor',[0.8,0.8,0.8]);

% 1
htext1 = uicontrol('Style','Text','String','surface temperature',...
                   'Position',[25,750,170,16]);
set(htext1,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8]) 

hedit1 = uicontrol('Style','Edit','String',num2str(T_surface),...
                   'Position',[200,749,50,18]);
set(hedit1,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext1unit = uicontrol('Style','Text','String','°C',...
                   'Position',[255,750,50,16]);
set(htext1unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 2
htext2 = uicontrol('Style','Text','String','basal temperature',...
                   'Position',[25,730,170,16]);
set(htext2,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])        

hedit2 = uicontrol('Style','Edit','String',num2str(T_mantle),...
                   'Position',[200,729,50,18]);
set(hedit2,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext2unit = uicontrol('Style','Text','String','°C',...
                   'Position',[255,730,50,16]);
set(htext2unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 3
htext3 = uicontrol('Style','Text','String','model thickness',...
                   'Position',[25,710,170,16]);
set(htext3,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit3 = uicontrol('Style','Edit','String',num2str(z_model./1000),...
                   'Position',[200,709,50,18]);
set(hedit3,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext3unit = uicontrol('Style','Text','String','km',...
                   'Position',[255,710,50,16]);
set(htext3unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])     
          
% 4
htext4 = uicontrol('Style','Text','String','thermal diffusivity',...
                   'Position',[25,690,170,16]);
set(htext4,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit4 = uicontrol('Style','Edit','String',num2str(kappa),...
                   'Position',[200,689,50,18]);
set(hedit4,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext4unit = uicontrol('Style','Text','String','km²/Ma',...
                   'Position',[255,690,50,16]);
set(htext4unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])          

% 5
htext5 = uicontrol('Style','Text','String','heat production rate',...
                   'Position',[25,670,170,16]);
set(htext5,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit5 = uicontrol('Style','Edit','String',num2str(H),...
                   'Position',[200,669,50,18]);
set(hedit5,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext5unit = uicontrol('Style','Text','String','°C/Ma',...
                   'Position',[255,670,50,16]);
set(htext5unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 6
htext6 = uicontrol('Style','Text','String','density',...
                   'Position',[25,650,170,16]);
set(htext6,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit6 = uicontrol('Style','Edit','String',num2str(rho),...
                   'Position',[200,649,50,18]);
set(hedit6,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext6unit = uicontrol('Style','Text','String','kg/m³',...
                   'Position',[255,650,50,16]);
set(htext6unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 7
htext7 = uicontrol('Style','Text','String','specific heat capacity',...
                   'Position',[25,630,170,16]);
set(htext7,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit7 = uicontrol('Style','Edit','String',num2str(Cp),...
                   'Position',[200,629,50,18]);
set(hedit7,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit1_callback})

htext7unit = uicontrol('Style','Text','String','J/kg*K',...
                   'Position',[255,630,50,16]);
set(htext7unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 8
htext8 = uicontrol('Style','Text','String','thermal conductivity',...
                   'Position',[25,580,170,16]);
set(htext8,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit8 = uicontrol('Style','Text','String',num2str(k,'%.1f'),...
                   'Position',[200,579,50,18]);
set(hedit8,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit2_callback})

htext8unit = uicontrol('Style','Text','String','W/m*K',...
                   'Position',[255,580,50,16]);
set(htext8unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 9
htext9 = uicontrol('Style','Text','String','crustal heat production',...
                   'Position',[25,560,170,16]);
set(htext9,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit9 = uicontrol('Style','Text','String',num2str(A,'%.1f'),...
                   'Position',[200,559,50,18]);
set(hedit9,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit2_callback})

htext9unit = uicontrol('Style','Text','String','µW/m³',...
                   'Position',[255,560,50,16]);
set(htext9unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 10
htext10 = uicontrol('Style','Text','String','surface heat flow',...
                   'Position',[25,540,170,16]);
set(htext10,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

hedit10 = uicontrol('Style','Text','String',num2str(q0,'%.1f'),...
                   'Position',[200,539,50,18]);
set(hedit10,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8],...
                    'Callback',{@edit2_callback})

htext10unit = uicontrol('Style','Text','String','mW/m²',...
                   'Position',[255,540,50,16]);
set(htext10unit,'Fontsize',10,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

%% Create object to display geothermal gradient
hpanel2 = uipanel('Title','Results - Geothermal Gradient',...
                 'Parent',mainGUI,...
                 'Position',[.01,.01,.23,.34],...
                 'Units','Normalized',...
                 'Fontsize',12,...
                 'FontWeight','bold',...
                 'TitlePosition','CenterTop',...
                 'BackgroundColor',[0.8,0.8,0.8]);

% 1
htext12title = uicontrol('Style','Text','String','uppermost 3 km',...
                   'Position',[25,220,150,20]);
set(htext12title,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

htext12val = uicontrol('Style','Text','String',sprintf('%.1f °C/km',G_3km),...
                   'Position',[200,220,100,20]);
set(htext12val,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 2
htext13title = uicontrol('Style','Text','String','uppermost 5 km',...
                   'Position',[25,160,150,20]);
set(htext13title,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

htext13val = uicontrol('Style','Text','String',sprintf('%.1f °C/km',G_5km),...
                   'Position',[200,160,100,20]);
set(htext13val,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 3
htext14title = uicontrol('Style','Text','String','uppermost 10 km',...
                   'Position',[25,100,150,20]);
set(htext14title,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

htext14val = uicontrol('Style','Text','String',sprintf('%.1f °C/km',G_10km),...
                   'Position',[200,100,100,20]);
set(htext14val,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

% 4
htext12title = uicontrol('Style','Text','String','whole model',...
                   'Position',[25,40,150,20]);
set(htext12title,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])

htext15val = uicontrol('Style','Text','String',sprintf('%.1f °C/km',G_all),...
                   'Position',[200,40,100,20]);
set(htext15val,'Fontsize',12,'FontWeight','bold','HorizontalAlignment','Left','BackgroundColor',[0.8,0.8,0.8])


%% Create plot
% Create axes object
GeoT_ax = axes('Units','Pixels','Position',[375,60,675,750]);
% Change properties of the axes object
set(GeoT_ax,'YDir','reverse','LineWidth',2.5,'FontSize',14,'FontWeight','bold')
% Create x- and y-label
ylabel('Depth [km]','FontSize',14,'FontWeight','bold')
xlabel('Temperature [°C]','FontSize',14,'FontWeight','bold')
% Show all axes
box on;

% Plot the data
GeoT_plot = line(T_step,z_step,'LineWidth',5,'Color',[1 0 0]);
          
%% Create table with the data
GeoT_table = uitable('Parent',mainGUI,'Data',[z_step',round(T_step')],...
                     'Position',[1070,60,200,750],...
                     'ColumnName',{'Depth [km]','Temperature [°C]'},'ColumnWidth',{80 100},...
                     'RowName',[]);

%% Callbacks
function edit1_callback(~,~)
    % Get the values from the seven uppermost edits
    T_surface = str2double(get(hedit1,'String'));
    T_mantle  = str2double(get(hedit2,'String'));
    z_model   = str2double(get(hedit3,'String')) .*1000;
    kappa     = str2double(get(hedit4,'String'));
    H         = str2double(get(hedit5,'String'));
    rho       = str2double(get(hedit6,'String'));
    Cp        = str2double(get(hedit7,'String'));

    % Calculate the parameters
    k = (kappa.*1000000/oneMa) .* rho .* Cp;
    A = ((H  ./ oneMa) .* rho .* Cp) * 1000000;
    q0 = (((T_mantle - T_surface) .* k ./ z_model) + (A ./ 1000000) .* z_model) .* 1000;

    % Set the calculated parameters
    set(hedit8,'String',num2str(k,'%.1f'))
    set(hedit9,'String',num2str(A,'%.1f'))
    set(hedit10,'String',num2str(q0,'%.1f'))

    % Calculate new temperature field
    [G_3km,G_5km,G_10km,G_all,z_step,T_step] = tool_geoT_field(A,k,q0,T_surface,z_model);

    % Chancge values in table and plot
    set(GeoT_table,'Data',[z_step',round(T_step')])
    set(GeoT_plot,'XData',T_step,'YData',z_step)

    % Set geothermal gradients
    set(htext12val,'String',sprintf('%.1f °C/km',G_3km))
    set(htext13val,'String',sprintf('%.1f °C/km',G_5km))
    set(htext14val,'String',sprintf('%.1f °C/km',G_10km))
    set(htext15val,'String',sprintf('%.1f °C/km',G_all))
end

%% Make the GUI visible
set(mainGUI,'Visible','on')
end