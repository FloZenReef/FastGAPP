function tool_PTE
%% 00a Create the figure
fig_pte = figure('Visible','off');
% Set units of the figure to pixel and hide menu bar.
set(fig_pte,'Units','pixel','MenuBar','figure');
% Set size and position (absolute pixel) of the figure and set name of the GUI
set(fig_pte,'Position',[50,50,1280,920],'Name','Periodic Table of Elements v1.0');
% Change the background color of the GUI to black
set(fig_pte,'Color',[1.,1.,1.]);
%% 00b Load the database
% Load the database
[elements chem] = elements_database;
% Get the number of elements
[m ~] = size(elements);
%% 01 Create axes object in figure
% Create axes object
pte_ax = axes('Parent',fig_pte,'Position',[0.01,0.01,0.98,0.98],'Units','normalized');
% Setup axes object
set(pte_ax,'XLim',[0 19],'YLim',[0 10])
% Switch axis off
axis off;
%% 02a Vertical lines
% for main groups (1-3)
line([0.5 0.5],[9.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([1.5 1.5],[9.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([2.5 2.5],[8.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([3.5 3.5],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
% for main groups (4-18)
line([4.0 4.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([5.0 5.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([6.0 6.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([7.0 7.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([8.0 8.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([9.0 9.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([10.0 10.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([11.0 11.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([12.0 12.0],[6.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([13.0 13.0],[8.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([14.0 14.0],[8.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([15.0 15.0],[8.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([16.0 16.0],[8.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([17.0 17.0],[8.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([18.0 18.0],[9.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([19.0 19.0],[9.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
% for lanthanides and actinides
line([4.0 4.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([5.0 5.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([6.0 6.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([7.0 7.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([8.0 8.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([9.0 9.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([10.0 10.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([11.0 11.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([12.0 12.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([13.0 13.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([14.0 14.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([15.0 15.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([16.0 16.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([17.0 17.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([18.0 18.0],[0.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
%% 02b Horizontal lines
% for main groups (1-3)
line([0.5 1.5],[9.5 9.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 2.5],[8.5 8.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 2.5],[7.5 7.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 3.5],[6.5 6.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 3.5],[5.5 5.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 3.5],[4.5 4.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 3.5],[3.5 3.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([0.5 3.5],[2.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
% for main groups (4-19)
line([18.0 19.0],[9.5 9.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([13.0 19.0],[8.5 8.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([13.0 19.0],[7.5 7.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 19.0],[6.5 6.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 19.0],[5.5 5.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 19.0],[4.5 4.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 19.0],[3.5 3.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 19.0],[2.5 2.5],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
% for lanthanides and actinides
line([4.0 18.0],[2.0 2.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 18.0],[1.0 1.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
line([4.0 18.0],[0.0 0.0],'LineStyle','-','LineWidth',2,'Color',[0,0,0])
% axis off;
%% 03a Other lines
% dotted for lanthanides and actinides
line([3.5 4.0],[4.5 4.5],'LineStyle',':','LineWidth',2,'Color',[0,0,0])
line([3.5 4.0],[3.5 3.5],'LineStyle',':','LineWidth',2,'Color',[0,0,0])
line([3.5 4.0],[2.5 2.5],'LineStyle',':','LineWidth',2,'Color',[0,0,0])
% solid for lanthanides and actinides
line([3.5 3.9 3.9 2.4 2.4 2.5],...
     [4.0 4.0 2.1 2.1 1.5 1.5],'LineStyle','-','LineWidth',1.5,'Color',[0,0,0])
line([3.5 3.6 3.6 2.1 2.1 2.5],...
     [3.0 3.0 2.4 2.4 0.5 0.5],'LineStyle','-','LineWidth',1.5,'Color',[0,0,0])
%% 03b Boxes with text
line([2.5 2.5 4.0 4.0 2.5],...
     [1.25 1.75 1.75 1.25 1.25],'LineStyle','-','LineWidth',1.5,'Color',[0,0,0])
text(3.25,1.5,'Lanthanides',...
              'FontSize',10,'FontWeight','Bold',...
              'HorizontalAlignment','Center','VerticalAlignment','Middle')
line([2.5 2.5 4.0 4.0 2.5],...
     [0.25 0.75 0.75 0.25 0.25],'LineStyle','-','LineWidth',1.5,'Color',[0,0,0])
text(3.25,0.5,'Actinides',...
              'FontSize',10,'FontWeight','Bold',...
              'HorizontalAlignment','Center','VerticalAlignment','Middle')
%% 03c Plot period title
xpos = 0.45; ypos = 9;
for i = 1:7
text(xpos,ypos,num2str(i),...
              'FontSize',14,'FontWeight','Bold',...
              'HorizontalAlignment','Right','VerticalAlignment','Middle')
ypos = ypos - 1;
end
%% 03d Plot group label
% Group label
grouplable = {'IA';'IIA';'IIIB';'IVB';'VB';'VIB';'VIIB';'VIII';'VIII';'VIII';'IB';'IIB';'IIIA';'IVA';'VA';'VIA';'VIIA';'VIIIA'};
% Initial position
xpos = 1.48; ypos = 9.6;
for i = 1:18
text(xpos,ypos,grouplable{i,1},...
              'FontSize',14,'FontWeight','Bold',...
              'HorizontalAlignment','Right','VerticalAlignment','Middle')
xpos = xpos + 1;
if i == 1
ypos = ypos - 1;
elseif i == 2
ypos = ypos - 2;
elseif i == 3
xpos = xpos + 0.5;
elseif i == 12
ypos = ypos + 2;
elseif i == 17
ypos = ypos + 1;
end
end
%% 04 Plot database
% Initial position
xpos = 1; ypos = 9;
% Plot chemical elements
for i = 1:m
% Plot chemical symbols
    cur_sym = text(xpos,ypos-0.1,chem.(elements{i,1}).symbol,...
                        'FontWeight','Bold',...
                        'HorizontalAlignment','Center','VerticalAlignment','Middle');
    % Change font size if more than 2 characters
    if length(chem.(elements{i,1}).symbol) > 2
        set(cur_sym,'FontSize',24);
    else
        set(cur_sym,'FontSize',28);
    end
    % Adjust the font color
    if strcmpi(chem.(elements{i,1}).state,'gaseous')
        set(cur_sym,'Color',[0.0,0.8,0.0])
    elseif strcmpi(chem.(elements{i,1}).state,'solid')
        set(cur_sym,'Color',[0.0,0.0,0.0])
    elseif strcmpi(chem.(elements{i,1}).state,'liquid')
        set(cur_sym,'Color',[0.0,0.0,1.0])
    elseif strcmpi(chem.(elements{i,1}).state,'radioactive')
        set(cur_sym,'Color',[1.0,0.0,0.0])
    else
        set(cur_sym,'Color',[0.3,0.3,0.3])
    end
    % Plot atomic number
    text(xpos-0.46,ypos+0.42,num2str(chem.(elements{i,1}).atomicnumber),...                        
                        'FontSize',8,'FontWeight','Bold',...
                        'HorizontalAlignment','Left','VerticalAlignment','Middle');
    % Plot molar weight
    if ischar(chem.(elements{i,1}).molarweight)
    text(xpos-0.46,ypos+0.28,chem.(elements{i,1}).molarweight,...
                            'FontSize',7,'FontWeight','Normal',...
                            'HorizontalAlignment','Left','VerticalAlignment','Middle');
    else
    text(xpos-0.46,ypos+0.28,num2str(chem.(elements{i,1}).molarweight),...
                            'FontSize',7,'FontWeight','Normal',...
                            'HorizontalAlignment','Left','VerticalAlignment','Middle');
    end
    % Plot electronegativity
    text(xpos+0.46,ypos+0.28,num2str(chem.(elements{i,1}).electronegativity),...
                            'FontSize',7,'FontWeight','Normal','Color',[0.0,0.8,0.0],...
                            'HorizontalAlignment','Right','VerticalAlignment','Middle');
    % Plot element name
    text(xpos,ypos-0.4,chem.(elements{i,1}).name,...
               'FontSize',7,'FontWeight','Bold',...
               'HorizontalAlignment','Center','VerticalAlignment','Middle');

% Update position
if i == 1
xpos = xpos + 17.5;
elseif i == 2
xpos = xpos - 17.5; ypos = ypos - 1;
elseif i == 4
xpos = xpos + 11.5;
elseif i == 10;
xpos = xpos - 17.5; ypos = ypos - 1;
elseif i == 12
xpos = xpos + 11.5;
elseif i == 18
xpos = xpos - 17.5; ypos = ypos - 1;
elseif i == 21
xpos = xpos + 1.5;
elseif i == 36
xpos = xpos - 17.5; ypos = ypos - 1;
elseif i == 39
xpos = xpos + 1.5;
elseif i == 54
xpos = xpos - 17.5; ypos = ypos - 1;
elseif i == 57
xpos = xpos + 1.5; ypos = ypos - 2.5;
elseif i == 71
xpos = xpos - 13.0; ypos = ypos + 2.5;
elseif i == 86
xpos = xpos - 17.5; ypos = ypos - 1;
elseif i == 89
xpos = xpos + 1.5; ypos = ypos - 2.5;
elseif i == 103
xpos = xpos - 13.0; ypos = ypos + 2.5;
else
xpos = xpos + 1;
end

end
%% 00c Make figure visible
set(fig_pte,'Visible','On')
end