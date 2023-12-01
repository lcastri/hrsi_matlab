clear all
close all
clc

%% Add utilities folder
currentFolder = pwd;
currentFolder_splitted = string(strsplit(currentFolder, '/'));
projectFolder_index = find(strcmp(currentFolder_splitted, 'hrsi_matlab'));
env_path = strjoin(currentFolder_splitted(1, 1:projectFolder_index), '/');
addpath(genpath(env_path + '/utilities'))
addpath(genpath(env_path + '/classes'))

%% Virtual potential field parameters
% Attractive field
Ka = 2;

% Total field
Kv = 0.2;
Kw = 3;

%% Init data definition
DT = 0.1;
L = 1.25;
desired_ts_length = 2048;
simulation_time = desired_ts_length*0.1;
tout = 0 : DT : simulation_time-DT;
dist_thres = 0.3;
sat_op = true;
max_v = 1.75;
task_op = false;
max_t = 15;
environment;

%% Noise definition
% noise;
apply_noise = true;
mu = 0;
sigma = 0.05;

%% Goals
G = {};
g1 = Agent(1, 'k', ...
           Ka, 0, 0, ...
           1, 4, 0, ...
           tout, 0);
G{1,1} = g1;

g2 = Agent(2, 'k', ...
           Ka, 0, 0, ...
           -9.4, 0, 0, ...
           tout, 0);
G{2,1} = g2;

g3 = Agent(3, 'k', ...
           Ka, 0, 0, ...
           -1, -4, 0, ...
           tout, 0);
G{3,1} = g3;

g4 = Agent(4, 'k', ...
           Ka, 0, 0, ...
           9.4, -4, 0, ...
           tout, 0);
G{4,1} = g4;

g5 = Agent(5, 'k', ...
           Ka, 0, 0, ...
           9.4, 4.2, 0, ...
           tout, 0);
G{5,1} = g5;


%% Agent definition
n_agent = size(G,1) + 1;
U = {};
u1 = Unicycle(size(G,1) + 1, 'r', ...
              0, 0, 0, ...
              g1.x(1), g1.y(1), -pi/2, ...
              tout, 0, n_agent, L, ...
              sat_op, max_v, task_op, Kv, Kw);
u1.set_goal(g1, 1)

U{1,1} = u1;

%% DATA
data{1,1}.name = 'theta_g';
data{2,1}.name = 'd_g';
data{3,1}.name = 'v';

