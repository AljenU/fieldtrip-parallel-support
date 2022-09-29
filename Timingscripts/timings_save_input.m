function timings_save_input(testfun, changeState, varargin)
% Adapted version of timings.m, to gather data through save_input calls
% that have been added in the called functions. Data for later use in more
% specific timing-gathering function.

%% Check input
knownStates = {'orig'};

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
            @ft_tut_15_sensor_analysis, 'ft_tut_15_sensor_analysis';
            @ft_check_test_freqanalysis, 'ft_check_test_freqanalysis';
            };
    otherwise
        error('Unknown testfun')
end

%% Prepare variables and create directory

nr_funs = size(funs,1);
for i=1:nr_funs

    % For use by save_input function
    assignin('base', 'testfun', testfun);
    assignin('base', 'runfun', funs{i,2});

    % call the function
    funs{i,1}();
    close('all');
    
end

end
