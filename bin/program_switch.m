% Created with Pcreator v1.1
% Date/Time: 23-Oct-2019 17:17:53
% Called from: main_window_type1.m --> defplot_callback and update_callback
%              main_window_type2.m --> defplot_callback and update_callback
function [plotax] = program_switch(control,plotax,plotsel,data,files_op,opt_check)

    if strcmpi(control.program,'FastGAPP');
        plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check);
        plotax = fastgapp_lineswitch(control,plotax,plotsel);
        plotax = fastgapp_labelswitch(control,plotax,plotsel);

    elseif strcmpi(control.program,'PetroPlot')
        plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check);
        plotax = petroplot_lineswitch(control,plotax,plotsel);
        plotax = petroplot_labelswitch(control,plotax,plotsel);

    elseif strcmpi(control.program,'SediPlot')
        plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check);
        plotax = sediplot_lineswitch(control,plotax,plotsel);
        plotax = sediplot_labelswitch(control,plotax,plotsel);

    elseif strcmpi(control.program,'SoilPlot')
        plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check);
        plotax = soilplot_lineswitch(control,plotax,plotsel);
        plotax = soilplot_labelswitch(control,plotax,plotsel);

    else
        fprintf('Fatal error: Program does not exist!')

    end

end