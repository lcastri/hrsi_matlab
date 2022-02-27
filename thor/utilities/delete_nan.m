function no_nan_data = delete_nan(data, DT)
%delete_nan: delete nan from data struct
% - param data: (struct) struct containing agents data with NaNs
% - param DT: (int) delta time
% - return no_nan_data: (struct) struct containing agents data without NaNs

    no_nan_data = {};
    for i = 1 : size(data,1)
        h = data{i};
        valid_indices = ~isnan(h.x);

        fn = fieldnames(h);
        for k=1:numel(fn)
            if length(h.(fn{k})) == length(data{i}.x) 
                h.(fn{k}) = h.(fn{k})(valid_indices,:);
            end
        end

        if ~isempty(h.g_changed) && sum(isnan(h.g_changed)) > 0
            h.g_changed(:,1) = fillmissing(h.g_changed(:,1), 'nearest');
        end
        if ~isempty(h.theta) && sum(isnan(h.theta)) > 0
            h.theta(:,1) = fillmissing(h.theta(:,1), 'nearest');
        end
        if ~isempty(h.bearing) && sum(isnan(h.bearing)) > 0
            h.bearing(:,1) = fillmissing(h.bearing(:,1), 'nearest');
        end
        if ~isempty(h.v) && sum(isnan(h.v)) > 0
            h.v(:,1) = fillmissing(h.v(:,1), 'nearest');
        end
        if ~isempty(h.w) && sum(isnan(h.w)) > 0
            h.w(:,1) = fillmissing(h.w(:,1), 'nearest');
        end
        if ~isempty(h.goals_seq) && sum(isnan(h.goals_seq)) > 0
            h.goals_seq(:,1) = fillmissing(h.goals_seq(:,1), 'nearest');
        end
        if ~isempty(h.d_a)
            for a = data{1,1}.id : size(h.d_a, 2)                  
                h.d_a(:,a) = fillmissing(h.d_a(:,a), 'nearest');
            end
        end
        if ~isempty(h.theta_a)
            for a = data{1,1}.id : size(h.theta_a, 2)
                h.theta_a(:,a) = fillmissing(h.theta_a(:,a), 'nearest');
            end
        end
        if ~isempty(h.risk) && sum(isnan(h.risk)) > 0
            h.risk(:,1) = fillmissing(h.risk(:,1), 'nearest');
        end
        if ~isempty(h.dobs) && sum(isnan(h.dobs)) > 0
            h.dobs(:,1) = fillmissing(h.dobs(:,1), 'nearest');
        end
        if ~isempty(h.eta_dobs) && sum(isnan(h.eta_dobs)) > 0
            h.eta_dobs(:,1) = fillmissing(h.eta_dobs(:,1), 'nearest');
        end
        if ~isempty(h.vobs) && sum(isnan(h.vobs)) > 0
            h.vobs(:,1) = fillmissing(h.vobs(:,1), 'nearest');
        end
        h.time = (0 : DT : (length(h.x)-1)*DT)';
        no_nan_data{i,1} = h;
    end
end

