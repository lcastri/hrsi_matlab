function plot_map(obst_x,obst_y,exp_id)
%plot_map: plot THOR map
% - param obst_x: (array) parameter to draw the map
% - param obst_y: (array) parameter to draw the map
% - param exp_id: 1

plot(obst_x{exp_id}(1:200:end), obst_y{exp_id}(1:200:end),'.','Color', [0.3,0.3,0.3])
axis equal

end