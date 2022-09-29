function timings_2(testfun, changeState)
% Adapted version of timings.m, to use the data gathered by
% timings_save_input, to run more specific timings-gathering using timeit.

%% Check input
knownStates = {'orig', 'zeropar', 'parfor'};

if ~any(strcmp(changeState, knownStates))
    error('Unknown state')
end

refdir = ft_tut_datadir;
mat_directory = fullfile(fileparts(refdir), 'timingscripts_mat_input');
len_testfun = length(testfun);
name_filt = @(x) x(len_testfun+2:end-4); % remove TESTFUN_ and .mat

mat_list = dir(mat_directory);
mat_list = {mat_list.name};
is_testfun = strncmp(mat_list, testfun, len_testfun);
mat_list = mat_list(is_testfun);

%% Prepare variables and create directory
parentFolder = fileparts(mfilename('fullpath'));
savesFolder = fullfile(parentFolder, 'profiling_saves_2');
timingsFile = fullfile(savesFolder, 'timing_info_2.mat');
timingcase = [testfun, '_', changeState];

if exist(timingsFile, 'file')
    timing_info = load(timingsFile);
else
    % initialize the struct
    runfun = name_filt(mat_list{1});
    timing_info.(testfun).(changeState).(runfun) = NaN;
end

basefoldername = fullfile(savesFolder, timingcase);
mkdir(basefoldername)

nr_funs = length(mat_list);
for i=1:nr_funs

    mat_data = load(fullfile(mat_directory, mat_list{i}));
    runfun = name_filt(mat_list{i});

    % run without profiler to get timings
    switch testfun
        case 'timelock'
            fh = @()ft_timelockanalysis(mat_data.varargin{:});
        case 'network'
            fh = @()ft_networkanalysis(mat_data.varargin{:});
        case 'freq'
            fh = @()ft_freqanalysis(mat_data.varargin{:});
        otherwise
            error('Unknown testfun')
    end

    % call the function
    runtime = timeit(fh);
    timing_info.(testfun).(changeState).(runfun) = runtime;
    close('all');

    % run with profiler to get details
    profile on

    % call the function
    fh();

    profinfo = profile("info");
    foldername = fullfile(basefoldername, runfun);
    try
        profsave(profinfo,foldername)
    catch ME
        disp('Caught error, probably on trying to open the main file with web()')
        disp(ME)
    end
    close('all');

end

save(timingsFile, '-struct', 'timing_info');

end
