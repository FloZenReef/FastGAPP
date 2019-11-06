function spanel = tool_data_path(spanel)
%% Tool - Load Path v1.0
% This small tools opens a folder selection window to set a new data path, which
% will appear when any load dataset button is pressed. The selected path will be 
% saved in the fgapp20.config file in root folder. 
% Author: Florian Riefstahl
% Project: FastGAPP 2015-2019

%% Open the folder selection window and set a new data directory path
% Get the fgapp folder
[fgapp_path] = pwd;
% Open the uiputdir dialog to define a standard search path for datasets
[data_path] = uigetdir(fgapp_path,'Select data folder');
    % Check the output from uigetdir
    if ischar(data_path)
        % Save the location to the config file
        if exist([fgapp_path '/' 'fgapp20.config'],'file') == 2;
            input_config = load([fgapp_path '/' 'fgapp20.config'],'-mat');
            % Check if another path was present in config file
            if isfield(input_config,'save_path');
                save_path = input_config.save_path;
                fprintf('fgapp20.config updated!\n')
                save('fgapp20.config','save_path','data_path')
                fprintf('Data path: %s\n',data_path)
                fprintf('Save path: %s\n',save_path)
            else
                fprintf('fgapp20.config updated!\n')
                save('fgapp20.config','data_path')
                fprintf('Data path: %s\n',data_path)
            end
        else
            fprintf('fgapp20.config created!\n')
            save('fgapp20.config','data_path')
            fprintf('Data path: %s\n',data_path)
        end
        % Update statuspanel
        set(spanel,'String',sprintf('Data path: %s',data_path))
    else
        % Give output to command window
        fprintf('Path selection aborted...\n')
        fprintf('...no changes applied!\n') 
    end

end