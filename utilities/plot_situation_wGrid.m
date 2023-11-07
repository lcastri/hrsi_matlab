function plot_situation_wGrid(makeVideo, video, r_id, A, t, ax) 
%plot_situation_wGrid: plot scenario situation at time t
% - param makeVideo: (bool) record video bit
% - param video: video instance
% - param r_id: (int) robot id
% - param A: (struc) struct containing all agents
% - param t: (int) time step
% - param ax: (array) axis figure [xmin xmax ymin ymax]

    % % Define the grid size and cell resolution
    % grid_size = 8;  % 8m x 8m grid
    % cell_resolution = 1;  % 1m cell resolution
    % 
    % % Calculate the grid limits based on the center position
    % x_min = A{r_id}.x(t) - grid_size / 2;
    % x_max = A{r_id}.x(t) + grid_size / 2;
    % y_min = A{r_id}.y(t) - grid_size / 2;
    % y_max = A{r_id}.y(t) + grid_size / 2;
    % 
    % % Create a grid
    % [x, y] = meshgrid(x_min:cell_resolution:x_max, y_min:cell_resolution:y_max);
    % 
    % % Plot the grid
    % plot(x, y, 'Color', [0.6, 0.6, 0.6]);
    % hold on
    % plot(x', y', 'Color', [0.6, 0.6, 0.6]);
    % hold on

    % Calculate the row and column of the corresponding cell
    plot(A{r_id-1}.estim_x(t), A{r_id-1}.estim_y(t), '.', 'MarkerSize', 35, 'Color', 'c')
    hold on
    % row = round((A{r_id-1}.estim_y(t) - y_min) / cell_resolution) + 1;
    % col = round((A{r_id-1}.estim_x(t) - x_min) / cell_resolution) + 1;
    % if row > 0 && col > 0 && row < size(x,1) && col < size(x,2) && row < size(y,1) && col < size(y,2)
    %     rectangle('Position', [x(row, col), y(row, col), cell_resolution, cell_resolution], 'FaceColor', 'm');
    % end

    
    % draw agents
    for i = 1 : length(A)
        A{i}.draw(t)
    end

    % set axis
    axis(ax)

    grid on
    title('Environment')
    xlabel('[meters]');
    ylabel('[meters]');

    % draw time index top left
    ylim=get(gca,'ylim');
    xlim=get(gca,'xlim');
    text(xlim(1), ylim(2) + 1, "Time : " + string(t) + "/" + string(length(A{1}.x)))
    drawnow

    % to avoid problem with the figure initialisation
    if t == 1
        pause(0.5)
    end

    % get current frame for the video
    if makeVideo
        writeVideo(video, getframe(gca));
    end 
    
    % clear figure
    clf

