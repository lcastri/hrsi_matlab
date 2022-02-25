figure

%% PLOT Trajectories
plot_map(obst_x, obst_y,1)
hold on
for a = selected_A
    plot(no_nan_A{a}.x, no_nan_A{a}.y, 'Color', no_nan_A{a}.color);
    hold on
end
grid on
clear a

%% PLOT Goals
for g = 1 : length(G)
    circle(G{g}.x, G{g}.y, G{g}.r*1000, G{g}.name, 'g');
    hold on
end
clear g

%% PLOT
n_plot = length(no_nan_data);
figure
for p = 1 : n_plot
    subplot(n_plot,1,p)
    plot(1:length(no_nan_data{p,1}.data), no_nan_data{p,1}.data)
    ylabel(no_nan_data{p,1}.name);
    xlim([0 inf])  
    grid on
end

n_plot = length(data);
figure
for p = 1 : n_plot
    subplot(n_plot,1,p)
    plot(1:length(data{p,1}.data), data{p,1}.data)
    ylabel(data{p,1}.name);
    xlim([0 inf])
    grid on
end
clear p
