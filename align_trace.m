function [trace_before_gate_open, trace_at_trial_end] = align_trace(all_traces, all_plusmaze_info, mouse_i, session_i, cell_i, num_frames)

trial_frame_inds = all_plusmaze_info{mouse_i}{1+session_i,1};
num_trials = size(trial_frame_inds, 1);

trace = all_traces{mouse_i}{session_i}(cell_i,:);

trace_before_gate_open = zeros(num_trials, num_frames);
trace_at_trial_end = zeros(num_trials, num_frames);

for k = 1:num_trials
    gate_open_frame = trial_frame_inds(k, 2);
    end_of_trial_frame = trial_frame_inds(k, 4);
    
    trace_before_gate_open(k,:) = trace(gate_open_frame-num_frames+1:gate_open_frame);
    trace_at_trial_end(k,:) = trace(end_of_trial_frame-num_frames+1:end_of_trial_frame);
end