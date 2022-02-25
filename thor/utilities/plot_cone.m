function plot_cone(obst_x, obst_y, a, obs, A, G, cone, risk, t)     
   
    % selected a
    % position
    plot(A{a}.x(t-1), A{a}.y(t-1), '.', 'MarkerSize', 20, 'Color', 'r')
    hold on
    quiver(A{a}.x(t-1), A{a}.y(t-1), A{a}.x(t) - A{a}.x(t-1), A{a}.y(t)-A{a}.y(t-1), 0, 'Color', 'r', 'MaxHeadSize', 1);
    hold on
    text(A{a}.x(t-1)+300, A{a}.y(t-1), string(A{a}.id - length(G)))
    hold on

    % obs
    % position
    plot(A{obs}.x(t-1), A{obs}.y(t-1), '.', 'MarkerSize', 20, 'Color', 'k')
    hold on
    quiver(A{obs}.x(t-1), A{obs}.y(t-1), A{obs}.x(t)-A{obs}.x(t-1), A{obs}.y(t)-A{obs}.y(t-1), 0, 'Color', 'k', 'MaxHeadSize', 1);
    hold on
    text(A{obs}.x(t-1)+300, A{obs}.y(t-1), string(A{obs}.id - length(G)))
    hold on

    % vobs shifted to a
    quiver(A{a}.x(t-1), A{a}.y(t-1), A{obs}.x(t)-A{obs}.x(t-1), A{obs}.y(t)-A{obs}.y(t-1), 0, 'Color', 'k', 'MaxHeadSize', 1);
    hold on
    % vrel
    Va = [A{a}.x(t) - A{a}.x(t-1);
          A{a}.y(t) - A{a}.y(t-1)];
    Vobs = [A{obs}.x(t) - A{obs}.x(t-1);
            A{obs}.y(t) - A{obs}.y(t-1)];
    Vrel = Va - Vobs;
    quiver(cone(1,1), cone(2,1), Vrel(1), Vrel(2), 0, 'Color', 'b', 'MaxHeadSize', 1);
    hold on

    % cone
    if risk
        c = 'r';
    else
        c = 'g';
    end
    coneplot = fill(cone(1,:), cone(2,:), c,'LineStyle','none');
    hold on
    set(coneplot,'facealpha',.5)

    % map
    plot_map(obst_x, obst_y,1)
    hold on
    
    grid on
    title('Environment')

    ylim=get(gca,'ylim');
    xlim=get(gca,'xlim');
    text(xlim(1), ylim(2) + 1000, "Time : " + string(t) + "/" + string(length(A{1}.x)))

    drawnow

    clf