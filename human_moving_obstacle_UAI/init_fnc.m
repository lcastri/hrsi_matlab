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
G = {};
for g = 1 : length(Goals_h)
    goal = Agent(g, 'k', ...
                 Ka, 0, 0, ...
                 Goals_h(g,1), Goals_h(g,2), 0, ...
                 tout, 0);
    G{g,1} = goal;
    clear goal
end

% Human/Robot
U = {};
n_a = 3;

n_agent = length(Goals_h) + n_a;
        
for obs = 1 : n_a
    gx = G{obs}.x(1);
    gy = G{obs}.y(1);
    r = Unicycle(obs+length(G), 'k', ...
                 0, Kr, eta_0, ...
                 gx, gy, 0, ...
                 tout, Rep_force.REPULSIVE, n_agent, L, ...
                 saturation_op, max_v, task_op, Kv, Kw);

    r.set_goal(G{obs}, 1)
    U{obs,1} = r;

end
clear r

%% Obstacle definition
for i = 1 : n_a
    agents = [U{:}];
    agents(agents == U{i}) = [];
    U{i}.set_obs(agents,1)
end

%% Places
available_places = 1 : length(Goals_h);
occupied_places = 1 : n_a;
available_places = setdiff(available_places, occupied_places);

%% DATA
data{1,1}.data = [];
data{2,1}.data = [];
data{3,1}.data = [];
data{1,1}.name = "d_g";
data{2,1}.name = "v";  
data{3,1}.name = "risk";  

theta_to_change = false;