clear all
close all
clc

%% Add utilities folder
currentFolder = pwd;
currentFolder_splitted = string(strsplit(currentFolder, '/'));
projectFolder_index = find(strcmp(currentFolder_splitted, 'hrsi'));
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
Simulation_time = 600;
tout = 0 : DT : Simulation_time;
dist_thres = 0.01;
sat_op = true;
max_v = 1.75;
task_op = true;
max_t = 15;
environment;

%% Noise definition
noise;

%% Goals
G = {};
g1 = Agent(1, 'k', ...
           Ka, 0, 0, ...
           1, 4, 0, ...
           tout, 0);
G{1,1} = g1;

g2 = Agent(2, 'k', ...
           Ka, 0, 0, ...
           -1, -4, 0, ...
           tout, 0);
G{2,1} = g2;

g3 = Agent(3, 'k', ...
           Ka, 0, 0, ...
           9.4, 4.2, 0, ...
           tout, 0);
G{3,1} = g3;

%% Agent definition
n_agent = 4;
U = {};
u1 = Unicycle(4, 'r', ...
              0, 0, 0, ...
              g1.x(1), g1.y(1), -pi/2, ...
              tout, 0, n_agent, L, ...
              sat_op, max_v, task_op, Kv, Kw);
u1.set_goal(g1, 1)

U{1,1} = u1;

%% DATA
data{1,1}.name = 'theta_{gh}';
data{2,1}.name = 'D_{gh}';
data{3,1}.name = 'v_h';

