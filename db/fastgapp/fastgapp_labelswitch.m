function [plotax] = fastgapp_labelswitch(control,plotax,plotsel)

% Get the selected plot type
plotsel = control.plots.list(plotsel,1);
% Enable overlay plotting
hold(plotax,'on')

  if strcmpi(plotsel,'TAS classification diagram (volcanic rocks I)')
  %  1 of 83 - TAS classification diagram (volcanic rocks I)
  [plotax] = labels_lebas_etal_1986_tas(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TAS (discrimination line I)')
  %  2 of 83 - TAS (discrimination line I)
  [plotax] = labels_macdonald_1968_tas(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TAS (discrimination line II)')
  %  3 of 83 - TAS (discrimination line II)
  [plotax] = labels_irvine_baragar_1971_tas(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TAS classification diagram (volcanic rocks II)')
  %  4 of 83 - TAS classification diagram (volcanic rocks II)
  [plotax] = labels_middlemost_1994_tas_volc(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TAS classification diagram (plutonic rocks)')
  %  5 of 83 - TAS classification diagram (plutonic rocks)
  [plotax] = labels_middlemost_1994_tas_plut(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TAS classification diagram (volcanic pebbles)')
  %  6 of 83 - TAS classification diagram (volcanic pebbles)
  [plotax] = labels_cox_etal_1979_tas(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'SiO2 vs. Zr/TiO2 classification diagram')
  %  7 of 83 - SiO2 vs. Zr/TiO2 classification diagram
  [plotax] = labels_winchester_floyd_1977_SiO2ZrTiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'SiO2 vs. Nb/Y classification diagram')
  %  8 of 83 - SiO2 vs. Nb/Y classification diagram
  [plotax] = labels_winchester_floyd_1977_SiO2NbY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr/TiO2 vs. Nb/Y classification diagram')
  %  9 of 83 - Zr/TiO2 vs. Nb/Y classification diagram
  [plotax] = labels_winchester_floyd_1977_ZrTiO2NbY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Na2O vs. K2O classification diagram')
  % 10 of 83 - Na2O vs. K2O classification diagram
  [plotax] = labels_middlemost_1975_Na2OK2O(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'AFM classification diagram')
  % 11 of 83 - AFM classification diagram
  [plotax] = labels_irvine_baragar_1971_afm(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Peraluminity Index vs. Alkalinity Saturation Index')
  % 12 of 83 - Peraluminity Index vs. Alkalinity Saturation Index
  [plotax] = labels_shand_1927_1943_PIASI(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'FeOtot/(MgO+FeOtot) discrimination diagram')
  % 13 of 83 - FeOtot/(MgO+FeOtot) discrimination diagram
  [plotax] = labels_frost_frost_2008_FeOMgOFeOvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'MALI vs. SiO2 discrimination diagram')
  % 14 of 83 - MALI vs. SiO2 discrimination diagram
  [plotax] = labels_frost_frost_2008_MALIvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Alkalinity Saturation Index vs. SiO2')
  % 15 of 83 - Alkalinity Saturation Index vs. SiO2
  [plotax] = labels_frost_frost_2008_ASIvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Peraluminity Index vs. SiO2')
  % 16 of 83 - Peraluminity Index vs. SiO2
  [plotax] = labels_frost_frost_2008_PIvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Sr/Y vs. Y classification diagram')
  % 17 of 83 - Sr/Y vs. Y classification diagram
  [plotax] = labels_hansen_etal_2002_SrYvsY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'P2O5 vs. Zr discrimation diagram')
  % 18 of 83 - P2O5 vs. Zr discrimation diagram
  [plotax] = labels_floyd_winchester_1975_P2O5vsZr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TiO2 vs. Zr/P2O5 discrimation diagram')
  % 19 of 83 - TiO2 vs. Zr/P2O5 discrimation diagram
  [plotax] = labels_floyd_winchester_1975_TiO2vsZrP2O5(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb/Y vs. Zr/P2O5 discrimation diagram')
  % 20 of 83 - Nb/Y vs. Zr/P2O5 discrimation diagram
  [plotax] = labels_floyd_winchester_1975_NbYvsZrP2O5(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'K2O vs. SiO2 classification diagram')
  % 21 of 83 - K2O vs. SiO2 classification diagram
  [plotax] = labels_pecerillo_taylor_1976_K2OSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Th vs. Co classification diagram')
  % 22 of 83 - Th vs. Co classification diagram
  [plotax] = labels_hastie_etal_2007_ThCo(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'FeOtotal / MgO vs. SiO2 classification diagram')
  % 23 of 83 - FeOtotal / MgO vs. SiO2 classification diagram
  [plotax] = labels_miyashiro_1974_FeOMgOvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'FeOtotal vs. FeOtotal / MgO classification diagram')
  % 24 of 83 - FeOtotal vs. FeOtotal / MgO classification diagram
  [plotax] = labels_miyashiro_shido_1975_FeOvsFeOMgO(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TiO2 vs. FeOtotal / MgO classification diagram')
  % 25 of 83 - TiO2 vs. FeOtotal / MgO classification diagram
  [plotax] = labels_miyashiro_shido_1975_TiO2vsFeOMgO(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'V vs. FeOtotal / MgO classification diagram I')
  % 26 of 83 - V vs. FeOtotal / MgO classification diagram I
  [plotax] = labels_miyashiro_shido_1975_VvsFeOMgO(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'V vs. FeOtotal / MgO classification diagram II')
  % 27 of 83 - V vs. FeOtotal / MgO classification diagram II
  [plotax] = labels_miyashiro_shido_1975_VvsFeOMgO_2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Cr vs. SiO2 classification diagram')
  % 28 of 83 - Cr vs. SiO2 classification diagram
  [plotax] = labels_miyashiro_shido_1975_CrvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'V vs. Cr classification diagram')
  % 29 of 83 - V vs. Cr classification diagram
  [plotax] = labels_miyashiro_shido_1975_VvsCr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'CaO/(Na2O+K20) vs. SiO2 discrimination diagram')
  % 30 of 83 - CaO/(Na2O+K20) vs. SiO2 discrimination diagram
  [plotax] = labels_brown_1982_CaoNa2OK2OvsSiO2(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Na2O + K2O vs. 10000*Ga/Al granite subdivision')
  % 31 of 83 - Na2O + K2O vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_TAvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'(Na2O + K2O) / CaO vs. 10000*Ga/Al granite subdivision')
  % 32 of 83 - (Na2O + K2O) / CaO vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_TACaOvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'K2O / MgO vs. 10000*Ga/Al granite subdivision')
  % 33 of 83 - K2O / MgO vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_K2OMgOvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'FeOtotal / MgO vs. 10000*Ga/Al granite subdivision')
  % 34 of 83 - FeOtotal / MgO vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_FeOMgOvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr vs. 10000*Ga/Al granite subdivision')
  % 35 of 83 - Zr vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_ZrvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb vs. 10000*Ga/Al granite subdivision')
  % 36 of 83 - Nb vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_NbvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ce vs. 10000*Ga/Al granite subdivision')
  % 37 of 83 - Ce vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_CevsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Y vs. 10000*Ga/Al granite subdivision')
  % 38 of 83 - Y vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_YvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zn vs. 10000*Ga/Al granite subdivision')
  % 39 of 83 - Zn vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_ZnvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'AI vs. 10000*Ga/Al granite subdivision')
  % 40 of 83 - AI vs. 10000*Ga/Al granite subdivision
  [plotax] = labels_whalen_1987_NaKAlvsGaAl(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'FeOtot / MgO vs. Zr+Nb+Ce+Y granite subdivision')
  % 41 of 83 - FeOtot / MgO vs. Zr+Nb+Ce+Y granite subdivision
  [plotax] = labels_whalen_1987_FeOMgOvsZrNbCeY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'(Na2O + K2O) / CaO vs. Zr+Nb+Ce+Y granite subdivision')
  % 42 of 83 - (Na2O + K2O) / CaO vs. Zr+Nb+Ce+Y granite subdivision
  [plotax] = labels_whalen_1987_TACaOvsZrNbCeY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Rb/Nb vs. Y/Nb granite subdivision')
  % 43 of 83 - Rb/Nb vs. Y/Nb granite subdivision
  [plotax] = labels_eby_1992_RbNbYNb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Y/Nb vs. Sc/Nb granite subdivision')
  % 44 of 83 - Y/Nb vs. Sc/Nb granite subdivision
  [plotax] = labels_eby_1992_YNbScNb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb-Y-Ga A-type granite subdivision ')
  % 45 of 83 - Nb-Y-Ga A-type granite subdivision 
  [plotax] = labels_eby_1992_NbYGa(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb-Y-Ce A-type granite subdivision ')
  % 46 of 83 - Nb-Y-Ce A-type granite subdivision 
  [plotax] = labels_eby_1992_NbYCe(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ga/Al vs. Eu/Eu* granite subdivision')
  % 47 of 83 - Ga/Al vs. Eu/Eu* granite subdivision
  [plotax] = labels_eby_1992_GaAlEuEu(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Yb vs. Al2O3 granite subdivision')
  % 48 of 83 - Yb vs. Al2O3 granite subdivision
  [plotax] = labels_arth_1979_YbAl2O3(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Carbonatite classification diagram I')
  % 49 of 83 - Carbonatite classification diagram I
  [plotax] = labels_lebas_streckeisen_1991_carbonatites(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Carbonatite classification diagram II')
  % 50 of 83 - Carbonatite classification diagram II
  [plotax] = labels_gittins_harmer_1997_carbonatites(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Th/Ta vs. Yb discrimination diagram')
  % 51 of 83 - Th/Ta vs. Yb discrimination diagram
  [plotax] = labels_gorton_schandl_2000_ThTavsYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Th/Yb vs. Ta/Yb discrimination diagram I')
  % 52 of 83 - Th/Yb vs. Ta/Yb discrimination diagram I
  [plotax] = labels_gorton_schandl_2000_ThYbvsTaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'MnO-TiO2-P2O5 classification diagram')
  % 53 of 83 - MnO-TiO2-P2O5 classification diagram
  [plotax] = labels_mullen_1983_MnOTiO2P2O5(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'TiO2-K2O-P2O5 classification diagram')
  % 54 of 83 - TiO2-K2O-P2O5 classification diagram
  [plotax] = labels_pearce_etal_1975_P2O5TiO2K2O(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Al2O3-FeO-MgO classification diagram')
  % 55 of 83 - Al2O3-FeO-MgO classification diagram
  [plotax] = labels_pearce_etal_1977_MgOAl2O3FeO(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr/Nb vs. Nb/Th geotectonic discrimination diagram')
  % 56 of 83 - Zr/Nb vs. Nb/Th geotectonic discrimination diagram
  [plotax] = labels_condie_2005_ZrNbNbTh(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb/Y vs. Zr/Y geotectonic discrimination diagram')
  % 57 of 83 - Nb/Y vs. Zr/Y geotectonic discrimination diagram
  [plotax] = labels_condie_2005_NbYZrY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb/Y vs. Zr/Y source discrimination diagram')
  % 58 of 83 - Nb/Y vs. Zr/Y source discrimination diagram
  [plotax] = labels_fitton_etal_1997_NbYZrY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr/4-2Nb-Y geotectonic classification diagram')
  % 59 of 83 - Zr/4-2Nb-Y geotectonic classification diagram
  [plotax] = labels_meschede_1986_2NbZr4Y(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ti vs Zr geotectonic classification diagram')
  % 60 of 83 - Ti vs Zr geotectonic classification diagram
  [plotax] = labels_pearce_cann_1973_ZrTi(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Sr/2-Ti/100-Zr geotectonic discrimination diagram')
  % 61 of 83 - Sr/2-Ti/100-Zr geotectonic discrimination diagram
  [plotax] = labels_pearce_cann_1973_Sr2Ti100Zr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ti/100-3Y-Zr geotectonic discrimination diagram')
  % 62 of 83 - Ti/100-3Y-Zr geotectonic discrimination diagram
  [plotax] = labels_pearce_cann_1973_Ti1003YZr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ta-Th-Hf/3 geotectonic discrimination diagram')
  % 63 of 83 - Ta-Th-Hf/3 geotectonic discrimination diagram
  [plotax] = labels_wood_1980_ThHf3Ta(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb/8-La/10-Y/15 geotectonic classification diagram')
  % 64 of 83 - Nb/8-La/10-Y/15 geotectonic classification diagram
  [plotax] = labels_cabanis_lecolle_1989_Nb8Y15La10(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb/La vs. La/Yb geotectonic classification diagram')
  % 65 of 83 - Nb/La vs. La/Yb geotectonic classification diagram
  [plotax] = labels_hollocher_etal_2012_NbLaLaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'17.9*Ta/La vs. La/Yb geotectonic classification diagram')
  % 66 of 83 - 17.9*Ta/La vs. La/Yb geotectonic classification diagram
  [plotax] = labels_hollocher_etal_2012_TaLaLaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'((Nb+17.9*Ta)/2)/La vs. La/Yb geotectonic classification diagram')
  % 67 of 83 - ((Nb+17.9*Ta)/2)/La vs. La/Yb geotectonic classification diagram
  [plotax] = labels_hollocher_etal_2012_NbTaLaLaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Th/La vs. La/Yb geotectonic classification diagram')
  % 68 of 83 - Th/La vs. La/Yb geotectonic classification diagram
  [plotax] = labels_hollocher_etal_2012_ThLaLaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'V vs. Ti discrimination diagram')
  % 69 of 83 - V vs. Ti discrimination diagram
  [plotax] = labels_shervais_1982_TiV(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Cr vs. Ti discrimination diagram')
  % 70 of 83 - Cr vs. Ti discrimination diagram
  [plotax] = labels_pearce_1975_CrvsTi(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Cr vs. Y discrimination diagram')
  % 71 of 83 - Cr vs. Y discrimination diagram
  [plotax] = labels_dilek_etal_2007_CrvsY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr vs. Ti discrimination diagram')
  % 72 of 83 - Zr vs. Ti discrimination diagram
  [plotax] = labels_dilek_furnes_2009_ZrvsTi(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr/Y vs. Zr discrimination diagram I')
  % 73 of 83 - Zr/Y vs. Zr discrimination diagram I
  [plotax] = labels_pearce_norry_1979_ZrYvsZr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ti vs. Zr discrimination diagram I')
  % 74 of 83 - Ti vs. Zr discrimination diagram I
  [plotax] = labels_pearce_etal_1981_TivsZr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'K2O/Yb vs. Ta/Yb discrimination diagram')
  % 75 of 83 - K2O/Yb vs. Ta/Yb discrimination diagram
  [plotax] = labels_pearce_1982_K2OYbvsTaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Th/Yb vs. Ta/Yb discrimination diagram II')
  % 76 of 83 - Th/Yb vs. Ta/Yb discrimination diagram II
  [plotax] = labels_pearce_1982_ThYbvsTaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Ti/Y vs. Nb/Y discrimination diagram')
  % 77 of 83 - Ti/Y vs. Nb/Y discrimination diagram
  [plotax] = labels_pearce_1982_TiYvsNbY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Th/Yb vs. Ta/Yb discrimination diagram III')
  % 78 of 83 - Th/Yb vs. Ta/Yb discrimination diagram III
  [plotax] = labels_pearce_1983_ThYbvsTaYb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Zr/Y vs. Zr discrimination diagram II')
  % 79 of 83 - Zr/Y vs. Zr discrimination diagram II
  [plotax] = labels_pearce_1983_ZrYvsZr(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Rb vs. Y + Nb discrimination diagram')
  % 80 of 83 - Rb vs. Y + Nb discrimination diagram
  [plotax] = labels_pearce_etal_1984_RbYNb(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Rb vs. Yb + Ta discrimination diagram')
  % 81 of 83 - Rb vs. Yb + Ta discrimination diagram
  [plotax] = labels_pearce_etal_1984_RbYbTa(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Nb vs. Y discrimination diagram')
  % 82 of 83 - Nb vs. Y discrimination diagram
  [plotax] = labels_pearce_etal_1984_NbY(control,plotax);
  %
  %
  elseif strcmpi(plotsel,'Yb vs. Ta discrimination diagram')
  % 83 of 83 - Yb vs. Ta discrimination diagram
  [plotax] = labels_pearce_etal_1984_TaYb(control,plotax);
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
