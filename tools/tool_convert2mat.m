function tool_convert2mat(data_path)
%% *****************************************************************************
% This tool 'Convert to MAT' reads selected Excel-Spreadsheet and converts
% them into MAT files formatted as FastGAPP input files
%
% Name: Tool - Convert to MAT
% Author: Florian Riefstahl
% Institutions: University of Bremen, Bremen, Germany
%               Alfred-Wegener-Institute, Bremerhaven, Germany
%               Christian-Albrechts-University Kiel, Kiel, Germany
% Initial Version: v1.0 2015
% Current Version: v1.1 - August 2019 - minor bugfixes
% ******************************************************************************

%% 00 Start function
% Output to command window
fprintf('convert2MAT v1.1 - Time: %s \n',datestr(clock));
% File selection
% Open a standard dialog box for retrieving an input file with TXT, DAT, XLS or
% XLSX extension.
[inputfile, inputpath] = uigetfile({'*.xls;*.xlsx','Spreadsheets (*.xls, *.xlsx)'},...
                                    'Select a file for MAT conversion',...
                                    data_path,...
                                    'MultiSelect', 'on');
    % Error message if selection cancelled.
    if ischar(inputfile)
    % Print the input file name
    fprintf('Input: 1 file - Time: %s\n',datestr(clock));
    % Print the input file name
    fprintf('Processing file %s... - Time: %s\n',fullfile(inputpath,inputfile),datestr(clock));
    % Get the file's extension
    [~, filename, ext] = fileparts(fullfile(inputpath,inputfile));
        % Check if spreadsheet extension.
        if strcmpi(ext,'.xlsx') == 1 || strcmpi(ext,'.xls') == 1
        % If spreadsheat, read the file with xlsread.
        [num,txt,raw] = xlsread(fullfile(inputpath,inputfile)); %#ok<NASGU,ASGLU>
        % Finally, save the variables.
        save(fullfile(inputpath,[filename '.mat']),'num','txt','raw');
        % Status output to command window
        fprintf('...finished - Time: %s\n',datestr(clock));
        % Else send an error to the command window.
        else
        fprintf('Error 1: Wrong file extension!\nSelect file with .xls or .xlsx extension! - Time: %s\n',datestr(clock));
        end
    % If more than one file was selected.
    elseif iscell(inputfile)
    % Get the size of the inputfiles
    [m,~] = size(inputfile');
    % Print the input file name
    fprintf('Input: %s files - Time: %s\n',num2str(m),datestr(clock));
        for i = 1:m
        % Print the curent file name
        fprintf('Processing file %s... - %s/%s files - Time: %s\n',inputfile{1,i},num2str(i),num2str(m),datestr(clock));
        % Get the file's extension
        [~, filename, ext] = fileparts(fullfile(inputpath,inputfile{1,i}));
        % Check if spreadsheet extension.
        if strcmpi(ext,'.xlsx') == 1 || strcmpi(ext,'.xls') == 1
        % If spreadsheat, read the file with xlsread.
        [num,txt,raw] = xlsread(fullfile(inputpath,inputfile{1,i})); %#ok<NASGU,ASGLU>
        % Finally, save the variables.
        save(fullfile(inputpath,[filename '.mat']),'num','txt','raw');
        % Status output to command window
        fprintf('...finished - Time: %s\n',datestr(clock));
        % Else send an error to the command window.
        else
        fprintf('Error 1: Wrong file extension!\nSelect file with .xls or .xlsx extension! - Time: %s\n',datestr(clock));
        end
        end
    % No files were selected...
    else
    fprintf('Conversion aborted by user! - Time: %s \n',datestr(clock));

    end

% Output to command window
fprintf('convert2MAT v1.1 - Time: %s \n\n',datestr(clock));
end 
