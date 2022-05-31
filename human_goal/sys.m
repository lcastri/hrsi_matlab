init_fnc;

for t = 2 : length(tout)
    for i = 1 : length(U)
 
        %% GOAL
        U{i}.g_changed(t) = ~U{i}.g_changed(t-1) && U{i}.d_a(t-1, U{i}.g_seq(t-1)) <= dist_thres;
        current_goal = U{i}.g_seq(t-1);
        if U{i}.g_changed(t)
            if current_goal + 1 <= length(G)
                current_goal = current_goal + 1;
            else
                current_goal = 1;
            end
            U{i}.task = t + randi(max_t/DT);
        end
        U{i}.set_goal(G{current_goal}, t);
        U{i}.compute_next_state(t, DT)
    end
    for i = 1 : length(U)

        %% MEASURMENTS
        U{i}.bearing_g(t, Noise_theta.values(t))
        if ~U{i}.g_changed(t)
            U{i}.range_g(t, Noise_D.values(t))
        else
            U{i}.d_a(t, U{i}.g.id) = U{i}.d_a(t-1, U{i}.g.id) + Noise_D.values(t);
        end

        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        if ~U{i}.g_changed(t)
            U{i}.compute_next_inputs(t, Ft, gFt, Noise_V.values(t), 0)
        else
            U{i}.v(t) = U{i}.v(t-1) + Noise_V.values(t);
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
