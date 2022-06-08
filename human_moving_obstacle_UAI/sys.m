init_fnc;

%% System evolving
for t = 2 : length(tout)
    for i = 1 : length(U)
        
        %% GOAL
        current_goal = U{i}.g_seq(t-1);
        
        U{i}.g_changed(t) = ~U{i}.g_changed(t-1) && U{i}.d_a(t-1, U{i}.g_seq(t-1)) <= dist_thres;
        if U{i}.g_changed(t-1)
            if i == 1
                theta_to_change = true;
            end
            next_goal_id = randsample(available_places, 1);
            available_places(available_places == next_goal_id) = [];
            available_places(end+1) = U{i}.g_seq(t-1);
            current_goal = next_goal_id;
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

        if theta_to_change
            if abs(U{i}.theta_a(t, U{i}.g_seq(t)) - U{i}.theta(t)) > 0.01
                U{i}.v(t) = noise_v.values(t);
                U{i}.w(t) = Kw * (atan2(Ft(2), Ft(1)) - U{i}.theta(t));

            else
                theta_to_change = false;
            end
        else
            U{i}.compute_next_inputs(t, Ft, gFt, noise_v.values(t), 0)
        end        
    end
    
    %% PLOT CURRENT STATE
%      plot_situation(false, 0, Boundaries, [G; U], t, axis_def)
    
    %% DATA
    data{1,1}.data(end+1,1) = U{1}.d_a(t, U{1}.g_seq(t));
    data{2,1}.data(end+1,1) = U{1}.v(t);
    data{3,1}.data(end+1,1) = U{1}.risk(t);

end
end_fnc;
