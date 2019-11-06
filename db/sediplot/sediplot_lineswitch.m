function [plotax] = sediplot_lineswitch(control,plotax,plotsel)

% Get the selected plot type
plotsel = control.plots.list(plotsel,1);
% Enable overlay plotting
hold(plotax,'on')

  if strcmpi(plotsel,'Mud-Gravel-Sand diagram')
  %  1 of 10 - Mud-Gravel-Sand diagram
  [plotax] = lines_mugrsa_classification(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Sand-Silt-Clay diagram')
  %  2 of 10 - Sand-Silt-Clay diagram
  [plotax] = lines_clsasi_classification(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qt-F-L (0-15% matrix) diagram')
  %  3 of 10 - Qt-F-L (0-15% matrix) diagram
  [plotax] = lines_qtfl_classification3(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qt-F-L (15-75% matrix) diagram')
  %  4 of 10 - Qt-F-L (15-75% matrix) diagram
  [plotax] = lines_qtfl_classification4(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qt-F-L diagram')
  %  5 of 10 - Qt-F-L diagram
  [plotax] = lines_qtfl_classification1(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qp-Lv-Ls+Lm provenance diagram')
  %  6 of 10 - Qp-Lv-Ls+Lm provenance diagram
  [plotax] = lines_qplvlslm_classification(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qm-F-Lt provenance diagram')
  %  7 of 10 - Qm-F-Lt provenance diagram
  [plotax] = lines_qmflt_classification(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qt-F-L provenance diagram')
  %  8 of 10 - Qt-F-L provenance diagram
  [plotax] = lines_qtfl_classification2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Lm-Lv-Ls provenance diagram')
  %  9 of 10 - Lm-Lv-Ls provenance diagram
  [plotax] = lines_lmlvls_classification(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Qp-Lvm-Lsm provenance diagram')
  % 10 of 10 - Qp-Lvm-Lsm provenance diagram
  [plotax] = lines_qplvmlsm_classification(control,plotax);
  %
  %
  else
    fprintf('Error: Unknown plot!\n');
  end
  %
  %
% Disable overlay plotting
hold(plotax,'on')
end
