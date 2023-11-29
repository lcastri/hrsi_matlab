close all

%% Graphs
generate_graph(data);

%% Export data
answer = questdlg('Save results?', ...
         'Waiting', ...
         'Yes','No','');
switch answer
    case 'Yes'
        prompt = {'Enter file name:', 'Description:'};
        dlgtitle = 'Input';
        dims = [1 35; 1 35];
        insert_data = string(inputdlg(prompt,dlgtitle,dims));
        FileName = string(insert_data(1));
        description = string(insert_data(2));
        if ~exist(FileName, 'dir')
            mkdir(FileName)
        end
        %% save .mat
        save(FileName + '/data')

        %% save .csv
        save_csv(FileName, data);

        %% README.txt creation
        create_readme;

        %% parameters.txt creation
        create_parameters(FileName);
end