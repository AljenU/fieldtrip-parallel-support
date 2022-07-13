parentFolder = fileparts(mfilename('fullpath'));
fpsFolder = fileparts(parentFolder);

% Add tutorial functions to path
addpath(fullfile(fpsFolder, 'Mcode'));

% Add fieldtrip to path
% Assume next to fps folder
addpath(fullfile(fpsFolder, '..', 'fieldtrip'));

% Set the ft_tut_datadir
% TODO: one datadir at the 'ftp' level, and the test or tutorial or workshop part added inside the functions
ft_tut_datadir('D:\FieldTripData\tutorial')
ft_tut_workshopdir('D:\FieldTripData\workshop')

% Put an input() function on the path that always responds yes
addpath(fullfile(parentFolder, 'override_functions'));

% call ft_defaults, so the full path has been set, before starting the
% parallel pool
ft_defaults();

% Set what should be the default parallel profile
% parallel.defaultClusterProfile('local')

% Already start the parallel pool, to avoid the startup time influencing
% the timing of the first function that actually uses it.
parpool();
