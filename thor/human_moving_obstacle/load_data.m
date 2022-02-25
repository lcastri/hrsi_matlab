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
dataset_name = "Exp_1_run_1";
raw_data = load(dataset_name + '.mat');
D = struct2cell(raw_data);
D = D{1};

%% Goals definition
waitbar(counter/tot, hw, sprintf('Goals definition: %d %%', floor(counter/tot*100)));
goals_manager;
counter = counter + 1;

%% Init
waitbar(counter/tot, hw, sprintf('Extracting data: %d %%', floor(counter/tot*100)));
step = 10;
[DT, A] = extract_data(D, length(G), step);
DT = DT*step; %[s]
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

%% Useful parameters 
L = 1000; % [mm]
eta_0 = 1.50; % [m]

%% Data processing
waitbar(counter/tot, hw, sprintf('Data processing: %d %%', floor(counter/tot*100)));
data_processing_risk;
% data_processing_dobs;
% data_processing_vobs;
% data_processing_w;
counter = counter + 1;

waitbar(counter/tot, hw, sprintf('NaN handling: %d %%', floor(counter/tot*100)));
no_nan_A = delete_nan(A, DT);
counter = counter + 1;

%% Save data
waitbar(counter/tot, hw, sprintf('Complete: %d %%', floor(counter/tot*100)));
pause(1);
close(hw)

save(dataset_name + '_elab.mat')

