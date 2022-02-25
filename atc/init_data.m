clear all
close all
clc

%% Loading data
load('dataset')

%% map
[xmin, xmax, ymin, ymax] = find_axis(H);
map_axis = [xmin, xmax, ymin, ymax];

%% goals definition
G1 = [46264, -20022];  % [mm]
G2 = [-14220, -9931];  % [mm]
G3 = [-10184, 22708];  % [mm]

Garray = [G1; G2; G3]; % [mm]
Rarray = [2; 2; 2]; % [m]

G = {};
for i = 1 : length(Garray)
    g.name = "G"+i;
    g.id = i;
    g.x = Garray(i,1);
    g.y = Garray(i,2);
    g.r = Rarray(i);
    G{i,1} = g;
end
clear g G1 G2 G3 Garray Rarray i

%% human selection
selected_id = 9360100; %longer
% id = 9335900; %shorter
% id = 9351500; %

%% processing and result
DT = 0.035; % [s]
data_processing;
generate_graph;
save_data;