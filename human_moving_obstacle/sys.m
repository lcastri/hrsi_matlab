init_fnc;

%% System evolving
for t = 2 : length(tout)
    for i = 1 : length(U)
        
        %% GOAL
        current_goal = U{i}.g_seq(t-1);
        if i ~= 2
            U{i}.g_changed(t) = ~U{i}.g_changed(t-1) && U{i}.d_a(t-1, U{i}.g_seq(t-1)) <= dist_thres;
            if U{i}.g_changed(t-1)
                if i == 1
                    theta_to_change = true;
                end
                current_goal = randi(length(Goals_h));
            end
        else
            U{i}.g_changed(t) = ~U{i}.g_changed(t-1) && U{i}.d_a(t-1, U{i}.g_seq(t-1)) <= 0.5;
            if U{i}.g_changed(t-1)
                if current_goal + 1 <= length(Goals_r) + length(Goals_h)
                    current_goal = current_goal + 1;
                else
                    current_goal = length(Goals_r)+1;
                end
            end
        end
        U{i}.set_goal(G{current_goal}, t);
        U{i}.compute_next_state(t, DT);
    end
    
    for i = 1 : length(U)   
        U{i}.measure_g(t, noise_Dg.values(t), 0);
        U{i}.measure_obs(t);
        U{i}.measure_risk(t, noise_risk.values(t));

        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        U{i}.compute_next_inputs(t, Ft, gFt)
        
    end
    
    %% PLOT CURRENT STATE
%      plot_situation(false, 0, Boundaries, [G; U], t, axis_def)
    
    %% DATA
    data{1,1}.data(end+1,1) = U{1}.d_a(t, U{1}.g_seq(t));
    data{2,1}.data(end+1,1) = U{1}.v(t);
    data{3,1}.data(end+1,1) = U{1}.risk(t);

end
end_fnc;
