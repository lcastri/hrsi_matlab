function create_parameters(path)
    fileID = fopen(path + '/parameters.txt', 'w');
    fprintf(fileID, "alpha = 0.05\n");
    fprintf(fileID, "n lag = 1\n");
    fprintf(fileID, "ci test = GPDC\n");
    fprintf(fileID, "subsampling option = False\n");
end

