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
        T = table(H(selected_id).theta_gh', H(selected_id).d', abs(H(selected_id).v/1000)');
        T.Properties.VariableNames = {'theta_gh', 'Dgh', 'V_h'};
        writetable(T, FileName + '/data.csv')
                
        %% README creation
        create_readme;
end