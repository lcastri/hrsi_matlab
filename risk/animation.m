% close all

% %% VIDEO
% answer = questdlg('Do you want to make a video?', ...
%          'Waiting', ...
%          'Yes','No','');
% switch answer
%     case 'Yes'
%         makeVideo = true;
%         if ~exist('video', 'dir')
%             mkdir('video')
%         end
%         video = VideoWriter('video/simulation.avi');
%         video.FrameRate = 50;
%         video.Quality = 85;
%         open(video)
%         ax = gca();
%     otherwise
%         makeVideo = false;
%         video = nan;
% end

%% PLOT
step = 3; % to change to speed up the video

for t = 1 : step : length(tout)
    plot_situation_wGrid(false, 0, r.id, [G;U], t, axis_def)
    % plot_situation_wGrid(makeVideo, video, r.id, [G;U], t, axis_def)

end

% if makeVideo
%     close(video)
% end