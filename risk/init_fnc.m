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
simulation_time = 150;
tout = 0 : DT : simulation_time;
dist_thres = 0.1;
sat_op = true;
sat_v = 1;
max_v = 1.5;
task_op = false;
max_t = 5;
environment;

%% Noise definition
mu = 0;
sigma = 0.05; % [m]
apply_noise = true;

%% Agent definition
% Goal
Gh = {};
goal = Agent(1, 'm', ...
             Ka, 0, 0, ...
             Goals_h(1,1), Goals_h(1,2), 0, ...
             tout, 0, DT);
Gh{1,1} = goal;
clear goal

Gr = {};
for g = 2 : length(Goals_r) + 1
    goal = Agent(g, 'm', ...
                 Ka, 0, 0, ...
                 Goals_r(g-1, 1), Goals_r(g-1, 2), 0, ...
                 tout, 0, DT);
    Gr{g-1, 1} = goal;
    clear goal
end

G = [Gh; Gr];

% Human/Robot
U = {};
n_a = 2;

n_agent = 1 + length(Goals_r) + n_a;

h = Unicycle(1+length(G), 'b', ...
             0, Kr, eta_0, ...
             Gh{1}.x(1), Gh{1}.y(1), 0, ...
             tout, Rep_force.VORTEX, n_agent, L, ...
             sat_op, max_v, task_op, Kv, Kw, DT);
h.set_goal(Gh{1}, 1)
         
r = Unicycle(2+length(G), 'r', ...
             0, Kr, eta_0, ...
             Gr{1}.x(1), Gr{1}.y(1), 0, ...
             tout, Rep_force.VORTEX, n_agent, L, ...
             sat_op, sat_v, task_op, Kv, Kw, DT);
r.set_goal(Gr{1}, 1)

%% Obstacle definition
h.set_obs(r,1)
U{1,1} = h; 
U{2,1} = r; 

%% DATA
data{1,1}.data = [];
data{2,1}.data = [];
data{3,1}.data = [];
data{4,1}.data = [];
data{5,1}.data = [];
data{6,1}.data = [];

data{1,1}.name = "d_{rh}";
data{2,1}.name = "v_r";  
data{3,1}.name = "risk";
data{4,1}.name = "v_h";
data{5,1}.name = "\theta_{rh}";
data{6,1}.name = "d_{rg}";