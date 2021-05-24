function trial_inds = get_trials(mouse_i,session_i,location_info,filter_NS_trials,filter_CI_trials)
% Returns:
%   trial_inds: 3 x 2 cell in the format:
%       {east west;
%        north south;
%        correct incorrect};
%
% Options:
%   filter_NS_trials:
%       0: use all north/south trials;
%       1: use only correct
%   filter_CI_trials:
%       0: use all corr/incorr trials;
%       1: use only same end. Specifically, the initially rewarded path

east_trials = find(strcmp(location_info(:,1),'east'));
west_trials = find(strcmp(location_info(:,1),'west'));
north_trials = find(strcmp(location_info(:,3),'north'));
south_trials = find(strcmp(location_info(:,3),'south'));
correct_trials = find(strcmp(location_info(:,2),location_info(:,3)));
incorrect_trials = find(~strcmp(location_info(:,2),location_info(:,3)));

if filter_NS_trials
    north_trials = intersect(north_trials,correct_trials);
    south_trials = intersect(south_trials,correct_trials);            
end

% NOTE: Hard-coded switch paths for each mouse
all_switch_starts = {'west';'west';'east';'west'};
all_switch_ends = {'south';'north';'south';'north'}; % Initially rewarded end

if filter_CI_trials % only use same end arm (switch arm)
    switch_start = all_switch_starts{mouse_i};
    switch_end = all_switch_ends{mouse_i};

    switch session_i
        case {2, 6} % Ego --> Allo
            % 'switch_trials' are initially rewarded paths that are no
            % longer rewarded after the switch
            switch_start_trials = find(strcmp(location_info(:,1),switch_start));
            switch_end_trials = find(strcmp(location_info(:,3),switch_end));
            switch_trials = intersect(switch_start_trials,switch_end_trials);
            
            incorrect_trials = intersect(incorrect_trials,switch_trials);
            correct_trials = intersect(correct_trials,switch_trials);

        case 4 % Allo --> Ego
            switch_start_trials = find(strcmp(location_info(:,1),switch_start));
            switch_end_trials = find(~strcmp(location_info(:,3),switch_end));
            switch_trials = intersect(switch_start_trials,switch_end_trials);
            
            incorrect_trials = intersect(incorrect_trials,switch_trials);
            correct_trials = intersect(correct_trials,switch_trials);  
    end

end

trial_inds = {east_trials west_trials;...
              north_trials south_trials;...
              correct_trials incorrect_trials};
                
end