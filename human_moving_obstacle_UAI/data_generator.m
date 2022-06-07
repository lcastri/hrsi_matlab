clear df
S = [G; U];

for i = 1 : 2 : length(S)*2
    df{i,1}.name = 'x' + string(ceil(i/2));
    df{i+1,1}.name = 'y' + string(ceil(i/2));
end

for i = 1 : 2 : length(S)*2
    df{i,1}.data(:,1) = S{ceil(i/2)}.x;
    df{i+1,1}.data(:,1) = S{ceil(i/2)}.y;
end

% dt handling
last_column = length(df)+1;
extra_column = nan(length(tout),1);
extra_column(1,1) = DT;
df{last_column,1}.name = "DT";
df{last_column,1}.data(:,1) = extra_column;

% static agents handling
last_column = length(df)+1;
extra_column = nan(length(tout),1);
extra_column(1,1) = length(G);
df{last_column,1}.name = "static";
df{last_column,1}.data(:,1) = extra_column;

T = table;
for i = 1 : length(df)
    column_name = df{i,1}.name;
    T.(column_name) = df{i,1}.data;
end
writetable(T, 'data.csv')