function [filename] = only_filename(fullfilepath)
% Gets a full file paths and returns only the filenames with extension

% Get the parts of the fullfilename
[path,filename,extension] = fileparts(fullfilepath);
% Concatenate name and extension
filename = [filename extension];

end

