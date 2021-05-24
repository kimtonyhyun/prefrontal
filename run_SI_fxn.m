%% Load Data
fprintf('%s: Loading traces and plusmaze info... \n',datestr(now));
load('all_plusmaze_info_20210323.mat');
load('all_norm_traces_20210323.mat');
fprintf('%s: Traces and plusmaze info loaded. \n',datestr(now));

%% Set parameters for selectivity index test
num_shuffles = 10; % normally set to 100000
filter_NS_trials = 1; % 0: use all north/south trials; 1: use only correct
filter_CI_trials = 1; % 0: use all corr/incorr trials; 1: use only same end
shuffle_toggle = 3;
    % shuffle toggle types:
    % 1: same shuffle permutation for start/goal/end
    % 2: same shuffle permutation for goal/end
    % 3: shuffle differently for start/goal/end
session_i = 4;

% Run get_SI_vals to get selectivity index for each cell, each category
fprintf('%s: Starting SI analysis... \n',datestr(now));

[SI_vals, num_trials_used, info] = get_SI_vals(all_norm_traces,all_plusmaze_info,...
    num_shuffles,session_i,filter_NS_trials,filter_CI_trials,...
    shuffle_toggle);

fprintf('%s: Done\n',datestr(now));
