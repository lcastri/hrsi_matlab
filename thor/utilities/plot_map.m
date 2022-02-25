function plot_map(obst_x,obst_y,exp_id)

plot(obst_x{exp_id}(1:200:end), obst_y{exp_id}(1:200:end),'.','Color', [0.3,0.3,0.3])
axis equal

end