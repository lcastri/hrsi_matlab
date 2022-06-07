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
Ka = 4;

% Repulsive field
Kr = 6;
eta_0 = 2.5;

% Total field
Kv = 0.2;
Kw = 4;

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
% Goal
Gh = {};
for g = 1 : length(Goals_h)
    goal = Agent(g, 'k', ...
                 Ka, 0, 0, ...
                 Goals_h(g,1), Goals_h(g,2), 0, ...
                 tout, 0);
    Gh{g,1} = goal;
    clear goal
end

G = Gh;

% Human/Robot
U = {};
n_a = 4;

n_agent = length(Goals_h) + n_a;

h = Unicycle(1+length(G), 'r', ...
             0, Kr, eta_0, ...
             Gh{1}.x(1), Gh{1}.y(1), 0, ...
             tout, Rep_force.VORTEX, n_agent, L, ...
             saturation_op, max_v, task_op, Kv, Kw);
h.set_goal(Gh{1}, 1)
U{1,1} = h; 
         
for obs = 2 : n_a
    gx = Gh{obs}.x(1);
    gy = Gh{obs}.y(1);
    sat_v = 0.75;
    r = Unicycle(obs+length(G), 'k', ...
                 0, Kr, eta_0, ...
                 gx, gy, 0, ...
                 tout, Rep_force.REPULSIVE, n_agent, L, ...
                 saturation_op, sat_v, task_op, Kv, Kw);

    r.set_goal(Gh{obs}, 1)
    U{obs,1} = r; 
end
clear r
%% Obstacle definition
h.set_obs([U{2:end}],1)

%% DATA
data{1,1}.data = [];
data{2,1}.data = [];
data{3,1}.data = [];
data{1,1}.name = "d_g";
data{2,1}.name = "v";  
data{3,1}.name = "risk";  

theta_to_change = false;