close all

%% Graphs
generate_graph;

%% Export data
answer = questdlg('Save results?', ...
         'Waiting', ...
         'Yes','No','');
switch answer
    case 'Yes'
        FileName = dataset_name + '_a' + string(selected_A);
        ex_path = '/home/luca/Git/CausalInference/simulation/' + FileName;
        if ~exist(ex_path, 'dir')
            mkdir(ex_path)
        end
        %% save .mat
        save(ex_path + '/data')
        
        %% save .csv
        save_csv(ex_path, no_nan_data);
        
        %% README.txt creation
        create_readme;
        
        %% parameters.txt creation
        create_parameters(ex_path);
end