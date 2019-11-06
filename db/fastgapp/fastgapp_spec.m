function [data,control] = fastgapp_spec(data,control,files_op)
% Go through the loaded files
for i = 1:files_op

% Some additional output to command windows
fprintf('...working on %s...\n',control.files{i,1})
    
	%% 01a Handle FeO and Fe2O3
    % Go through samples and calculate Fe values
    % Case 1: FeO calculated from Fe2O3 --> Fe2O3tot = Fe2O3
    % Case 2: Fe2O3 calculated from FeO --> Fe2O3tot = Fe2O3
    % Case 3: Fe2O3tot calculated from FeO + Fe2O3 (if both are available)
    % FeOtot is always calculated from the formerly calculated Fe2O3
    % Get the size of the samples
    [m,~] = size(data(1,i).dat.Samples);
    % Get three counters to count how many values have been calculated
    counter1 = 0; counter2 = 0; counter3 = 0; counter4 = 0;
    for j = 1:m
        if isfinite(data(1,i).dat.Fe2O3.Values(j,1)) && isnan(data(1,i).dat.FeO.Values(j,1))
            % FeO
            data(1,i).dat.FeO.Values(j,1) = Fe2O3_to_FeO(data(1,i).dat.Fe2O3.Values(j,1));
            % Fe2O3 total
            data(1,i).dat.Fe2O3tot.Values(j,1) = data(1,i).dat.Fe2O3.Values(j,1);
            % FeO
            data(1,i).dat.FeOtot.Values(j,1) = Fe2O3_to_FeO(data(1,i).dat.Fe2O3tot.Values(j,1));
            % Increase counter
            counter1 = counter1 + 1;
            
        elseif isfinite(data(1,i).dat.FeO.Values(j,1)) && isnan(data(1,i).dat.Fe2O3.Values(j,1))
            % Fe2O3
            data(1,i).dat.Fe2O3.Values(j,1) = FeO_to_Fe2O3(data(1,i).dat.FeO.Values(j,1));
            % Fe2O3 total
            data(1,i).dat.Fe2O3tot.Values(j,1) = data(1,i).dat.Fe2O3.Values(j,1);
            % FeO total
            data(1,i).dat.FeOtot.Values(j,1) = Fe2O3_to_FeO(data(1,i).dat.Fe2O3.Values(j,1));
            % Increase counter
            counter2 = counter2 + 1;
            
        elseif isfinite(data(1,i).dat.FeO.Values(j,1)) && isfinite(data(1,i).dat.Fe2O3.Values(j,1))
            % Increase counter
            counter3 = counter3 + 1;
            % Fe2O3 total
            data(1,i).dat.Fe2O3tot.Values(j,1) = data(1,i).dat.Fe2O3.Values(j,1) + FeO_to_Fe2O3(data(1,i).dat.FeO.Values(j,1));
            % FeO total
            data(1,i).dat.FeOtot.Values(j,1) = Fe2O3_to_FeO(data(1,i).dat.Fe2O3tot.Values(j,1));
        else
            if isfinite(data(1,i).dat.FeO.Values(j,1)) && isfinite(data(1,i).dat.Fe2O3.Values(j,1)) && isfinite(data(1,i).dat.FeOtot.Values(j,1)) && isfinite(data(1,i).dat.Fe2O3tot.Values(j,1))
                % Increase counter
                counter4 = counter4 + 1;
            end
        end
    end
    
    % Calculate statistics
    % Fe2O3
    data(1,i).dat.Fe2O3.Max = own_nanmax(data(1,i).dat.Fe2O3.Values);
    data(1,i).dat.Fe2O3.Mean = own_nanmean(data(1,i).dat.Fe2O3.Values);
    data(1,i).dat.Fe2O3.Median = own_nanmed(data(1,i).dat.Fe2O3.Values);
    data(1,i).dat.Fe2O3.Min = own_nanmin(data(1,i).dat.Fe2O3.Values);
    % FeO
    data(1,i).dat.FeO.Max = own_nanmax(data(1,i).dat.FeO.Values);
    data(1,i).dat.FeO.Mean = own_nanmean(data(1,i).dat.FeO.Values);
    data(1,i).dat.FeO.Median = own_nanmed(data(1,i).dat.FeO.Values);
    data(1,i).dat.FeO.Min = own_nanmin(data(1,i).dat.FeO.Values);
    % Fe2O3tot
    data(1,i).dat.Fe2O3tot.Max = own_nanmax(data(1,i).dat.Fe2O3tot.Values);
    data(1,i).dat.Fe2O3tot.Mean = own_nanmean(data(1,i).dat.Fe2O3tot.Values);
    data(1,i).dat.Fe2O3tot.Median = own_nanmed(data(1,i).dat.Fe2O3tot.Values);
    data(1,i).dat.Fe2O3tot.Min = own_nanmin(data(1,i).dat.Fe2O3tot.Values);
    % FeOtot
    data(1,i).dat.FeOtot.Max = own_nanmax(data(1,i).dat.FeOtot.Values);
    data(1,i).dat.FeOtot.Mean = own_nanmean(data(1,i).dat.FeOtot.Values);
    data(1,i).dat.FeOtot.Median = own_nanmed(data(1,i).dat.FeOtot.Values);
    data(1,i).dat.FeOtot.Min = own_nanmin(data(1,i).dat.FeOtot.Values);
    
    % More information
    if counter1 == m
        % FeO
        data(1,i).dat.FeO.UnitIn = data(1,i).dat.FeO.UnitIn;
        data(1,i).dat.FeO.headerv_op = false(size(data(1,i).dat.FeO.headerv_op));
        data(1,i).dat.FeO.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.FeO.headerv_pos = [];
        data(1,i).dat.FeO.headerv_opsum = 2;
        data(1,i).dat.FeO.headerv_calc = 'Fe2O3';
        % Fe2O3tot
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3tot.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_op = false(size(data(1,i).dat.Fe2O3tot.headerv_op));
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_pos = [];
        data(1,i).dat.Fe2O3tot.headerv_opsum = 2;
        data(1,i).dat.Fe2O3tot.headerv_calc = 'Fe2O3';
        % FeOtot
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.FeOtot.UnitIn;
        data(1,i).dat.FeOtot.headerv_op = false(size(data(1,i).dat.FeOtot.headerv_op));
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.FeOtot.headerv_pos = [];
        data(1,i).dat.FeOtot.headerv_opsum = 2;
        data(1,i).dat.FeOtot.headerv_calc = 'Fe2O3tot';
        
    elseif counter2 == m
        % Fe2O3
        data(1,i).dat.Fe2O3.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.Fe2O3.headerv_op = false(size(data(1,i).dat.Fe2O3.headerv_op));
        data(1,i).dat.Fe2O3.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.Fe2O3.headerv_pos = [];
        data(1,i).dat.Fe2O3.headerv_opsum = 2;
        data(1,i).dat.Fe2O3.headerv_calc = 'FeO';
        % Fe2O3tot
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3tot.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_op = false(size(data(1,i).dat.Fe2O3tot.headerv_op));
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_pos = [];
        data(1,i).dat.Fe2O3tot.headerv_opsum = 2;
        data(1,i).dat.Fe2O3tot.headerv_calc = 'Fe2O3';
        % FeOtot
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.FeOtot.UnitIn;
        data(1,i).dat.FeOtot.headerv_op = false(size(data(1,i).dat.FeOtot.headerv_op));
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.FeOtot.headerv_pos = [];
        data(1,i).dat.FeOtot.headerv_opsum = 2;
        data(1,i).dat.FeOtot.headerv_calc = 'Fe2O3tot';
        
    elseif counter3 == m
        % Fe2O3tot
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3tot.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_op = false(size(data(1,i).dat.Fe2O3tot.headerv_op));
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_pos = [];
        data(1,i).dat.Fe2O3tot.headerv_opsum = 2;
        data(1,i).dat.Fe2O3tot.headerv_calc = 'Fe2O3';
        % FeOtot
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.FeOtot.UnitIn;
        data(1,i).dat.FeOtot.headerv_op = false(size(data(1,i).dat.FeOtot.headerv_op));
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.FeO.UnitIn;
        data(1,i).dat.FeOtot.headerv_pos = [];
        data(1,i).dat.FeOtot.headerv_opsum = 2;
        data(1,i).dat.FeOtot.headerv_calc = 'Fe2O3tot';
        
    elseif counter4 == m
        % Nothing will be done here!
        
    else
        % Fe2O3tot
        data(1,i).dat.Fe2O3tot.UnitIn = data(1,i).dat.Fe2O3tot.UnitIn;
        data(1,i).dat.Fe2O3tot.headerv_op = false(size(data(1,i).dat.Fe2O3tot.headerv_op));
        data(1,i).dat.Fe2O3tot.headerv_pos = [];
        data(1,i).dat.Fe2O3tot.headerv_opsum = 2;
        data(1,i).dat.Fe2O3tot.headerv_calc = 'FeO and Fe2O3';
        % FeOtot
        data(1,i).dat.FeOtot.UnitIn = data(1,i).dat.FeOtot.UnitIn;
        data(1,i).dat.FeOtot.headerv_op = false(size(data(1,i).dat.FeOtot.headerv_op));
        data(1,i).dat.FeOtot.headerv_pos = [];
        data(1,i).dat.FeOtot.headerv_opsum = 2;
        data(1,i).dat.FeOtot.headerv_calc = 'Fe2O3tot';
    end

    %% 01b Create NaN-free values for all headers
    
    % Define headers and get their size
    headers = struct();
    headers.input = cell(1,1);
    headers.input = {'SiO2'; 'TiO2'; 'Al2O3'; 'Fe2O3tot'; 'Fe2O3'; 'FeOtot'; 'FeO'; 'MnO'; 'MgO'; 'CaO'; 'Na2O'; 'K2O'; 'P2O5';...
                     'SO3'; 'Cl'; 'F'; 'H2O'; 'CO2'; 'LOI';...
                     'Total';...
                     'Ag'; 'As'; 'Au'; 'B'; 'Ba'; 'Be'; 'Bi'; 'Cd'; 'Co'; 'Cr'; 'Cs'; 'Cu';...
                     'Ga'; 'Ge'; 'Hf'; 'Hg'; 'In'; 'Li'; 'Mo'; 'Nb'; 'Ni'; 'Pb'; 'Rb'; 'Re';...
                     'Sb'; 'Sc'; 'Se'; 'Sn'; 'Sr'; 'Ta'; 'Te'; 'Th'; 'Tl'; 'U'; 'V'; 'W'; 'Y';...
                     'Zn'; 'Zr';...
                     'Ru'; 'Rh'; 'Pd'; 'Os'; 'Ir'; 'Pt';...
                     'La'; 'Ce'; 'Pr'; 'Nd'; 'Sm'; 'Eu'; 'Gd'; 'Tb'; 'Dy'; 'Ho';...
                     'Er'; 'Tm'; 'Yb'; 'Lu'...
                     };
    [m,~] = size(headers.input);
    
    % Handle Units of the input data and create NaN-free values
    for j = 1:m
        if sum(strcmpi(data(1,i).dat.(headers.input{j,1}).UnitIn,{'wt.%','wt. %','(wt.%)','(wt. %)','[wt.%]','[wt. %]','%','(%)','[%]'})) == 1
            data(1,i).dat.(headers.input{j,1}).UnitIn = 'wt.%';
        elseif sum(strcmpi(data(1,i).dat.(headers.input{j,1}).UnitIn,{'ppm','(ppm)','[ppm]','mg/kg','mg / kg','(mg/kg)','(mg / kg)','[mg/kg]','[mg / kg]'})) == 1
            data(1,i).dat.(headers.input{j,1}).UnitIn = 'ppm';
        elseif sum(strcmpi(data(1,i).dat.(headers.input{j,1}).UnitIn,{'ppb','(ppb)','[ppb]'}))
            data(1,i).dat.(headers.input{j,1}).Values = data(1,i).dat.(headers.input{j,1}).Values ./ 1000;
            data(1,i).dat.(headers.input{j,1}).UnitIn = 'ppm';
        end
        % Create NaN-free values and handle units
        calc.(headers.input{j,1}) = data(1,i).dat.(headers.input{j,1}).Values(:,1);
        calc.(headers.input{j,1})(isnan(calc.(headers.input{j,1}))) = 0;
    end
    
    %% 01d Calculate new total values
    
    % Calculate total value (main elements and volatiles)
    data(1,i).dat.TotM.Values = ...
                     calc.SiO2+calc.TiO2+calc.Al2O3+calc.Fe2O3tot+calc.MnO+calc.MgO+calc.CaO+calc.Na2O+calc.K2O+calc.P2O5+...  % main elements
                     calc.SO3+calc.Cl+calc.F+calc.H2O+calc.CO2+calc.LOI;                                                       % volatiles
    data(1,i).dat.TotM.headerv_opsum = 2; data(1,i).dat.TotM.headerv_calc = 'input data';
    data(1,i).dat.TotM.Max    = own_nanmax(data(1,i).dat.TotM.Values);
    data(1,i).dat.TotM.Mean   = own_nanmean(data(1,i).dat.TotM.Values);
    data(1,i).dat.TotM.Median = own_nanmed(data(1,i).dat.TotM.Values);
    data(1,i).dat.TotM.Min    = own_nanmin(data(1,i).dat.TotM.Values);
    data(1,i).dat.TotM.UnitIn = 'wt.%';
    
    % Calculate total value (only trace elements)
    data(1,i).dat.TotT.Values = ...
                   ((calc.Ag+calc.As+calc.Au+calc.Ba+calc.B+calc.Be+calc.Bi+calc.Cd+calc.Co+calc.Cr+calc.Cs+calc.Cu+...     % minor elements A-C
                     calc.Ga+calc.Ge+calc.Hf+calc.Hg+calc.In+calc.Li+calc.Mo+calc.Nb+calc.Ni+calc.Pb+calc.Rb+calc.Re+...    % minor elements G-R
                     calc.Sb+calc.Sc+calc.Sn+calc.Sr+calc.Ta+calc.Te+calc.Th+calc.Tl+calc.U+calc.V+calc.W+calc.Y+...        % minor elements S-Y
                     calc.Zn+calc.Zr+...                                                                                    % minor elements Z
                     calc.Ru+calc.Rh+calc.Pd+calc.Os+calc.Ir+calc.Pt+...                                                    % platinum-group elements
                     calc.La+calc.Ce+calc.Pr+calc.Nd+calc.Sm+calc.Eu+calc.Gd+calc.Tb+calc.Dy+calc.Ho+...                    % Rare-earth elements I
                     calc.Er+calc.Tm+calc.Yb+calc.Lu)./10000);                                                              % Rare-earth elements II
    data(1,i).dat.TotT.headerv_opsum = 2; data(1,i).dat.TotT.headerv_calc = 'input data';
    data(1,i).dat.TotT.Max    = own_nanmax(data(1,i).dat.TotT.Values);
    data(1,i).dat.TotT.Mean   = own_nanmean(data(1,i).dat.TotT.Values);
    data(1,i).dat.TotT.Median = own_nanmed(data(1,i).dat.TotT.Values);
    data(1,i).dat.TotT.Min    = own_nanmin(data(1,i).dat.TotT.Values);
    data(1,i).dat.TotT.UnitIn = 'wt.%';
    
    % Calculate total value (main elements, volatiles, and trace elements)
    data(1,i).dat.TotC.Values = ...
                     calc.SiO2+calc.TiO2+calc.Al2O3+calc.Fe2O3tot+calc.MnO+calc.MgO+calc.CaO+calc.Na2O+calc.K2O+calc.P2O5+...  % main elements
                     calc.SO3+calc.Cl+calc.F+calc.H2O+calc.CO2+calc.LOI+...                                                 % volatiles
                   ((calc.Ag+calc.As+calc.Au+calc.Ba+calc.B+calc.Be+calc.Bi+calc.Cd+calc.Co+calc.Cr+calc.Cs+calc.Cu+...     % minor elements A-C
                     calc.Ga+calc.Ge+calc.Hf+calc.Hg+calc.In+calc.Li+calc.Mo+calc.Nb+calc.Ni+calc.Pb+calc.Rb+calc.Re+...    % minor elements G-R
                     calc.Sb+calc.Sc+calc.Sn+calc.Sr+calc.Ta+calc.Te+calc.Th+calc.Tl+calc.U+calc.V+calc.W+calc.Y+...        % minor elements S-Y
                     calc.Zn+calc.Zr+...                                                                                    % minor elements Z
                     calc.Ru+calc.Rh+calc.Pd+calc.Os+calc.Ir+calc.Pt+...                                                    % platinum-group elements
                     calc.La+calc.Ce+calc.Pr+calc.Nd+calc.Sm+calc.Eu+calc.Gd+calc.Tb+calc.Dy+calc.Ho+...                    % Rare-earth elements I
                     calc.Er+calc.Tm+calc.Yb+calc.Lu)./10000);                                                              % Rare-earth elements II
    data(1,i).dat.TotC.headerv_opsum = 2; data(1,i).dat.TotC.headerv_calc = 'input data';
    data(1,i).dat.TotC.Max    = own_nanmax(data(1,i).dat.TotC.Values);
    data(1,i).dat.TotC.Mean   = own_nanmean(data(1,i).dat.TotC.Values);
    data(1,i).dat.TotC.Median = own_nanmed(data(1,i).dat.TotC.Values);
    data(1,i).dat.TotC.Min    = own_nanmin(data(1,i).dat.TotC.Values);
    data(1,i).dat.TotC.UnitIn = 'wt.%';
    
    % Calculate volatile-free total value (main elements and trace elements)
    data(1,i).dat.TotF.Values = ...
                     calc.SiO2+calc.TiO2+calc.Al2O3+calc.Fe2O3tot+calc.MnO+calc.MgO+calc.CaO+calc.Na2O+calc.K2O+calc.P2O5+...  % main elements
                   ((calc.Ag+calc.As+calc.Au+calc.Ba+calc.B+calc.Be+calc.Bi+calc.Cd+calc.Co+calc.Cr+calc.Cs+calc.Cu+...     % minor elements A-C
                     calc.Ga+calc.Ge+calc.Hf+calc.Hg+calc.In+calc.Li+calc.Mo+calc.Nb+calc.Ni+calc.Pb+calc.Rb+calc.Re+...    % minor elements G-R
                     calc.Sb+calc.Sc+calc.Sn+calc.Sr+calc.Ta+calc.Te+calc.Th+calc.Tl+calc.U+calc.V+calc.W+calc.Y+...        % minor elements S-Y
                     calc.Zn+calc.Zr+...                                                                                    % minor elements Z
                     calc.Ru+calc.Rh+calc.Pd+calc.Os+calc.Ir+calc.Pt+...                                                    % platinum-group elements
                     calc.La+calc.Ce+calc.Pr+calc.Nd+calc.Sm+calc.Eu+calc.Gd+calc.Tb+calc.Dy+calc.Ho+...                    % Rare-earth elements I
                     calc.Er+calc.Tm+calc.Yb+calc.Lu)./10000);                                                              % Rare-earth elements II
    data(1,i).dat.TotF.headerv_opsum = 2; data(1,i).dat.TotF.headerv_calc = 'input data';
    data(1,i).dat.TotF.Max    = own_nanmax(data(1,i).dat.TotF.Values);
    data(1,i).dat.TotF.Mean   = own_nanmean(data(1,i).dat.TotF.Values);
    data(1,i).dat.TotF.Median = own_nanmed(data(1,i).dat.TotF.Values);
    data(1,i).dat.TotF.Min    = own_nanmin(data(1,i).dat.TotF.Values);
    data(1,i).dat.TotF.UnitIn = 'wt.%';
       
    %% 01e Define total value for normalisation
    
    % Define value for normalisation 
    % Here, volatile-free total including trace elements with total Fe as Fe2O3 )
    val_n = data(1,i).dat.TotF.Values;

    %% 01f Perform normalisation
    
    % Copy samples into structure
    data(1,i).norm.Samples = data(1,i).dat.Samples;
    
    % Define header and get the size (new headers are inserted here)
    headers = {'SiO2'; 'TiO2'; 'Al2O3'; 'Fe2O3tot'; 'Fe2O3'; 'FeOtot'; 'FeO'; 'MnO'; 'MgO'; 'CaO'; 'Na2O'; 'K2O'; 'P2O5';...
               'SO3'; 'Cl'; 'F'; 'H2O'; 'CO2'; 'LOI';...
               'Total'; 'TotF'; 'TotC'; 'TotM'; 'TotT';...
               'Ag'; 'As'; 'Au'; 'B'; 'Ba'; 'Be'; 'Bi'; 'Cd'; 'Co'; 'Cr'; 'Cs'; 'Cu';...
               'Ga'; 'Ge'; 'Hf'; 'Hg'; 'In'; 'Li'; 'Mo'; 'Nb'; 'Ni'; 'Pb'; 'Rb'; 'Re';...
               'Sb'; 'Sc'; 'Se'; 'Sn'; 'Sr'; 'Ta'; 'Te'; 'Th'; 'Tl'; 'U'; 'V'; 'W'; 'Y';...
               'Zn'; 'Zr';...
               'Ru'; 'Rh'; 'Pd'; 'Os'; 'Ir'; 'Pt';...
               'La'; 'Ce'; 'Pr'; 'Nd'; 'Sm'; 'Eu'; 'Gd'; 'Tb'; 'Dy'; 'Ho';...
               'Er'; 'Tm'; 'Yb'; 'Lu'...
               };
    [m,~] = size(headers);
    
    % Normalise data in loop for headers - Fill up, not used headers with zeros / NaN's
    for j = 1:m
        
        if strcmpi(headers{j,1},'TotF')
            data(1,i).norm.(headers{j,1}).Values = val_n;  
            data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
            data(1,i).norm.(headers{j,1}).Max = own_nanmax(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Mean = own_nanmean(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Median = own_nanmed(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Min = own_nanmin(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
            data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).norm.(headers{j,1}).headerv_pos = [];
            data(1,i).norm.(headers{j,1}).headerv_opsum = 2;
            data(1,i).norm.(headers{j,1}).headerv_calc = 'Total values used for normalisation to 100%%';
            
        elseif strcmpi(headers{j,1},'TotC') || strcmpi(headers{j,1},'TotM') || strcmpi(headers{j,1},'TotT')
            data(1,i).norm.(headers{j,1}).Values = zeros(size(data(1,i).norm.Samples)); 
            data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
            data(1,i).norm.(headers{j,1}).Max = NaN;
            data(1,i).norm.(headers{j,1}).Mean = NaN;
            data(1,i).norm.(headers{j,1}).Median = NaN;
            data(1,i).norm.(headers{j,1}).Min = NaN;
            data(1,i).norm.(headers{j,1}).UnitIn = 'wt.%';
            data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).norm.(headers{j,1}).headerv_pos = [];
            data(1,i).norm.(headers{j,1}).headerv_opsum = 3;
            
        elseif strcmpi(headers{j,1},'SO3') || strcmpi(headers{j,1},'Cl') || strcmpi(headers{j,1},'F') || strcmpi(headers{j,1},'H2O') || strcmpi(headers{j,1},'CO2') || strcmpi(headers{j,1},'LOI')
            data(1,i).norm.(headers{j,1}).Values = zeros(size(data(1,i).norm.Samples));
            data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
            data(1,i).norm.(headers{j,1}).Max = NaN;
            data(1,i).norm.(headers{j,1}).Mean = NaN;
            data(1,i).norm.(headers{j,1}).Median = NaN;
            data(1,i).norm.(headers{j,1}).Min = NaN;
            data(1,i).norm.(headers{j,1}).UnitIn = 'wt.%';
            data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).norm.(headers{j,1}).headerv_pos = [];
            data(1,i).norm.(headers{j,1}).headerv_opsum = 3;
            
        elseif strcmpi(headers{j,1},'Fe2O3') || strcmpi(headers{j,1},'FeO')
            data(1,i).norm.(headers{j,1}).Values = zeros(size(data(1,i).norm.Samples)); 
            data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
            data(1,i).norm.(headers{j,1}).Max = NaN;
            data(1,i).norm.(headers{j,1}).Mean = NaN;
            data(1,i).norm.(headers{j,1}).Median = NaN;
            data(1,i).norm.(headers{j,1}).Min = NaN;
            data(1,i).norm.(headers{j,1}).UnitIn = 'wt.%';
            data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).norm.(headers{j,1}).headerv_pos = [];
            data(1,i).norm.(headers{j,1}).headerv_opsum = 3;
            
        elseif strcmpi(headers{j,1},'FeOtot')
            data(1,i).norm.(headers{j,1}).Values = Fe2O3_to_FeO(data(1,i).norm.Fe2O3tot.Values);
            data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
            data(1,i).norm.(headers{j,1}).Max = own_nanmax(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Mean = own_nanmean(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Median = own_nanmed(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Min = own_nanmin(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
            data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).norm.(headers{j,1}).headerv_pos = [];
            data(1,i).norm.(headers{j,1}).headerv_opsum = 2;
            data(1,i).norm.(headers{j,1}).headerv_calc = 'Fe2O3 (not normalised)';
            
        elseif strcmpi(headers{j,1},'Total')
            data(1,i).norm.(headers{j,1}).Values  = val_n./val_n*100;  
            data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
            data(1,i).norm.(headers{j,1}).Max = own_nanmax(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Mean = own_nanmean(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Median = own_nanmed(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).Min = own_nanmin(data(1,i).norm.(headers{j,1}).Values);
            data(1,i).norm.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
            data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).norm.(headers{j,1}).headerv_pos = [];
            data(1,i).norm.(headers{j,1}).headerv_opsum = 2;
            data(1,i).norm.(headers{j,1}).headerv_calc = 'input data normalised to 100 wt.%%';
            
        else
            if data(1,i).dat.(headers{j,1}).headerv_opsum == 0
                data(1,i).norm.(headers{j,1}).Values  = data(1,i).dat.(headers{j,1}).Values;
                data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
                data(1,i).norm.(headers{j,1}).Max = own_nanmax(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Mean = own_nanmean(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Median = own_nanmed(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Min = own_nanmin(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
                data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
                data(1,i).norm.(headers{j,1}).headerv_pos = [];
                data(1,i).norm.(headers{j,1}).headerv_opsum = data(1,i).dat.(headers{j,1}).headerv_opsum;
            elseif data(1,i).dat.(headers{j,1}).headerv_opsum == 1 && sum(data(1,i).dat.(headers{j,1}).Values) == 0
                data(1,i).norm.(headers{j,1}).Values  = data(1,i).dat.(headers{j,1}).Values;
                data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
                data(1,i).norm.(headers{j,1}).Max = own_nanmax(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Mean = own_nanmean(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Median = own_nanmed(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Min = own_nanmin(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
                data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
                data(1,i).norm.(headers{j,1}).headerv_pos = [];
                data(1,i).norm.(headers{j,1}).headerv_opsum = data(1,i).dat.(headers{j,1}).headerv_opsum;
            else
                data(1,i).norm.(headers{j,1}).Values  = calc.(headers{j,1})./val_n*100;  
                data(1,i).norm.(headers{j,1}).Values(isnan(0./data(1,i).norm.(headers{j,1}).Values)) = NaN;
                data(1,i).norm.(headers{j,1}).Max = own_nanmax(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Mean = own_nanmean(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Median = own_nanmed(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).Min = own_nanmin(data(1,i).norm.(headers{j,1}).Values);
                data(1,i).norm.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
                data(1,i).norm.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
                data(1,i).norm.(headers{j,1}).headerv_pos = [];
                data(1,i).norm.(headers{j,1}).headerv_opsum = 2;
                data(1,i).norm.(headers{j,1}).headerv_calc = 'input data normalised to 100 wt.%%';
            end
        end
    end
       
    %% 02a Initiate molar conversion
    
    % Load elements database
    [~,chem] = elements_database;
  
    % Copy samples into structure
    data(1,i).mol.Samples = data(1,i).dat.Samples;
    
    %% 02b Recalculation to molar weights
    % Perform only the recalculation by using the molar weights
    for j = 1:m
        if strcmpi(headers{j,1},'SiO2')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1}) ./ (1*chem.Si.molarweight + 2*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'TiO2')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(1*chem.Ti.molarweight + 2*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'Al2O3')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(2*chem.Al.molarweight + 3*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'Fe2O3tot')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(2*chem.Fe.molarweight + 3*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'MnO')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(1*chem.Mn.molarweight + 1*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'MgO')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(1*chem.Mg.molarweight + 1*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'CaO')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(1*chem.Ca.molarweight + 1*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'Na2O')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(2*chem.Na.molarweight + 1*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'K2O')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(2*chem.K.molarweight + 1*chem.O.molarweight);
            
        elseif strcmpi(headers{j,1},'P2O5')
            data(1,i).mol.(headers{j,1}).Values  = calc.(headers{j,1})./(2*chem.P.molarweight + 5*chem.O.molarweight);     
            
        elseif strcmpi(headers{j,1},'Fe2O3') || strcmpi(headers{j,1},'FeO') || strcmpi(headers{j,1},'FeOtot')
            data(1,i).mol.(headers{j,1}).Values = zeros(size(data(1,i).mol.Samples));
            
        elseif strcmpi(headers{j,1},'Total')
            data(1,i).mol.(headers{j,1}).Values = zeros(size(data(1,i).mol.Samples));
            
        elseif strcmpi(headers{j,1},'TotF')
            data(1,i).mol.(headers{j,1}).Values = zeros(size(data(1,i).mol.Samples));
            
        elseif strcmpi(headers{j,1},'TotC') || strcmpi(headers{j,1},'TotM') || strcmpi(headers{j,1},'TotT')
            data(1,i).mol.(headers{j,1}).Values = zeros(size(data(1,i).mol.Samples));
            
        elseif strcmpi(headers{j,1},'SO3') || strcmpi(headers{j,1},'Cl') || strcmpi(headers{j,1},'F') || strcmpi(headers{j,1},'H2O') || strcmpi(headers{j,1},'CO2') || strcmpi(headers{j,1},'LOI')
            data(1,i).mol.(headers{j,1}).Values = zeros(size(data(1,i).mol.Samples));
            
        else
            % Replace * in non-stable isotope molar weights
            if isfinite(strfind(chem.(headers{j,1}).molarweight,'*'))
                chem.(headers{j,1}).molarweight = str2double(strrep(chem.(headers{j,1}).molarweight,'*',''));
            end
            data(1,i).mol.(headers{j,1}).Values = (calc.(headers{j,1})) ./ (chem.(headers{j,1}).molarweight) ./ 10000;
            
        end
    end
    
    %% 02c Calculate the total values
    % Calculate volatile-free total value (main elements and trace elements)

    
    data(1,i).mol.TotF.Values = ...
                     data(1,i).mol.SiO2.Values+data(1,i).mol.TiO2.Values+data(1,i).mol.Al2O3.Values+data(1,i).mol.Fe2O3tot.Values+data(1,i).mol.MnO.Values+...              % main elements II 
                     data(1,i).mol.MgO.Values+data(1,i).mol.CaO.Values+data(1,i).mol.Na2O.Values+data(1,i).mol.K2O.Values+data(1,i).mol.P2O5.Values+...                     % main elements II 
                   ((data(1,i).mol.Ag.Values+data(1,i).mol.As.Values+data(1,i).mol.Au.Values+data(1,i).mol.Ba.Values+data(1,i).mol.B.Values+data(1,i).mol.Be.Values+...     % minor elements A-B
                     data(1,i).mol.Bi.Values+data(1,i).mol.Cd.Values+data(1,i).mol.Co.Values+data(1,i).mol.Cr.Values+data(1,i).mol.Cs.Values+data(1,i).mol.Cu.Values+...    % minor elements B-C
                     data(1,i).mol.Ga.Values+data(1,i).mol.Ge.Values+data(1,i).mol.Hf.Values+data(1,i).mol.Hg.Values+data(1,i).mol.In.Values+data(1,i).mol.Li.Values+...    % minor elements G-L
                     data(1,i).mol.Mo.Values+data(1,i).mol.Nb.Values+data(1,i).mol.Ni.Values+data(1,i).mol.Pb.Values+data(1,i).mol.Rb.Values+data(1,i).mol.Re.Values+...    % minor elements M-R
                     data(1,i).mol.Sb.Values+data(1,i).mol.Sc.Values+data(1,i).mol.Sn.Values+data(1,i).mol.Sr.Values+data(1,i).mol.Ta.Values+data(1,i).mol.Te.Values+...    % minor elements S-T
                     data(1,i).mol.Th.Values+data(1,i).mol.Tl.Values+data(1,i).mol.U.Values+data(1,i).mol.V.Values+data(1,i).mol.W.Values+data(1,i).mol.Y.Values+...        % minor elements T-Y
                     data(1,i).mol.Zn.Values+data(1,i).mol.Zr.Values+...                                                                                                    % minor elements Z
                     data(1,i).mol.Ru.Values+data(1,i).mol.Rh.Values+data(1,i).mol.Pd.Values+data(1,i).mol.Os.Values+data(1,i).mol.Ir.Values+data(1,i).mol.Pt.Values+... 	% PG elements                                                                    % platinum-group elements
                     data(1,i).mol.La.Values+data(1,i).mol.Ce.Values+data(1,i).mol.Pr.Values+data(1,i).mol.Nd.Values+data(1,i).mol.Sm.Values+data(1,i).mol.Eu.Values+...    % Rare-earth elements I
                     data(1,i).mol.Gd.Values+data(1,i).mol.Tb.Values+data(1,i).mol.Dy.Values+data(1,i).mol.Ho.Values+...                                                    % Rare-earth elements II
                     data(1,i).mol.Er.Values+data(1,i).mol.Tm.Values+data(1,i).mol.Yb.Values+data(1,i).mol.Lu.Values)./10000);                                                     % Rare-earth elements III                                                                           % Rare-earth elements II
    data(1,i).mol.TotF.headerv_opsum = 2; 
    data(1,i).dat.TotF.headerv_calc = 'input data';
    data(1,i).mol.TotF.Max    = own_nanmax(data(1,i).dat.TotF.Values);
    data(1,i).mol.TotF.Mean   = own_nanmean(data(1,i).dat.TotF.Values);
    data(1,i).mol.TotF.Median = own_nanmed(data(1,i).dat.TotF.Values);
    data(1,i).mol.TotF.Min    = own_nanmin(data(1,i).dat.TotF.Values);
    data(1,i).mol.TotF.UnitIn = 'mol.%';
    
    %% 02d Define total value for normalisation
    % Define value for normalisation 
    % Here, volatile-free total including trace elements with total Fe as Fe2O3 )
    val_n = data(1,i).mol.TotF.Values;
    
    %% 02e Normalise the data to 100 mol.% and calculate statistics
    % If header values not, used, treat the same way as for normalisation
    % in wt.%
    for j = 1:m
        if  strcmpi(headers{j,1},'TotF')
            data(1,i).mol.(headers{j,1}).Values = val_n;  
            data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
            data(1,i).mol.(headers{j,1}).Max = own_nanmax(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Mean = own_nanmean(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Median = own_nanmed(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Min = own_nanmin(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
            data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).mol.(headers{j,1}).headerv_pos = [];
            data(1,i).mol.(headers{j,1}).headerv_opsum = 2;
            data(1,i).mol.(headers{j,1}).headerv_calc = 'Total values used for normalisation to 100 mol.%%!';
                        
        elseif strcmpi(headers{j,1},'TotC') || strcmpi(headers{j,1},'TotM') || strcmpi(headers{j,1},'TotT')
            data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
            data(1,i).mol.(headers{j,1}).Max = NaN;
            data(1,i).mol.(headers{j,1}).Mean = NaN;
            data(1,i).mol.(headers{j,1}).Median = NaN;
            data(1,i).mol.(headers{j,1}).Min = NaN;
            data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
            data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).mol.(headers{j,1}).headerv_pos = [];
            data(1,i).mol.(headers{j,1}).headerv_opsum = 3;
            
        elseif strcmpi(headers{j,1},'SO3') || strcmpi(headers{j,1},'Cl') || strcmpi(headers{j,1},'F') || strcmpi(headers{j,1},'H2O') || strcmpi(headers{j,1},'CO2') || strcmpi(headers{j,1},'LOI')
            data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
            data(1,i).mol.(headers{j,1}).Max = NaN;
            data(1,i).mol.(headers{j,1}).Mean = NaN;
            data(1,i).mol.(headers{j,1}).Median = NaN;
            data(1,i).mol.(headers{j,1}).Min = NaN;
            data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
            data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).mol.(headers{j,1}).headerv_pos = [];
            data(1,i).mol.(headers{j,1}).headerv_opsum = 3;
            
        elseif strcmpi(headers{j,1},'Fe2O3') || strcmpi(headers{j,1},'FeO')
            data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
            data(1,i).mol.(headers{j,1}).Max = NaN;
            data(1,i).mol.(headers{j,1}).Mean = NaN;
            data(1,i).mol.(headers{j,1}).Median = NaN;
            data(1,i).mol.(headers{j,1}).Min = NaN;
            data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
            data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).mol.(headers{j,1}).headerv_pos = [];
            data(1,i).mol.(headers{j,1}).headerv_opsum = 3;
            
        elseif strcmpi(headers{j,1},'FeOtot')
            data(1,i).mol.(headers{j,1}).Values = Fe2O3_to_FeO(data(1,i).mol.Fe2O3tot.Values);
            data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
            data(1,i).mol.(headers{j,1}).Max = own_nanmax(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Mean = own_nanmean(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Median = own_nanmed(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Min = own_nanmin(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
            data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).mol.(headers{j,1}).headerv_pos = [];
            data(1,i).mol.(headers{j,1}).headerv_opsum = 2;
            data(1,i).mol.(headers{j,1}).headerv_calc = 'Fe2O3 (molar converted,\nbut not normalised!)';

        elseif strcmpi(headers{j,1},'Total')
            data(1,i).mol.(headers{j,1}).Values = val_n./val_n.*100;  
            data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
            data(1,i).mol.(headers{j,1}).Max = own_nanmax(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Mean = own_nanmean(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Median = own_nanmed(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).Min = own_nanmin(data(1,i).mol.(headers{j,1}).Values);
            data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
            data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
            data(1,i).mol.(headers{j,1}).headerv_pos = [];
            data(1,i).mol.(headers{j,1}).headerv_opsum = 2;
            data(1,i).mol.(headers{j,1}).headerv_calc = 'molar converted input data and\n normalised to 100 mol.%%!';
            
        else
            if data(1,i).dat.(headers{j,1}).headerv_opsum == 0
                data(1,i).mol.(headers{j,1}).Values  = data(1,i).dat.(headers{j,1}).Values;
                data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
                data(1,i).mol.(headers{j,1}).Max = own_nanmax(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Mean = own_nanmean(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Median = own_nanmed(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Min = own_nanmin(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).UnitIn = data(1,i).dat.(headers{j,1}).UnitIn;
                data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
                data(1,i).mol.(headers{j,1}).headerv_pos = [];
                data(1,i).mol.(headers{j,1}).headerv_opsum = data(1,i).dat.(headers{j,1}).headerv_opsum;
            elseif data(1,i).dat.(headers{j,1}).headerv_opsum == 1 && sum(data(1,i).dat.(headers{j,1}).Values) == 0
                data(1,i).mol.(headers{j,1}).Values  = data(1,i).dat.(headers{j,1}).Values;
                data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
                data(1,i).mol.(headers{j,1}).Max = own_nanmax(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Mean = own_nanmean(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Median = own_nanmed(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Min = own_nanmin(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
                data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
                data(1,i).mol.(headers{j,1}).headerv_pos = [];
                data(1,i).mol.(headers{j,1}).headerv_opsum = data(1,i).dat.(headers{j,1}).headerv_opsum;
            else
                data(1,i).mol.(headers{j,1}).Values  = data(1,i).mol.(headers{j,1}).Values./val_n.*100;
                data(1,i).mol.(headers{j,1}).Values(isnan(0./data(1,i).mol.(headers{j,1}).Values)) = NaN;
                data(1,i).mol.(headers{j,1}).Max = own_nanmax(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Mean = own_nanmean(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Median = own_nanmed(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).Min = own_nanmin(data(1,i).mol.(headers{j,1}).Values);
                data(1,i).mol.(headers{j,1}).UnitIn = 'mol.%';
                data(1,i).mol.(headers{j,1}).headerv_op = false(size(data(1,i).dat.(headers{j,1}).headerv_op));
                data(1,i).mol.(headers{j,1}).headerv_pos = [];
                data(1,i).mol.(headers{j,1}).headerv_opsum = 2;
                data(1,i).mol.(headers{j,1}).headerv_calc = 'molar converted input data and\n normalised to 100 mol.%%!';
            end

        end
        
    end

    %% 03a Calculate PI, ASI, AI, MALI
    if i == 1
        % Extent header amount
        control.header.m = control.header.m+4;
        % ASI
        % Prepare headers
        control.header.valid{control.header.m-3,1} = 'ASI';
        control.header.valid{control.header.m-3,2} = 'Alumina Saturation Index';
        control.header.valid{control.header.m-3,3} = 'ASI';
        control.header.valid{control.header.m-3,4} = 'molar ratio';
    end
    
    % Calculate values
    data(1,i).mol.ASI.Values = Al2O3_to_Al(data(1,i).mol.Al2O3.Values) ./ (Na2O_to_Na(data(1,i).mol.Na2O.Values) + K2O_to_K(data(1,i).mol.K2O.Values)...
                                                                        + (CaO_to_Ca(data(1,i).mol.CaO.Values) - 1.67 * P2O5_to_P(data(1,i).mol.P2O5.Values)) );
%     data(1,i).mol.ASI.Values = data(1,i).mol.Al2O3.Values ./ (data(1,i).mol.Na2O.Values + data(1,i).mol.K2O.Values + (data(1,i).mol.CaO.Values - 1.67 * data(1,i).mol.P2O5.Values) );
    data(1,i).mol.ASI.Max = own_nanmax(data(1,i).mol.ASI.Values);
    data(1,i).mol.ASI.Mean = own_nanmean(data(1,i).mol.ASI.Values);
    data(1,i).mol.ASI.Median = own_nanmed(data(1,i).mol.ASI.Values);
    data(1,i).mol.ASI.Min = own_nanmin(data(1,i).mol.ASI.Values);
    data(1,i).mol.ASI.UnitIn = 'molar ratio';
    data(1,i).mol.ASI.headerv_op = false(size(data(1,i).dat.Samples));
    data(1,i).mol.ASI.headerv_pos = [];
    data(1,i).mol.ASI.headerv_opsum = 2;
    data(1,i).mol.ASI.headerv_calc = 'ASI = molar Al / (Na + K + (Ca - (1.67 * P)))';
%     data(1,i).mol.ASI.headerv_calc = 'ASI = molar Al2O3 / (Na2O + K2O + (CaO - (1.67 * P2O5)))';
    % Copy to other data types
    data(1,i).dat.ASI = data(1,i).mol.ASI;
    data(1,i).norm.ASI = data(1,i).mol.ASI;
    
    if i == 1
        % PI
        % Prepare headers
        control.header.valid{control.header.m-2,1} = 'PI';
        control.header.valid{control.header.m-2,2} = 'Peraluminity Index';
        control.header.valid{control.header.m-2,3} = 'PI';
        control.header.valid{control.header.m-2,4} = 'molar ratio';
    end
    
    % Calculate values
    data(1,i).mol.PI.Values = Al2O3_to_Al(data(1,i).mol.Al2O3.Values) ./ (Na2O_to_Na(data(1,i).mol.Na2O.Values) + K2O_to_K(data(1,i).mol.K2O.Values));
%     data(1,i).mol.PI.Values = data(1,i).mol.Al2O3.Values ./ (data(1,i).mol.Na2O.Values + data(1,i).mol.K2O.Values);
    data(1,i).mol.PI.Max = own_nanmax(data(1,i).mol.PI.Values);
    data(1,i).mol.PI.Mean = own_nanmean(data(1,i).mol.PI.Values);
    data(1,i).mol.PI.Median = own_nanmed(data(1,i).mol.PI.Values);
    data(1,i).mol.PI.Min = own_nanmin(data(1,i).mol.PI.Values);
    data(1,i).mol.PI.UnitIn = 'molar ratio';
    data(1,i).mol.PI.headerv_op = false(size(data(1,i).dat.Samples));
    data(1,i).mol.PI.headerv_pos = [];
    data(1,i).mol.PI.headerv_opsum = 2;
    data(1,i).mol.PI.headerv_calc = 'ASI = molar Al / (Na + K)';
%     data(1,i).mol.PI.headerv_calc = 'ASI = molar Al2O3 / (Na2O + K2O)';
    % Copy to other data types
    data(1,i).dat.PI = data(1,i).mol.PI;
    data(1,i).norm.PI = data(1,i).mol.PI;
    
    if i == 1
        % AI
        % Prepare headers
        control.header.valid{control.header.m-1,1} = 'AI';
        control.header.valid{control.header.m-1,2} = 'Agpaitic Index';
        control.header.valid{control.header.m-1,3} = 'AI';
        control.header.valid{control.header.m-1,4} = 'molar ratio';
    end
    
    % Calculate values
    data(1,i).mol.AI.Values = (Na2O_to_Na(data(1,i).mol.Na2O.Values) + K2O_to_K(data(1,i).mol.K2O.Values)) ./ Al2O3_to_Al(data(1,i).mol.Al2O3.Values);
    data(1,i).mol.AI.Max = own_nanmax(data(1,i).mol.AI.Values);
    data(1,i).mol.AI.Mean = own_nanmean(data(1,i).mol.AI.Values);
    data(1,i).mol.AI.Median = own_nanmed(data(1,i).mol.AI.Values);
    data(1,i).mol.AI.Min = own_nanmin(data(1,i).mol.AI.Values);
    data(1,i).mol.AI.UnitIn = 'molar ratio';
    data(1,i).mol.AI.headerv_op = false(size(data(1,i).dat.Samples));
    data(1,i).mol.AI.headerv_pos = [];
    data(1,i).mol.AI.headerv_opsum = 2;
    data(1,i).mol.AI.headerv_calc = 'AI = molar (Na+K)/Al';
    % Copy to other data types
    data(1,i).dat.AI = data(1,i).mol.AI;
    data(1,i).norm.AI = data(1,i).mol.AI;
    
    if i == 1
        % MALI
        % Prepare headers
        control.header.valid{control.header.m,1} = 'MALI';
        control.header.valid{control.header.m,2} = 'Modified Alkali-Lime Index';
        control.header.valid{control.header.m,3} = 'MALI';
        control.header.valid{control.header.m,4} = 'ratio';
    end
    
    % Calculate values
    data(1,i).dat.MALI.Values = (data(1,i).dat.Na2O.Values + data(1,i).dat.K2O.Values) - data(1,i).dat.CaO.Values;
    data(1,i).dat.MALI.Max = own_nanmax(data(1,i).dat.MALI.Values);
    data(1,i).dat.MALI.Mean = own_nanmean(data(1,i).dat.MALI.Values);
    data(1,i).dat.MALI.Median = own_nanmed(data(1,i).dat.MALI.Values);
    data(1,i).dat.MALI.Min = own_nanmin(data(1,i).dat.MALI.Values);
    data(1,i).dat.MALI.UnitIn = 'ratio';
    data(1,i).dat.MALI.headerv_op = false(size(data(1,i).dat.Samples));
    data(1,i).dat.MALI.headerv_pos = [];
    data(1,i).dat.MALI.headerv_opsum = 2;
    data(1,i).dat.MALI.headerv_calc = 'MALI = wt.% Na2O + K2O - CaO';
    % Copy to other data types
    data(1,i).mol.MALI = data(1,i).dat.MALI;
    data(1,i).norm.MALI = data(1,i).dat.MALI;
end

