% Created with Pcreator v1.1
% Date/Time: 23-Oct-2019 17:17:53
% Called from: mainwindow_type1.m
%              mainwindow_type2.m
function [data,control] = special_fnc_switch(data,control,files_op)

    switch control.program
        case 'FastGAPP'
            [data,control] = fastgapp_spec(data,control,files_op);

        case 'PetroPlot'
            [data] = petroplot_spec(data,files_op);

        case 'SediPlot'
            [data] = sediplot_spec(data,files_op);

        case 'SoilPlot'
            % No special function defined!!!

        otherwise
            fprintf('Fatal error: Program does not exist!')

    end

end