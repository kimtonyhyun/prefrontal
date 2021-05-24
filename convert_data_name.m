function converted_name = convert_data_name(all_matches, mouse_i, session_i, cell_i)

matches = all_matches.(sprintf('m%d', mouse_i));
converted_cell_idx = matches(cell_i, session_i);

switch mouse_i
    case 1
        converted_mouse_idx = 1;
    case 2
        converted_mouse_idx = 2;
    case 3
        converted_mouse_idx = 3;
    case 4
        converted_mouse_idx = 5;
end

converted_session_idx = session_i + 11;

converted_name = sprintf('c11m%dd%d, cell %d', converted_mouse_idx, converted_session_idx, converted_cell_idx);