figure
step = 10;
window = 250;
left = subplot(3, 3, [1, 2, 4, 5, 7, 8]);
right_1 = subplot(3, 3, 3);
right_2 = subplot(3, 3, 6);
right_3 = subplot(3, 3, 9);

hold(right_1, "on")
grid(right_1, 'on')
plot(right_1, 1 : length(data{1,1}.data), data{1,1}.data, 'b')
title(right_1, data{1,1}.name);

hold(right_2, "on")
grid(right_2, 'on')
plot(right_2, 1 : length(data{2,1}.data), data{2,1}.data, 'b')
title(right_2, data{2,1}.name);

hold(right_3, "on")
grid(right_3, 'on')
title(right_3, data{3,1}.name);


for t = 1 : step : length(A{1}.time)
    
    % draw map and agents
    subplot(3, 3, [1, 2, 4, 5, 7, 8])
    plot_agents(L, obst_x, obst_y, selected_A, A, G, eta_0, t); 
    hold on

    % moving window definition
    ll = t - window;
    rl = t + window;
    if ll < 0 
        ll = 1;
    end
    if rl > length(data{3,1}.data)
        rl = length(data{3,1}.data);
    end
    
    % draw signals
    right_1_plot = plot(right_1, ll : rl, data{1,1}.data(ll : rl, 1), 'b');
    right_1_dot = plot(right_1, t, data{1,1}.data(t), 'rs');
    set(right_1_plot, 'YLimInclude', 'off'); 
    set(right_1_dot, 'YLimInclude', 'off'); 
    axis(right_1, [ll, rl, 0, 20])

    right_2_plot = plot(right_2, ll : rl, data{2,1}.data(ll : rl, 1), 'b');
    right_2_dot = plot(right_2, t, data{2,1}.data(t), 'rs');
    set(right_2_plot, 'YLimInclude', 'off'); 
    set(right_2_dot, 'YLimInclude', 'off'); 
    axis(right_2, [ll, rl, 0, 3])

    right_3_plot = plot(right_3, ll : rl, data{3,1}.data(ll : rl, 1), 'b');
    right_3_dot = plot(right_3, t, data{3,1}.data(t), 'rs');
    set(right_3_plot, 'YLimInclude', 'off'); 
    set(right_3_dot, 'YLimInclude', 'off'); 
    axis(right_3, [ll, rl, 0, 7])

    drawnow
    cla(left)
    delete(right_1_dot)
    delete(right_2_dot)
    delete(right_3_dot)
    
end

clear left right_1 right_2 right_3