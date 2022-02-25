close all
figure

%% VIDEO
answer = questdlg('Do you want to make a video?', ...
         'Waiting', ...
         'Yes','No','');
switch answer
    case 'Yes'
        makeVideo = true;
        formatOut = 'dd-mm-yyyy_HH:MM:SS';
        FileName = string(datestr(now,formatOut)) + '.avi';
        if ~exist('Video', 'dir')
            mkdir('Video')
        end
        video = VideoWriter('Video/Path.avi');
        open(video)
        ax = gca();
    otherwise
        makeVideo = false;
        video = nan;
end

step = 25;
for t = 1 : step : length(A{1}.time)
   plot_situation(makeVideo, video, L, obst_x, obst_y, selected_A, A, G, t)
end

if makeVideo
    close(video)
end
close
clear g h t circleout
