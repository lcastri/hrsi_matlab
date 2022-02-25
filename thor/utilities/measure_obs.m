function [sum_dobs, sum_eta_dobs] = measure_obs(A, agent, G, eta_0, t, noise)   
    sum_dobs = 0;
    sum_eta_dobs = 0;
    % obstacles inside the radius
    d_obs = A{agent}.d_a(t-1, length(G)+1 : end);
    valid_index = ~isnan(d_obs) & (d_obs(:) <= eta_0)';

    if ~isempty(valid_index(valid_index ~= 0))
        % distance obstacles
        d_obs = d_obs(valid_index);
        eta_dobs = eta_0 - d_obs;
        sum_dobs = sum(d_obs) + noise;
        sum_eta_dobs = sum(eta_dobs) + noise;
    end
end