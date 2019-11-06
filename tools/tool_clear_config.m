function [spanel1,spanel2] = tool_clear_config(spanel1,spanel2)
%% Tool - Clear Config v1.0
% This small tools clears the fgapp20.config from root folder
% Author: Florian Riefstahl
% Project: FastGAPP 2015-2019

%% Clear the config file
% Get the fgapp folder
[fgapp_path] = pwd;
% Remove config file
if exist([fgapp_path '/fgapp20.config'],'file')
delete([fgapp_path '/fgapp20.config']);
fprintf('fgapp20.config deleted!\n')
else
    
end
% Update panels
set(spanel1,'String',sprintf('Data path: %s',fgapp_path));
set(spanel2,'String',sprintf('Save path: %s',fgapp_path));
end

