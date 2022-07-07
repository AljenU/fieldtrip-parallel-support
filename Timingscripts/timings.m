function timings(testfun, changeState)
% Run a tic-toc and a profiler on a set of functions

%% Check input
knownStates = {'orig', 'zeropar', 'parfor'};

if ~any(strcmp(changeState, knownStates))
    error('Unknown state')
end

switch testfun
case 'timelock'
    funs = {
        @ft_bench_01_timelockanalysis_tut_15, 'ft_bench_01_timelockanalysis_tut_15';
        @ft_bench_01_timelockanalysis_01, 'ft_bench_01_timelockanalysis_01';
        @ft_bench_01_timelockanalysis_01a, 'ft_bench_01_timelockanalysis_01a';
        @ft_bench_01_timelockanalysis_02, 'ft_bench_01_timelockanalysis_02';
        @ft_bench_01_timelockanalysis_02a 'ft_bench_01_timelockanalysis_02a';
        @ft_ex_10_ica_remove_ecg_artifacts, 'ft_ex_10_ica_remove_ecg_artifacts';
        };
case 'network'
    funs = {
        @ft_bench_04_networkanalysis_01, 'ft_bench_04_networkanalysis_01';
        @ft_bench_04_networkanalysis_02, 'ft_bench_04_networkanalysis_02';
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

nr_funs = size(funs,1);
for i=1:nr_funs

    % run without profiler to get timings
    funtime = tic;
    try
        funs{i,1}();
    catch ME
        disp('Caught an error')
        disp(ME)
    end
    timing_info.(testfun).(changeState).(funs{i,2}) = toc(funtime);
    close('all');

    % run with profiler to get details
    profile on
    try
        funs{i,1}();
    catch ME
        disp('Caught an error')
        disp(ME)
    end
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
