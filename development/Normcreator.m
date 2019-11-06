function Normcreator
% The Pcreator reads the master program file and creates the program switch


% Some output to command windos
fprintf('Launching NormCreator v1.0... - Time: %s\n',datestr(clock));
fprintf('...select normalisation value file... - Time: %s\n',datestr(clock));

% Select files and divide it into names, extension, fullfile ...
[inp.file,inp.filepath] = uigetfile({'*.xls; *.xlsx',...
                                     'Excel Spreadsheets (*.xls, *.xlsx)'},...
                                     'Select normalisation value file!','MultiSelect','Off',...
                                     [pwd '/development/normalisation_values/']);
% Check the input
    if isequal(inp.file,0)
        % If no file is selected make output to command window
        fprintf('No file selected! Program stopped...\n - Time: %s\n',datestr(clock))
        % Abort callback
        return
    else
        fprintf('...reading normalisation value file... - Time: %s\n',datestr(clock));
        % Read the general information from master spreadsheet
        [~,~,inp.general] = xlsread(fullfile(inp.filepath,inp.file),'values');
        % Output to command window, should be deactivated
        % assignin('base','inp',inp)
        % Get the size of input cell array
        [m,n] = size(inp.general);
        
        % Create a question dialog box to confirm progress
        choice = questdlg(sprintf('%1.0f different items found!\nCreate the normalisation values script?',m-3),'Progess?','Yes','No','Yes');
        
        % Check the answer of the question dialog box
        switch choice
            % Start process if yes has been clicked
            case 'Yes'
                % Some output and create the m-file
                fprintf('Start to create the normalisation values script... - Time: %s\n',datestr(clock));
                fid = fopen('db/normalisation/normalisation_values.m','w');
                
                % Write the function title
                fprintf(fid,'function [norm_vals] = normalisation_values\n\n');
                    
                    % Write the names and references
                    for i = 1:m-3
                        if i == 1
                            % Write the begin of struct
                            fprintf(fid,'norm_vals.str = {...\n');
                        end
                        
                        % Write the block of information
                        fprintf(fid,'                 ''%s'', ''%s'', ''%s'', ''%s'';...\n',inp.general{i+3,1},inp.general{i+3,2},inp.general{i+3,n-1},inp.general{i+3,n});
                            
                        if i == m-3;
                            % Write the of the cell array
                            fprintf(fid,'                 };\n\n');
                        end
                    end

                    for i = 1:n-4
                        for j = 1:m-3
                            if j == 1
                                % Write the begin of struct
                                fprintf(fid,'norm_vals.%s = [...\n',inp.general{j,i+2});
                            end
                                if ischar(inp.general{j+3,i+2})
                                    fprintf(fid,'                NaN;...\n');
                                else
                                    % Write the block of information
                                    fprintf(fid,'                %5.5f;...\n',inp.general{j+3,i+2});
                                end
                            if j == m-3;
                                % Write the of the cell array
                                fprintf(fid,'                 ];\n\n');
                            end
                        end
                    end
                fprintf(fid,'end');
                % Some output and close file
                fprintf('...finished with the script! - Time: %s\n',datestr(clock));
                fclose(fid);

            % Terminate the program if No has been clicked or aborted
            otherwise
                fprintf('...program terminated by user! - Time: %s\n',datestr(clock));
                return
        end
    end
end

