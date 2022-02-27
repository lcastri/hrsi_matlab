function obs = get_closest_obs(A, G, agent, t)
%get_closest_obs: compute closest obstacles
% - param A: (struct) agents struct
% - param G: (struct) goals struct
% - param agent: (int) index selected agent
% - param t: (int) time step
% - return obs: (int) index closest obstacle

    d_obs = A{agent}.d_a(t, length(G) + 1 : end);
    d_obs(isnan(d_obs)) = 1000;
    [mini, min_index] = min(d_obs(~isnan(d_obs)));
    if mini ~= 1000
        obs = min_index;
    else
        obs = nan;
    end
end

