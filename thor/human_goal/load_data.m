clear all
close all
clc

%% Add utilities folder
currentFolder = pwd;
currentFolder_splitted = string(strsplit(currentFolder,'/'));
projectFolder_index = find(strcmp(currentFolder_splitted,'thor'));
env_path = strjoin(currentFolder_splitted(1, 1:projectFolder_index),'/');
addpath(genpath(string(env_path) + '/utilities'))
addpath(genpath(string(env_path) + '/data'))

%% Progress bar
hw = waitbar(0,'Load dataset...');
counter = 1;
tot = 5;

%% Load dataset .mat
load('Exp_1_run_1.mat')

%% Goals definition
waitbar(counter/tot, hw, sprintf('Goals definition: %d %%', floor(counter/tot*100)));
goals_manager;
counter = counter + 1;

%% Init
waitbar(counter/tot, hw, sprintf('Extracting data: %d %%', floor(counter/tot*100)));
[DT, A] = extract_data(Experiment_1_run_1_0050, length(G));
counter = counter + 1;

%% Load maps
map{1} = imread('orebro_map.png');
map{1} = map{1}(:,:,1);
map{1} = flip(map{1});
map{1} = map{1}';
[obst_x{1},obst_y{1}] = find(map{1} == 0);
obst_x{1} = obst_x{1} * 10 - 11000;%7000;
obst_y{1} = obst_y{1} * 10 - 10000;%6500;
shuffle = randperm(length(obst_x{1}));
obst_x{1} = obst_x{1}(shuffle);
obst_y{1} = obst_y{1}(shuffle);

%% Select obj to plot
% h  | obj name
% 2  - H1
% 3  - H2
% 4  - H3
% 5  - H4
% 6  - H5
% 7  - H6
% 8  - H7
% 9  - H8
% 10 - H9
% 11 - H10
% 12 - Velodyne	
% 13 - Citi_1

% selected_A = [3,4,5,6,7,8,9,10,11];
L = 1000;
selected_A = [10];

%% DATA
data{1,1}.name = 'theta_{gh}';
data{2,1}.name = 'D_{gh}';
data{3,1}.name = 'v_h';

%% Data processing
waitbar(counter/tot, hw, sprintf('Data processing: %d %%', floor(counter/tot*100)));
data_processing;
counter = counter + 1;

waitbar(counter/tot, hw, sprintf('NaN handling: %d %%', floor(counter/tot*100)));
no_nan_A = delete_nan(A, DT);
counter = counter + 1;
close(hw)

data_handling;

end_fnc;

