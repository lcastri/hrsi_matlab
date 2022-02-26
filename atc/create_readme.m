%% create README.txt
fileID = fopen(FileName + '/README.txt', 'w');
t = now;
d = datetime(t,'ConvertFrom','datenum');
fprintf(fileID, "Simulation created on " + string(d) + "\n");
fprintf(fileID, "\n");

fprintf(fileID, "Agents considered:\n");
fprintf(fileID, selected_id + "\n");
fprintf(fileID, "\n");


fprintf(fileID, "Simulation parameters:\n");
fprintf(fileID, "- sampling time [s]: %f\n", DT);

fclose(fileID);