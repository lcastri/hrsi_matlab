clear all
close all
clc

hw = waitbar(0,'Reading csv...');
T = readtable('atc-20121114.csv');

%% Init
H = containers.Map('KeyType','double', 'ValueType','any');
for r = 1 : height(T)
    waitbar(r/height(T), hw, sprintf('Progress: %d %%', floor(r/height(T)*100)));

    id = table2array(T(r,2));
    if isKey(H, id)
        h = H(id);
        h.x(end+1) = table2array(T(r,3));
        h.y(end+1) = table2array(T(r,4));
        h.z(end+1) = table2array(T(r,5));
        h.v(end+1) = table2array(T(r,6));
        h.aom(end+1) = table2array(T(r,7));
        h.fa(end+1) = table2array(T(r,8));
    else
        h.x = table2array(T(r,3));
        h.y = table2array(T(r,4));
        h.z = table2array(T(r,5));
        h.v = table2array(T(r,6));
        h.aom = table2array(T(r,7));
        h.fa = table2array(T(r,8));
    end
    H(id) = h;
    clear h
end
hw = waitbar(100,'Saving mat...');
save('dataset', 'H')
close(hw)