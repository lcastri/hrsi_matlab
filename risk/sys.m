init_fnc;

%% System evolving
for t = 2 : length(tout)
    for i = 1 : length(U)
        
        %% GOAL
        current_goal = U{i}.g_seq(t-1);
        U{i}.g_changed(t) = ~U{i}.g_changed(t-1) && U{i}.d_a(t-1, U{i}.g_seq(t-1)) <= dist_thres;
        if U{i} == r
            if U{i}.g_changed(t-1)
                if t <= length(tout)/2
                    current_goal = 3 - (current_goal ~= 2);
                else
                    current_goal = 5 - (current_goal ~= 4);
                end
            end
        end
        U{i}.set_goal(G{current_goal}, t);
        U{i}.compute_next_state(t, DT);
    end
    
    for i = 1 : length(U)   
        % U{i}.measure_g(t, noise_Dg.values(t), 0);
        U{i}.measure_g(t);
        U{i}.measure_obs(t);
        % U{i}.measure_risk(t, noise_risk.values(t));
        U{i}.measure_risk(t);

        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        U{i}.compute_next_inputs(t, Ft, gFt);
        % U{i}.compute_next_state(t, DT);    
    end
    
    %% PLOT CURRENT STATE
    % plot_situation_wGrid(false, 0, r.id, [G; U], t, axis_def)
    
    %% DATA
    data{1,1}.data(end+1,1) = h.d_a(t, r.id);
    data{2,1}.data(end+1,1) = r.v(t);
    data{3,1}.data(end+1,1) = h.risk(t);
    data{4,1}.data(end+1,1) = h.v(t);
    % data{5,1}.data(end+1,1) = h.rel_angle(t, r.id);

end

for t = 2:length(tout)
    x_disp = h.x(t) - h.x(t-1);
    y_disp = h.y(t) - h.y(t-1);
    v = [x_disp y_disp] / h.dt;

    obs_x_disp = r.x(t) - r.x(t-1);
    obs_y_disp = r.y(t) - r.y(t-1);
    obs_v = [obs_x_disp obs_y_disp] / r.dt;

    v=v * [1; 1i];
    obs_v=obs_v* [1; 1i];
    h.rel_angle(t-1, r.id) = angle(v*obs_v');

    % h.rel_angle(t-1, r.id) = atan2(abs(cross(obs_v, v, 2)),dot(obs_v, v));

    % h.rel_angle(t-1, r.id) = (atan2(obs_y_disp, obs_x_disp) - atan2(y_disp(t), x_disp(t)));
    % Adjust the sign of h.rel_angle to match the orientation of vectors
    % if h.rel_angle(t-1, r.id) < -pi/2
    %     h.rel_angle(t-1, r.id) = h.rel_angle(t-1, r.id) + pi;
    % elseif h.rel_angle(t-1, r.id) > pi/2
    %     h.rel_angle(t-1, r.id) = h.rel_angle(t-1, r.id) - pi;
    % end

    % % Compute the dot product of the two vectors
    % dot_product = dot(v, obs_v);
    % 
    % % Compute the magnitudes of the vectors
    % magn_v = norm(v);
    % magn_obs_v = norm(obs_v);
    % if magn_v < 0.05 || magn_obs_v < 0.05
    %     h.rel_angle(t-1, r.id) = 0;
    % else
    %     % Compute the cosine of the angle between the vectors
    %     cosine_angle = dot_product / (magn_v * magn_obs_v);
    % 
    %     % Compute the angle in radians
    %     ciao = atan2(obs_y_disp, obs_x_disp) - atan2(y_disp, x_disp);
    %     h.rel_angle(t-1, r.id) = acos(cosine_angle);
    % end
    data{5,1}.data(end+1,1) = h.rel_angle(t-1, r.id);

    estim_x_disp = norm(v) * cos(h.rel_angle(t-1, r.id)) * h.dt;
    estim_y_disp = norm(v) * sin(h.rel_angle(t-1, r.id)) * h.dt;

    h.estim_x(t-1) = h.x(t-1) + estim_x_disp;  % New x-coordinate of point A
    h.estim_y(t-1) = h.y(t-1) + estim_y_disp;  % New y-coordinate of point A
    % h.estimate_next_pos(t);
end

end_fnc;
