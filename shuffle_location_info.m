function location_info_sh = shuffle_location_info(location_info, shuffle_toggle)
% shuffle_toggle options:
%   1: same shuffle permutation for start/goal/end
%   2: same shuffle permutation for goal/end
%   3: shuffle differently for start/goal/end

num_trials = size(location_info,1);

switch shuffle_toggle
    case 3
        sh1 = randperm(num_trials);
        sh2 = randperm(num_trials);
        sh3 = randperm(num_trials);
        location_info_sh = [location_info(sh1,1) location_info(sh2,2) location_info(sh3,3)];
    case 2
        sh1 = randperm(num_trials);
        sh2 = randperm(num_trials);
        location_info_sh = [location_info(sh1,1) location_info(sh2,2) location_info(sh2,3)];
    case 1
        shuffle = randperm(num_trials);
        location_info_sh = location_info(shuffle,:);
end