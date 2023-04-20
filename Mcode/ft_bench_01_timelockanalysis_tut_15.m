function ft_tut_15_sensor_analysis
% Tutorial: Sensor-level ERF, TFR and connectivity analysis
%
% From: https://www.fieldtriptoolbox.org/tutorial/sensor_analysis/

% Load preprocessed data

load(fullfile(ft_tut_datadir, 'sensor_analysis', 'subjectK.mat'));

% Visualization

plot(data_left.time{1}, data_left.trial{1}(130,:));

figure
for k = 1:10
plot(data_left.time{k}, data_left.trial{k}(130,:)+k*1.5e-12);
hold on;
end
plot([0 0], [0 1], 'k');
ylim([0 11*1.5e-12]);
set(gca, 'ytick', (1:10).*1.5e-12);
set(gca, 'yticklabel', 1:10);
ylabel('trial number');
xlabel('time (s)');

% Event-related analysis

cfg  = [];
data = ft_appenddata(cfg, data_left, data_right);

cfg                 = [];
cfg.covariance        = 'yes';
cfg.channel         = 'MEG';
save_input(cfg,data)
tl                  = ft_timelockanalysis(cfg, data);

% Visualization

cfg                 = [];
cfg.showlabels      = 'yes';
cfg.showoutline     = 'yes';
cfg.layout          = 'CTF151_helmet.mat';
ft_multiplotER(cfg, tl);

% Planar gradient

cfg                 = [];
cfg.method          = 'template';
cfg.template        = 'CTF151_neighb.mat';
neighbours          = ft_prepare_neighbours(cfg, data);

cfg                 = [];
cfg.method          = 'sincos';
cfg.neighbours      = neighbours;
data_planar         = ft_megplanar(cfg, data);

cfg                 = [];
cfg.covariance        = 'yes';
cfg.channel         = 'MEG';
save_input(cfg,data_planar)
tl_planar           = ft_timelockanalysis(cfg, data_planar);

end