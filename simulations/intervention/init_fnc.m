clear all
close all
clc

%% Add utilities folder
currentFolder = pwd;
currentFolder_splitted = string(strsplit(currentFolder,'/'));
projectFolder_index = find(strcmp(currentFolder_splitted,'simulations'));
env_path = strjoin(currentFolder_splitted(1, 1:projectFolder_index),'/');
addpath(genpath(env_path + '/utilities'))
addpath(genpath(env_path + '/classes'))

%% Virtual potential field parameters
% Attractive field
Ka = 2;

% Repulsive field
Kr = 5;
eta_0 = 1.25;

% Total field
Kv = 0.2;
Kw = 3;

%% Init data definition
DT = 0.1;
L = 1.25;
Simulation_time = 150;
tout = 0 : DT : Simulation_time;
dist_thres = 0.1;
saturation_op = true;
max_v = 1.75;
task_op = false;
max_t = 15;
environment;

%% Noise definition
noise;

%% Agent definition
n_agent = 4;

% Goal
G = {};
intervention_point = Agent(1, 'k', ...
                           Ka, 0, 0, ...
                           0, 0, 0, ...
                           tout, 0);
G{1,1} = intervention_point;

g2 = Agent(2, 'k', ...
           Ka, 0, 0, ...
           10, 10, 0, ...
           tout, 0);
G{2,1} = g2;

% Human
U = {};
u1 = Unicycle(3, 'r', ...
              0, 0, 0, ...
              intervention_point.x(1), intervention_point.y(1), 0, ...
              tout, 0, n_agent, L, ...
              saturation_op, max_v, task_op, Kv, Kw);
u1.set_goal(intervention_point, 1)
u1.range_g(1)

u2 = Unicycle(4, 'b', ...
              0, Kr, eta_0, ...
              g2.x(1), g2.y(1), 0, ...
              tout, Rep_force.VORTEX, n_agent, L, ...
              saturation_op, max_v, task_op, Kv, Kw);
u2.set_goal(g2, 1)
u1.set_obs(u2, 1)

U{1,1} = u1;
U{2,1} = u2;

%% DATA
data{1,1}.data = [];
data{2,1}.data = [];
data{3,1}.data = [];
data{1,1}.name = "v_2";
data{2,1}.name = "d_{g2}";  
data{3,1}.name = "v_1";


