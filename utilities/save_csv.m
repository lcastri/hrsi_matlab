function save_csv(path, data)
%save_csv: save data as csv
% - param path: (string) path
% - param data: (struct) data to save

    T = table;
    for i = 1 : length(data)
        column_name = data{i,1}.name;
        T.(column_name) = data{i,1}.data;
    end
    writetable(T, path + '/data.csv')
end

