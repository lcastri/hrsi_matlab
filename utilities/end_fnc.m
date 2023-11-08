close all

%% Graphs
generate_graph(data);

%% Export data
answer = questdlg('Save results?', ...
         'Waiting', ...
         'Yes','No','');
switch answer
    case 'Yes'
        prompt = {'Enter file name:'};
        dlgtitle = 'Input';
        dims = [1 35];
        FileName = string(inputdlg(prompt,dlgtitle,dims));

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