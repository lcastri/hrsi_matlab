clc
close all
figure

%% VIDEO
answer = questdlg('Do you want to make a video?', ...
         'Waiting', ...
         'Yes','No','');
switch answer
    case 'Yes'
        makeVideo = true;
        if ~exist('video', 'dir')
            mkdir('video')
        end
        video = VideoWriter('video/simulation.avi');
        open(video)
        ax = gca();
    otherwise
        makeVideo = false;
        video = nan;
end

L = 2500;
h = H(selected_id);
for t = 1 : 15 : length(h.x)
    % goals
    for g = 1 : length(G)
        if G{g}.id == h.goals_seq(t)
            circle(G{g}.x, G{g}.y, G{g}.r*1000, G{g}.name, 'b');
        else
            circle(G{g}.x, G{g}.y, G{g}.r*1000, G{g}.name, 'g');
        end
        hold on
    end
    plot(h.x(t), h.y(t), '.', 'MarkerSize', 20, 'Color', 'r')
    hold on
    % orientation
    quiver(h.x(t), h.y(t), L*cos(h.aom(t)), L*sin(h.aom(t)), 0, 'Color', 'r', 'MaxHeadSize', 1);
    hold on
    line([h.x(t) h.x(t) + L*cos(h.theta_gh(t))], [h.y(t) h.y(t) + L*sin(h.theta_gh(t))], 'Color', 'b');
%     text(h.x(t) + 2000, h.y(t), string(h.theta_gh(t)))
    hold on
    axis(map_axis)
    grid on
    drawnow
    if makeVideo
        writeVideo(video, getframe(gca));
    end 
    clf
end
if makeVideo
    close(video)
end
close
