%% create README.txt
fileID = fopen(ex_path + '/README.txt', 'w');
t = now;
d = datetime(t,'ConvertFrom','datenum');
fprintf(fileID, "Simulation created on " + string(d) + "\n");
fprintf(fileID, "Scenario: " + dataset_name + "\n");
fprintf(fileID, "\n");

fprintf(fileID, "Agents considered:\n");
for a = selected_A
    fprintf(fileID, A{a}.name + "\n");
end
fprintf(fileID, "\n");

fprintf(fileID, "Simulation parameters:\n");
fprintf(fileID, "- sampling time [s]: %f\n", DT);

fclose(fileID);