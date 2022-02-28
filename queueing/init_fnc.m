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
Ka = 3.5;

% Repulsive field
Kr = 5;
eta_0 = 1.5;

% Total field
Kv = 0.2;
Kw = 3;

%% Init data definition
DT = 0.1;
L = 1.25;
Simulation_time = 150;
tout = 0 : DT : Simulation_time;
dist_thres = 0.01;
dist_thres_requeueing = 0.1;
saturation_op = true;
max_v = 1.75;
task_op = true;
max_t = 15;
environment;

%% Noise definition
noise;

%% Agent definition
n_agent = 11;

% Goal
G = {};
for g = 1 : length(Goals_h)
    goal = Agent(g, 'k', ...
                 Ka, 0, 0, ...
                 Goals_h(g,1), Goals_h(g,2), 0, ...
                 tout, 0);
    G{g,1} = goal;
    clear goal
end

% Human
U = {};
n_h = 5;

for i = 1 : n_h
    u = Unicycle(i+length(G), 'b', ...
                  0, Kr, eta_0, ...
                  G{i}.x(1), G{i}.y(1), 0, ...
                  tout, Rep_force.VORTEX, n_agent, L, ...
                  saturation_op, max_v, task_op, Kv, Kw);
    u.set_goal(G{i}, 1)

    U{i,1} = u; 
end

% %% Obstacle definition
% for i = 1 : n_h
%     human_array = [U{:}];
%     human_array(human_array == U{i}) = [];
%     U{i}.set_obs(human_array,1)
% end

%% Initial condition
diff_down = false;
g_reached = false;
d_index = 5;
i_requeueing = -1;
requeueing = false;

%% DATA
data{1,1}.name = 'v_{queue}';
data{2,1}.name = 'theta';

