init_fnc;

for t = 2 : length(tout)
    %% GOAL
    U{1}.set_goal(G{1}, t);
    
    U{2}.g_changed(t) = ~U{2}.g_changed(t-1) && U{2}.d_a(t-1, U{2}.g_seq(t-1)) <= dist_thres;
    current_goal = U{2}.g_seq(t-1);
    if U{2}.g_changed(t-1)
        if current_goal + 1 <= length(G)
            current_goal = current_goal + 1;
        else
            current_goal = 1;
        end
    end
    U{2}.set_goal(G{current_goal}, t);
           
    for i = 1 : length(U)
        U{i}.compute_next_state(t, DT);
    end
    
    for i = 1 : length(U)

        U{i}.measure_g(t, noise_D12.values(t), 0);
        U{i}.measure_obs(t, noise_D12.values(t), 0);

        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        if i == 1
            nv = noise_v1.values(t);
        else
            nv = noise_v2.values(t);
        end
        U{i}.compute_next_inputs(t, Ft, gFt, nv, 0)
    end
    
    
    %% PLOT CURRENT STATE
%     plot_situation(false, 0, Boundaries, [G;U], t, axis_def)
    
    %% DATA
    if isequal(U{2}.g, intervention_point)
        data{1,1}.data(end+1,1) = abs(U{2}.v(t));
        data{2,1}.data(end+1,1) = U{1}.d_a(t,U{1}.obs.id);
        data{3,1}.data(end+1,1) = abs(U{1}.v(t));
    end

end
end_fnc;
