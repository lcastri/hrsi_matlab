%% Progress bar
hw = waitbar(0,'data processing...');
counter = 1;
tot = length(cell2mat(keys(H))) * 3;

%% Time
for id = cell2mat(keys(H))
    % progress bar handling
    waitbar(counter/tot, hw, sprintf('Time generation: %d %%', floor(counter/tot*100)));

    h = H(id);
    h.time = (0 : DT : (length(h.x) - 1) * DT);
    H(id) = h;
    counter = counter + 1;
end
clear id h

%% Goal sequence
for id = cell2mat(keys(H))
    % progress bar handling
    waitbar(counter/tot, hw, sprintf('Goal sequence generation: %d %%', floor(counter/tot*100)));

    h = H(id);
    G_seq = {};
    for t = 1 : length(h.time)
        for g = 1 : length(G)
            if (distance(G{g}.x, G{g}.y, h.x(t), h.y(t)) < G{g}.r) && (isempty(G_seq) || G_seq{end}.id ~= G{g}.id)
                G_seq{end+1, 1} = G{g};
            end
        end
    end
    h.goals = G_seq;
    H(id) = h;
    counter = counter + 1;
end
clear G_seq id t g h

%% Distance and theta
for id = cell2mat(keys(H))
    % progress bar handling
    waitbar(counter/tot, hw, sprintf('Distance and Theta generation: %d %%', floor(counter/tot*100)));
    
    theta_gh = [];
    d = [];
    g_seq = [];
    g = 1;
    
    h = H(id);
    if ~isempty(h.goals)
        g_changed = true;
        d(1) = distance(h.goals{g}.x, h.goals{g}.y, h.x(1), h.y(1));
        g_seq(1) = h.goals{g}.id;
        
        for t = 2 : length(h.time)
            if ~g_changed && d(t-1) < h.goals{g}.r && (g ~= length(h.goals))
            	g = g + 1; 
                g_changed = true;
            else
                g_changed = false;
            end
            
            % Goal sequence over time
            g_seq(t) = h.goals{g}.id;

            % bearing
            theta_gh(t) = wrapToPi(atan2(h.goals{g}.y - h.y(t), h.goals{g}.x - h.x(t)));
%             theta_gh(t) = wrapTo2Pi(atan2(h.goals{g}.y - h.y(t), h.goals{g}.x - h.x(t)));

            % Distance
            if ~g_changed
                d(t) = distance(h.goals{g}.x, h.goals{g}.y, h.x(t), h.y(t));
            else
                d(t) = d(t-1);
            end
        end
    end
    h.theta_gh = theta_gh;
    h.d = d;
    h.goals_seq = g_seq;
    
    H(id) = h;
    counter = counter + 1;
end
clear id d g_seq g t ...
      theta_gh g_changed

close(hw)
clear tot counter hw
  
