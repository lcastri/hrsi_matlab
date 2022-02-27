function generate_graph(data)
%generate_graph: generate graphs of data
% - param data: (struct) data to plot

    n_plot = length(data);
    figure
    for p = 1 : n_plot
        subplot(n_plot,1,p)
        plot(1:length(data{p,1}.data), data{p,1}.data)
        ylabel(data{p,1}.name);
        grid on
    end
end

