init_fnc;

for t = 2 : length(tout)
    for i = 1 : length(U)
 
        %% GOAL
        U{i}.g_changed(t) = ~U{i}.g_changed(t-1) && U{i}.d_a(t-1, U{i}.g_seq(t-1)) <= dist_thres;
        current_goal = U{i}.g_seq(t-1);
        if U{i}.g_changed(t)
            current_goal = randi([1, size(G,1)]);
            % if current_goal + 1 <= length(G)
            %     current_goal = current_goal + 1;
            % else
            %     current_goal = 1;
            % end
            U{i}.task = t + randi(max_t/DT);
        end
        U{i}.set_goal(G{current_goal}, t);
        U{i}.compute_next_state(t, DT)

        if apply_noise
            % Applying gaussian noise to the agent positions
            noise_x = mu + sigma*(2*rand-1); 
            noise_y = mu + sigma*(2*rand-1);
            U{i}.x(t) = U{i}.x(t) + noise_x;
            U{i}.y(t) = U{i}.y(t) + noise_y;
        end
    end
    for i = 1 : length(U)

        %% MEASURMENTS
        U{i}.bearing_g(t)
        if ~U{i}.g_changed(t)
            U{i}.range_g(t)
        else
            U{i}.d_a(t, U{i}.g.id) = U{i}.d_a(t-1, U{i}.g.id);
        end

        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        if ~U{i}.g_changed(t)
            U{i}.compute_next_inputs(t, Ft, gFt)
        else
            U{i}.v(t) = U{i}.v(t-1);
            U{i}.w(t) = U{i}.w(t-1);
        end
    end

    %% PLOT CURRENT STATE
%     plot_situation(false, 0, Boundaries, [G;U], t, axis_def)

    %% DATA
    data{1,1}.data(t,1) = wrapTo2Pi(U{1}.theta_a(t, U{1}.g_seq(t)));
    data{2,1}.data(t,1) = U{1}.d_a(t, U{1}.g_seq(t));
    data{3,1}.data(t,1) = abs(U{1}.v(t));
    
end

end_fnc;
