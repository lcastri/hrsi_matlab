init_fnc;

%% System evolving
for t = 2 : length(tout)
    
    %% TASK
    for i = 1 : length(H)
        current_goal = H{i}.g_seq(t-1);
        goal_to_change = g_reached && t > task_end;
        if goal_to_change
            if current_goal + 1 <= size(Goals_h,1)
                current_goal = current_goal + 1;
            else
               	i_requeueing = i;
            end
            if isequal(Goals_h(current_goal,:), checkout)
                d_index = i;
            end
        end
        H{i}.g_seq(t) = current_goal;
        H{i}.g(t,:) = Goals_h(current_goal, :);
        if goal_to_change && i == length(H)
            current_goal = get_free_place(H, t, checkout, Goals_h);
            H{i_requeueing}.g_seq(t) = current_goal;
            H{i_requeueing}.g(t,:) = Goals_h(current_goal, :); 
            g_reached = false;
            diff_down = true;
        end
    end
    %% GOAL   
    if ~g_reached && ~diff_down && H{d_index}.d_gh(t-1) <= dist_thres
        g_reached = true;
        task = randi(max_t/DT);
        task_end = t + task;
    end
    diff_down = false;

    %% HUMAN
    for i = 1 : length(H)
        
        % new state
        H{i}.x(t) = H{i}.x(t-1) + DT*H{i}.v(t-1)*cos(H{i}.theta(t-1));
        H{i}.y(t) = H{i}.y(t-1) + DT*H{i}.v(t-1)*sin(H{i}.theta(t-1));
        H{i}.theta(t) = H{i}.theta(t-1) + DT*H{i}.w(t-1);
        
    end
    
    for i = 1 : length(H)
        % inputs
        H{i}.theta_gh(t) = wrapToPi(atan2(H{i}.g(t,2) - H{i}.y(t), H{i}.g(t,1) - H{i}.x(t))) + N{1,1}.values(t);
        [dx_gh, dy_gh] = dxdy(H{i}.d_gh(t-1), H{i}.theta_gh(t-1));
        H{i}.d_gh(t) = sqrt((H{i}.g(t,1) - H{i}.x(t))^2 + (H{i}.g(t,2) - H{i}.y(t))^2);
        Ft = attractive_force(Ka, dx_gh, dy_gh);
        gFt = attractive_gradient(Ka);
        
        % human measurement
        for obs = H{i}.obs
            [dx_hh, dy_hh] = dxdy(H{i}.d_hh(t-1, obs), H{i}.theta_hh(t-1, obs));
            H{i}.theta_hh(t,obs) = atan2(H{i}.y(t) - H{obs}.y(t), H{i}.x(t) - H{obs}.x(t));
            H{i}.d_hh(t,obs) = sqrt((H{i}.x(t) - H{obs}.x(t))^2 + (H{i}.y(t) - H{obs}.y(t))^2);
            
            if H{i}.d_hh(t-1, obs) < eta_0
                H{i}.interaction(t, obs) = true;
%                 if i == i_requeueing
                    if repulsive
                        Ft = Ft + repulsive_force(Kr, dx_hh, dy_hh);
                        gFt = gFt + repulsive_gradient(Kr, dx_hh, dy_hh);
                    elseif vortex
                        Ft = Ft + vortex_force(Kr, dx_hh, dy_hh);
                        gFt = gFt + vortex_gradient(Kr, dx_hh, dy_hh);
                    end
%                 end
            end
        end
         
        H{i}.v(t) = get_v(Kv, H{i}.theta(t-1), Ft(1), Ft(2), i ~= i_requeueing, task_end, t, saturation_op, max_v) + N{2,1}.values(t);
        H{i}.w(t) = get_w(Kw, Ft(1), Ft(2), H{i}.theta(t-1), H{i}.v(t-1), gFt, i ~= i_requeueing, task_end, t);
        
        if t >= task_end
            task = 0;
        end
        
        %% DATA
        data{1,1}.name = 'v_queue';
        data{2,1}.name = 'theta';

        if H{i}.g_seq(t) == 4
            data{1,1}.data(t,1) = H{i}.v(t);
        elseif H{i}.g_seq(t) == length(Goals_h)
            data{2,1}.data(t,1) = H{i}.theta_gh(t);
        end
    end
       
    %% PLOT CURRENT STATE
    plot_situation(Boundaries, Goals_h, H, t, axis_def)

end
end_fnc;
