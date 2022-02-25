classdef Unicycle < Agent

    properties
        Kv
        Kw
        d_a
        theta_a
        g_seq
        g
        g_changed
        interaction
        sat_op
        max_v
        task_op
        task
        obs
        L
        risk
    end
    
    methods
        function obj = Unicycle(id, color, Ka, Kr, eta_0, x, y, theta, tout, rep_force_type, n_agent, L, sat_op, max_v, task_op, Kv, Kw)
            obj@Agent(id, color, Ka, Kr, eta_0, x, y, theta, tout, rep_force_type);
            obj.x = zeros(length(tout),1);
            obj.y = zeros(length(tout),1);
            obj.theta = zeros(length(tout),1);
            obj.d_a = zeros(length(tout), n_agent);
            obj.theta_a = zeros(length(tout), n_agent);
            obj.g_seq = zeros(length(tout), 1);
            obj.g_changed = zeros(length(tout), 1);
            obj.interaction = zeros(length(tout), n_agent);
            obj.risk = zeros(length(tout), 1);
            
            obj.Kv = Kv;
            obj.Kw = Kw;
            obj.x(1) = x;
            obj.y(1) = y;
            obj.theta(1) = theta;
            obj.v(1) = 0;
            obj.w(1) = 0;
            obj.L = L;
            obj.sat_op = sat_op;
            obj.max_v = max_v;
            obj.task_op = task_op;
            obj.task = 0;

        end

        function draw(obj, t)
            
            % draw position
            plot(obj.x(t), obj.y(t), '.', 'MarkerSize', 35, 'Color', obj.color)
            hold on

            % draw id
            text(obj.x(t)+0.25, obj.y(t), string(obj.id), 'Color','red')
            hold on

            % draw orientation
            quiver(obj.x(t), obj.y(t), obj.L*cos(obj.theta(t)), obj.L*sin(obj.theta(t)), 0, 'Color', obj.color, 'MaxHeadSize', 1);
            hold on

            % draw goal bearing
            line([obj.x(t) obj.x(t) + obj.L*cos(obj.theta_a(t, obj.g_seq(t)))], [obj.y(t) obj.y(t) + obj.L*sin(obj.theta_a(t, obj.g_seq(t)))], 'Color', obj.color);

            % draw interactions
            for o = obj.obs
                if obj.interaction(t, o.id)
                    line([obj.x(t) o.x(t)], [obj.y(t) o.y(t)], 'Color', 'm');
                end
            end
        end
        
        function set_obs(obj, obs, t)
            obj.obs = obs;
            if t == 1
                obj.measure_obs(t)
            end
        end
        

        function measure_risk(obj, t, varargin)
            minArgs = 2;
            noise_risk = 0;
            if nargin > minArgs
                noise_risk = varargin{1};
            end
            % TODO
            % velocity obstacle strategy and risk evaluation based on
            % relative velocity between selected agent and the closest
            % obstacle at time t

        end

        function measure_obs(obj, t, varargin)
            minArgs = 2;
            noise_range = 0;
            noise_bearing = 0;
            if nargin > minArgs
                noise_range = varargin{1};
                noise_bearing = varargin{2};
            end
            for o = obj.obs
                obj.range_obs(t, o, noise_range);
                obj.bearing_obs(t, o, noise_bearing);
            end
        end

        function measure_g(obj, t, varargin)
            minArgs = 2;
            noise_range = 0;
            noise_bearing = 0;
            if nargin > minArgs
                noise_range = varargin{1};
                noise_bearing = varargin{2};
            end
            obj.range_g(t, noise_range);
            obj.bearing_g(t,noise_bearing);
        end

        function set_goal(obj, goal, t)
            obj.g_seq(t) = goal.id;
            obj.g = goal;
            if t == 1
                obj.measure_g(t)
            end
        end
        
        function range_g(obj, t, varargin)
            minArgs = 2;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.d_a(t, obj.g_seq(t)) = sqrt((obj.g.x(t) - obj.x(t))^2 + (obj.g.y(t) - obj.y(t))^2) + noise;
        end

        function bearing_g(obj, t, varargin)
            minArgs = 2;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.theta_a(t, obj.g_seq(t)) = atan2(obj.g.y(t) - obj.y(t), obj.g.x(t) - obj.x(t)) + noise;
        end

        function range_obs(obj, t, obs, varargin)
            minArgs = 3;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.d_a(t, obs.id) = sqrt((obj.x(t) - obs.x(t))^2 + (obj.y(t) - obs.y(t))^2) + noise;
        end

        function bearing_obs(obj, t, obs, varargin)
            minArgs = 3;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            obj.theta_a(t, obs.id) = atan2(obj.y(t) - obs.y(t), obj.x(t) - obs.x(t)) + noise;
        end

        function compute_next_state(obj, t, DT)
            obj.x(t) = obj.x(t-1) + DT*obj.v(t-1)*cos(obj.theta(t-1));
            obj.y(t) = obj.y(t-1) + DT*obj.v(t-1)*sin(obj.theta(t-1));
            obj.theta(t) = obj.theta(t-1) + DT*obj.w(t-1);
        end

        function [Fa, gFa] = goal_force(obj, t)
            [dx_gh, dy_gh] = dxdy(obj.d_a(t-1, obj.g_seq(t-1)), obj.theta_a(t-1, obj.g_seq(t-1)));
            Fa = attractive_force(obj.g.Ka, dx_gh, dy_gh);
            gFa = attractive_gradient(obj.g.Ka);
        end

        function [Fr, gFr] = obs_force(obj, t, obs)
            Fr = [0 0];
            gFr = [0 0; 0 0];
            [dx_hh, dy_hh] = dxdy(obj.d_a(t-1, obs.id), obj.theta_a(t-1, obs.id));

            if obj.d_a(t-1, obs.id) < obs.eta_0
                obj.interaction(t, obs.id) = true;
                switch obs.rep_force_type
                    case Rep_force.REPULSIVE
                        Fr = repulsive_force(obs.Kr, dx_hh, dy_hh);
                        gFr = repulsive_gradient(obs.Kr, dx_hh, dy_hh);
                    case Rep_force.VORTEX
                        Fr =  vortex_force(obs.Kr, dx_hh, dy_hh);
                        gFr = vortex_gradient(obs.Kr, dx_hh, dy_hh);
                end
            end
        end

        function [Ft, gFt] = total_force_field(obj, t)
            Fr = [0 0];
            gFr = [0 0; 0 0];
            [Fa, gFa] = obj.goal_force(t);
            for o = obj.obs
                [Fr_o, gFr_o] = obj.obs_force(t, o);
                Fr = Fr + Fr_o;
                gFr = gFr + gFr_o;
            end
            Ft = Fa + Fr;
            gFt = gFa + gFr;
        end

        function compute_v(obj, t, Ft, varargin)
            minArgs = 3;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            Fx = Ft(1);
            Fy = Ft(2);
            if (obj.task_op && t > obj.task) || ~obj.task_op
                v = obj.Kv*(Fx*cos(obj.theta(t-1)) + Fy*sin(obj.theta(t-1)));
                if obj.sat_op
                    if v > obj.max_v
                        v = obj.max_v;
                    elseif v < -obj.max_v
                        v = -obj.max_v;
                    end
                end
            else
                v = 0;
            end
            obj.v(t) = v + noise;
        end

        function compute_w(obj, t, Ft, gFt, varargin)
            minArgs = 4;
            noise = 0;
            if nargin > minArgs
                noise = varargin{1};
            end
            Fx = Ft(1);
            Fy = Ft(2);
            if (obj.task_op && t > obj.task) || ~obj.task_op
                nFt = sqrt(Fx^2+Fy^2);
                t_a = atan2(Fy, Fx);
                theta_d = obj.theta(t-1) - asin(sin(obj.theta(t-1) - t_a));
        
                first_term = -obj.Kw*(obj.theta(t-1) - theta_d)/(sign(cos(obj.theta(t-1) - t_a)));
                if nFt ~= 0 
                    second_term = obj.v(t-1)/power(nFt,2)*([-Fy Fx] * gFt * [cos(obj.theta(t-1)); sin(obj.theta(t-1))]);
                else
                    second_term = 0;
                end
                w = first_term + second_term;
                if obj.v(t-1) ~= 0
                    w = sign(obj.v(t-1)) * w;
                end
            else
                w = 0;
            end
            obj.w(t) = w + noise;
        end
        
        function compute_next_inputs(obj, t, Ft, gFt, varargin)
            minArgs = 4;
            noise = [0 0];
            if nargin > minArgs
                noise(1) = varargin{1};
                noise(2) = varargin{2};
            end
            obj.compute_v(t, Ft, noise(1))
            obj.compute_w(t, Ft, gFt, noise(2))
        end
        
    end
end

