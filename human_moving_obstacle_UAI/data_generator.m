S = [G; U];

for i = 1 : 2 : length(S)*2
    df{i,1}.name = 'x' + string(ceil(i/2));
    df{i+1,1}.name = 'y' + string(ceil(i/2));
end

for t = 1 : length(tout)
    for i = 1 : 2 : length(S)*2
        df{i,1}.data(t,1) = S{ceil(i/2)}.x(t);
        df{i+1,1}.data(t,1) = S{ceil(i/2)}.y(t);
    end
end

T = table;
for i = 1 : length(df)
    column_name = df{i,1}.name;
    T.(column_name) = df{i,1}.data;
end
writetable(T, 'data.csv')