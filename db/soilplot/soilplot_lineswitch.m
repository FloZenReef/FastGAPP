function [plotax] = soilplot_lineswitch(control,plotax,plotsel)

% Get the selected plot type
plotsel = control.plots.list(plotsel,1);
% Enable overlay plotting
hold(plotax,'on')

  if strcmpi(plotsel,'Sand-Silt-Clay soil classification diagram')
  %  1 of  1 - Sand-Silt-Clay soil classification diagram
  [plotax] = lines_ssc_classification(control,plotax);
  %
  %
% Disable overlay plotting
hold(plotax,'on')
end
