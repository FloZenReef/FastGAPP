function [control] = soilplot_control

% Title of the program
control.title = 'SoilPlot v1.0';

% Name of the program
control.program = 'SoilPlot';

% Number valid header entries
control.header.m =  3;
% Valid header and fulltext header entries
control.header.valid = {...
                        'Sand','>2mm fraction','Sand','%';...
                        'Silt','<2mm & >63µm fraction','Silt','%';...
                        'Clay','<63µm fraction','Clay','%';...
                        };

% Number of plots
control.plots.m =  1;
% List of plot for button names and plot information
control.plots.list = {...
                      'Sand-Silt-Clay soil classification diagram','ternary',{'Silt';'Clay';'Sand'},{'fraction';'fraction';'fraction'},{'-';'-';'-'},'soil classification','net','all','soil','all','Sand-Silt-Clay soil classification diagram (after USDA (United States Department of Agriculture) classification of soils)';...
                      };
% List of plot for button names and plot information
control.plots.description = {...
                      'USDA (United States Department of Agriculture) classification of soils','USDA (United States Department of Agriculture) classification of soils','Sand-Silt-Clay classification diagram\n(USDA recommendation)';...
                      };
end