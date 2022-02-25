%% PLOT Goals
figure
plot(H(selected_id).x, H(selected_id).y, 'Color', 'b');
hold on
grid on
for g = 1 : length(G)
    circle(G{g}.x, G{g}.y, G{g}.r*1000, G{g}.name, 'g');
    hold on
end
clear g
axis(map_axis)


%% PLOT
figure
if ~isempty(H(selected_id).goals_seq)
    subplot(4,1,1);
    plot(H(selected_id).time, H(selected_id).goals_seq, 'Color', 'b');
    ylabel("G")
    grid on
end
if ~isempty(H(selected_id).theta_gh)
    subplot(4,1,2);
    plot(H(selected_id).time, H(selected_id).theta_gh, 'Color', 'b');
    ylabel("\theta_{GH} [rad]")
    grid on
end
if ~isempty(H(selected_id).d)
    subplot(4,1,3);
    plot(H(selected_id).time, H(selected_id).d, 'Color', 'b');
    ylabel("D_{GH} [m]")
    grid on
end
if ~isempty(H(selected_id).v)
    subplot(4,1,4);
    plot(H(selected_id).time, H(selected_id).v/1000, 'Color', 'b');
    ylabel("vel_H [m/s]")
    grid on
end
xlabel("time [s]")