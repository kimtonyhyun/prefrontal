function show_SI_data(all_matches, all_traces, all_plusmaze_info, mouse_i, session_i, cell_i, info)

converted_name = convert_data_name(all_matches, mouse_i, session_i, cell_i);

num_frames_to_sample = info.num_frames_to_sample;
[trace_at_trial_start, trace_at_trial_end] = align_trace(all_traces, all_plusmaze_info, mouse_i, session_i, cell_i, num_frames_to_sample);
t = -(num_frames_to_sample-1):0;

location_info = all_plusmaze_info{mouse_i,1}{1+session_i,2};
trials_of_int = get_trials(mouse_i, session_i, location_info,...
    info.filter_NS_trials, info.filter_CI_trials);

% Parse traces
traces_east = trace_at_trial_start(trials_of_int{1,1},:);
traces_west = trace_at_trial_start(trials_of_int{1,2},:);
num_east = size(traces_east,1);
num_west = size(traces_west,1);

traces_north = trace_at_trial_end(trials_of_int{2,1},:);
traces_south = trace_at_trial_end(trials_of_int{2,2},:);
num_north = size(traces_north,1);
num_south = size(traces_south,1);

traces_corr = trace_at_trial_end(trials_of_int{3,1},:);
traces_incorr = trace_at_trial_end(trials_of_int{3,2},:);
num_corr = size(traces_corr,1);
num_incorr = size(traces_incorr,1);

% Custom subplot command with less whitespace between panels
sp = @(m,n,p) subtightplot(m, n, p, 0.05, 0.05, 0.05); % Gap, Margin-X, Margin-Y

% East/West
%------------------------------------------------------------
sp(3,3,1);
imagesc(t, 1:num_east, traces_east, [0 1]);
ylabel(sprintf('East start (%d trials)', num_east));
set(gca,'YTick',[]);

sp(3,3,2);
imagesc(t, 1:num_west, traces_west, [0 1]);
ylabel(sprintf('West start (%d trials)', num_west));
xlabel('Frames relative to gate open');
set(gca,'YTick',[]);
title(sprintf('Mouse %d, Session %d, Cell %d\n(Originally: %s)', mouse_i, session_i, cell_i, converted_name));

sp(3,3,3);
shadedErrorBar(t, mean(traces_east), std(traces_east)/sqrt(num_east), 'lineprops', 'b');
hold on;
shadedErrorBar(t, mean(traces_west), std(traces_west)/sqrt(num_west), 'lineprops', 'r');
hold off;
legend('East', 'West', 'Location', 'NorthWest');
xlim(t([1 end]));
ylim([0 1]);

% North/South
%------------------------------------------------------------
sp(3,3,4);
imagesc(t, 1:num_north, traces_north, [0 1]);
ylabel(sprintf('North end (%d trials)', num_north));
set(gca,'YTick',[]);

sp(3,3,5);
imagesc(t, 1:num_south, traces_south, [0 1]);
ylabel(sprintf('South end (%d trials)', num_south));
set(gca,'YTick',[]);
xlabel('Frames relative to trial end');

sp(3,3,6);
shadedErrorBar(t, mean(traces_north), std(traces_north)/sqrt(num_north), 'lineprops', 'b');
hold on;
shadedErrorBar(t, mean(traces_south), std(traces_south)/sqrt(num_south), 'lineprops', 'r');
hold off;
legend('North', 'South', 'Location', 'NorthWest');
xlim(t([1 end]));
ylim([0 1]);

% Correct/Incorrect
%------------------------------------------------------------
sp(3,3,7);
imagesc(t, 1:num_corr, traces_corr, [0 1]);
ylabel(sprintf('Correct trials (%d trials)', num_corr));
set(gca,'YTick',1:num_corr);
set(gca,'YTickLabel', trials_of_int{3,1});

sp(3,3,8);
imagesc(t, 1:num_incorr, traces_incorr, [0 1]);
ylabel(sprintf('Incorrect trials (%d trials)', num_incorr));
set(gca,'YTick',1:num_incorr);
set(gca,'YTickLabel', trials_of_int{3,2});
xlabel('Frames relative to trial end');

sp(3,3,9);
shadedErrorBar(t, mean(traces_corr), std(traces_corr)/sqrt(num_corr), 'lineprops', 'b');
hold on;
shadedErrorBar(t, mean(traces_incorr), std(traces_incorr)/sqrt(num_incorr), 'lineprops', 'r');
hold off;
legend('Correct', 'Incorrect', 'Location', 'NorthWest');
xlim(t([1 end]));
ylim([0 1]);

end