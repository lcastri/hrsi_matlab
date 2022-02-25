
%% Goal sequence
for i = 1 : length(A)
    G_seq = {};
    for t = 1 : length(A{i}.time)
        for g = 1 : length(G)
            if (distance(G{g}.x, G{g}.y, A{i}.x(t), A{i}.y(t)) < G{g}.r) && (isempty(G_seq) || G_seq{end}.id ~= G{g}.id)
                G_seq{end+1, 1} = G{g};
            end
        end
    end
    A{i}.goals = G_seq;
end
clear G_seq i t g


%% Initialization
for i = 1 : length(A)
    A{i}.v = NaN(length(A{i}.x), 1);
    A{i}.w = NaN(length(A{i}.x), 1);
    A{i}.theta = NaN(length(A{i}.x), 1);
    A{i}.theta_a = NaN(length(A{i}.x), length(G) + length(A));
    A{i}.d_a = NaN(length(A{i}.x), length(G) + length(A));
    A{i}.goals_seq = NaN(length(A{i}.x), 1);
    A{i}.g_changed = NaN(length(A{i}.x), 1);
    A{i}.risk = NaN(length(A{i}.x), 1);
    A{i}.dobs = NaN(length(A{i}.x), 1);
    A{i}.vobs = NaN(length(A{i}.x), 1);
    A{i}.eta_dobs = NaN(length(A{i}.x), 1);
    A{i}.interaction = zeros(length(A{i}.x), length(G) + length(A));
    A{i}.bearing = NaN(length(A{i}.x), 1);
    A{i}.vrel = NaN(length(A{i}.x), 1);


    obs = 1 : length(A);
    obs = obs(obs~=i);
    A{i}.obs = obs;
    A{i}.g = 1;
    if ~isempty(A{i}.goals)
        A{i}.v(1) = 0;
        A{i}.w(1) = 0;
        A{i}.g_changed(1) = true;
        A{i}.goals_seq(1) = A{i}.goals{A{i}.g}.id;
        A{i}.d_a(1, A{i}.goals_seq(1)) = distance(A{i}.goals{A{i}.g}.x, A{i}.goals{A{i}.g}.y, A{i}.x(1), A{i}.y(1));
        A{i}.risk(1) = 0;
        A{i}.dobs(1) = 0;
        A{i}.vobs(1) = 0;
        A{i}.eta_dobs(1) = 0;
        A{i}.bearing(1) = 0;

    end
end

%% System
for t = 2 : length(A{i}.time)
    for i = 1 : length(A)
        if ~isempty(A{i}.goals)
            A{i}.goals_seq(t) = A{i}.goals{A{i}.g}.id;
            A{i}.g_changed(t) = A{i}.goals_seq(t) ~= A{i}.goals_seq(t-1);
            if ~isnan(A{i}.x(t))

                % Goal sequence
                if ~A{i}.g_changed(t-1) && A{i}.d_a(t-1, A{i}.goals_seq(t-1)) < A{i}.goals{A{i}.g}.r && (A{i}.g ~= length(A{i}.goals))
                    A{i}.g = A{i}.g + 1;
                end
                A{i}.goals_seq(t) = A{i}.goals{A{i}.g}.id;
                A{i}.g_changed(t) = A{i}.goals_seq(t) ~= A{i}.goals_seq(t-1);

                % Velocity
                disp_x = A{i}.x(t) - A{i}.x(t-1);
                disp_y = A{i}.y(t) - A{i}.y(t-1);
                if ~A{i}.g_changed(t)
                    A{i}.v(t) = sqrt(disp_x^2 + disp_y^2)*((1/1000)/DT);
                else
                    A{i}.v(t) = A{i}.v(t-1)*((1/1000)/DT);
                end

                % Theta
                A{i}.theta(t) = atan2(disp_y, disp_x);

                % Omega
                A{i}.w(t-1) = A{i}.theta(t) - A{i}.theta(t-1);

                % Bearing g
                A{i}.theta_a(t, A{i}.goals_seq(t)) = wrapToPi(atan2(A{i}.goals{A{i}.g}.y - A{i}.y(t), A{i}.goals{A{i}.g}.x - A{i}.x(t)));

                % Bearing obs
                for o = A{i}.obs
                    A{i}.theta_a(t, length(G) + o) = wrapToPi(atan2(A{i}.y(t) - A{o}.y(t), A{i}.x(t) - A{o}.x(t)));
                end

                % Distance g
                if ~A{i}.g_changed(t)
                    A{i}.d_a(t, A{i}.goals_seq(t)) = distance(A{i}.goals{A{i}.g}.x, A{i}.goals{A{i}.g}.y, A{i}.x(t), A{i}.y(t));
                else
                    A{i}.d_a(t, A{i}.goals_seq(t-1)) = A{i}.d_a(t-1, A{i}.goals_seq(t-1));
                end

                % Distance obs and risk evaluation
                for o = A{i}.obs
                    A{i}.d_a(t, length(G) + o) = distance(A{o}.x(t), A{o}.y(t), A{i}.x(t), A{i}.y(t));
                    if A{i}.d_a(t, length(G) + o) < eta_0
                        A{i}.interaction(t, length(G) + o) = 1;
                    end
                end
                A{i}.risk(t) = exp(A{i}.v(t-1));
                obs = get_closest_obs(A, G, i, t);
                if ~isnan(obs) && A{i}.interaction(t, length(G) + obs)
                    [cone, collision, r] = cone_building(A, i, obs, eta_0, t, DT);
%                     if sum(isnan(cone), 'all') == 0 && i == 10
%                         plot_cone(obst_x, obst_y, i, obs, A, G, cone, collision, t)
%                     end
                    A{i}.risk(t) = A{i}.risk(t) + exp(r);                   
                end
            end
        end
    end
%     plot_situation(false, 0, L, obst_x, obst_y, selected_A, A, G, t)
end

clear i t disp_x disp_y

