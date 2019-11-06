% Created with Pcreator v1.1
% Date/Time: 23-Oct-2019 17:17:53
% Called from: FGAPP20.m
function start_programs(radiostr,load_op,files,files_op,save_path)

    if strcmpi('FastGAPP',radiostr)
        control = fastgapp_control;
        mainwindow_type1(control,load_op,files,files_op,save_path);

    elseif strcmpi('PetroPlot',radiostr)
        control = petroplot_control;
        mainwindow_type2(control,load_op,files,files_op,save_path);

    elseif strcmpi('SediPlot',radiostr)
        control = sediplot_control;
        mainwindow_type2(control,load_op,files,files_op,save_path);

    elseif strcmpi('SoilPlot',radiostr)
        control = soilplot_control;
        mainwindow_type2(control,load_op,files,files_op,save_path);

    else
        fprintf('Fatal error: Program does not exist!')

    end

end