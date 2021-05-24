function [SI_vals, num_trials_used, info] = get_SI_vals(all_traces,all_plusmaze_info,...
                                num_shuffles,session_i,filter_NS_trials, filter_CI_trials,...
                                shuffle_toggle)
% Options:
%   filter_NS_trials, filter_CI_trials: See 'get_trials.m'
%   shuffle_toggle: See 'shuffle_location_info.m'
%

% Parameters:
num_frames_to_sample = 45;

% FIXME: Hard-coded
SI_vals = zeros(1767, 3, 1+num_shuffles, 'single'); % 1767 cells, 3 categories
cell_ranges = [1 411;
               412 873;
               874 1121;
               1122 1767];

% Number of trials used for each SI computation
num_trials_used = zeros(3, 2, 1+num_shuffles, 'uint16');
count_trials = @(x) cellfun(@length, x, 'UniformOutput', true);

for mouse_i = 1:4
    % Report progress
    fprintf('%s: Analyzing mouse %d. \n',datestr(now),mouse_i);

    num_cells = size(all_traces{mouse_i,1}{session_i,1},1);            
    for cell_i = 1:num_cells

        % determine all_cell_id
        all_cell_id = cell_i + cell_ranges(mouse_i,1)-1;

        % Report progress
        if ~mod(all_cell_id,50)
            fprintf('%s: Analyzing Cell %d of 1767. \n',datestr(now),all_cell_id);
        end

        % THK
        [trace_at_trial_start, trace_at_trial_end] = align_trace(all_traces, all_plusmaze_info, mouse_i, session_i, cell_i, num_frames_to_sample);
                
        %%% REGULAR DATA %%%

        % get trial info for parsing traces
        location_info = all_plusmaze_info{mouse_i,1}{1+session_i,2};
        trials_of_int = get_trials(mouse_i,session_i,location_info,filter_NS_trials,filter_CI_trials);
               
        % Compute SI
        SI_vals(all_cell_id,:,1) = compute_all_SIs(trace_at_trial_start, trace_at_trial_end, trials_of_int);
        num_trials_used(:,:,1) = count_trials(trials_of_int);
        
        %%% SHUFFLE DATA %%%
        for shuffle_i = 1:num_shuffles
            location_info_sh = shuffle_location_info(location_info, shuffle_toggle);
            trials_of_int_sh = get_trials(mouse_i,session_i,location_info_sh,filter_NS_trials,filter_CI_trials);
            
            SI_vals(all_cell_id,:,1+shuffle_i) = compute_all_SIs(trace_at_trial_start, trace_at_trial_end, trials_of_int_sh);
            num_trials_used(:,:,1+shuffle_i) = count_trials(trials_of_int_sh);
        end

    end % cell_i
end % mouse_i

info.num_shuffles = num_shuffles;
info.filter_NS_trials = filter_NS_trials;
info.filter_CI_trials = filter_CI_trials;
info.shuffle_toggle = shuffle_toggle;
info.session_i = session_i;
info.num_frames_to_sample = num_frames_to_sample;

end % get_SI_vals

function SI_vals = compute_all_SIs(trace_at_trial_start, trace_at_trial_end, trials_of_int)
    SI_vals = zeros(1,3,'single');

    mean_trace_east = mean(trace_at_trial_start(trials_of_int{1,1},:),1);
    mean_trace_west = mean(trace_at_trial_start(trials_of_int{1,2},:),1);
    SI_vals(1) = calc_SI(mean_trace_east, mean_trace_west);

    mean_trace_north = mean(trace_at_trial_end(trials_of_int{2,1},:),1);
    mean_trace_south = mean(trace_at_trial_end(trials_of_int{2,2},:),1);
    SI_vals(2) = calc_SI(mean_trace_north, mean_trace_south);

    mean_trace_correct = mean(trace_at_trial_end(trials_of_int{3,1},:),1);
    mean_trace_incorrect = mean(trace_at_trial_end(trials_of_int{3,2},:),1);
    SI_vals(3) = calc_SI(mean_trace_correct, mean_trace_incorrect);
end % compute_all_SIs

function SI = calc_SI(summary_A,summary_B)
    mean_A = mean(summary_A);
    mean_B = mean(summary_B);

    SI = mean_A-mean_B;
end % calc_SI