function [outputArg1,outputArg2] = timing_disp()

parentFolder = fileparts(mfilename('fullpath'));
savesFolder = fullfile(parentFolder, 'profiling_saves');
timingsFile = fullfile(savesFolder, 'timing_info.mat');
timing_info = load(timingsFile);

fields_top = fieldnames(timing_info)';
alltables = struct();

for fieldname = fields_top
    subnames = fieldnames(timing_info.(fieldname{1}))';
    for subname = subnames
        thistable = struct2table(timing_info.(fieldname{1}).(subname{1}), 'RowNames',subname);
        % thistable.name = subname;
        if isfield(alltables, fieldname{1})
            alltables.(fieldname{1}) = vertcat(alltables.(fieldname{1}), thistable);
        else
            alltables.(fieldname{1}) = thistable;
        end
    end
    disp(fieldname{1})
    disp(alltables.(fieldname{1}))
end


