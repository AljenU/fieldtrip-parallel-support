function timings(testfun, changeState, varargin)
% Run a tic-toc and a profiler on a set of functions

%% Check input
knownStates = {'orig', 'zeropar', 'parfor'};

if ~any(strcmp(changeState, knownStates))
    error('Unknown state')
end

if nargin>2
    fun_to_run = varargin{1};
else
    fun_to_run = '';
end

switch testfun
    case 'timelock'
        funs = {
            @ft_bench_01_timelockanalysis_tut_15, 'ft_bench_01_timelockanalysis_tut_15';
            @ft_bench_01_timelockanalysis_01, 'ft_bench_01_timelockanalysis_01';
            @ft_bench_01_timelockanalysis_01a, 'ft_bench_01_timelockanalysis_01a';
            @ft_bench_01_timelockanalysis_02, 'ft_bench_01_timelockanalysis_02';
            @ft_bench_01_timelockanalysis_02a 'ft_bench_01_timelockanalysis_02a';
            };
    case 'network'
        funs = {
            @ft_bench_04_networkanalysis_01, 'ft_bench_04_networkanalysis_01';
            @ft_bench_04_networkanalysis_02, 'ft_bench_04_networkanalysis_02';
            };
    case 'freq'
        funs = {
            @ft_bench_02_freqanalysis_01, 'ft_bench_02_freqanalysis_01';
            @ft_bench_02_freqanalysis_02, 'ft_bench_02_freqanalysis_02';
            @ft_bench_03_connectivityanalysis_01, 'ft_bench_03_connectivityanalysis_01';
            @ft_tut_13_timefrequency_analysis, 'ft_tut_13_timefrequency_analysis';
            % @ft_tut_14_timefrequency_combined_meg_eeg, 'ft_tut_14_timefrequency_combined_meg_eeg'; % do not use, requires user interaction, at 'computing var'
            @ft_tut_15_sensor_analysis, 'ft_tut_15_sensor_analysis';
            @ft_check_test_freqanalysis, 'ft_check_test_freqanalysis';
            };
    otherwise
        error('Unknown testfun')
end

%% Prepare variables and create directory
parentFolder = fileparts(mfilename('fullpath'));
savesFolder = fullfile(parentFolder, 'profiling_saves');
timingsFile = fullfile(savesFolder, 'timing_info.mat');
timingcase = [testfun, '_', changeState];

if exist(timingsFile, 'file')
    timing_info = load(timingsFile);
else
    % initialize the struct
    timing_info.(testfun).(changeState).(funs{1,2}) = NaN;
end

basefoldername = fullfile(savesFolder, timingcase);
mkdir(basefoldername)


if ~isempty(fun_to_run)
    % Skip all except the fun_to_run
    keep = strcmp(fun_to_run, funs(:,2));
    funs = funs(keep,:);
end

nr_funs = size(funs,1);
for i=1:nr_funs

    % run without profiler to get timings
    funtime = tic;

    % call the function
    funs{i,1}();
    timing_info.(testfun).(changeState).(funs{i,2}) = toc(funtime);
    close('all');
    
    % run with profiler to get details
    profile on

    % call the function
    funs{i,1}();

    profinfo = profile("info");
    foldername = fullfile(basefoldername, funs{i,2});
    try
        profsave(profinfo,foldername)
    catch ME
        disp('Caught error, probably on trying to open the main file with web()')
        disp(ME)
    end
    close('all');

end

save(timingsFile, '-struct', 'timing_info');
