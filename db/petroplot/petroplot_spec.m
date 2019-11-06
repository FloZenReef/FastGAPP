function [data] = petroplot_spec(data,files_op)
    % Go through the loaded files
    for i = 1:files_op
        % Get the number of samples in dataset
        [m,~] = size(data(1,i).dat.Samples);
        % Go through the samples
        for j = 1:m
            % Calculations for P and Plg values
            if isnan(data(1,i).dat.P.Values(j,1)) && isfinite(data(1,i).dat.Plg.Values(j,1))
                data(1,i).dat.P.Values(j,1) = data(1,i).dat.Plg.Values(j,1);
                data(1,i).dat.P.headerv_opsum = 2; data(1,i).dat.P.headerv_calc = 'Plg';

            elseif isnan(data(1,i).dat.Plg.Values(j,1)) && isfinite(data(1,i).dat.P.Values(j,1))
                data(1,i).dat.Plg.Values(j,1) = data(1,i).dat.P.Values(j,1);
                data(1,i).dat.Plg.headerv_opsum = 2; data(1,i).dat.Plg.headerv_calc = 'P';
            end

            % Calculations for Px/Opx/Cpx values
            if isnan(data(1,i).dat.Px.Values(j,1)) 
                if isfinite(data(1,i).dat.Opx.Values(j,1)) && isfinite(data(1,i).dat.Cpx.Values(j,1))
                    data(1,i).dat.Px.Values(j,1) = data(1,i).dat.Opx.Values(j,1) + data(1,i).dat.Cpx.Values(j,1);
                    data(1,i).dat.Px.headerv_opsum = 2; data(1,i).dat.Px.headerv_calc = 'Opx and Cpx';

                elseif isfinite(data(1,i).dat.Opx.Values(j,1)) && isnan(data(1,i).dat.Cpx.Values(j,1))
                    data(1,i).dat.Px.Values(j,1) = data(1,i).dat.Opx.Values(j,1);
                    data(1,i).dat.Px.headerv_opsum = 2; data(1,i).dat.Px.headerv_calc = 'Opx';

                elseif isnan(data(1,i).dat.Opx.Values(j,1)) && isfinite(data(1,i).dat.Cpx.Values(j,1))
                    data(1,i).dat.Px.Values(j,1) = data(1,i).dat.Cpx.Values(j,1);
                    data(1,i).dat.Px.headerv_opsum = 2; data(1,i).dat.Px.headerv_calc = 'Cpx';
                end
            end

        end

        % Write statistics of values were calculated for P and Plg values
        if data(1,i).dat.Plg.headerv_opsum == 2
            data(1,i).dat.Plg.Max    = own_nanmax(data(1,i).dat.Plg.Values);
            data(1,i).dat.Plg.Mean   = own_nanmean(data(1,i).dat.Plg.Values);
            data(1,i).dat.Plg.Median = own_nanmed(data(1,i).dat.Plg.Values);
            data(1,i).dat.Plg.Min    = own_nanmin(data(1,i).dat.Plg.Values);
        elseif data(1,i).dat.P.headerv_opsum == 2
            data(1,i).dat.P.Max    = own_nanmax(data(1,i).dat.P.Values);
            data(1,i).dat.P.Mean   = own_nanmean(data(1,i).dat.P.Values);
            data(1,i).dat.P.Median = own_nanmed(data(1,i).dat.P.Values);
            data(1,i).dat.P.Min    = own_nanmin(data(1,i).dat.P.Values);
        end

        % Write statistics of values were calculated for Px values
        if data(1,i).dat.Px.headerv_opsum == 2
            data(1,i).dat.Px.Max    = own_nanmax(data(1,i).dat.Px.Values);
            data(1,i).dat.Px.Mean   = own_nanmean(data(1,i).dat.Px.Values);
            data(1,i).dat.Px.Median = own_nanmed(data(1,i).dat.Px.Values);
            data(1,i).dat.Px.Min    = own_nanmin(data(1,i).dat.Px.Values);
        end
    end

end

