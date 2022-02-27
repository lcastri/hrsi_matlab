function [DT, data] = extract_data(dataset, n_goals, step)
%extract_data: extract x,y,DT data from a dataset.mat
% - param dataset: (.mat file) dataset.mat
% - param n_goals: (int) number of static agent
% - param step: (int) sub-sampling parameter (= 1 if we want all data)
% - return DT: (float) delta time dataset
% - return data: (struct) data extracted

    body_colors = [
        [0,0,0]
        [0,0,1]
        [0,1,0]
        [1.0,0.2,0.2]
        [1,1,0]
        [1,0,1]
        [0,1,1]
        [1,0.8,0]
        [0,0.6,1]
        [0.9,0,0]
        [0.5,0.5,0.5]
        [0.8,0.8,0.8]
        [0.1,0.1,0.1]];
    DT = 1/dataset.FrameRate;
    names = dataset.RigidBodies.Name;
    posH = dataset.RigidBodies.Positions(1:13,1:2,:);
    data = {};
    for i = 1 : size(posH,1)
        if i ~= 12
            h = squeeze(posH(i,:,:))';
            hs.id = i + n_goals;
            hs.name = names{1,i};
            hs.x = h(1 : step : end,1);
            hs.y = h(1 : step : end,2);
            hs.time = (0 : DT : (length(hs.x)-1)*DT)';
            hs.color = body_colors(i,:);
            data{end+1,1} = hs;
        end
    end
end

