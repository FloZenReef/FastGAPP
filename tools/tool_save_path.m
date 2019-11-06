function spanel = tool_save_path(spanel)
%% Tool - Save Path v1.0
% This small tools opens a folder selection window to set a new save path, which
% will appear when any save or load button is pressed. The selected path will be 
% saved in the fgapp20.config file in root folder. 
% Author: Florian Riefstahl
% Project: FastGAPP 2015-2019

%% Open the folder selection window and set a new save directory path
% Get the fgapp folder
[fgapp_path] = pwd;
% Open the uiputdir dialog to define a standard search path for datasets
[save_path] = uigetdir(fgapp_path,'Select save folder!');
    % Check the output from uigetdir
    if ischar(save_path)
        % Save the location to the config file
        if exist([fgapp_path '/' 'fgapp20.config'],'file') == 2;
            input_config = load([fgapp_path '/' 'fgapp20.config'],'-mat');
            % Check if another path was present in config file
            if isfield(input_config,'data_path');
                data_path = input_config.data_path;
                fprintf('fgapp20.config updated!\n')
                save('fgapp20.config','save_path','data_path')
                fprintf('Data path: %s\n',data_path)
                fprintf('Save path: %s\n',save_path)
            else
                fprintf('fgapp20.config updated!\n')
                save('fgapp20.config','save_path')
                fprintf('Save path: %s\n',save_path)
            end
        else
            fprintf('fgapp20.config created!\n')
            save('fgapp20.config','save_path')
            fprintf('Save path: %s\n',save_path)
        end
        % Update statuspanel
        set(spanel,'String',sprintf('Save path: %s',save_path))
    else
        % Give output to command window
        fprintf('Path selection aborted...\n')
        fprintf('...no changes applied!\n') 
    end

end