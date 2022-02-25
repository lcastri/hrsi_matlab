function vobs = measure_vobs(A, agent, G, eta_0, t)
    vobs = 0;
    tmp_vobs = [];
    for a = 1 : length(A)
        tmp_vobs(end+1) = A{a}.v(t);
    end

    % obstacles in the radius
    d_obs = A{agent}.d_a(t, length(G)+1 : end);
    valid_index = ~isnan(tmp_vobs) & ~isnan(d_obs) & (d_obs(:) <= eta_0)';

    if ~isempty(valid_index(valid_index ~= 0)) && ~isnan(A{agent}.v(t))
        % velocity obstacles
        tmp_vobs = tmp_vobs(valid_index);
        vobs = sum(tmp_vobs) - length(tmp_vobs)*A{agent}.v(t);
    end
end

