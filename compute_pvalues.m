function pvals = compute_pvalues(SI_vals)

[num_cells, num_cat, num_shuffles] = size(SI_vals);
num_shuffles = num_shuffles - 1; % The first entry is non-shuffled values

pvals = zeros(num_cells, num_cat, 'single');

for k = 1:num_cells
    for j = 1:num_cat
        true_SI = SI_vals(k,j,1);
        shuffled_SIs = squeeze(SI_vals(k,j,2:end));
        
        p1 = sum(shuffled_SIs<true_SI)/num_shuffles; % Left tail of shuffle distribution
        p2 = sum(shuffled_SIs>true_SI)/num_shuffles; % Right tail
        
        pvals(k,j) = min(p1, p2);
    end
end