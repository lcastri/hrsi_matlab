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
        U{i}.compute_next_state(t);

        if apply_noise
            % Applying gaussian noise to the agent positions
            noise_x = mu + sigma*(2*rand-1); 
            noise_y = mu + sigma*(2*rand-1);
            U{i}.x(t) = U{i}.x(t) + noise_x;
            U{i}.y(t) = U{i}.y(t) + noise_y;
        end
    end
    
    for i = 1 : length(U)   
        U{i}.measure_g(t);
        U{i}.measure_obs(t);
        U{i}.measure_risk(t);

        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        % U{i}.compute_next_inputs(t, Ft, gFt, 0.05*(2*rand-1), 0);
        U{i}.compute_next_inputs(t, Ft, gFt);

    end
    
    %% PLOT CURRENT STATE
    % plot_situation_wGrid(false, 0, r.id, [G; U], t, axis_def)
    
    %% DATA
    data{1,1}.data(end+1,1) = h.d_a(t, r.id);
    data{2,1}.data(end+1,1) = r.v(t);
    data{3,1}.data(end+1,1) = h.risk(t);
    data{4,1}.data(end+1,1) = h.v(t);
    data{6,1}.data(end+1,1) = r.d_a(t, r.g_seq(t));

end

for t = 2:length(tout)
    % if h.v(t) ~= 0
        x_disp = (h.x(t) - h.x(t-1))/ h.dt;
        y_disp = (h.y(t) - h.y(t-1))/ h.dt;
    % else
    %     x_disp = 0;
    %     y_disp = 0;
    % end
    % 
    % if r.v(t) ~= 0
        obs_x_disp = (r.x(t) - r.x(t-1))/ r.dt;
        obs_y_disp = (r.y(t) - r.y(t-1))/ r.dt;
    % else
    %     obs_x_disp = 0;
    %     obs_y_disp = 0;
    % end
    v = [x_disp y_disp];
    obs_v = [obs_x_disp obs_y_disp];

    cross_prod = obs_v(1)*v(2) - obs_v(2)*v(1);
    r.rel_angle(t-1, h.id) = wrapTo2Pi(atan2(cross_prod,dot(obs_v, v)));
    data{5,1}.data(end+1,1) = r.rel_angle(t-1, h.id);

    estim_x_disp = norm(v) * cos(r.rel_angle(t-1, h.id)) * h.dt;
    estim_y_disp = norm(v) * sin(r.rel_angle(t-1, h.id)) * h.dt;

    r.theta(t-1) = wrapTo2Pi(r.theta(t-1));
    estim_disp = [estim_x_disp, estim_y_disp]*invRotationMatrixZ(r.theta(t-1));

    h.estim_x(t-1) = h.x(t-1) + estim_disp(1);
    h.estim_y(t-1) = h.y(t-1) + estim_disp(2);

end

end_fnc;
