function [outputArg1,outputArg2] = timing_disp(version)

parentFolder = fileparts(mfilename('fullpath'));
if version==1
    savesFolder = fullfile(parentFolder, 'profiling_saves');
    timingsFile = fullfile(savesFolder, 'timing_info.mat');
else
    savesFolder = fullfile(parentFolder, 'profiling_saves_2');
    timingsFile = fullfile(savesFolder, 'timing_info_2.mat');
end
timing_info = load(timingsFile);

fields_top = fieldnames(timing_info)';
alltables = struct();

labels = struct(...
    'orig', 'original', ...
    'parfor', 'parfor_infWorkers', ...
    'zeropar', 'parfor_zeroWorkers');

for fieldname = fields_top
    subnames = fieldnames(timing_info.(fieldname{1}))';
    for subname = subnames
        label = {labels.(subname{1})};
        thistable = struct2table(timing_info.(fieldname{1}).(subname{1}), 'RowNames',label);
        % thistable.name = subname;
        if isfield(alltables, fieldname{1})
            alltables.(fieldname{1}) = vertcat(alltables.(fieldname{1}), thistable);
        else
            alltables.(fieldname{1}) = thistable;
        end
    end
    disp(fieldname{1})
    disp(rows2vars(alltables.(fieldname{1})))
end


