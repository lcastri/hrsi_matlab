function obs = get_closest_obs(A, G, agent, t)
    d_obs = A{agent}.d_a(t, length(G) + 1 : end);
    d_obs(isnan(d_obs)) = 1000;
    [mini, min_index] = min(d_obs(~isnan(d_obs)));
    if mini ~= 1000
        obs = min_index;
    else
        obs = nan;
    end
end

