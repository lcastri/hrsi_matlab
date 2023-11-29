%% create README.txt
fileID = fopen(FileName + '/README.txt', 'w');
t = now;
d = datetime(t,'ConvertFrom','datenum');
fprintf(fileID, "Simulation created on " + string(d) + "\n");
fprintf(fileID, "\n");

fprintf(fileID, "Description:\n");
fprintf(fileID, description);
fprintf(fileID, "\n\n");

fprintf(fileID, "Virtual potential field parameters:\n");
fprintf(fileID, "- Ka : %f\n", Ka);
if exist('Kr','var') == 1
    fprintf(fileID, "- Kr : %f\n", Kr);
end
if exist('eta_0','var') == 1
    fprintf(fileID, "- eta_0 : %f\n", eta_0);
end
fprintf(fileID, "- Kv : %f\n", Kv);
fprintf(fileID, "- Kw : %f\n", Kw);
fprintf(fileID, "\n");

fprintf(fileID, "Noise definition:\n");
fprintf(fileID, "- mean : %f\n", mu);
fprintf(fileID, "- standard deviation : %f\n", sigma);
fprintf(fileID, "\n");

fprintf(fileID, "Simulation parameters:\n");
fprintf(fileID, "- sampling time [s]: %f\n", DT);
fprintf(fileID, "- simulation time [s] : %f\n", simulation_time);
fprintf(fileID, "- distance threshold [m]: %f\n", dist_thres);
fprintf(fileID, "\n");

fprintf(fileID, "Velocity saturation:\n");
fprintf(fileID, "- Active [True/False]: %s\n", string(sat_op));
fprintf(fileID, "- max velocity [m/s] : %f\n", max_v);
fprintf(fileID, "\n");

fprintf(fileID, "Task:\n");
fprintf(fileID, "- Active [True/False]: %s\n", string(task_op));
fprintf(fileID, "- max task duration [s] : %f\n", max_t);

fclose(fileID);

