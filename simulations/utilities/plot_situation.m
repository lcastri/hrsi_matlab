function plot_situation(makeVideo, video, bounds, A, t, ax) 
%plot_situation: plot scenario situation at time t
% - param makeVideo: (bool) record video bit
% - param video: video instance
% - param bounds: (array) boundaries scenario
% - param A: (struc) struct containing all agents
% - param t: (int) time step
% - param ax: (array) axis figure [xmin xmax ymin ymax]

    % draw bounds
    line(bounds(:,1), bounds(:,2), 'Color', 'k')
    hold on

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
        pause(0.25)
    end

    % get current frame for the video
    if makeVideo
        writeVideo(video, getframe(gca));
    end 
    
    % clear figure
    clf

