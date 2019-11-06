function [data] = sediplot_spec(data,files_op)
    % Go through the loaded files
    for i = 1:files_op
        
        % Get the number of samples in dataset
        [m,~] = size(data(1,i).dat.Samples);
        
        
        % Go through the samples
        for j = 1:m
            % Calculations for Qt from Qp and / or Qm values
            if isnan(data(1,i).dat.Qt.Values(j,1)) && isfinite(data(1,i).dat.Qp.Values(j,1)) && isfinite(data(1,i).dat.Qm.Values(j,1))
                data(1,i).dat.Qt.Values(j,1) = data(1,i).dat.Qp.Values(j,1) + data(1,i).dat.Qm.Values(j,1);
                data(1,i).dat.Qt.headerv_opsum = 2; data(1,i).dat.Qt.headerv_calc = 'Qp and Qm';
            elseif isnan(data(1,i).dat.Qt.Values(j,1)) && isnan(data(1,i).dat.Qp.Values(j,1)) && isfinite(data(1,i).dat.Qm.Values(j,1))
                data(1,i).dat.Qt.Values(j,1) = data(1,i).dat.Qm.Values(j,1);
                data(1,i).dat.Qt.headerv_opsum = 2; data(1,i).dat.Qt.headerv_calc = 'Calculated from Qp';
            elseif isnan(data(1,i).dat.Qt.Values(j,1)) && isfinite(data(1,i).dat.Qp.Values(j,1)) && isnan(data(1,i).dat.Qm.Values(j,1))
                data(1,i).dat.Qt.Values(j,1) = data(1,i).dat.Qp.Values(j,1);
                data(1,i).dat.Qt.headerv_opsum = 2; data(1,i).dat.Qt.headerv_calc = 'Calculated from Qp';
            end
            % Calculations of Mud from Silt & Clay values
            if isnan(data(1,i).dat.Mud.Values(j,1)) && isfinite(data(1,i).dat.Silt.Values(j,1)) && isfinite(data(1,i).dat.Clay.Values(j,1))
                data(1,i).dat.Mud.Values(j,1) = data(1,i).dat.Silt.Values(j,1) + data(1,i).dat.Clay.Values(j,1);
                data(1,i).dat.Mud.headerv_opsum = 2; data(1,i).dat.Mud.headerv_calc = 'Silt and Clay';
            elseif isnan(data(1,i).dat.Mud.Values(j,1)) && isnan(data(1,i).dat.Clay.Values(j,1)) && isfinite(data(1,i).dat.Silt.Values(j,1))
                data(1,i).dat.Mud.Values(j,1) = data(1,i).dat.Silt.Values(j,1);
                data(1,i).dat.Mud.headerv_opsum = 2; data(1,i).dat.Mud.headerv_calc = 'Calculated from Silt';
            elseif isnan(data(1,i).dat.Mud.Values(j,1)) && isfinite(data(1,i).dat.Clay.Values(j,1)) && isnan(data(1,i).dat.Silt.Values(j,1))
                data(1,i).dat.Mud.Values(j,1) = data(1,i).dat.Clay.Values(j,1);
                data(1,i).dat.Mud.headerv_opsum = 2; data(1,i).dat.Mud.headerv_calc = 'Calculated from Clay';
            end
        end
        
        % Calculated statistics if anything was done with Qt from Qp and / or Qm values
        if data(1,i).dat.Qt.headerv_opsum == 2
            data(1,i).dat.Qt.Max    = own_nanmax(data(1,i).dat.Qt.Values);
            data(1,i).dat.Qt.Mean   = own_nanmean(data(1,i).dat.Qt.Values);
            data(1,i).dat.Qt.Median = own_nanmed(data(1,i).dat.Qt.Values);
            data(1,i).dat.Qt.Min    = own_nanmin(data(1,i).dat.Qt.Values);
        end
        
        % Calculated statistics if anything was done with Qt from Qp and / or Qm values
        if data(1,i).dat.Mud.headerv_opsum == 2
            data(1,i).dat.Mud.Max    = own_nanmax(data(1,i).dat.Mud.Values);
            data(1,i).dat.Mud.Mean   = own_nanmean(data(1,i).dat.Mud.Values);
            data(1,i).dat.Mud.Median = own_nanmed(data(1,i).dat.Mud.Values);
            data(1,i).dat.Mud.Min    = own_nanmin(data(1,i).dat.Mud.Values);
        end
    end

end

