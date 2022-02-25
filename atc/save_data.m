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
        
        ex_path = '/home/luca/Git/CausalInference/simulation/' + FileName;
        if ~exist(ex_path, 'dir')
            mkdir(ex_path)
        end
        %% save .mat
        save(ex_path + '/data')

        %% save .csv
        T = table(H(selected_id).theta_gh', H(selected_id).d', abs(H(selected_id).v/1000)');
        T.Properties.VariableNames = {'theta_gh', 'Dgh', 'V_h'};
        writetable(T, ex_path + '/data.csv')
        clear T FileName
        
        %% README creation
        create_readme;
end