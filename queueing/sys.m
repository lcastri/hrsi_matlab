init_fnc;

%% System evolving
for t = 2 : length(tout)
    
    %% TASK
    for i = 1 : length(U)
        current_goal = U{i}.g_seq(t-1);
        if g_reached && t > U{d_index}.task
            requeueing = false;
            if current_goal + 1 <= size(G,1)
                current_goal = current_goal + 1;
            end
            if isequal(Goals_h(current_goal,:), exit)
            	i_requeueing = i;
            elseif isequal(Goals_h(current_goal,:), checkout)
                d_index = i;
            end
            if i == length(U)
                g_reached = false;
                diff_down = true;
            end
        end
        U{i}.set_goal(G{current_goal}, t);
        
        U{i}.compute_next_state(t, DT);
    end
    
    %% GOAL   
    if ~g_reached && ~diff_down && U{d_index}.d_a(t-1, U{d_index}.g_seq(t-1)) <= dist_thres
        g_reached = true;
        task_end = t + randi(max_t/DT);
        for i = 1 : length(U)
            U{i}.task = task_end;
        end
    end
    
    if ~requeueing && ~diff_down && i_requeueing ~= -1 && U{i_requeueing}.d_a(t-1, U{i_requeueing}.g_seq(t-1)) <= dist_thres_requeueing
        next_g = get_free_place(U, t, checkout, Goals_h);
        U{i_requeueing}.set_goal(G{next_g}, t);
        requeueing = true;
    end
    diff_down = false;

    %% HUMAN
    for i = 1 : length(U)
               
        U{i}.measure_g(t, 0, Noise_theta.values(t));
        U{i}.measure_obs(t);
        
        %% VELOCITIES
        [Ft, gFt] = U{i}.total_force_field(t);
        U{i}.task_op = i ~= i_requeueing;
        U{i}.compute_next_inputs(t, Ft, gFt, Noise_V.values(t), 0)
                 
        %% DATA
        if U{i}.g_seq(t) == 4
            data{1,1}.data(t,1) = abs(U{i}.v(t));
        elseif U{i}.g_seq(t) == length(Goals_h)
            data{2,1}.data(t,1) = wrapToPi(U{i}.theta_a(t, U{i}.g_seq(t)));
        end
    end
        
    %% PLOT CURRENT STATE
%     plot_situation(false, 0, Boundaries, [G;U], t, axis_def)

end
end_fnc;
