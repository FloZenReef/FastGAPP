function [outfiles] = parse_files(infiles,files_op)
% This function handles the selected files from FGAPP20.m
% Probably datasets could be read on different of nine location and not
% continously. This function sorts them continously and files up the rest
% with no data values and sets handle operator to zero


% Preallocate new files
outfiles = cell(9,6);
% Output counters
j = 1; k = 1 + files_op;
    % Loop to read and write from input cell array
    for i = 1:9
        % If operator is 1, write filename to output
        if infiles{i,6} == 1;
            outfiles(j,1:5) = infiles(i,1:5);
            outfiles{j,6} = true;
            j = j + 1;
        % Else write clear line in output
        else
            outfiles{k,1} = 'no data';
            outfiles{k,6} = false;
            k = k + 1;
        end
    end

end