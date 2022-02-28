close all

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

%% PLOT
step = 1; % to change to speed up the video

for t = 1 : step : length(tout)
    plot_situation(makeVideo, video, boundaries, [G;U], t, axis_def)
end

if makeVideo
    close(video)
end