close all
clear data
clear no_nan_data
clc

%% Add utilities folder
currentFolder = pwd;
currentFolder_splitted = string(strsplit(currentFolder,'/'));
projectFolder_index = find(strcmp(currentFolder_splitted,'thor'));
env_path = strjoin(currentFolder_splitted(1, 1:projectFolder_index),'/');
addpath(genpath(string(env_path) + '/utilities'))
addpath(genpath(string(env_path) + '/data'))

%% Load data
dataset_name = "Exp_1_run_1_elab";
load(dataset_name + '.mat');

%% Select agent
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

agent = 10;
selected_A = agent;

%% data_processing_w
% % No NaN data
% no_nan_data{1,1}.name = "d_g"; 
% no_nan_data{2,1}.name = "\theta_g";  
% no_nan_data{3,1}.name = "\omega"; 
% no_nan_data{4,1}.name = "d_{obs}"; 
% 
% for t = 1 : length(no_nan_A{agent}.time)
%     if t ~= 1 && no_nan_A{agent}.goals_seq(t) ~= no_nan_A{agent}.goals_seq(t-1)
%         no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t-1));
%     else
%         no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t));
%     end  
% end
% no_nan_data{2,1}.data(:,1) = no_nan_A{agent}.bearing(:);
% no_nan_data{3,1}.data(:,1) = no_nan_A{agent}.w(:);
% no_nan_data{4,1}.data(:,1) = no_nan_A{agent}.dobs(:);
% 
% % Data
% data{1,1}.name = "\theta_g";  
% data{2,1}.name = "\omega"; 
% data{3,1}.name = "d_{obs}"; 
% 
% data{1,1}.data(:,1) = A{agent}.bearing(:);
% data{2,1}.data(:,1) = A{agent}.w(:);
% data{3,1}.data(:,1) = A{agent}.dobs(:);


%% data_processing_vobs
% % No NaN data
% no_nan_data{1,1}.name = "d_g";  
% no_nan_data{2,1}.name = "v";
% no_nan_data{3,1}.name = "v_obs"; 
% 
% for t = 1 : length(no_nan_A{agent}.time)
%     if t ~= 1 && no_nan_A{agent}.goals_seq(t) ~= no_nan_A{agent}.goals_seq(t-1)
%         no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t-1));
%     else
%         no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t));
%     end  
% end
% no_nan_data{2,1}.data(:,1) = no_nan_A{agent}.v(:);
% no_nan_data{3,1}.data(:,1) = no_nan_A{agent}.vobs(:); 
% 
% % Data
% data{1,1}.name = "d_g";
% data{2,1}.name = "v";
% data{3,1}.name = "v_obs"; 
% 
% for t = 1 : length(A{agent}.time)
%     if t ~= 1 && A{agent}.goals_seq(t) ~= A{agent}.goals_seq(t-1)
%         data{1,1}.data(t,1) = A{agent}.d_a(t, A{agent}.goals_seq(t-1));
%     else
%         data{1,1}.data(t,1) = A{agent}.d_a(t, A{agent}.goals_seq(t));
%     end    
% end
% data{2,1}.data(:,1) = A{agent}.v(:);
% data{3,1}.data(:,1) = A{agent}.vobs(:); 

%% data_processing_dobs
% % No NaN data
% no_nan_data{1,1}.name = "d_g";  
% no_nan_data{2,1}.name = "v";
% no_nan_data{3,1}.name = "d_obs"; 
% 
% for t = 1 : length(no_nan_A{agent}.time)
%     if t ~= 1 && no_nan_A{agent}.goals_seq(t) ~= no_nan_A{agent}.goals_seq(t-1)
%         no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t-1));
%     else
%         no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t));
%     end  
% end
% no_nan_data{2,1}.data(:,1) = no_nan_A{agent}.v(:);
% % no_nan_data{3,1}.data(:,1) = no_nan_A{agent}.sum_dobs(:); 
% 
% %% Data
% data{1,1}.name = "d_g";
% data{2,1}.name = "v";
% data{3,1}.name = "d_obs"; 
% 
% for t = 1 : length(A{agent}.time)
%     if t ~= 1 && A{agent}.goals_seq(t) ~= A{agent}.goals_seq(t-1)
%         data{1,1}.data(t,1) = A{agent}.d_a(t, A{agent}.goals_seq(t-1));
%     else
%         data{1,1}.data(t,1) = A{agent}.d_a(t, A{agent}.goals_seq(t));
%     end    
% end
% data{2,1}.data(:,1) = A{agent}.v(:);
% data{3,1}.data(:,1) = A{agent}.sum_dobs(:); 

%% data_processing_risk
% No NaN data
no_nan_data{1,1}.name = "d_g";  
no_nan_data{2,1}.name = "v";
no_nan_data{3,1}.name = "risk"; 

for t = 1 : length(no_nan_A{agent}.time)
    if t ~= 1 && no_nan_A{agent}.goals_seq(t) ~= no_nan_A{agent}.goals_seq(t-1)
        no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t-1));
    else
        no_nan_data{1,1}.data(t,1) = no_nan_A{agent}.d_a(t, no_nan_A{agent}.goals_seq(t));
    end  
end
no_nan_data{2,1}.data(:,1) = no_nan_A{agent}.v(:);
no_nan_data{3,1}.data(:,1) = no_nan_A{agent}.risk(:); 

% Data
data{1,1}.name = "d_g";
data{2,1}.name = "v";
data{3,1}.name = "risk"; 

for t = 1 : length(A{agent}.time)
    if t ~= 1 && A{agent}.goals_seq(t) ~= A{agent}.goals_seq(t-1)
        data{1,1}.data(t,1) = A{agent}.d_a(t, A{agent}.goals_seq(t-1));
    else
        data{1,1}.data(t,1) = A{agent}.d_a(t, A{agent}.goals_seq(t));
    end    
end
data{2,1}.data(:,1) = A{agent}.v(:);
data{3,1}.data(:,1) = A{agent}.risk(:);

end_fnc;