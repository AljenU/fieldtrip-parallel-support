function output = ft_check_test_freqanalysis

% based on test_ft_selectdata

% fix the rng seed, to be able to compare results
rng(5)

% MEM 2gb
% WALLTIME 00:10:00
% DEPENDENCY ft_selectdata ft_selectdata_old ft_selectdata_new ft_appendfreq

timelock1 = [];
timelock1.label = {'1' '2'};
timelock1.time  = 1:5;
timelock1.dimord = 'chan_time';
timelock1.avg = randn(2,5);

cfg = [];
cfg.channel = 1;
timelock1a = ft_selectdata(cfg, timelock1);
assert(isequal(size(timelock1a.avg), [1 5]));

cfg = [];
timelock2 = ft_appendtimelock(cfg, timelock1, timelock1, timelock1);

cfg = [];
cfg.channel = 1;
timelock2a = ft_selectdata(cfg, timelock2);
assert(isequal(size(timelock2a.trial), [3 1 5]));

cfg = [];
cfg.trials = [1 2];
timelock2b = ft_selectdata(cfg, timelock2);
assert(isequal(size(timelock2b.trial), [2 2 5]));

% The one that follows is a degenerate case. By selecting only one trial,
% the output is not really trial-based any more, but still contains one trial.
cfg = [];
cfg.trials = 1;
timelock2c = ft_selectdata(cfg, timelock2);
assert(isequal(size(timelock2c.trial), [1 2 5]));
% assert(isequal(size(timelock2c.trial), [2 5]));


%-------------------------------------
%generate data
data = [];
data.fsample = 1000;
data.cfg     = [];

nsmp  = 1000;
nchan = 80;
for k = 1:10
    data.trial{k} = randn(nchan,nsmp);
    data.time{k}  = ((1:nsmp)-1)./data.fsample;
end

% create grad-structure and add to data
grad.pnt  = randn(nchan,3);
grad.ori  = randn(nchan,3);
grad.tra  = eye(nchan);
for k = 1:nchan
    grad.label{k,1} = ['chan',num2str(k,'%03d')];
end
data.grad  = ft_datatype_sens(grad);
data.label = grad.label;
data.trialinfo = (1:10)';
data = ft_checkdata(data, 'hassampleinfo', 'yes');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this part of the script tests the functionality of ft_selectdata with respect
% to freqdata. it implements the (old) test_ft_selectdata_freqdata

% do spectral analysis
cfg        = [];
cfg.method = 'mtmfft';
cfg.output = 'fourier';
cfg.foilim = [2 100];
cfg.pad    = 1;
cfg.tapsmofrq = 3;
freq       = ft_freqanalysis(cfg, data);

cfg.output = 'pow';
cfg.keeptrials = 'yes';
freqp      = ft_freqanalysis(cfg, data);

cfg.output = 'powandcsd';
cfg.channelcmb = ft_channelcombination([data.label(1) {'all'};data.label(2) {'all'}], data.label);
freqc      = ft_freqanalysis(cfg, data);

cfg        = [];
cfg.method = 'mtmconvol';
cfg.foi    = [20:20:100]; % there are 10 repetitions, so let's use 5 frequencies
cfg.toi    = [0.4 0.5 0.6];
cfg.t_ftimwin = ones(1,numel(cfg.foi)).*0.2;
cfg.taper  = 'hanning';
cfg.output = 'pow';
cfg.keeptrials = 'yes';
freqtf     = ft_freqanalysis(cfg, data);

% remove cfg because it has info on current time
freq = rmfield(freq, 'cfg');
freqp = rmfield(freqp, 'cfg');
freqc = rmfield(freqc, 'cfg');
freqtf = rmfield(freqtf, 'cfg');

output = {freq, freqp, freqc, freqtf};

end