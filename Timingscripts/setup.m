% Required additional files to be able to run these functions:
% - The fieldtrip code itself, from https://github.com/fieldtrip/fieldtrip
% - Some of the fieldtrip 'ftp' data, available at https://download.fieldtriptoolbox.org/. Not all
%   of the data is needed, however the ft_tut_datadir and ft_tut_workshopdir functions do expect
%   that for the data that has been downloaded, the folder structure is the same as on the server
%
% The expected folder structure for a checkout of this repository relative to the checkout of https://github.com/fieldtrip/fieldtrip
%
% somerootfolder
% |___fieldtrip-parallel-support
% |   |   README.md
% |   |   ...
% |   |
% |   |___Mcode
% |   |   |   ft_tut_datadir.m
% |   |   |   ...
% |   |
% |   |___Timingscripts
% |       |   setup.m (this file)
% |       |   ...
% |
% |___fieldtrip
%     |   ft_defaults.m
%     |   ...
%
% The expected folder structure for the data downloaded from https://download.fieldtriptoolbox.org/
%
% someotherrootfolder
% |___tutorial
% |   |___sensor_analysis
% |   |   |   subjectK.mat
% |   |
% |   |___network_analysis
% |   |   |   comp.mat
% |   |   |   ...
% |   | 
% |   |   ...
% |
% |___test
% |   |___ctf
% |   |   |   SubjectRest.ds
% |   |   |   ...
% |   |
% |   |   ...
% |
% |___workshop
%     |   ...
%

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
