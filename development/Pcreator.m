% The Pcreator reads the master program file and creates the
% program_switch.m, create_rb_cellarr.m, special_fnc_switch.n 
% and start_programs.m
% *************************************************************************
% M-File: Pcreator.m
% Project: FastGAPP 2.0
% Author: Florian Riefstahl
% Date: 2015-2019
% Versions: v1.0 2015-2019
%                - Initial version only writing 
% Versions: v1.1 2019-10-21
%                - Update for 3 functions 
%                - Some improvements of functionality
% *************************************************************************
% Input information (MASTER_PROGRAMS.xlsx)
% Column  1: Entry Nr
% Column  2: Program Name
% Column  3: Tool Tip String shown in main window
% Column  4: Visibility of Button
% Column  5: control function name
% Column  6: line switch name
% Column  7: label switch name
% Column  8: main window type
% Column  9: special function
% Column 10: output for special function
% Column 11: input for special function
% *************************************************************************
function Pcreator
% Version number
vers_nr = '1.1';
% Some output to command windos
fprintf('Launching ProgramSwitchCreator v%s... - Time: %s\n',vers_nr,datestr(clock));
fprintf('...select program master file... - Time: %s\n',datestr(clock));

% Select files and divide it into names, extension, fullfile ...
[inp.file,inp.filepath] = uigetfile({'*.xls; *.xlsx',...
                                     'Excel Spreadsheets (*.xls, *.xlsx)'},...
                                     'Select master plot file!','MultiSelect','Off',...
                                     [pwd '/development/programs/']);
% Check the input
    if isequal(inp.file,0)
        % If no file is selected make output to command window
        fprintf('No file selected! Program stopped...\n - Time: %s\n',datestr(clock))
        % Abort callback
        return
    else
        fprintf('...reading program master file... - Time: %s\n',datestr(clock));
        % Read the general information from master spreadsheet
        [~,~,inp.general] = xlsread(fullfile(inp.filepath,inp.file),'general');
        % Output to command window, should be deactivated
        % Get the size of input cell array
        [m,n] = size(inp.general);
        % Cut header line
        inp.general = inp.general(2:m,1:n);
        
% Control element
% assignin('base','inp',inp)

        % Subtract header lines
        m = m - 1;
        % Count visible entries and contained programs
        count_vis = 0; count_prog = 0;
        for i = 1:m
           if strcmpi(inp.general{i,4},'on')
               count_vis = count_vis + 1;
           end
           if strcmpi(inp.general{i,5},'-') == false
              count_prog = count_prog + 1; 
           end
        end
        % Show that idata import is done
        fprintf('...done! - Time: %s\n\n',datestr(clock));
        
