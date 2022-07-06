% TODO: how to make sure / check that noone else is using the CPU?

parentFolder = fileparts(mfilename('fullpath'));
basefoldername = fullfile(parentFolder, 'timelock_origfor');
mkdir(basefoldername)

funs = {
    @ft_bench_01_timelockanalysis_tut_15, 'ft_bench_01_timelockanalysis_tut_15';
    };
funs_not = {
    @ft_bench_01_timelockanalysis_01, 'ft_bench_01_timelockanalysis_01';
    @ft_bench_01_timelockanalysis_02, 'ft_bench_01_timelockanalysis_02';
    @ft_tut_15_sensor_analysis, 'ft_tut_15_sensor_analysis';
    @ft_ex_10_ica_remove_ecg_artifacts, 'ft_ex_10_ica_remove_ecg_artifacts';
    @ft_ex_11_ica_remove_eog_artifacts, 'ft_ex_11_ica_remove_eog_artifacts';
    };

nr_funs = size(funs,1);

for i=1:nr_funs

    % run without profiler to get timings
    tic
    try
        funs{i,1}();
    catch ME
        disp('Caught an error')
        disp(ME)
    end
    timing.(funs{i,2}) = toc;

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

end

timingfile = fullfile(basefoldername, 'timings.mat');
save(timingfile, 'timing');
