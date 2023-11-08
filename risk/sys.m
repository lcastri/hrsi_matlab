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
    x_disp = (h.x(t) - h.x(t-1))/ h.dt;
    y_disp = (h.y(t) - h.y(t-1))/ h.dt;
    v = [x_disp y_disp];

    obs_x_disp = (r.x(t) - r.x(t-1))/ r.dt;
    obs_y_disp = (r.y(t) - r.y(t-1))/ r.dt;
    obs_v(t, :) = [obs_x_disp obs_y_disp];

    cross_prod = obs_v(t, 1)*v(2)-obs_v(t, 2)*v(1);
    r.rel_angle(t-1, h.id) = wrapTo2Pi(atan2(cross_prod,dot(obs_v(t,:), v)));

    data{5,1}.data(end+1,1) = r.rel_angle(t-1, h.id);

    estim_x_disp = norm(v) * cos(r.rel_angle(t-1, h.id)) * h.dt;
    estim_y_disp = norm(v) * sin(r.rel_angle(t-1, h.id)) * h.dt;
    
    estim_disp = invRotationMatrixZ(r.theta(t-1))*[estim_x_disp;estim_x_disp];

    h.estim_x(t-1) = h.x(t-1) + estim_disp(1);  % New x-coordinate of point A
    h.estim_y(t-1) = h.y(t-1) + estim_disp(2);  % New y-coordinate of point A
end

end_fnc;
