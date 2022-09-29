function save_input(varargin)
%SAVE_INPUT Save reference input to testfun, as used in runfun, for later
%use in a timing collection function
% Note that the data gathering is not yet as efficient as it could be, as
% in some functions the same data is used, and only the processing option
% is different in a next call. Thus, the same data will be in multiple
% files. An even better update would be to make dedicated data-generation
% functions based on the runfuns, instead of saving the input data to mat
% file. For now, this was the quickest way to gather specific timing info.

refdir = ft_tut_datadir;
mat_directory = fullfile(fileparts(refdir), 'timingscripts_mat_input');

testfun = evalin('base', 'testfun');
fun = evalin('base', 'runfun');

mat_name = sprintf('%s%s%s', testfun, '_', fun);
mat_name = fullfile(mat_directory, mat_name);

dirlist = dir([mat_name, '*']);

mat_name = sprintf('%s%s%d%s', mat_name, '_', length(dirlist)+1, '.mat');

save(mat_name,"varargin",'-mat');

end

