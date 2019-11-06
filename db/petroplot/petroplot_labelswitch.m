function [plotax] = petroplot_labelswitch(control,plotax,plotsel)

% Get the selected plot type
plotsel = control.plots.list(plotsel,1);
% Enable overlay plotting
hold(plotax,'on')

  if strcmpi(plotsel,'QAPF diagram (volcanic rocks)')
  %  1 of 16 - QAPF diagram (volcanic rocks)
  [plotax] = labels_qapf_volcanic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'QAPF diagram (plutonic rocks)')
  %  2 of 16 - QAPF diagram (plutonic rocks)
  [plotax] = labels_qapf_plutonic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'QAP diagram (volcanic rocks)')
  %  3 of 16 - QAP diagram (volcanic rocks)
  [plotax] = labels_qap_volcanic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'QAP diagram (plutonic rocks)')
  %  4 of 16 - QAP diagram (plutonic rocks)
  [plotax] = labels_qap_plutonic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'APF diagram (volcanic rocks)')
  %  5 of 16 - APF diagram (volcanic rocks)
  [plotax] = labels_apf_volcanic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'APF diagram (plutonic rocks)')
  %  6 of 16 - APF diagram (plutonic rocks)
  [plotax] = labels_apf_plutonic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Plg-Px-Ol diagram (gabbroic rocks)')
  %  7 of 16 - Plg-Px-Ol diagram (gabbroic rocks)
  [plotax] = labels_plg_px_ol_gabbros(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Plg-Opx-Cpx diagram (gabbroic rocks)')
  %  8 of 16 - Plg-Opx-Cpx diagram (gabbroic rocks)
  [plotax] = labels_plg_opx_cpx_gabbros(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Plg-Px-Hbl diagram (gabbroic rocks)')
  %  9 of 16 - Plg-Px-Hbl diagram (gabbroic rocks)
  [plotax] = labels_plg_px_hbl_gabbros(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ol-Opx-Cpx diagram (ultramafic rocks)')
  % 10 of 16 - Ol-Opx-Cpx diagram (ultramafic rocks)
  [plotax] = labels_ol_opx_cpx_ultramafic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ol-Px-Hbl diagram (ultramafic rocks)')
  % 11 of 16 - Ol-Px-Hbl diagram (ultramafic rocks)
  [plotax] = labels_ol_px_hbl_ultramafic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Mel-Cpx-Ol volcanic diagram')
  % 12 of 16 - Mel-Cpx-Ol volcanic diagram
  [plotax] = labels_mel_cpx_ol_volcanic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Mel-Cpx-Ol plutonic diagram')
  % 13 of 16 - Mel-Cpx-Ol plutonic diagram
  [plotax] = labels_mel_cpx_ol_plutonic(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'An-Ab-Or feldspar diagram')
  % 14 of 16 - An-Ab-Or feldspar diagram
  [plotax] = labels_an_ab_or_feldspar(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Or-Ab-An feldspar diagram')
  % 15 of 16 - Or-Ab-An feldspar diagram
  [plotax] = labels_or_ab_an_feldspar(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Fs-Wo-En pyroxene diagram')
  % 16 of 16 - Fs-Wo-En pyroxene diagram
  [plotax] = labels_fs_wo_en_pyroxene(control,plotax);
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
