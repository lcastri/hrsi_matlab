function plot_agents(L, obst_x, obst_y, selected_A, A, G, eta_0, t)     
%plot_agents: plot agents in A
% - param L: (float) length orientation arrow
% - param obst_x: (array) parameter to draw the map
% - param obst_y: (array) parameter to draw the map
% - param selected_A: (int) index selected agent
% - param A: (struct) agents struct
% - param G: (struct) goals struct
% - param eta_0: (float) obstacle minimum distance
% - param t: (int) time step

    for a = 1 : length(A)
        c = 'k';
        if a == selected_A
            c = 'r';
        end
        % position
        plot(A{a}.x(t), A{a}.y(t), '.', 'MarkerSize', 20, 'Color', c)
        hold on
        % orientation
        quiver(A{a}.x(t), A{a}.y(t), L*cos(A{a}.theta(t)), L*sin(A{a}.theta(t)), 0, 'Color', c, 'MaxHeadSize', 1);
        hold on
        % risk area
        if a == selected_A
            circle(A{a}.x(t), A{a}.y(t), eta_0*1000, "", 'm');
        end
        
        if a == selected_A
            % bearing goal
            line([A{a}.x(t) A{a}.x(t) + L*cos(A{a}.theta_a(t, A{a}.goals_seq(t)))], [A{a}.y(t) A{a}.y(t) + L*sin(A{a}.theta_a(t, A{a}.goals_seq(t)))], 'Color', c);
            hold on
            for g = 1 : length(G)
                if g ~= A{a}.goals_seq(t)
                    circle(G{g}.x, G{g}.y, G{g}.r*1000, G{g}.name, 'g');
                else
                    circle(G{g}.x, G{g}.y, G{g}.r*1000, G{g}.name, c);
                end
                hold on
            end    
        end
        text(A{a}.x(t)+300, A{a}.y(t), string(A{a}.id - length(G)))

    end
    % map
    plot_map(obst_x, obst_y,1)
    hold on
    
    grid on
    title('Environment')

    ylim=get(gca,'ylim');
    xlim=get(gca,'xlim');
    text(xlim(1), ylim(2) + 1000, "Time : " + string(t) + "/" + string(length(A{1}.x)))