% Control element
% assignin('base','inp',inp)

        % Prompt if process with the input, show short summary
        choice = questdlg(sprintf('%1.0f entries found!\n%1.0f visible radio buttons\n%1.0f programs\nCreate m-files?',m,count_vis,count_prog),'Confirm input!','Yes','No','Yes');
        
        % Another prompt asking for confirmation
        if strcmpi(choice,'Yes')
            choice = questdlg(sprintf('ATTENTION!!!\nImportant functions will be overwritten!\nAre you really sure to continue?'),'Confirm selection!','Yes','No','Yes');
        else
            fprintf('...program terminated by user! - Time: %s\n\n',datestr(clock));
            return
        end
        
        % Write the three function if confirmed
        if strcmpi(choice,'Yes')
            %% Write the create_rb_cellar.m function
            
            fprintf('Start to create the create_rb_cellar.m... - Time: %s\n',datestr(clock));            
            % Open file for writing
            fid = fopen('bin/create_rb_cellarr.m','w');
            % Write comment lines
            fprintf(fid,'%% Created with Pcreator v%s\n',vers_nr);
            fprintf(fid,'%% Date/Time: %s\n',datestr(clock));
            fprintf(fid,'%% Called from: FGAPP20.m\n');
            % Write the function title
            fprintf(fid,'function out_cell = create_rb_cellarr\n\n');
            % Write begin of cell array
            fprintf(fid,'    out_cell = ({...\n');
            % Write the contents
            for i = 1:1:m
                fprintf(fid,'                 ''%s'',''%s'',''%s'';... %% %1.0f\n',inp.general{i,2},inp.general{i,3},inp.general{i,4},inp.general{i,1});
            end
            % Close cell array
            fprintf(fid,'                 });\n\n');
            % Close the function
            fprintf(fid,'end');
            % Show that this script is done
            fprintf('...done! - Time: %s\n\n',datestr(clock)); 
            
            %% Write the start_programs.m function
            
            fprintf('Start to create the start_programs.m... - Time: %s\n',datestr(clock));               
            % Open file for writing
            fid = fopen('bin/start_programs.m','w');
            % Write comment lines
            fprintf(fid,'%% Created with Pcreator v%s\n',vers_nr);
            fprintf(fid,'%% Date/Time: %s\n',datestr(clock));
            fprintf(fid,'%% Called from: FGAPP20.m\n');
            % Write the function title
            fprintf(fid,'function start_programs(radiostr,load_op,files,files_op,save_path)\n\n');
            
            % Write function contents
            for i = 1:m
                if i == 1;
                    % Write if statement
                    fprintf(fid,'    if strcmpi(''%s'',radiostr)\n',inp.general{i,2});
                    fprintf(fid,'        control = %s;\n',inp.general{i,5});
                    fprintf(fid,'        %s(control,load_op,files,files_op,save_path);\n\n',inp.general{i,8});
                elseif strcmpi(inp.general{i,2},'-') == false && strcmpi(inp.general{i,5},'-') == false
                    % Write elseif statement
                    fprintf(fid,'    elseif strcmpi(''%s'',radiostr)\n',inp.general{i,2});
                    fprintf(fid,'        control = %s;\n',inp.general{i,5});
                    fprintf(fid,'        %s(control,load_op,files,files_op,save_path);\n\n',inp.general{i,8});
                end
            end
            % Write an unknown error output to the end
            fprintf(fid,'    else\n');
            % Output if unexpectedly the program does not exist
            fprintf(fid,'        fprintf(''Fatal error: Program does not exist!'')\n\n');
            % Close if-elseif statement in output file
            fprintf(fid,'    end\n\n');
            % Close the function
            fprintf(fid,'end');
            % Close the file
            fclose(fid);
            % Show that this script is done
            fprintf('...done! - Time: %s\n\n',datestr(clock));  
            
            %% Write the special_fnc_switch.m
            
            fprintf('Start to create the start_programs.m... - Time: %s\n',datestr(clock));               
            % Open file for writing
            fid = fopen('bin/special_fnc_switch.m','w');
            % Write comment lines
            fprintf(fid,'%% Created with Pcreator v%s\n',vers_nr);
            fprintf(fid,'%% Date/Time: %s\n',datestr(clock));
            fprintf(fid,'%% Called from: mainwindow_type1.m\n');
            fprintf(fid,'%%              mainwindow_type2.m\n');
            
            % Write the function title
            fprintf(fid,'function [data,control] = special_fnc_switch(data,control,files_op)\n\n');
            fprintf(fid,'    switch control.program\n');
            % Write function contents
            for i = 1:m
                if sum(strcmpi(inp.general{i,9},{'-';'none'})) == 0
                    % Start to write cases with special function
                    fprintf(fid,'        case ''%s''\n',inp.general{i,2});
                    fprintf(fid,'            [%s] = %s(%s);\n\n',inp.general{i,10},inp.general{i,9},inp.general{i,11});
                elseif strcmpi(inp.general{i,9},'none')
                    % Start to write cases without special function
                    fprintf(fid,'        case ''%s''\n',inp.general{i,2});
                    fprintf(fid,'            %% No special function defined!!!\n\n');
                end
            end
            % Write an unknown error output to the end
            fprintf(fid,'        otherwise\n');
            % Output if unexpectedly the program does not exist
            fprintf(fid,'            fprintf(''Fatal error: Program does not exist!'')\n\n');
            % Close if-elseif statement in output file
            fprintf(fid,'    end\n\n');
            % Close the function
            fprintf(fid,'end');
            % Close the file
            fclose(fid);
            % Write the start_programs.m function
            fprintf('...done! - Time: %s\n\n',datestr(clock)); 
            
            %% Write the program_switch.m function
            
            fprintf('Start to create the program_switch.m... - Time: %s\n',datestr(clock));
            % Open file for writing
            fid = fopen('bin/program_switch.m','w');
            % Write comment lines
            fprintf(fid,'%% Created with Pcreator v%s\n',vers_nr);
            fprintf(fid,'%% Date/Time: %s\n',datestr(clock));
            fprintf(fid,'%% Called from: main_window_type1.m --> defplot_callback and update_callback\n');
            fprintf(fid,'%%              main_window_type2.m --> defplot_callback and update_callback\n');
            % Write the function title
            fprintf(fid,'function [plotax] = program_switch(control,plotax,plotsel,data,files_op,opt_check)\n\n');
            % Write function contents
            for i = 1:m
                if i == 1;
                    % Start to write if statement
                    fprintf(fid,'    if strcmpi(control.program,''%s'');\n',inp.general{i,2});
                    % Write plot samples function
                    fprintf(fid,'        plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check);\n');
                    % Write lineswitches
                    fprintf(fid,'        plotax = %s(control,plotax,plotsel);\n',inp.general{i,6});
                    % Write label switches
                    fprintf(fid,'        plotax = %s(control,plotax,plotsel);\n\n',inp.general{i,7});
                elseif strcmpi(inp.general{i,5},'-') == false
                    % Start to write elseif statement
                    fprintf(fid,'    elseif strcmpi(control.program,''%s'')\n',inp.general{i,2});
                    % Write plot samples function
                    fprintf(fid,'        plotax = plot_samples(control,plotax,plotsel,data,files_op,opt_check);\n');
                    % Write lineswitches
                    fprintf(fid,'        plotax = %s(control,plotax,plotsel);\n',inp.general{i,6});
                    % Write label switches
                    fprintf(fid,'        plotax = %s(control,plotax,plotsel);\n\n',inp.general{i,7});
                end
            end
            % Write an unknown error output to the end
            fprintf(fid,'    else\n');
            % Output if unexpectedly the program does not exist
            fprintf(fid,'        fprintf(''Fatal error: Program does not exist!'')\n\n');
            % Close if-elseif statement in output file
            fprintf(fid,'    end\n\n');
            % Close the function
            fprintf(fid,'end');
            % Close the file
            fclose(fid);
            % Write the start_programs.m function
            fprintf('...done! - Time: %s\n\n',datestr(clock)); 
             
        else
            fprintf('...program terminated by user! - Time: %s\n',datestr(clock));
            return
        end
    end
end

