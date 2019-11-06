function [data,temp] = read_files(files_op,infiles,headerv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program is the heart of the file input and can handle up to nine
% input files. It checks the selected input file and reads the contents: 
% MAT files created with the converter tool
% XLSX/XLS files with specific format
% Author: Florian Riefstahl
% Institutions: University of Bremen, Bremen, Germany
%               Alfred-Wegener-Institute, Bremerhaven, Germany
%               Carl-Albrechts-University Kiel, Kiel, Germany
% Version: Initial version 2015-2016
%%% Revisions %%%
% 14th July 2019: Minor revision as recommended by MATLAB
%                 Important change: Now file with unit can be read without issue
%                 Fixed marker and font input colors!
% 15th July 2019: Input Unit is now written into data structure
% 23rd July 2019: Changed the output and handling of default marker /
%                 symbols and labels. These are now written to all of the 9
%                 datasets to enable easier saving of default and adjusted
%                 setup via save button in mainwindows...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create waitbar
wb = waitbar(0,'Create data structure','Name','Importing files...');
%% Allocate structures
% Create structures
for i = 1:9 
    % Create a structure for data input
    data(i).dat = struct(); 
    
    % Create structures for markers / symbols
    data(i).symbol = struct(); 
    temp(i).symbol = struct(); 
    % Create default operators for reading the markers / symbols
    data(i).symbol.op.op = false;
    data(i).symbol.op.override = true;
    temp(i).symbol.op = data(i).symbol.op;
    % Write the defaults markers / symbols into structure
    [data(i).symbol,temp(i).symbol] = defaults_marker(i,data(i).symbol,temp(i).symbol);
    
    % Create structures for labels
    data(i).label = struct();
    temp(i).label = struct();
    % Create default operators for reading the labels
    data(i).label.op.op = false;
    data(i).label.op.disp = false;
    data(i).label.op.override = true;
    temp(i).label.op = data(i).label.op;
    % Write the default labels into structure
    [data(i).label,temp(i).label] = defaults_label(i,data(i).label,temp(i).label);
end
% assignin('base','data_raw',data) % Control element - Show data struct in workspace
% assignin('base','temp',temp)
%% Input header measurements

% Get the size of valid header
[sizes.headerv_m,~] = size(headerv);

%% Symbol and label columns

% Valid symbol column headers
markerv = {'Marker';'MarkerSize';'MarkerEdgeColor';'MarkerFaceColor';'EdgeWidth'};
% Output field names
structv = {'symbol';'size';'mec';'mfc';'edgew'};
% Get the size of valid symbol column headers
[sizes.markerv_m,sizes.markerv_n] = size(markerv);
% Valid symbol column headers
labv = {'FontName';'FontWeight';'FontAngle';'FontSize';'FontColor';'FontUnits';'VerticalAlignment';'HorizontalAlignment'};
% Output field names
labstructv = {'FontName';'FontWeight';'FontAngle';'FontSize';'Color';'FontUnits';'VertAlign';'HoriAlign'};
% Get the size of valid symbol column headers
[sizes.labv_m,sizes.labv_n] = size(labv);

%% Read the selected files

for i = 1:files_op
	% Update waitbar
    waitbar(i/files_op,wb,sprintf('%s/%s Dataset %s',num2str(i),num2str(files_op),num2str(i)));
    % Check for the extension and load the files
    if strcmpi(infiles{i,5},{'.mat'}) && true(infiles{i,6})
        load(infiles{i,3},'num','txt','raw');
    elseif sum(strcmpi(infiles{i,5},{'.xlsx','.xls'})) && true(infiles{i,6})
        [num,txt,raw] = xlsread(infiles{i,3});
    elseif sum(strcmpi(infiles{i,5},{'.txt','.dat'})) && true(infiles{i,6})
        fprintf('Error: ASCII file input is at the moment not available!')
    else
        fprintf('Error: Unknown error during file import!')
    end
%% Get information about the files contents
    % Get the dimension of txt and num input
    [sizes.txt_m,sizes.txt_n] = size(txt); [sizes.num_m,sizes.num_n] = size(num);
    % Get the header from input
    header_in = txt(1,2:sizes.txt_n);
    % Get the size of header input
    [sizes.headerin_m,sizes.headerin_n] = size(header_in);
%% Write data to dat structure
    % Get the sample code
    data(i).dat.Samples = txt(3:sizes.txt_m,1); %#ok<*AGROW>
    % Parse through valid header files
    for j = 1:sizes.headerv_m
        % Case #1 - Header values has not been found in input file
        % disp(sum(strcmpi(headerv(j),header_in'))) % Control elements
        % disp(headerv(j)) % Control elements
        if sum(strcmpi(headerv(j),header_in')) ~= 1
        % The header entry was not present
        data(i).dat.(headerv{j,1}) = struct('headerv_op',strcmpi(headerv(j),header_in'),...
                                    'headerv_pos',find(strcmpi(headerv(j),header_in')),...
                                    'headerv_opsum',sum(strcmpi(headerv(j),header_in')),...
                                    'Values',NaN(sizes.num_m,1),...
                                    'UnitIn',NaN,...
                                    'Max',NaN(1,1),...
                                    'Mean',NaN(1,1),...
                                    'Median',NaN(1,1),...
                                    'Min',NaN(1,1));
        else
        % Case #2 - Header value has been found in input file
        % Find the position in input data
        headerv_pos = find(strcmpi(headerv(j),header_in')); % disp(headerv_pos);
        % Get the size of header input
        [sizes.data_m,sizes.data_n] = size(raw);
        % Preallocate structure
        vals = zeros(sizes.data_m-2,1); % disp('vals ='); disp(sizes.data_m-2); % Control commands
        % Get the data from input in loop
        for k = 3:sizes.data_m
             % This if statement is required if there is still some text within 
             % the numeric values like >0.05 or whatever
            if(ischar(raw{k,headerv_pos+1}))
                vals(k-2,1) = NaN; 
            else
                vals(k-2,1) = raw{k,headerv_pos+1};
            end
        end
        % Write the data to structure
        data(i).dat.(headerv{j,1}) = struct('headerv_op',strcmpi(headerv(j),header_in'),...
                                    'headerv_pos',headerv_pos,...
                                    'headerv_opsum',sum(strcmpi(headerv(j),header_in')),...
                                    'Values',vals,...
                                    'UnitIn',raw{2,headerv_pos+1},...
                                    'Max',own_nanmax(vals),...
                                    'Mean',own_nanmean(vals),...
                                    'Median',own_nanmed(vals),...
                                    'Min',own_nanmin(vals));

        end
    end
%% Read symbol columns
    % Use marker and loop to find if all columns are in the file
    no_markerv = 0; 
    for j = 1:sizes.markerv_m; 
        no_markerv = sum(strcmpi(markerv(j),header_in')) + no_markerv; 
    end
    % Only write marker variable if all columns are present
    if no_markerv == sizes.markerv_m
        % Go through the marker and get values
        for j = 1:sizes.markerv_m
            % Handle input of different data types
            % Marker, Size and Width are numeric and are read form num
            % variable
            if sum(strcmpi(structv{j,1},{'symbol','size','edgew'})) == 1
                headerv_pos = find(strcmpi(markerv(j),header_in'));
                vals = zeros(sizes.data_m-2,1);
                for k = 3:sizes.data_m
                vals(k-2,1) = raw{k,headerv_pos+1};
                end
            data(i).symbol.(structv{j,1}) = vals;
            % Color are triples and are converted from string to numeric
            % triplets in loop
            else
            [y,x] = find(strcmpi(markerv(j),txt)); % disp(y); disp(x); % Control elements
            [m,~] = size(txt); % disp(m); % Control elements
            data(i).symbol.(structv{j,1}) = txt(y+2:m,x); % assignin('base','mec',txt(y+1:m,x)) % Control elements
                for k = 1:m-2
                data(i).symbol.(structv{j,1}){k,1} = str2num(data(i).symbol.(structv{j,1}){k,1}); %#ok<*ST2NM>
                end
            end
        end
    % Finally, set the operator true or false
    data(i).symbol.op.op = true; temp(i).symbol.op.op = true;
    data(i).symbol.op.override = false;  temp(i).symbol.op.override = true;
    else
    data(i).symbol.op.op = false;
    data(i).symbol.op.override = true;
    end
    % Changed to beginning of this m-file to enable saving markers as
    % default - FR 23/07/19
    % Run the defaults and fill in default setup if no marker columns were
    % available
    % data(i).symbol = defaults_marker(i,data(i).symbol);
    
%% Read label columns
    % Use marker and loop to find if all columns are in the file
    no_labv = 0; for j = 1:sizes.labv_m; no_labv = sum(strcmpi(labv(j),header_in')) + no_labv; end;
    % Only write marker variable if all columns are present
    if no_labv == sizes.labv_m
        % Go through the marker and get values
        for j = 1:sizes.labv_m
            % Handle input of different data types
            % FontSize is the only one reading from num
            if strcmpi(labv{j,1},'FontSize') == true
                headerv_pos = find(strcmpi(labstructv(j),header_in'));
                vals = zeros(sizes.data_m-2,1);
                for k = 3:sizes.data_m
                vals(k-2,1) = raw{k,headerv_pos+1};
                end
            data(i).label.(labstructv{j,1}) = vals;
            % Color are triples and are converted from string to numeric
            % triplets in loop
            else
                % Read color triplets
                if sum(strcmpi(labv{j,1},{'FontColor'})) == 1
                [y,x] = find(strcmpi(labv(j),txt));
                [m,~] = size(txt);
                data(i).label.(labstructv{j,1}) = txt(y+2:m,x);
                    for k = 1:m-2
                    data(i).label.(labstructv{j,1}){k,1} = str2num(data(i).label.(labstructv{j,1}){k,1}); %#ok<*ST2NM>
                    end
                % Read text entries
                else
                [y,x] = find(strcmpi(labv(j),txt));
                [m,~] = size(txt);
                data(i).label.(labstructv{j,1}) = txt(y+2:m,x);
                    for k = 1:m-2
                    data(i).label.(labstructv{j,1}){k,1} = data(i).label.(labstructv{j,1}){k,1}; %#ok<*ST2NM>
                    end
                end
            end
        end
    % Finally, set the operator true
    data(i).label.op.op = true; temp(i).label.op.op = true;
    % Set the operator for displaying labels true
    data(i).label.op.disp = true;
    % Set the operator for override the columns false
    data(i).label.op.override = false; temp(i).label.op.override = true;
    else
    data(i).label.op.op = false;
    data(i).label.op.disp = false;
    data(i).label.op.override = true;
    end
    % Changed to beginning of this m-file to enable saving labels as
    % default - FR 23/07/19
    % Run the defaults and fill in default setup if no marker columns were
    % available
    % data(i).label = defaults_label(i,data(i).label);
    
end
% Close waitbar
delete(wb)
end
