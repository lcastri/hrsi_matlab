function save_csv(path, data)
    T = table;
    for i = 1 : length(data)
        column_name = data{i,1}.name;
        T.(column_name) = data{i,1}.data;
    end
    writetable(T, path + '/data.csv')
end

