clear all
close all
clc

%% Confidence level alpha
init_alpha = 0.05;
final_alpha = 0.001;
step_alpha = -0.001;
alpha_val = init_alpha : step_alpha : final_alpha;

%% Ground-truth structures
goal_ground_struct = [1 1 0; 
                      1 1 1; 
                      0 1 1];
interaction_ground_struct = [1 1 0; 
                             1 1 1; 
                             0 1 1];

%% THOR human-goal scenario
% thetag parents:
% name   | pvalue
% thetag | 0
% dg     | 0
% v      | 0.04
% dg parents:
% name   | pvalue
% dg     | 0
% thetag | 0
% v      | 0
% v parents:
% name   | pvalue
% v      | 0
% dg     | 0.033

thor_goal_struct = [1 1 1; 
                    1 1 1; 
                    0 1 1];
thor_goal_pval = [0 0 0.04; 
                  0 0 0; 
                  0 0.033 0];
thor_goal_shd = shd(goal_ground_struct, thor_goal_struct, thor_goal_pval, alpha_val);

%% ATC human-goal scenario
% thetag parents:
% name   | pvalue
% thetag | 0
% dg     | 0
% dg parents:
% name   | pvalue
% dg     | 0
% thetag | 0.02
% v      | 0.005
% v parents:
% name   | pvalue
% v      | 0
% dg     | 0.014

atc_goal_struct = [1 1 0; 
                   1 1 1;
                   0 1 1];
atc_goal_pval = [0 0 0; 
                 0.02 0 0.005; 
                 0 0.014 0];
atc_goal_shd = shd(goal_ground_struct, atc_goal_struct, atc_goal_pval, alpha_val);


%% THOR human-moving obstacles scenario
% dg parents:
% name   | pvalue
% dg     | 0
% v      | 0
% risk   | 0.023
% v parents:
% name   | pvalue
% v      | 0
% risk   | 0.002
% dg     | 0.01
% risk parents:
% name   | pvalue
% v      | 0
% risk   | 0
% dg     | 0.024

thor_interaction_struct = [1 1 1; 
                           1 1 1;
                           1 1 1];
thor_interaction_pval = [0 0 0.023;
                         0.01 0 0.002; 
                         0.024 0 0];
thor_interaction_shd = shd(interaction_ground_struct, thor_interaction_struct, thor_interaction_pval, alpha_val);
